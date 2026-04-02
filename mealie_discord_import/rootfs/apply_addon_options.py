#!/usr/bin/env python3
"""Apply Home Assistant /data/options.json to os.environ, then exec the bot."""
import json
import os
import sys


def _bool_str(v) -> str:
    if isinstance(v, bool):
        return "true" if v else "false"
    s = str(v).strip().lower()
    return "true" if s in ("1", "true", "yes", "on") else "false"


def _strip_unexpanded_docker_templates(env: dict) -> None:
    """Remove leftover ${option_name} values from Docker env (broken substitution)."""
    for k, v in list(env.items()):
        if isinstance(v, str) and v.startswith("${") and v.endswith("}"):
            env.pop(k, None)


def main() -> None:
    os.chdir("/app")
    env = dict(os.environ)
    _strip_unexpanded_docker_templates(env)
    path = "/data/options.json"

    if os.path.isfile(path):
        with open(path, encoding="utf-8") as f:
            o = json.load(f)

        def nonempty_str(key: str):
            v = o.get(key)
            if v is None:
                return None
            s = v if isinstance(v, str) else str(v)
            return s if s.strip() else None

        if "discord_token" in o:
            v = o.get("discord_token")
            env["DISCORD_TOKEN"] = "" if v is None else (
                v.strip() if isinstance(v, str) else str(v)
            )

        gid = o.get("discord_guild_id")
        if gid is not None and str(gid).strip() != "":
            gs = str(gid).strip()
            try:
                env["DISCORD_GUILD_ID"] = str(int(gs))
            except ValueError:
                env["DISCORD_GUILD_ID"] = gs
        else:
            env.pop("DISCORD_GUILD_ID", None)

        if (v := nonempty_str("discord_command_prefix")) is not None:
            env["DISCORD_COMMAND_PREFIX"] = v
        else:
            env.pop("DISCORD_COMMAND_PREFIX", None)

        if "mealie_base_url" in o:
            v = o.get("mealie_base_url")
            env["MEALIE_BASE_URL"] = "" if v is None else (
                v.strip() if isinstance(v, str) else str(v)
            )
        if "mealie_api_token" in o:
            v = o.get("mealie_api_token")
            env["MEALIE_API_TOKEN"] = "" if v is None else (
                v.strip() if isinstance(v, str) else str(v)
            )

        if (v := nonempty_str("mealie_username")) is not None:
            env["MEALIE_USERNAME"] = v
        else:
            env.pop("MEALIE_USERNAME", None)
        if (v := nonempty_str("mealie_password")) is not None:
            env["MEALIE_PASSWORD"] = v
        else:
            env.pop("MEALIE_PASSWORD", None)

        if "bot_log_level" in o and o.get("bot_log_level") is not None:
            v = o["bot_log_level"]
            env["BOT_LOG_LEVEL"] = v.strip() if isinstance(v, str) else str(v)
        if "bot_timeout" in o and o.get("bot_timeout") is not None:
            env["BOT_TIMEOUT"] = str(int(o["bot_timeout"]))

        if "default_recipe_tags" in o and o.get("default_recipe_tags") is not None:
            v = o["default_recipe_tags"]
            env["DEFAULT_RECIPE_TAGS"] = v.strip() if isinstance(v, str) else str(v)

        if "require_instructions" in o:
            env["REQUIRE_INSTRUCTIONS"] = _bool_str(o["require_instructions"])
        if "require_ingredients" in o:
            env["REQUIRE_INGREDIENTS"] = _bool_str(o["require_ingredients"])

        if (v := nonempty_str("openai_api_key")) is not None:
            env["OPENAI_API_KEY"] = v
        else:
            env.pop("OPENAI_API_KEY", None)

        if "ai_enabled" in o:
            env["AI_ENABLED"] = _bool_str(o["ai_enabled"])
        if (v := nonempty_str("ai_model")) is not None:
            env["AI_MODEL"] = v

    os.execve(sys.executable, [sys.executable, "src/main.py"], env)


if __name__ == "__main__":
    main()

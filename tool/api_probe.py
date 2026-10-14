#!/usr/bin/env python3
"""Checks the backend responses against docs/API.md. Sends GET requests only.

Logs in, calls every read endpoint the app uses and prints the structure of
each response: keys, value types, list sizes and the values of enum-like
fields. Personal data is not printed. Raw responses can be saved with --out
(keep that folder outside the repository: it contains real data).

Credentials and the backend root are read from the environment or, if not
set there, from the project's .env (RFID_API_LOGIN, RFID_API_PASSWORD,
API_BASE_URL).

Usage:
    python3 tool/api_probe.py
    python3 tool/api_probe.py --out /tmp/api

Options:
    --base-url URL   backend root (default: API_BASE_URL from .env)
    --out DIR        save raw JSON responses into DIR
    --verify-tls     verify the server certificate (off by default, like the app)
"""
import argparse
import json
import os
import re
import ssl
import sys
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

ENUM_KEYS = {"status", "status_code", "status_label", "type", "common_status", "success"}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--base-url")
    parser.add_argument("--out")
    parser.add_argument("--verify-tls", action="store_true")
    args = parser.parse_args()

    dotenv = load_dotenv(Path(__file__).resolve().parent.parent / ".env")
    login = os.environ.get("RFID_API_LOGIN") or dotenv.get("RFID_API_LOGIN")
    password = os.environ.get("RFID_API_PASSWORD") or dotenv.get("RFID_API_PASSWORD")
    base_url = args.base_url or dotenv.get("API_BASE_URL") or "https://mderp.uz/"
    if not login or not password:
        sys.exit("Set RFID_API_LOGIN and RFID_API_PASSWORD (environment or .env)")

    client = Client(base_url, verify_tls=args.verify_tls, out=args.out)

    auth = client.call("auth", "POST", "api/auth.php", query={"action": "login"},
                       body={"login": login, "password": password}, redact=("token",))
    token = (auth or {}).get("token")
    if not token:
        sys.exit("Login failed, see the response above")

    client.call("no_token", "GET", "api/inventory.php")
    client.call("bad_token", "GET", "api/inventory.php", token="invalid")

    inventories = client.call("inventory", "GET", "api/inventory.php", token=token)
    inventory_id = first_id(inventories, lambda row: row.get("status_code") != "closed")
    if inventory_id is not None:
        client.call("inventory_tasks", "GET", "api/inventory_tasks.php", token=token,
                    query={"inventory_id": inventory_id})
        client.call("inventory_plan", "GET", "api/inventory_get_plan.php", token=token,
                    query={"id": inventory_id})

    client.call("items", "GET", "api/items.php", token=token)

    markings = client.call("markings", "GET", "api/markings.php", token=token)
    marking_id = first_id(markings)
    if marking_id is not None:
        client.call("marking_tasks", "GET", "api/get_marking_tasks_for_mobile.php",
                    token=token, query={"marking_id": marking_id})
        client.call("marking_items", "GET", "api/get_marking_items.php", token=token,
                    query={"marking_id": marking_id})

    client.call("movement_tasks", "GET", "api/get_movement_tasks_for_mobile.php", token=token)
    client.call("locations", "GET", "api/locations.php", token=token)


def load_dotenv(path):
    values = {}
    if not path.exists():
        return values
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values


class Client:
    def __init__(self, base_url, verify_tls, out):
        self.base_url = base_url if base_url.endswith("/") else base_url + "/"
        self.context = ssl.create_default_context()
        if not verify_tls:
            self.context.check_hostname = False
            self.context.verify_mode = ssl.CERT_NONE
        self.out = Path(out) if out else None
        if self.out:
            self.out.mkdir(parents=True, exist_ok=True)

    def call(self, name, method, path, token=None, query=None, body=None, redact=()):
        url = self.base_url + path + ("?" + urllib.parse.urlencode(query) if query else "")
        headers = {"Accept": "application/json"}
        data = None
        if body is not None:
            data = json.dumps(body).encode()
            headers["Content-Type"] = "application/json"
        if token:
            headers["Authorization"] = f"Bearer {token}"
        request = urllib.request.Request(url, data=data, headers=headers, method=method)
        try:
            with urllib.request.urlopen(request, context=self.context, timeout=45) as response:
                status, raw = response.status, response.read()
        except urllib.error.HTTPError as error:
            status, raw = error.code, error.read()
        text = raw.decode("utf-8", errors="replace")
        try:
            parsed = json.loads(text)
        except ValueError:
            parsed = None
        if isinstance(parsed, dict):
            parsed = {k: ("<redacted>" if k in redact else v) for k, v in parsed.items()}

        print(f"\n=== {name}: {method} {path} {query or ''} -> HTTP {status}")
        if parsed is None:
            print(f"  not JSON ({len(text)} chars): {text[:120]!r}")
        else:
            describe(parsed, 1)
        if self.out:
            (self.out / f"{name}.json").write_text(
                json.dumps(parsed, ensure_ascii=False, indent=2) if parsed is not None else text
            )
        return parsed if isinstance(parsed, dict) else None


def first_id(parsed, prefer=None):
    rows = (parsed or {}).get("data")
    if not isinstance(rows, list) or not rows:
        return None
    for row in rows:
        if isinstance(row, dict) and (prefer is None or prefer(row)):
            return row.get("id")
    return None


def type_name(value):
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "bool"
    if isinstance(value, int):
        return "int"
    if isinstance(value, float):
        return "double"
    if isinstance(value, str):
        if value == "":
            return "str(empty)"
        return "str(numeric)" if re.fullmatch(r"-?\d+(\.\d+)?", value) else "str"
    return "list" if isinstance(value, list) else "map"


def describe(value, indent):
    pad = "  " * indent
    if isinstance(value, dict):
        for key, item in value.items():
            if isinstance(item, (dict, list)):
                size = f"[{len(item)}]" if isinstance(item, list) else ""
                print(f"{pad}{key}: {type_name(item)}{size}")
                describe(item, indent + 1)
            else:
                shown = f" = {item!r}" if key in ENUM_KEYS else ""
                print(f"{pad}{key}: {type_name(item)}{shown}")
    elif isinstance(value, list):
        rows = [row for row in value if isinstance(row, dict)]
        if not rows:
            kinds = sorted({type_name(row) for row in value})
            print(f"{pad}<items>: {', '.join(kinds) or 'empty'}")
            return
        keys = {}
        for row in rows:
            for key, item in row.items():
                slot = keys.setdefault(key, {"types": set(), "values": set(), "nested": None})
                slot["types"].add(type_name(item))
                if key in ENUM_KEYS and not isinstance(item, (dict, list)):
                    slot["values"].add(repr(item))
                if isinstance(item, (dict, list)) and item and slot["nested"] is None:
                    slot["nested"] = item
        for key, slot in keys.items():
            line = f"{pad}- {key}: {' | '.join(sorted(slot['types']))}"
            if slot["values"]:
                line += f"  values={sorted(slot['values'])[:12]}"
            print(line)
            if slot["nested"] is not None:
                describe(slot["nested"], indent + 2)


if __name__ == "__main__":
    main()

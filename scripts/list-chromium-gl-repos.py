#!/usr/bin/env python3
"""
List all projects under openos-project/Chromium_Browser_OS_Deving.
Falls back to trying the group by ID if path lookup fails.
Also checks token identity and accessible groups.
"""
import os, json, urllib.request, urllib.error

token = os.environ["GITLAB_TOKEN"]
api   = os.environ.get("GL_API", "https://gitlab.com/api/v4")

def gl_get(path):
    req = urllib.request.Request(f"{api}{path}",
        headers={"PRIVATE-TOKEN": token, "User-Agent": "fork-sync-all"})
    try:
        with urllib.request.urlopen(req) as r:
            return json.load(r), r.status
    except urllib.error.HTTPError as e:
        return {"_error": e.code, "_body": e.read().decode()[:300]}, e.code

def fmt(b):
    if b >= 1073741824: return f"{b/1073741824:.1f}G"
    if b >= 1048576:    return f"{b/1048576:.1f}M"
    if b >= 1024:       return f"{b/1024:.1f}K"
    return f"{b}B"

# 1. Who is this token?
print("=== Token identity ===")
user, _ = gl_get("/user")
if "_error" not in user:
    print(f"  User: {user.get('username')} ({user.get('name')})")
    print(f"  Scopes: check token settings")
else:
    print(f"  Error: {user}")

# 2. List top-level groups accessible to this token
print("\n=== Accessible groups (top-level) ===")
groups, _ = gl_get("/groups?per_page=50&top_level_only=true")
if isinstance(groups, list):
    for g in groups:
        print(f"  {g['full_path']} (id={g['id']})")
else:
    print(f"  Error: {groups}")

# 3. Try to access openos-project group
print("\n=== openos-project subgroups ===")
subs, _ = gl_get("/groups/openos-project/subgroups?per_page=50")
if isinstance(subs, list):
    for g in subs:
        print(f"  {g['full_path']} (id={g['id']})")
else:
    print(f"  Error: {subs}")

# 4. Try Chromium group by various path encodings
print("\n=== Chromium group lookup attempts ===")
for path in [
    "/groups/openos-project%2FChromium_Browser_OS_Deving",
    "/groups/openos-project%2Fchromium_browser_os_deving",
    "/groups?search=Chromium_Browser",
]:
    data, status = gl_get(path)
    if isinstance(data, list):
        print(f"  Search results for {path}:")
        for g in data[:5]:
            print(f"    {g.get('full_path')} (id={g.get('id')})")
    elif "_error" not in data:
        print(f"  Found: {data.get('full_path')} (id={data.get('id')})")
    else:
        print(f"  {path}: HTTP {data['_error']}")

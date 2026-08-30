#!/usr/bin/env python3
"""Inject portal cross-navigation into the generated workspace sites.

structurizr-site-generatr renders each workspace as an isolated site with no
knowledge of the portal landing page or its sibling workspaces. This script
adds a 'Portal' home link and a workspace switcher to the Bulma navbar of
every generated HTML page, using relative links (so the portal works when
hosted under a subpath, e.g. GitLab Pages project sites).

Run by scripts/build_site.sh after site generation. Idempotent.
"""

from __future__ import annotations

import sys
from pathlib import Path

PUBLIC = Path(__file__).resolve().parent.parent / "public"
WORKSPACES = ["enterprise", "technology", "security", "integration"]
MARKER = "<!-- portal-nav -->"
ANCHOR = '<div class="navbar-menu has-site-branding">'


def nav_html(prefix: str, current: str) -> str:
    # A sibling of navbar-menu (not a child): Bulma hides navbar-menu below
    # 1024px and the generated sites have no burger toggle, so the switcher
    # must live outside it to stay visible on narrow screens.
    items = [
        f'<a class="navbar-item has-site-branding" href="{prefix}">Portal</a>'
    ]
    for ws in WORKSPACES:
        style = ' style="text-decoration: underline;"' if ws == current else ""
        items.append(
            f'<a class="navbar-item has-site-branding" '
            f'href="{prefix}{ws}/"{style}>{ws.capitalize()}</a>'
        )
    return (
        f'{MARKER}<div class="portal-nav" '
        f'style="display:flex;align-items:stretch;flex-wrap:wrap;">'
        f'{"".join(items)}</div>'
    )


def main() -> int:
    if not PUBLIC.is_dir():
        print("public/ does not exist — run scripts/build_site.sh first", file=sys.stderr)
        return 1

    patched = 0
    for path in PUBLIC.rglob("*.html"):
        relative = path.relative_to(PUBLIC)
        if len(relative.parts) == 1:
            continue  # the landing page has its own navigation

        html = path.read_text()
        if MARKER in html or ANCHOR not in html:
            continue

        depth = len(relative.parts) - 1
        prefix = "../" * depth
        current = relative.parts[0]
        html = html.replace(ANCHOR, nav_html(prefix, current) + ANCHOR, 1)
        path.write_text(html)
        patched += 1

    print(f"injected portal navigation into {patched} pages")
    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Add sibling navigation to element documentation section pages.

The site generator lists an element's documentation sections on the
`sections/` index page, but once you open a section the list is gone: there is
no way to reach a sibling section without going back. This injects the section
list — styled like the generator's own sub-tabs — into each section page, with
the current section marked active, plus prev/next links at the foot.

Run by scripts/build_site.sh after generation. Idempotent.
"""

from __future__ import annotations

import html
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SITE = ROOT / "build" / "site"

MARKER = "<!-- section-nav -->"
CONTENT_ANCHOR = '<div class="content p-3">'

# Rows of the section index's table of contents: <a href="slug/">Title</a>
TOC_LINK_RE = re.compile(r'<td><a href="([^"/]+)/"[^>]*>([^<]+)</a></td>')


def section_list(index_page: Path) -> list[tuple[str, str]]:
    """Ordered (slug, title) pairs from a sections index page."""
    return [
        (slug, html.unescape(title).strip())
        for slug, title in TOC_LINK_RE.findall(index_page.read_text())
    ]


def nav_html(sections: list[tuple[str, str]], current: str) -> str:
    """Sub-tab row matching the generator's own section navigation."""
    items = ['<li><a href="../">All documentation</a></li>']
    for slug, title in sections:
        active = ' class="is-active"' if slug == current else ""
        anchor_class = ' class="is-active"' if slug == current else ""
        href = "./" if slug == current else f"../{slug}/"
        items.append(f'<li{active}><a href="{href}"{anchor_class}>{title}</a></li>')
    return (
        f'{MARKER}<div class="tabs">'
        f'<ul class="m-0 is-flex-wrap-wrap is-flex-shrink-1 is-flex-grow-0">'
        f'{"".join(items)}</ul></div>'
    )


def pager_html(sections: list[tuple[str, str]], index: int) -> str:
    """Previous / next links for reading sections in order."""
    previous = sections[index - 1] if index > 0 else None
    following = sections[index + 1] if index < len(sections) - 1 else None
    if not previous and not following:
        return ""

    left = (
        f'<a href="../{previous[0]}/">&#8592; {previous[1]}</a>'
        if previous else "<span></span>"
    )
    right = (
        f'<a href="../{following[0]}/">{following[1]} &#8594;</a>'
        if following else "<span></span>"
    )
    return (
        '<nav class="is-flex is-justify-content-space-between mt-5 pt-3" '
        'style="border-top: 1px solid #dbdbdb;">'
        f"{left}{right}</nav>"
    )


def main() -> int:
    if not SITE.is_dir():
        print("build/site/ not found — run scripts/build_site.sh first", file=sys.stderr)
        return 1

    patched = 0
    for index_page in SITE.rglob("sections/index.html"):
        sections = section_list(index_page)
        if len(sections) < 2:
            continue  # a lone section has nothing to navigate between

        for position, (slug, _) in enumerate(sections):
            page = index_page.parent / slug / "index.html"
            if not page.is_file():
                continue

            markup = page.read_text()
            if MARKER in markup or CONTENT_ANCHOR not in markup:
                continue

            markup = markup.replace(
                CONTENT_ANCHOR,
                CONTENT_ANCHOR + nav_html(sections, slug),
                1,
            )
            # Close the pager inside the content div, before its closing tag.
            pager = pager_html(sections, position)
            if pager:
                tail = markup.rfind("</div>\n      </div>")
                if tail != -1:
                    markup = markup[:tail] + pager + markup[tail:]

            page.write_text(markup)
            patched += 1

    print(f"injected section navigation into {patched} pages")
    return 0


if __name__ == "__main__":
    sys.exit(main())

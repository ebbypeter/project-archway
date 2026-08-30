#!/usr/bin/env python3
"""Verify every authored document reaches the published site.

Documentation can be authored, reviewed and merged but never published:
Structurizr attaches docs to *elements*, so a missing `!docs` / `!adrs`
directive silently drops a folder from the portal, and integration docs cannot
use those directives at all (integrations are relationships). Nothing else in
the pipeline notices — the DSL still compiles and the site still builds.

This check reads the *built site* and confirms each authored document is
present in it. It verifies presence, not fidelity: it catches a document that
is missing entirely, which is the failure mode that actually occurs.

Run by scripts/build_site.sh after generation; `make verify` runs it alone.
"""

from __future__ import annotations

import html
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SITE = ROOT / "build" / "site"

# Documents that are deliberately not published, with the reason.
EXCLUDED = {
    "docs/spec": "source specifications, kept for provenance",
    "docs/templates": "copy-paste starting points, not content",
}

# Where authored documentation lives.
SEARCH_ROOTS = ["models", "workspace", "docs"]

TAG_RE = re.compile(r"<(script|style)\b.*?</\1>|<[^>]+>", re.S | re.I)
NON_ALNUM_RE = re.compile(r"[^a-z0-9]+")

# AsciiDoc / Markdown lines that carry markup rather than publishable prose.
MARKUP_PREFIXES = (
    "//", "++++", "image::", "[cols", "[options", "|===", "----", "'''",
    "<div", "</div", "<img", "<script", "</script", "<ul", "</ul", "<li",
    "<a ", "</a", "document.", "});", "}", "{",
)


def normalize(text: str) -> str:
    """Reduce text to lowercase alphanumerics so markup, entity escaping and
    typographic substitution cannot cause false mismatches."""
    return NON_ALNUM_RE.sub("", text.lower())


def site_text() -> str:
    """All rendered text in the built site, normalized."""
    chunks = []
    for page in SITE.rglob("*.html"):
        raw = page.read_text(errors="ignore")
        chunks.append(html.unescape(TAG_RE.sub(" ", raw)))
    return normalize(" ".join(chunks))


def prose(doc: Path) -> str:
    """The publishable prose of a document, normalized."""
    kept = []
    for line in doc.read_text().splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith(MARKUP_PREFIXES):
            continue
        # Headings and list markers: keep the text, drop the marker.
        stripped = re.sub(r"^[=#*.]+\s*", "", stripped)
        # Table rows: keep the cell text.
        stripped = stripped.replace("|", " ")
        kept.append(stripped)
    return normalize(" ".join(kept))


def needles(doc: Path) -> list[str]:
    """Distinctive slices of a document to look for in the site."""
    text = prose(doc)
    if len(text) < 40:
        return []
    width = 40
    positions = [0, max(0, len(text) // 2 - width // 2), len(text) - width]
    return sorted({text[p:p + width] for p in positions})


def authored_docs() -> list[Path]:
    docs = []
    for root in SEARCH_ROOTS:
        base = ROOT / root
        if not base.is_dir():
            continue
        for pattern in ("*.adoc", "*.md"):
            for doc in base.rglob(pattern):
                rel = doc.relative_to(ROOT).as_posix()
                if any(rel.startswith(ex + "/") for ex in EXCLUDED):
                    continue
                docs.append(doc)
    return sorted(docs)


def main() -> int:
    if not SITE.is_dir():
        print(
            "build/site/ not found — run `make site` before verifying.",
            file=sys.stderr,
        )
        return 1

    haystack = site_text()
    missing: list[tuple[str, str]] = []
    skipped: list[str] = []
    checked = 0

    for doc in authored_docs():
        rel = doc.relative_to(ROOT).as_posix()
        candidates = needles(doc)
        if not candidates:
            skipped.append(rel)
            continue
        checked += 1
        if not any(n in haystack for n in candidates):
            missing.append((rel, candidates[0]))

    for rel in skipped:
        print(f"  · skipped (too short to fingerprint): {rel}")

    if missing:
        print(
            f"\nPublication check FAILED — {len(missing)} authored document(s) "
            f"never reach the site:\n",
            file=sys.stderr,
        )
        for rel, sample in missing:
            print(f"  ✗ {rel}", file=sys.stderr)
            print(f"      looked for: …{sample[:60]}…", file=sys.stderr)
        print(
            "\nAttach it with `!docs` / `!adrs` on the owning element, or — for "
            "integration assets, which are relationships and cannot carry "
            "documentation — publish it through scripts/generate_reports.py.",
            file=sys.stderr,
        )
        return 1

    print(f"Publication check passed: {checked} authored documents present in the site.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

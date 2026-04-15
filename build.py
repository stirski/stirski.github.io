"""
build.py — Build script for GitHub Pages deployment.

Reads compact-notation chapter XML files from chapters/, expands them to
valid XML, and writes all site files into docs/.  GitHub Pages is configured
to serve from the docs/ directory.

Usage:
    python3 build.py            # build into docs/
    python3 build.py --clean    # wipe docs/ first, then build
"""

from __future__ import annotations

import sys
import shutil
from pathlib import Path

ROOT = Path(__file__).parent
sys.path.insert(0, str(ROOT / 'util'))
from markup import expand  # noqa: E402

SRC  = ROOT / 'chapters'
DEST = ROOT / 'docs'

# Files copied verbatim (no expansion needed).
STATIC_SUFFIXES = {'.xsl', '.js', '.html', '.css', '.json', '.txt'}
STATIC_NAMES    = {'index.xml', 'lexicon.xml'}


def clean() -> None:
    if DEST.exists():
        shutil.rmtree(DEST)
        print(f'  cleaned  {DEST.relative_to(ROOT)}/')


def build() -> None:
    DEST.mkdir(exist_ok=True)

    expanded = copied = 0

    for src in sorted(SRC.iterdir()):
        if src.is_dir():
            continue

        dest = DEST / src.name

        if src.match('ch*.xml'):
            raw  = src.read_text(encoding='utf-8')
            out  = expand(raw)
            dest.write_text(out, encoding='utf-8')
            print(f'  expanded  {src.name}  ({len(raw):,} B → {len(out):,} B)')
            expanded += 1

        elif src.name in STATIC_NAMES or src.suffix in STATIC_SUFFIXES:
            shutil.copy2(src, dest)
            print(f'  copied    {src.name}')
            copied += 1

        # Skip .py, __pycache__, .pyc, .DS_Store, etc.

    print(f'\n  {expanded} expanded, {copied} copied → {DEST.relative_to(ROOT)}/')


def main() -> None:
    if '--clean' in sys.argv:
        clean()
    print(f'Building into {DEST.relative_to(ROOT)}/…')
    build()
    print('Done.')


if __name__ == '__main__':
    main()

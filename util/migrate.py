"""
migrate.py — Convert chapter XML files to compact inline notation.

Rewrites every ch*.xml file in chapters/ in-place, replacing <w .../> and
<st .../> self-closing tags with the compact bracket form.  Structural tags
and all other content are left untouched.

After migration, open files via serve.py (not directly) so compact notation
is expanded back to valid XML before XSLT rendering.

Usage:
    python3 util/migrate.py           # migrate all ch*.xml files
    python3 util/migrate.py --dry-run # preview changes without writing
    python3 util/migrate.py --verify  # confirm round-trip on every file
    python3 util/migrate.py --stats   # show size-savings breakdown
"""

from __future__ import annotations

import sys
import re
from pathlib import Path

# markup.py lives alongside this file in util/
sys.path.insert(0, str(Path(__file__).parent))
from markup import compress, expand, stats  # noqa: E402


CHAPTERS_DIR = Path(__file__).parent.parent / 'chapters'  # repo_root/chapters/


def _chapter_files() -> list[Path]:
    return sorted(CHAPTERS_DIR.glob('ch*.xml'))


def _count(text: str, pattern: str) -> int:
    return len(re.findall(pattern, text))


def migrate(dry_run: bool = False) -> None:
    """Convert all chapter XML files to compact notation."""
    files = _chapter_files()
    if not files:
        print('No chapter XML files found in', CHAPTERS_DIR)
        return

    total_saved = 0
    for path in files:
        original  = path.read_text(encoding='utf-8')
        compacted = compress(original)

        if compacted == original:
            print(f'  (no change)  {path.name}')
            continue

        orig_bytes    = len(original.encode('utf-8'))
        compact_bytes = len(compacted.encode('utf-8'))
        saved         = orig_bytes - compact_bytes
        total_saved  += saved

        w_tags  = _count(original, r'<w\s')
        st_tags = _count(original, r'<st\s')
        pct     = 100 * saved / orig_bytes

        action = 'DRY-RUN' if dry_run else 'migrated'
        print(
            f'  [{action}]  {path.name}: '
            f'{w_tags} <w>, {st_tags} <st>  →  '
            f'saved {saved:,} B ({pct:.1f}%)'
        )

        if not dry_run:
            path.write_text(compacted, encoding='utf-8')

    if total_saved:
        print(f'\n  Total saved: {total_saved:,} bytes across all chapter files.')
    if dry_run:
        print('  (dry-run — no files were written)')


def verify() -> None:
    """Expand every chapter file and confirm it round-trips cleanly."""
    files = _chapter_files()
    if not files:
        print('No chapter XML files found.')
        return

    all_ok = True
    for path in files:
        compact  = path.read_text(encoding='utf-8')
        restored = expand(compact)
        re_compact = compress(restored)

        if re_compact != compact:
            print(f'  FAIL  {path.name}: round-trip mismatch')
            # Find first differing line for a useful error message
            for i, (a, b) in enumerate(zip(compact.splitlines(), re_compact.splitlines()), 1):
                if a != b:
                    print(f'    line {i}:')
                    print(f'      stored:   {a!r}')
                    print(f'      restored: {b!r}')
                    break
            all_ok = False
        else:
            print(f'  ok    {path.name}')

    if all_ok:
        print('\n  All files round-trip correctly.')
    else:
        print('\n  Some files failed — check output above.')
        sys.exit(1)


def show_stats() -> None:
    """Print a size-savings summary for all chapter files."""
    files = _chapter_files()
    total_orig = total_compact = 0
    for path in files:
        text = path.read_text(encoding='utf-8')
        # If already compact, re-expand to get the original sizes for comparison
        if '[w ' in text or '[st ' in text:
            compacted = text
            original  = expand(text)
        else:
            original  = text
            compacted = compress(text)
        orig_b    = len(original.encode('utf-8'))
        compact_b = len(compacted.encode('utf-8'))
        total_orig    += orig_b
        total_compact += compact_b
        pct = 100 * (orig_b - compact_b) / orig_b
        print(f'  {path.name}: {orig_b:,} → {compact_b:,} B  ({pct:.1f}% saved)')

    total_saved = total_orig - total_compact
    total_pct   = 100 * total_saved / total_orig if total_orig else 0
    print(f'\n  Total: {total_orig:,} → {total_compact:,} B  '
          f'({total_saved:,} B, {total_pct:.1f}% saved)')


def main() -> None:
    args = sys.argv[1:]

    if '--verify' in args:
        print('Verifying round-trips for all chapter files…')
        verify()
    elif '--stats' in args:
        print('Size statistics for all chapter files…')
        show_stats()
    elif '--dry-run' in args:
        print('Dry-run: previewing migration (no files will be written)…')
        migrate(dry_run=True)
    else:
        print('Migrating chapter XML files to compact notation…')
        migrate(dry_run=False)
        print('\nDone. Use serve.py to serve files to the browser.')


if __name__ == '__main__':
    main()

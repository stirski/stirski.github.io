"""
markup.py — Compact inline notation for Styrian grammar XML files.

The compact format replaces the two high-frequency self-closing tags with a
lighter bracket syntax that is still valid XML text content and round-trips
losslessly back to XML.

COMPACT NOTATION
================

  <w ref="az"/>                          →  [w az]
  <w ref="vydit" infl="1s"/>             →  [w vydit :i 1s]
  <w ref="dom" infl="o"/>                →  [w dom :i o]
  <w ref="ydat" cap="1"/>                →  [w ydat :c]
  <w ref="sej" infl="ms" cap="1"/>       →  [w sej :i ms :c]

  <st v="ӑ" tr=""/>                      →  [st ӑ]
  <st v="Страски" tr="Strasky"/>         →  [st Страски :t Strasky]
  <st v="не знам" tr="ne znam"/>         →  [st не знам :t ne znam]

Rules:
  • [w <ref>]                  – ref only
  • [w <ref> :i <infl>]        – with inflection tag
  • [w <ref> :c]               – sentence-initial capitalisation flag
  • [w <ref> :i <infl> :c]     – infl + cap (always in this order)
  • [st <v>]                   – Cyrillic surface form, empty transliteration
  • [st <v> :t <tr>]           – surface form + transliteration
      The ` :t ` delimiter is safe because Cyrillic text never contains the
      ASCII sequence `:t`.

All structural tags (<p>, <sec>, <ex>, <item>, <tb>, …) remain unchanged XML.

PUBLIC API
==========
  expand(text)          compact → XML   (string → string)
  compress(text)        XML → compact   (string → string)
  expand_file(path)     read compact file, return XML string
  compress_file(path)   read XML file, return compact string
  stats(original, compacted)  print token-savings report
"""

from __future__ import annotations

import re
from pathlib import Path


# ---------------------------------------------------------------------------
# Expand: compact notation → XML tags
# ---------------------------------------------------------------------------

# Matches:  [w ref]  [w ref :i infl]  [w ref :c]  [w ref :i infl :c]
#
# Group 1: ref   – Latin + extended chars, no space / ] / :
# Group 2: infl  – optional, same char class
# Group 3: cap   – optional " :c" literal (truthy when present)
_W_EXPAND = re.compile(
    r'\[w '
    r'([^\] :]+)'            # (1) ref
    r'(?: :i ([^\] :]+))?'   # (2) optional infl
    r'( :c)?'                # (3) optional cap flag
    r'\]'
)

# Matches:  [st v]  or  [st v :t tr]
# Group 1: entire content between [st and ]
# Splitting on ' :t ' is done inside the handler (see _expand_st).
_ST_EXPAND = re.compile(r'\[st ([^\]]+?)\]')


def _expand_w(m: re.Match) -> str:
    ref  = m.group(1)
    infl = m.group(2)
    cap  = m.group(3)           # " :c" or None
    out  = [f'<w ref="{ref}"']
    if infl:
        out.append(f' infl="{infl}"')
    if cap:
        out.append(' cap="1"')
    out.append('/>')
    return ''.join(out)


def _expand_st(m: re.Match) -> str:
    content = m.group(1)
    # Split on the first occurrence of ' :t '
    if ' :t ' in content:
        v, tr = content.split(' :t ', 1)
    else:
        v, tr = content, ''
    v  = v.strip()
    tr = tr.strip()
    return f'<st v="{v}" tr="{tr}"/>'


def expand(text: str) -> str:
    """Convert compact inline notation to valid XML self-closing tags.

    All bracket tokens are substituted in a single pass each; structural XML
    is left completely untouched.
    """
    text = _W_EXPAND.sub(_expand_w, text)
    text = _ST_EXPAND.sub(_expand_st, text)
    return text


def expand_file(path: str | Path) -> str:
    """Read a compact-format file and return the expanded XML string."""
    return expand(Path(path).read_text(encoding='utf-8'))


# ---------------------------------------------------------------------------
# Compress: XML tags → compact notation
# ---------------------------------------------------------------------------

# Match <w .../> with any attribute order, possibly spanning a line.
# Captures everything between <w and />
_W_COMPRESS  = re.compile(r'<w(\s[^/]*?)\s*/>', re.DOTALL)
_ST_COMPRESS = re.compile(r'<st(\s[^/]*?)\s*/>', re.DOTALL)


def _attr(attrs: str, name: str) -> str | None:
    """Return the value of attribute `name` from an XML attribute string."""
    m = re.search(rf'\b{name}="([^"]*)"', attrs)
    return m.group(1) if m else None


def _compress_w(m: re.Match) -> str:
    attrs = m.group(1)
    ref   = _attr(attrs, 'ref')
    infl  = _attr(attrs, 'infl')
    cap   = bool(re.search(r'\bcap="1"', attrs))
    if ref is None:
        return m.group(0)            # leave malformed tag unchanged
    out = [f'[w {ref}']
    if infl:
        out.append(f' :i {infl}')
    if cap:
        out.append(' :c')
    out.append(']')
    return ''.join(out)


def _compress_st(m: re.Match) -> str:
    attrs = m.group(1)
    v     = _attr(attrs, 'v')
    tr    = _attr(attrs, 'tr') or ''
    if v is None:
        return m.group(0)
    if tr:
        return f'[st {v} :t {tr}]'
    return f'[st {v}]'


def compress(text: str) -> str:
    """Convert XML self-closing inline tags to compact bracket notation.

    Only <w> and <st> self-closing tags are affected; all other markup,
    including structural elements and the XSL processing instruction, is
    left unchanged.
    """
    text = _W_COMPRESS.sub(_compress_w, text)
    text = _ST_COMPRESS.sub(_compress_st, text)
    return text


def compress_file(path: str | Path) -> str:
    """Read an XML file and return its compact-notation string."""
    return compress(Path(path).read_text(encoding='utf-8'))


# ---------------------------------------------------------------------------
# Stats helper
# ---------------------------------------------------------------------------

def stats(original: str, compacted: str) -> None:
    """Print a token-savings summary comparing two texts."""
    orig_bytes    = len(original.encode('utf-8'))
    compact_bytes = len(compacted.encode('utf-8'))
    saved         = orig_bytes - compact_bytes
    pct           = 100 * saved / orig_bytes if orig_bytes else 0

    w_orig    = len(re.findall(r'<w\s', original))
    st_orig   = len(re.findall(r'<st\s', original))
    w_compact = len(re.findall(r'\[w ', compacted))
    st_compact= len(re.findall(r'\[st ', compacted))

    print(f'  <w>  tags: {w_orig:>5}  →  [w]  tokens: {w_compact:>5}')
    print(f'  <st> tags: {st_orig:>5}  →  [st] tokens: {st_compact:>5}')
    print(f'  Size: {orig_bytes:,} B  →  {compact_bytes:,} B  '
          f'(saved {saved:,} B, {pct:.1f}%)')


# ---------------------------------------------------------------------------
# Quick self-test (run as __main__)
# ---------------------------------------------------------------------------

if __name__ == '__main__':
    _CASES: list[tuple[str, str]] = [
        # (compact_form, xml_form)
        ('[w az]',                         '<w ref="az"/>'),
        ('[w vydit :i 1s]',                '<w ref="vydit" infl="1s"/>'),
        ('[w dom :i o]',                   '<w ref="dom" infl="o"/>'),
        ('[w ydat :c]',                    '<w ref="ydat" cap="1"/>'),
        ('[w sej :i ms :c]',               '<w ref="sej" infl="ms" cap="1"/>'),
        ('[w byt.neg :i 3s]',              '<w ref="byt.neg" infl="3s"/>'),
        ('[st ӑ]',                         '<st v="ӑ" tr=""/>'),
        ('[st Страски :t Strasky]',         '<st v="Страски" tr="Strasky"/>'),
        ('[st не знам :t ne znam]',         '<st v="не знам" tr="ne znam"/>'),
        ('[st ӑ :t ]',                     '<st v="ӑ" tr=""/>'),   # empty tr after :t
    ]

    ok = failed = 0
    for compact, xml in _CASES:
        # Test expand
        got = expand(compact)
        if got != xml:
            print(f'FAIL expand: {compact!r}')
            print(f'  expected: {xml!r}')
            print(f'  got:      {got!r}')
            failed += 1
        else:
            ok += 1

        # Test compress
        got2 = compress(xml)
        # normalise: empty tr '  :t  ' → no :t
        expected_c = compact if ' :t ]' not in compact else compact.replace(' :t ]', ']')
        if got2 != expected_c:
            print(f'FAIL compress: {xml!r}')
            print(f'  expected: {expected_c!r}')
            print(f'  got:      {got2!r}')
            failed += 1
        else:
            ok += 1

    # Round-trip test on a realistic fragment
    fragment = (
        '<ex><w ref="az" cap="1"/> <w ref="vydit" infl="1sg"/> '
        '<w ref="ta" infl="m.sg.obl"/> <w ref="dom" infl="obl.sg"/></ex>'
    )
    c = compress(fragment)
    r = expand(c)
    if r != fragment:
        print('FAIL round-trip')
        print(f'  original: {fragment!r}')
        print(f'  compact:  {c!r}')
        print(f'  restored: {r!r}')
        failed += 1
    else:
        ok += 1

    print(f'\nSelf-test: {ok} passed, {failed} failed')
    if not failed:
        print('Round-trip fragment:')
        print(f'  XML:     {fragment}')
        print(f'  compact: {c}')

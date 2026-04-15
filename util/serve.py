"""
serve.py — HTTP server for Styrian grammar files.

Serves chapter XML files with compact notation expanded to valid XML on the
fly, so the browser's built-in XSLT processor can apply grammar.xsl without
modification.  All other files (grammar.xsl, lexicon.xml, JS, etc.) are
served as-is.

Usage:
    python3 util/serve.py           # from repo root, listens on :8080
    python3 util/serve.py 9000      # custom port

Then open, e.g.:
    http://localhost:8080/ch05_syntax.xml
    http://localhost:8080/viewer.html
"""

from __future__ import annotations

import sys
import http.server
import socketserver
from pathlib import Path

# markup.py lives alongside this file in util/
sys.path.insert(0, str(Path(__file__).parent))
from markup import expand  # noqa: E402

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

DEFAULT_PORT = 8080
SERVE_DIR    = Path(__file__).parent.parent / 'chapters'  # repo_root/chapters/

# Chapter files that contain compact notation and need expansion.
# Matches ch01_*.xml, ch02_*.xml, … ch07_*.xml
_IS_CHAPTER  = lambda name: name.startswith('ch') and name.endswith('.xml')


# ---------------------------------------------------------------------------
# Request handler
# ---------------------------------------------------------------------------

class GrammarHandler(http.server.SimpleHTTPRequestHandler):
    """Serves chapter XML with compact notation pre-expanded."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(SERVE_DIR), **kwargs)

    def do_GET(self) -> None:
        # Strip query string and leading slash to get a bare filename.
        name      = self.path.split('?')[0].split('#')[0].lstrip('/')
        file_path = SERVE_DIR / name

        if _IS_CHAPTER(name) and file_path.is_file():
            self._serve_expanded(file_path)
        else:
            # Delegate everything else to SimpleHTTPRequestHandler.
            super().do_GET()

    def _serve_expanded(self, path: Path) -> None:
        try:
            raw      = path.read_text(encoding='utf-8')
            expanded = expand(raw)
            data     = expanded.encode('utf-8')
        except Exception as exc:
            self.send_error(500, f'Expansion error: {exc}')
            return

        self.send_response(200)
        self.send_header('Content-Type', 'application/xml; charset=utf-8')
        self.send_header('Content-Length', str(len(data)))
        # Allow browser XSLT to load lexicon.xml via document() across origins.
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt: str, *args) -> None:  # noqa: ANN002
        # Suppress the default stderr noise; print a clean one-liner instead.
        print(f'[serve] {self.address_string()} {fmt % args}')


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    port = int(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_PORT

    # Allow rapid restarts without "address already in use" errors.
    socketserver.TCPServer.allow_reuse_address = True

    with socketserver.TCPServer(('', port), GrammarHandler) as httpd:
        print(f'Styrian grammar server running at http://localhost:{port}/')
        print(f'Serving files from: {SERVE_DIR}')
        print(f'Compact notation is expanded on the fly for ch*.xml files.')
        print('Press Ctrl-C to stop.\n')
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print('\nStopped.')


if __name__ == '__main__':
    main()

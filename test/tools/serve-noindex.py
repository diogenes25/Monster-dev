"""Static server that mimics raw.githubusercontent.com semantics:
a file is reachable only if you know its exact path. No directory listing,
so nothing invites browsing the way python -m http.server's index does.
"""
import sys
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer


class NoIndexHandler(SimpleHTTPRequestHandler):
    def list_directory(self, path):
        self.send_error(404, "Not Found")
        return None

    def log_message(self, fmt, *args):
        sys.stderr.write("%s - %s\n" % (self.address_string(), fmt % args))


if __name__ == "__main__":
    port = int(sys.argv[1])
    root = sys.argv[2]
    handler = partial(NoIndexHandler, directory=root)
    ThreadingHTTPServer(("127.0.0.1", port), handler).serve_forever()

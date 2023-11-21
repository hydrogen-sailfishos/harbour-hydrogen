# Copyright © 2021-2023 thigg
# Copyright © 2023 The SailfishOS Hackathon Budapest Team
#
# SPDX-License-Identifier: Apache-2.0

import pyotherside
import threading
import os
import http.server

PORT = 27834
os.chdir('/usr/share/harbour-hydrogen/hydrogen')

class Handler(http.server.SimpleHTTPRequestHandler):

    def do_GET(self) -> None:
        pyotherside.send("log", "GET %s"%self.path)
        super().do_GET()


def serveMe():
    with http.server.ThreadingHTTPServer(("", PORT), Handler) as httpd:
        pyotherside.send('log',"port %s"% PORT)
        pyotherside.send('finished',PORT)
        httpd.serve_forever()


class Downloader:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def serve(self):
        if self.bgthread.is_alive():
            return
        self.bgthread = threading.Thread(target=serveMe)
        self.bgthread.start()


downloader = Downloader()

#!/usr/bin/env python3

#
# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at https://mozilla.org/MPL/2.0/.
#

import subprocess

import gi
gi.require_version('Gdk', '3.0')
from gi.repository import Gdk, GdkX11

ffPid = int(subprocess.run(
    ["bash", "-c", "wmctrl -lp | grep -Fh $(pgrep firefox | head -n 1) -- -"],
    universal_newlines=True, stdout=subprocess.PIPE).stdout.split()[0], 0
)

gdk_display = GdkX11.X11Display.get_default()
Gdk.Window.process_all_updates()
gdk_window = GdkX11.X11Window.foreign_new_for_display(gdk_display, ffPid)

Gdk.Window.set_decorations(gdk_window, Gdk.WMDecoration.BORDER)
Gdk.Window.process_all_updates()

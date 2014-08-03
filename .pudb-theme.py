#!/usr/bin/python3

import sys

# print("exec'ing ~/.pudb-theme.py", file=sys.stderr)

# See /usr/lib/python3/dist-packages/pudb/theme.py for base definitions ("classic").  Then you can just update them.

palette.update({

            "source": ("black", "default"),
            "keyword": ("black", "default"),
            "kw_namespace": ("dark magenta", "default"),

            "literal": ("dark red", "default"),
            "string": ("dark red", "default"),
            "doublestring": ("dark red", "default"),
            "singlestring": ("dark red", "default"),
            "docstring": ("dark green", "default", None, "#080", None),

            "punctuation": ("black", "default"),
            "comment": ("dark gray", "default"),
            "classname": ("dark magenta", "default"),
            "name": (add_setting("dark blue", "bold"), "default"),
            "line number": ("dark gray", "default"),

            "breakpoint marker": ("dark red", "default"),

            # {{{ ui

            "header": ( "white", "dark gray", "standout"), # single app header across top
            "background": ( "white", "dark gray"), # general background of app, includes section headers (in main app).
            "hotkey": ( add_setting("yellow", "underline,bold"), "dark gray", "underline"),

            "selectable": ( "black", "yellow"), # e.g., module list when picking a module in a pop-up

            "dialog title": ( "black", "dark cyan"),

            # "focused sidebar": ( add_setting("light magenta", "bold"), "light gray"),
            # "focused sidebar": ( add_setting("black", "standout"), "default", "standout"),
            "focused sidebar": ( "white", "black"),

            # }}}
            
            # {{{ shell

            "command line edit": ("black", "default"),
            "command line prompt": (add_setting("black", "bold"), "default"),

            "command line output": (add_setting("black", "bold"), "default"),
            "command line input": ("black", "default"),
            "command line error": (add_setting("light red", "bold"), "default"),

            "focused command line output": ("black", "dark green"),
            "focused command line input": (add_setting("light cyan", "bold"), "dark green"),
            "focused command line error": ("black", "dark green"),

            # }}}

            # {{{ variables

            "variables": ( "black", "default"), # Pane
            "var label": ("dark blue", "default"),
            "var value": ("black", "default"),
            "focused var label": ("dark blue", "dark green"), #, None, "dark blue", "#8f0"),
            "focused var value": ("black", "dark green"), #, None, "dark blue", "#8f0"),

            # }}}

            # {{{ stack

            "stack": ( "black", "default"),
            "frame name": ( "black", "default"),
            "focused frame name": ( "black", "dark green"), #, None, "black", "#8f0"),
            "frame class": ( "dark blue", "default"),
            "focused frame class": ( "dark blue", "dark green"), #, None, "black", "#8f0"),
            "frame location": ( "light red", "default"),
            "focused frame location": ( "light red", "dark green"), #, None, "light red", "#8f0"),
            
            "current frame name": ( add_setting("yellow", "bold"), "light red", "bold"),
            "focused current frame name": ( add_setting("yellow", "bold"), "light red", "bold"),
            "current frame class": ( "dark blue", "default"),
            "focused current frame class": ( "dark blue", "dark green"), #, None, "dark blue", "#8f0"),
            "current frame location": ( "light red", "default"),
            "focused current frame location": ( "light red", "dark green"), #, None, "light red", "#8f0"),

            # }}}

            # {{{ breakpoints

            # "Breakpoint" pane.
            "breakpoint": ("black", "default"), 

            "breakpoint source": ( "white", "dark red"),
            # "breakpoint focused source": ( add_setting( "black","bold"), "dark red","bold"),
            "breakpoint focused source": ( "light red", "dark green"),
            "current breakpoint source": ( add_setting("yellow","bold"), "dark red", "bold"),
            # "current breakpoint focused source": ( add_setting( "white", "bold"), "dark red", "bold"),
            "current breakpoint focused source": ( add_setting( "light red", "bold"), "dark green", "bold"),

            # }}}

    })

# print("exec'ed ~/.pudb-theme.py", file=sys.stderr)

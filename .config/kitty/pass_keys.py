# https://github.com/kovidgoyal/kitty/blob/master/kitty/boss.py
# https://github.com/kovidgoyal/kitty/blob/master/kitty/window.py
import re

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut


def is_vim_window(window):
    fp = window.child.foreground_processes
    return any(re.search("nvim", p['cmdline'][0] if len(p['cmdline']) else '', re.I) for p in fp)


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def main():
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    key_mapping = args[1]

    if is_vim_window(window):
        encoded = encode_key_mapping(window, key_mapping)
        window.write_to_child(encoded)
        return

    default_hints_args = [
        "--hints-offset", "0",
        "--alphabet", "asdfghjkl;vnmiweoucqrzpbytx",
        "--hints-foreground-color", "green",
        "--hints-background-color", "black",
        "--hints-text-color", "red"
    ]

    if key_mapping == "ctrl+o":
        boss.run_kitten_with_metadata("hints", default_hints_args + ["--type", "hyperlink"])
    elif key_mapping == "ctrl+f":
        boss.run_kitten_with_metadata("hints", default_hints_args)
    elif key_mapping == "ctrl+u":
        window.scroll_page_up()
    elif key_mapping == "ctrl+d":
        window.scroll_page_down()
    elif key_mapping == "ctrl+x":
        # remapped ctrl-d (eof)
        window.send_text("all", "\x04")
    elif key_mapping == "ctrl+,":
        window.show_scrollback()
    elif key_mapping == "ctrl+/":
        boss.create_market()
    # elif key_mapping == "ctrl+t":
    #     boss.new_tab()
    elif key_mapping == "ctrl+1":
        boss.goto_tab(1)
    elif key_mapping == "ctrl+2":
        boss.goto_tab(2)
    elif key_mapping == "ctrl+3":
        boss.goto_tab(3)
    elif key_mapping == "ctrl+4":
        boss.goto_tab(4)
    elif key_mapping == "ctrl+5":
        boss.goto_tab(5)
    elif key_mapping == "ctrl+6":
        boss.goto_tab(6)
    elif key_mapping == "ctrl+7":
        boss.goto_tab(7)
    elif key_mapping == "ctrl+8":
        boss.goto_tab(8)
    elif key_mapping == "ctrl+9":
        boss.goto_tab(9)
    elif key_mapping == "ctrl+0":
        boss.goto_tab(0)

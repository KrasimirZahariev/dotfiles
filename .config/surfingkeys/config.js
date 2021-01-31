//-------------------------------------------------------------------------------
//                                  SETTINGS
//-------------------------------------------------------------------------------
Hints.characters = 'asdfghjklmnvowiu';
settings.hintAlign = "left";
settings.omnibarPosition = "middle";
settings.omnibarSuggestion = true;
settings.omnibarSuggestionTimeout = 200;
settings.focusFirstCandidate = false;
settings.modeAfterYank = "Normal";
settings.scrollStepSize = 100;
settings.focusAfterClosed = "last";
settings.newTabPosition = "last";

//-------------------------------------------------------------------------------
//                                  MAPPINGS
//-------------------------------------------------------------------------------
//Page related
map("<Ctrl-d>", "d"); //Half page down
map("_e", "e"); //remap helper
unmap("e");
map("<Ctrl-u>", "_e"); //Half page up
map("u", "S"); //Go back
map("U", "D"); //Go forward

//Tab related
map("q", "x"); //Close current tab
map("Q", "X"); //Reopen closed tab
map("gf", "t"); //Go to url in new tab
map("F", "af"); //Open link in new tab
map("H", "g0"); //Go to first tab
map("L", "g$"); //Go to last tab
map(";h", "E"); //Go one tab left
map(";l", "R"); //Go one tab right
map(";b", "T"); //List tabs
map("<Alt-Tab>", "<Ctrl-6>"); //Go to last used tab
map("or", "ox"); //Open recently closed tab

//Editing
map("eu", ";U"); //Edit current url
map("ev", ";e"); //Edit surfingkeys settings

//Bookmarks
map("ba", "ab"); //Add to bookmarks
map("bo", "b"); //Open bookmark

//Yanking
map("yl", "ya"); //Yank link on the page
cmap("<Ctrl-c>", "<Ctrl-e>"); //Yank selection in omnibar

//Visual mode
vmap("H", "0"); //Beginning of the line
vmap("L", "$"); //End of the line
vunmap("t");
vmapkey("t", "#9BG Translate", function() {
    if (window.getSelection().toString()) {
        searchSelectedWith('https://translate.google.com/?sl=auto&tl=bg&text=', false, false, '');
    }
});

//-------------------------------------
//           ACE EDITOR
//-------------------------------------
aceVimMap('H', '0', 'normal');
aceVimMap('L', '$', 'normal');

//-------------------------------------
//           SEARCH ENGINES
//-------------------------------------
map("sg","og"); //Google
map("sy","oy"); //YouTube

//Aur
addSearchAliasX(
    "a",
    "AUR",
    "https://aur.archlinux.org/packages/?O=0&SeB=nd&outdated=&SB=v&SO=d&PP=100&do_Search=Go&K=",
    "s"
)
mapkey("sa", "#8Search AUR", function() {
    Front.openOmnibar({type: "SearchEngine", extra: "a"})
});

//ArchWiki
addSearchAliasX(
    "w",
    "ArchWiki",
    "https://wiki.archlinux.org/index.php?go=go&search=",
    "s",
    "https://wiki.archlinux.org/api.php?action=opensearch&format=json&formatversion=2&namespace=0&limit=10&suggest=true&search=",
    function(response) { Omnibar.listWords(JSON.parse(response.text)[1]) }
)
mapkey("sw", "#8Search ArchWiki", function() {
    Front.openOmnibar({type: "SearchEngine", extra: "w"})
});


//-------------------------------------
//              UNMAPS
//-------------------------------------
// const unmaps = [ "cf", "<Ctrl-j>", "<Ctrl-h>", "S", "D"]
// unmaps.forEach((mapping) => {
//   unmap(mapping)
// })
iunmap(":"); //Dont't trigger emojis

//-------------------------------------------------------------------------------
//                                  THEME
//-------------------------------------------------------------------------------
// ---- Hints ----
Hints.style('border: solid 1px #52C196; color:#52C196; background: initial; background-color: #1D1F21;');
Hints.style("border: solid 1px #52C196 !important; padding: 1px !important; color: #52C196 !important; background: #1D1F21 !important;", "text");
Visual.style('marks', 'background-color: #52C196;');
Visual.style('cursor', 'background-color: #52C196;');

settings.theme = `
:root {
  --font: 'Fire Code';
  --font-size: 12;
  --font-weight: bold;
  --fg: #52C196;
  --bg: #282A2E;
  --bg-dark: #1D1F21;
  --border: #373b41;
  --main-fg: #81A2BE;
  --accent-fg: #52C196;
  --info-fg: #AC7BBA;
  --select: #585858;
}

/* ---------- Generic ---------- */
.sk_theme {
background: var(--bg);
color: var(--fg);
  background-color: var(--bg);
  border-color: var(--border);
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
}
input {
  font-family: var(--font);
  font-weight: var(--font-weight);
}
.sk_theme tbody {
  color: var(--fg);
}
.sk_theme input {
  color: var(--fg);
}
/* Hints */
#sk_hints .begin {
  color: var(--accent-fg) !important;
}
#sk_tabs .sk_tab {
  background: var(--bg-dark);
  border: 1px solid var(--border);
  color: var(--fg);
}
#sk_tabs .sk_tab_hint {
  background: var(--bg);
  border: 1px solid var(--border);
  color: var(--accent-fg);
}
.sk_theme #sk_frame {
  background: var(--bg);
  opacity: 0.2;
  color: var(--accent-fg);
}

/* ---------- Omnibar ---------- */
.sk_theme#sk_omnibar {
  width: 80%;
}
.sk_theme .title {
  color: var(--accent-fg);
}
.sk_theme .url {
  color: var(--main-fg);
}
.sk_theme .annotation {
  color: var(--accent-fg);
}
.sk_theme .omnibar_highlight {
  color: var(--accent-fg);
}
.sk_theme .omnibar_timestamp {
  color: var(--info-fg);
}
.sk_theme .omnibar_visitcount {
  color: var(--accent-fg);
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: var(--bg-dark);
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: var(--border);
}
.sk_theme #sk_omnibarSearchArea {
  border-top-color: var(--border);
  border-bottom-color: var(--border);
}
.sk_theme #sk_omnibarSearchArea input,
.sk_theme #sk_omnibarSearchArea span {
  font-size: var(--font-size);
}
.sk_theme .separator {
  color: var(--accent-fg);
}

/* ---------- Popup Notification Banner ---------- */
#sk_banner {
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
  background: var(--bg);
  border-color: var(--border);
  color: var(--fg);
  opacity: 0.9;
}

/* ---------- Popup Keys ---------- */
#sk_keystroke {
  background-color: var(--bg);
}
.sk_theme kbd .candidates {
  color: var(--info-fg);
}
.sk_theme span.annotation {
  color: var(--accent-fg);
}

/* ---------- Popup Translation Bubble ---------- */
#sk_bubble {
  background-color: var(--bg) !important;
  color: var(--fg) !important;
  border-color: var(--border) !important;
}
#sk_bubble * {
  color: var(--fg) !important;
}
#sk_bubble div.sk_arrow div:nth-of-type(1) {
  border-top-color: var(--border) !important;
  border-bottom-color: var(--border) !important;
}
#sk_bubble div.sk_arrow div:nth-of-type(2) {
  border-top-color: var(--bg) !important;
  border-bottom-color: var(--bg) !important;
}

/* ---------- Search ---------- */
#sk_status,
#sk_find {
  font-size: var(--font-size);
  border-color: var(--border);
}
.sk_theme kbd {
  background: var(--bg-dark);
  border-color: var(--border);
  box-shadow: none;
  color: var(--fg);
}
.sk_theme .feature_name span {
  color: var(--main-fg);
}

/* ---------- ACE Editor ---------- */
#sk_editor {
  background: var(--bg-dark) !important;
  height: 1% !important;
}
.ace_dialog-bottom {
  border-top: 1px solid var(--bg) !important;
}
.ace-chrome .ace_print-margin,
.ace_gutter,
.ace_gutter-cell,
.ace_dialog {
  background: var(--bg) !important;
}
.ace-chrome {
  color: var(--fg) !important;
}
.ace_gutter,
.ace_dialog {
  color: var(--fg) !important;
}
.ace_cursor {
  color: var(--fg) !important;
}
.normal-mode .ace_cursor {
  background-color: var(--fg) !important;
  border: var(--fg) !important;
  opacity: 0.35 !important;
}
.ace_marker-layer .ace_selection {
  background: var(--fg) !important;
  opacity: 0.25 !important;
}
.ace_editor,
.ace_dialog span,
.ace_dialog input {
  font-family: var(--font);
  font-size: var(--font-size);
//   font-weight: var(--font-weight);
}
`;

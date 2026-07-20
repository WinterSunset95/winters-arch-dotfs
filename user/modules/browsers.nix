{
  programs.qutebrowser = {
    enable = true;
    settings = {
      # App Preferences
      auto_save.session = true;
      session.lazy_restore = true;

      # UI Preferences
      editor.command = ["kitty" "-e" "nvim" "{file}"];
      url.start_pages = "https://www.google.com";
      url.default_page = "https://www.google.com";
      input.insert_mode.auto_load = false;
      tabs.background = true;
      url.open_base_url = true;
      tabs.show = "always";
      tabs.position = "right";
      content.pdfjs = true;

      # Tab area rice
      colors.tabs.bar.bg = "#1e2030";
      colors.tabs.even.bg = "#24273a";
      colors.tabs.odd.bg = "#24273a";
      colors.tabs.even.fg = "#cad3f5";
      colors.tabs.odd.fg = "#cad3f5";

      # Dark mode
      colors.webpage.darkmode.enabled = true;
      colors.webpage.darkmode.policy.images = "smart";
      colors.webpage.darkmode.policy.page = "smart";


    };
    keyBindings = {
      normal = {
        "gh" = "config-cycle tabs.show always switching";
      };
    };
    extraConfig = ''
      c.tabs.padding = {
        "bottom": 5,
        "left": 5,
        "right": 5,
        "top": 5
      };
      # Searchengines
      c.url.searchengines = {
        "DEFAULT": "https://www.google.com/search?q={}",
        "aw": "https://wiki.archlinux.org/index.php?search={}&title=Special%3ASearch&profile=default&fulltext=1",
        "brv": "https://search.brave.com/search?q={}",
        "ddg": "https://lite.duckduckgo.com/lite/{}",
        # youtube sucks
        #	"yt": "https://yewtu.be/search?q={}",
        "ngm": "https://www.nigma.net.ru/en/index.php?query={}",
        "srx": "https://searx.tiekoetter.com/search?q={}&category_general=on&language=en-US&time_range=&safesearch=0&theme=simple",
        "cdb": "https://codeberg.org/explore/repos?sort=recentupdate&language=&q={}",
        "ksl": "https://classifieds.ksl.com/search?keyword={}",
        "ig": "https://infogalactic.com/w/index.php?search={}",
        "st": "https://simplytranslate.org/?engine=deepl{}",
        "wb": "https://wiby.me/?q={}",
        "gig": "https://gigablast.com/search?c=main&qlangcountry=en-us&q={}",
        "mjk": "https://www.mojeek.com/search?q={}",
        "tld": "https://tilde.wtf/search?q={}",
        "tlv": "https://tilvids.com/search?search={}&searchTarget=local",
        # openbsd-specific
        "obspa": "https://marc.info/?l=openbsd-ports&w=2&r=1&s={}&q=b",
        "bsdp": "https://openports.se/search.php?stype=folder&so={}",
      };
      # Hardware acceleration
      c.qt.args = ["ignore-gpu-blocklist", "enable-gpu-rasterization", "enable-native-gpu-memory-buffers"];
    '';
  };
  programs.firefox = {
    enable = true; 
  };
}

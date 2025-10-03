from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

config: ConfigAPI = config
c: ConfigContainer = c

background = "#24273a"  # Background
background_light = "#1e2030"  # Lighter Background (for status bar, etc.)
highlights = "#494d64"  # Non-text highlights
text = "#cad3f5"  # Main Text
error = "#ed8796"  # Red (for errors)
warning = "#f5a97f"  # Orange / Yellow (for warnings)
match = "#eed49f"  # Yellow (for matches)
green = "#a6da95"  # Green
teal = "#8bd5ca"  # Teal
blue = "#8aadf4"  # Blue
selected = "#b7bdf8"  # Lavender (for selected items)

# App Preferences
config.load_autoconfig(True)
c.auto_save.session = True
c.session.lazy_restore = True

#UI Preferences
c.editor.command = ["kitty", "-e", "nvim", "{file}"]
c.url.start_pages = "https://www.google.com"
c.url.default_page = "https://www.google.com"
c.input.insert_mode.auto_load = False
c.tabs.background = True
c.url.open_base_url = True
c.tabs.show = "always"
c.tabs.position = "right"
# Tab area rice
c.colors.tabs.bar.bg = background_light
c.colors.tabs.even.bg = background
c.colors.tabs.odd.bg = background
c.colors.tabs.even.fg = text
c.colors.tabs.odd.fg = text
c.tabs.padding = {
        "bottom": 5,
        "left": 5,
        "right": 5,
        "top": 5
        }

# Dark mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "smart"
c.colors.webpage.darkmode.policy.page = "smart"

# solarized css
c.content.user_stylesheets = [
    #'./solarized-dark-all-sites.css',
]

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
}

# bindings 
config.bind('pt', 'tab-pin')
config.bind(';w','hint links spawn --output-messages yt-dlp -quiet --progress -P ~/media/video/playlist {hint-url}')
config.bind(';g','hint links spawn git clone {hint-url}')
config.bind(';d','hint links spawn --output-messages ftp {hint-url}')
config.bind(';W','spawn --output-messages yt-dlp -quiet --progress -P ~/media/video/playlist {url}')
config.bind(';i','config-source i2pconfig.py')
config.bind(';t','config-source torconfig.py')

c.qt.chromium.process_model = "process-per-site-instance" 
# security & privacy settings
#c.content.webgl = False
#c.content.dns_prefetch = False
#c.content.canvas_reading = False
#c.content.xss_auditing = True
## "Do not track" is actually used to track you. Ironic, I know.
#c.content.headers.do_not_track = False
#c.content.javascript.enabled = False
## If you want privacy, you don't want anything web stored on your computer. No history, no cache, nothing. Take notes and make additional search engines. Quickmarks, bookmarks and cookies get deleted after a restart assuming you're using my wrapper script
#c.content.cache.appcache = False
#c.content.local_storage = False
#c.completion.web_history.max_items = 0
## Cookies are blocked by Jmatrix, we leave them semi-enabled. 
#c.content.cookies.accept = "no-3rdparty"
## Private browsing does not work in single-process mode
#c.content.private_browsing = True
## Why can't I just disable it, The-Compiler?
#c.content.webrtc_ip_handling_policy = "disable-non-proxied-udp"
# adblock
c.content.blocking.enabled = False
c.content.blocking.method = "both"
# A lean, effective and non-breaking adblock list
c.content.blocking.adblock.lists = [
    # Core adblocking and privacy
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    # Block malicious URLs
    "https://gitlab.com/curben/urlhaus-filter/-/raw/master/urlhaus-filter.txt",
    # Remove cookie consent banners (a high-value annoyance filter)
    "https://www.i-dont-care-about-cookies.eu/abp/",
    # A list of rules to fix sites broken by other filters
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
]
c.content.blocking.hosts.lists = [
        "https://theajack.github.io/"
        ]
#c.content.blocking.whitelist = ['']

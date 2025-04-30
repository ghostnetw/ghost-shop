fx_version "cerulean"
game "gta5"

lua54 "yes"
use_experimental_fxv2_oal "yes"

author "ghostnetw"
description "Nice Shop For RP"
version "2.0.0"
repository "https://github.com/ghostnetw/ghost-shop"


shared_scripts {
    "@ox_lib/init.lua",
    "shared/utils/*.lua",
}
server_scripts {
    "bridge/server/*.lua",
    "server/utils/*.lua",
    "server/modules/*.lua",
    "server/*.lua",
}
client_scripts {
    "client/*.lua",
}

files {
    "web/dist/**/*",
    "config/*.lua",
    "client/utils/*.lua",
    "client/modules/*.lua",
}

ui_page { "web/dist/index.html" }

dependencies { "ox_lib" }

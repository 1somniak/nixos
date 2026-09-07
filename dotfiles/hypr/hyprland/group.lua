---------------
---- GROUP ----
---------------

hl.config({
    group = {
        ["col.border_active"]   = "0xffcba6f7",
        ["col.border_inactive"] = "0xff313244",

        -- Titres des fenêtres groupées (la barre au dessus)
        groupbar = {
            enabled        = true,
            font_size      = 12,
            text_color     = "0xffffffff",
            ["col.active"]   = "0xffcba6f7",  -- Violet quand actif
            ["col.inactive"] = "0xff313244",  -- Gris foncé quand inactif
        },
    },
})

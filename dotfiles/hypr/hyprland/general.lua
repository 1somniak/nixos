-----------------
---- GENERAL ----
-----------------

hl.config({
    general = {
        gaps_in     = 1,
        gaps_out    = 0,

        border_size = 1,

        ["col.active_border"] = {
            colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
            angle  = 45,
        },
        ["col.inactive_border"] = "rgba(595959aa)",

        -- Permet de redimensionner les fenêtres en tirant les bordures
        resize_on_border     = true,
        hover_icon_on_border = true,

        allow_tearing = false,

        layout = "dwindle",
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },
})

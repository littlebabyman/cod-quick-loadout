AddCSLuaFile()
CreateConVar("quickloadout_enable", 1, {FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY}, "Enable Quick Loadout.", 0, 1)
CreateConVar("quickloadout_default", -1, {FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY}, "Enable default loadout.", -1, 1)
CreateConVar("quickloadout_maxslots", 10, {FCVAR_ARCHIVE + FCVAR_REPLICATED}, "Max weapon slots in a loadout.", 0, 32)
CreateConVar("quickloadout_switchtime", 15, {FCVAR_ARCHIVE + FCVAR_REPLICATED}, "Grace period length to switch loadout after spawn.", 0)
CreateConVar("quickloadout_spawnclips", 5, {FCVAR_ARCHIVE + FCVAR_REPLICATED}, "Amount of clips worth of ammo a weapon gets upon applying a loadout.", 0)
CreateConVar("quickloadout_switchtime_override", 0, {FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY}, "Force grace period off on pressing primary attack.", 0, 1)

if CLIENT then
    CreateClientConVar("quickloadout_enable_client", 1, true, true, "Enable quick loadout sending.", 0, 1)
    CreateClientConVar("quickloadout_default_client", 1, true, true, "Request default loadout upon sending it.", 0, 1)
    CreateClientConVar("quickloadout_weapons", "", true, true, "Quick loadout weapon classes. Nonfunctional, only exists to bring 'old' autosaved loadout to new system.")
    CreateClientConVar("quickloadout_key", "n", true, false, "Quick loadout keybind.")
    CreateClientConVar("quickloadout_showcategory", 1, true, false, "Show weapon categories on equipped weapons.")
    CreateClientConVar("quickloadout_ui_fonts", "Bahnschrift", true, false, "Fonts used in the loadout menu.")
    CreateClientConVar("quickloadout_ui_font_scale", 1, true, false, "Overall scale of the fonts.", 0.5, 2)
    CreateClientConVar("quickloadout_ui_color_bg", "0 0 0", true, false, "Base color used for loadout menu background.")
    CreateClientConVar("quickloadout_ui_color_button", "96 128 192", true, false, "Base color used for loadout menu buttons.")
end
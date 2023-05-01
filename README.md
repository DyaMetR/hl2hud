# Half-Life 2 Customizable Heads Up Display

![](https://img.shields.io/github/v/release/DyaMetR/hl2hud)
![](https://img.shields.io/steam/views/2954934766)
![](https://img.shields.io/steam/downloads/2954934766)
![](https://img.shields.io/steam/favorites/2954934766)
![](https://img.shields.io/github/issues/DyaMetR/hl2hud)
![](https://img.shields.io/github/license/DyaMetR/hl2hud)

This addon for Garry's Mod mimicks the Heads Up Display feature from Valve's 2004 game Half-Life 2, adding a deep customization layer to it.

## Installation

### Steam Workshop

+   Go to the addon's [Steam Workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=2954934766) and **subscribe** to it.

### Legacy install

#### Cloning the repository

+   Go to your Garry's Mod `addons` folder.
+   Open a _terminal_.
+   `git clone git@github.com:DyaMetR/hl2hud.git`

#### Download latest release

+   **Download** the [latest release](https://github.com/DyaMetR/hl2hud/releases).
+   Go to your Garry's Mod `addons` folder.
+   Unzip the _downloaded `.zip` file_ there.

## How to use

Once installed you can find the options at:

`Build menu (Q by default) -> Utilities -> Half-Life 2 HUD`

Here you can find the following options:

+   `Enabled` toggles the HUD entirely.
+   `Draw without suit` will draw the HUD even if the player is not wearing their HEV suit.
+   `Keep CHud elements hidden` will hide default HUD elements even if their Lua counter parts are disabled.
+   `Minimal hints` will only display map hints. Weapon and vehicle hints will be disabled.
+   The `Schemes` list lets you to quickly swap between registered schemes.
+   `Edit current scheme` will open the [scheme customization menu](#scheme-customization-menu).
+   `Reset scheme to default` will reset your current scheme to the default one. Losing any unsaved changes.

### Scheme customization menu

The scheme customization menu allows you to change numerous aspects of your HUD, which are divided in different categories:

+   `ClientScheme` changes colours and fonts.
+   `HudLayout` changes HUD elements' properties.
+   `HudAnimations` changes how the HUD reacts to certain events.
+   `HudTextures` changes the different icons for weapons, ammunition and items.

### Manual initialization

In case you're playing on a server that has `sv_allowcslua` enabled, you can initialize this HUD with the console command: `lua_openscript_cl hl2hud_init.lua`

**BEWARE**: The following features will NOT work on a server that does not have this addon installed.

+   Poison damage indicator
+   _FULL_ ammunition pickup message
+   Vehicle crosshairs
+   Squad status indicator

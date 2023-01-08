# Parallax 2D node for Godot 4
Provides parallax 2D node to avoid using ParallaxBackground

This is a plugin for [Godot Engine](https://godotengine.org) 4.X that provides new class `Parallax` inherited from Node2D that moves itself relative to actual viewport center. It helps create beautiful volumetric decorations like foliage, distant or near objects ant other effects based on following viewport.

This is a port of the [similar plugin](https://godotengine.org/asset-library/asset/1557) from Godot 3.4.X to 4.X.X

You can:
- Disable/enable it in game and optionally in editor
- Control motion_scale and motion_offset like in ParallaxLayer
- Set process mode (Process / Physics process)

[![image](https://user-images.githubusercontent.com/7024016/202920689-7782adb5-d22f-4873-bc6c-0c1dc5445a81.png)](https://user-images.githubusercontent.com/7024016/202920636-4e71b6a4-32e3-490f-ab75-32e63cfb4dca.png)

[Screencast on YouTube](https://youtu.be/kTPX_Etzy2Y)

## Installation

Download or clone this repository and copy the contents of the
`addons` folder to your own project's `addons` folder.

Then enable the plugin on the Project Settings and use new class in your scenes.

## License

[MIT License](LICENSE). Copyright (c) 2022 Nikolay Lebedev aka nklbdev.

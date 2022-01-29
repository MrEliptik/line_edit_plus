A custom node addon bringing the power of Regex to the LineEdit node.

Made for the [Godot Addon Jam](https://itch.io/jam/godot-addons-jam-1). [Itch page](https://mreliptik.itch.io/lineeditplus)

## Features

Custom node
<p align="center">
  <img src="screenshots/lineedit_plus.png" width="200">
</p>

Premade Regex patterns or custom ones
<p align="center">
  <img src="screenshots/lineedit_inspector.png" width="200">
</p>

## How to use

Tick the `Use Regex` box and choose between a `predefined pattern` or enter your `custom Regex pattern`.

The lineedit node will automatically remove the characters that are not fitting the pattern.

*For example: If you enter a Digits only Regex, all the non digits characters will be removed when the user types them.*

## How to install

Extract the `line_edit_+` folder into the addons folder of you project (create one if needed).

<p align="center">
  <img src="screenshots/settings.png" width="800">
</p>

Then head to `Project Settings > Plugins` and enable `LineEdit+`. You can now add a new node and select `LineEdit+` instead of LineEdit.

<p align="center">
  <img src="screenshots/new_node.png" width="800">
</p>

## LICENSE

This project is distrbuted as-is, under the MIT license. Check [LICENSE](LICENSE) for more detail.

Made by [MrEliptik](https://twitter.com/mreliptik_) for the [Godot Addon Jam](https://itch.io/jam/godot-addons-jam-1)
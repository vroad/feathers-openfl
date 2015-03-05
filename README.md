# feathers-openfl
Unofficial port of Feathers UI Framework.

[io.js version of demo for Windows](https://www.dropbox.com/s/eor7mmc7wec2j0q/feathers-openfl-ComponentExplorer_20150305.zip?dl=0)

Install
-------

    haxelib git openfl https://github.com/vroad/feathers-openfl

Dependencies:

  [starling-openfl and its dependent libraries](https://github.com/vroad/starling-openfl)

Current Limitations
-------------------

* Currently only works on HTML5 and Node.js.
* Current does not work correctly on original version of OpenFL and lime.
* Only Next version of OpenFL is supported.
* ScrollText doesn't work correctly.
* TextInput doesn't work correctly.
* Numeric Stepper is still buggy on HTML5.
* TextBlockTextRenderer is not supported.
* On HTML5, Texts are rendered with TextFieldTextRenderer.
  * Texts on html5 may look diffrent from that of native targets.
* On native targets, Texts are rendered with BitmapFontTextRenderer.
  * Outline fonts are rendered with FreeType renderer implemented top of BitmapFont.
* If you move the mouse cursor outside of the window, touch processor still think that cursor is inside.

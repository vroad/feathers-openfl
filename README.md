# feathers-openfl
Unofficial port of Feathers UI Framework.

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

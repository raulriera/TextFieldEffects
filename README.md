# TextFieldEffects [![Build Status](https://travis-ci.org/raulriera/TextFieldEffects.svg?branch=master)](https://travis-ci.org/raulriera/TextFieldEffects)

I fell in love with the text inputs effects in [this article](http://tympanus.net/codrops/2015/01/08/inspiration-text-input-effects/). As an exercise I decided to recreate as many of them as I can using Swift *(some of them have a personal touch)*.

Currently it features the following effects from the article:

- [x] Kaede
- [x] Hoshi
- [x] Jiro
- [x] Isao
- [x] Minoru
- [x] Yoko
- [x] Madoka
- [x] Akira
- [x] Yoshiko

## How they look

### Kaede
<img src="/Screenshots/Kaede.gif" />

### Hoshi
<img src="/Screenshots/Hoshi.gif" />

### Jiro
<img src="/Screenshots/Jiro.gif" />

### Isao
<img src="/Screenshots/Isao.gif" />

### Minoru
<img src="/Screenshots/Minoru.gif" />

### Yoko
<img src="/Screenshots/Yoko.gif" />

### Madoka
<img src="/Screenshots/Madoka.gif" />

### Akira
<img src="/Screenshots/Akira.gif" />

### Yoshiko
<img src="/Screenshots/Yoshiko.gif" />

## Installation

- Looking for Swift 2.3 support? Check out the [1.2.0](https://github.com/raulriera/TextFieldEffects/releases/tag/1.2.0) tag.
- Looking for Swift 2.1 support? Check out the [1.1.1](https://github.com/raulriera/TextFieldEffects/releases/tag/1.1.1) tag.
- Looking for Swift 1.2 support? Check out the `swift-1.2` branch.

### Manual

The easiest way to install this framework is to drag and drop the `TextFieldEffects/TextFieldEffects` folder into your project. This also prevents the `frameworks` [problem in iOS](http://www.openradar.me/21258097) where the IBInspectable and IBDesignable are stripped out.

### CocoaPods

Add the following to your Podfile:

``` ruby
use_frameworks!
pod 'TextFieldEffects'
```

### Carthage

Add the following to your Cartfile:

``` ruby
github 'raulriera/TextFieldEffects'
```

## How to use them

Every effect is properly documented in the source code, this is the best way to both understand and see what they do. There is also an example project included with all the effects and their settings.

### Interface Builder

The library is a simple drop-in, as soon as you set your subclass to one of the effects and your module to `TextFieldEffects` you will be able to see all the IBDesignable settings in the storyboard.

### Code

If you like to get your hands dirty, you can use them just like you would normally use any `UITextField`

``` swift
let textField = KaedeTextField(frame: textFieldFrame)
textField.placeholderColor = .darkGrayColor()
textField.foregroundColor = .lightGrayColor()

view.addSubView(textField)
```

Is that simple.

## Created by
Raul Riera, [@raulriera](http://twitter.com/raulriera)

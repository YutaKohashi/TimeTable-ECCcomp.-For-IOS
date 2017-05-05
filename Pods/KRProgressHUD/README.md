[日本語](./README_Ja.md)

# KRProgressHUD

[![Version](https://img.shields.io/cocoapods/v/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![License](https://img.shields.io/cocoapods/l/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Download](https://img.shields.io/cocoapods/dt/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/krimpedance/KRProgressHUD.svg?style=flat)](https://travis-ci.org/krimpedance/KRProgressHUD)

`KRProgressHUD` is a beautiful and easy-to-use progress HUD for your iOS written by Swift.

[KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicator) is used for loading view.

<img src="./Resources/demo.gif" height=400>
<img src="./Resources/styles.png" width=400>

## Features
- Round indicator
- Indicator color can be customized

## Requirements
- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+

## DEMO
To run the example project, clone the repo, and open `KRProgressHUDDemo.xcodeproj` from the DEMO directory.

or [appetize.io](https://appetize.io/app/nw022juw0znkf1n5u6ynga5ntm)

## Installation
KRProgressHUD is available through [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).
To install it, simply add the following line to your Podfile or Cartfile:

```ruby
# CocoaPods
pod "KRProgressHUD"
```

```ruby
# Carthage
github "Krimpedance/KRProgressHUD"
```

## Usage
(see sample Xcode project in /Demo)

###### Caution :
**Only use it if you absolutely need to perform a task before taking the user forward.**

**If you want to use it with other cases (ex. pull to refresh), I suggest using [KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicator).**


`KRProgressHUD` is created as a singleton.

At first, import `KRProgressHUD` in your swift file.


Show simple HUD (using GCD) :
```Swift
KRProgressHUD.show()

let delay = DispatchTime.now() + 1
DispatchQueue.main.asyncAfter(deadline: delay) {
		KRProgressHUD.dismiss()
}
```

#### Showing the HUD
You can show HUD with some args.
You can appoint only the args which You want to appoint.
(Args is reflected only this time.)
```Swift
// progressHUDStyle : background color of progressView
// maskType : background color of maskView
// activityIndicatorStyle : style of KRActivityIndicatorView
// message : Text to display together
// image : Image that display instead of activity indicator
class func show(
    progressHUDStyle progressStyle :KRProgressHUDStyle? = nil,
    maskType type:KRProgressHUDMaskType? = nil,
    activityIndicatorStyle indicatorStyle :KRProgressHUDActivityIndicatorStyle? = nil,
    message :String? = nil,
    font :UIFont? = nil,
    image :UIImage? = nil,
    completion: (()->())? = nil
)

// Example
KRProgressHUD.show()
KRProgressHUD.show(message: "Loading...")
KRProgressHUD.show(progressHUDStyle: .black, message: "Loading...")
...
```

#### Update the HUD's message
The HUD can update message.
```Swift
class func update(text: String)

// Example
KRProgressHUD.update(text: "20%")
```

#### Show the HUD (only message)
The HUD can indicate only message.
```Swift
	public class func showText(
            message: String, font: UIFont? = nil,
            centerPosition position: CGPoint? = nil,
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type: KRProgressHUDMaskType? = nil)

// Example
KRProgressHUD.showText("Setup is complete!")
```

#### Dismissing the HUD
The HUD can be dismissed using:
```Swift
class func dismiss(_ completion: (()->())?)
```
Show a confirmation glyph before getting dismissed a little bit later.
(The display time is 1 sec.)

These can appoint some args like `show()`, too.

```Swift
class func showSuccess()
class func showInfo()
class func showWarning()
class func showError()
```

## Customization
`KRProgressHUD` can be customized via the following methods.
```Swift
public class func set(maskType: KRProgressHUDMaskType)  // Default is .black
public class func set(style: KRProgressHUDStyle)  // Default is .white
public class func set(activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle)  // Default is .black
public class func set(font: UIFont)  // Default is Hiragino Sans W3 13px (When it can't be used, system font 13px)
public class func set(centerPosition: CGPoint)  // Default is center of device screen.
```
`KRActivityIndicatorView`'s style, please refer to [here](https://github.com/krimpedance/KRActivityIndicator/blob/master/README.md).

## Contributing to this project
I'm seeking bug reports and feature requests.

## Release Note
- 2.2.1 : Modify `M_PI` to `Double.pi` in KRActivityIndicatorView.swift for Swift3 coding.
- 2.2.1 : Fixed bug of message label's position after calling `showText()`
- 2.2.0 : Add `KRProgressHUDStyle.color(background: UIColor, contents: UIColor)`.
          This can set custom color of HUD's background and contents(text, glyph icon).

## License
KRProgressHUD is available under the MIT license. See the LICENSE file for more info.

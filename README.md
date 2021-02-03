# 🦅oneHookLibrary 🦅

oneHookLibrary is a very ambiguous Library that aim to make iOS development even easier for iOS11 +

- [Kotlin Style Code](#kotlin-style-code)
- [Assets Script](#assets-script)
- [Declarative UI Building](#declarative-ui-building)
- [Other Utilities](#other-utilities)

## Integration Guide

I do not have time to turn this lib into pods or SPM, for now, you can add this lib as a submodule

run the following command to add this repo as a submodule, by default, it will use `release` branch

`git submodule add git@github.com:oneHook/oneHookLibrarySwift.git`

run the following command if you wish to check any latest release/change

`git submodule update --remote --merge`

## Samples

open `oneHookLibrarySwift.xcodeproj` to run the samples

# Features

## Kotlin Style Code

Are you tired of write code like this?

```
var a = something()
a.value1 = 5
a.value2 = 6
a.value3 = 7
```

Me too!

Inspired by `Kotlin` now you can do this

```
var a = something().apply {
    $0.value1 = 5
    $0.value2 = 6
    $0.value3 = 7
}
```

or

```
var a = something()
a.also {
    $0.value1 = 5
    $0.value2 = 6
    $0.value3 = 7
}
```

this enable us to better group code like this

```
let label = UILabel().apply {
   $0.font = ...
   $0.text = ...
}
```

## Assets Script

Are you tired of getting assets/strings like this?

```
UIImage(named: "xxx")
NSLocalizedString("xxx", comment: "xxx")
```

Remember that time you wasted 2 hours on a spelling error? No? Ok fine, shame on you

now with the asserts script, once you set it up in build phase, it will generate swift code that does all that for you, now you only do 

```
UIImage(named: R.Images.xxx)
R.Strings.xxx
```

### Instruction

1. install [Python3](https://www.python.org/downloads/)
2. Create a new file and define a empty class R
3. Add a new run script to your target and use the following, replace the path with your own
4. Just run, code will be auto generated

```
COLOR_SCRIPT_LOCATION="${SRCROOT}/oneHookLibrary/Script/color_assets_script.py"
COLOR_ASSET_LOCATION="${SRCROOT}/Sample/Assets/Colors.xcassets"
DARK_COLOR_ASSET_LOCATION="${SRCROOT}/Sample/Assets/Colors.xcassets/DarkMode"
COLOR_CLASS_LOCATION="${SRCROOT}/Sample/Assets"

python3 ${COLOR_SCRIPT_LOCATION} ${COLOR_ASSET_LOCATION} ${DARK_COLOR_ASSET_LOCATION} ${COLOR_CLASS_LOCATION}

IMAGE_SCRIPT_LOCATION="${SRCROOT}/oneHookLibrary/Script/assets_script.py"
IMAGE_ASSETS_LOCATION="${SRCROOT}/Sample/Assets/Assets.xcassets"
IMAGE_CLASS_LOCATION="${SRCROOT}/Sample/Assets/ImageAssets.swift Image"

python3 ${IMAGE_SCRIPT_LOCATION} ${IMAGE_ASSETS_LOCATION} ${IMAGE_CLASS_LOCATION}
```

## Declarative UI Building

Do you want to use `SwiftUI` but don't want to lose 30% users?
Do you want to use `AutoLayout` but found it way too complicated for simple case?
Do you want to use `storyboard` but... No, nobody wants to use storyboard, it's shit

now you can build UI like this, the following code made a simple `UITableViewCell` with title/subtitle

```
class SimpleTableViewCell: SelectableTableViewCell {

    private let stackLayout = StackLayout().apply {
        $0.padding = Dimens.marginMedium
        $0.contentGravity = .centerVertical
        $0.orientation = .vertical
        $0.spacing = Dimens.marginMedium
    }

    let titleLabel = EDLabel().apply {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .defaultTextColor
    }

    let subtitleLabel = EDLabel().apply {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .defaultTextColor
    }

    override func commonInit() {
        super.commonInit()
        backgroundColor = .clear
        contentView.addSubview(stackLayout.apply {
            $0.addSubview(titleLabel)
            $0.addSubview(subtitleLabel)
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackLayout.matchParent()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        stackLayout.sizeThatFits(size)
    }
}
```

## Other Utilities

TODO

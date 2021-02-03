# 🦅oneHookLibrary 🦅

oneHookLibrary is a very ambiguous Library that aim to make iOS development even easier

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

TODO

## Declarative UI Building

TODO

## Other Utilities

TODO

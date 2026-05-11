# ProfessionalAutoClicker

A professional Theos jailbreak tweak scaffold for an auto-clicker style overlay UI.

## What it includes

- Floating overlay button
- Slide-style menu panel
- Draggable point windows
- Add/delete/clear point management
- Interval and repeat preference model
- Preview engine using timers and point pulse animations
- Preferences bundle scaffold
- Clean Objective-C ARC structure
- Safe logging utility

## Safety boundary

This project intentionally does **not** synthesize real system touch events and does **not** bypass application/game protections. The included engine is visual-preview only. It is suitable for learning tweak architecture, overlays, point management, timers, and UI construction.

## Build

```sh
make clean package
```

## Install

```sh
make install
```

## Main files

```text
Tweak.xm
Classes/ACOverlayController.*
Classes/ACClickerEngine.*
Classes/ACPointView.*
Classes/ACMenuView.*
Classes/ACPreferences.*
Prefs/ACRootListController.*
```

## Notes

- Edit `ProfessionalAutoClicker.plist` to restrict injection if needed.
- Use the preference `targetBundleIdentifier` to restrict runtime display to one bundle.
- Keep Preview Mode enabled for safe testing.

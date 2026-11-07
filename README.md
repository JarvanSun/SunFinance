# SunFinance

A paper-trading app for iPhone, built with SwiftUI as a reference for how a modular, tested
codebase can look. Everything runs against a built-in mock exchange, so no keys or accounts are
needed.

- **Watchlist** with symbol search, **quote detail** with morphing charts and your own trades on
  them, an **order ticket** with market, limit, stop and scheduled orders, **Portfolio** and
  **Orders**.
- Six local Swift packages: `Watchlist`, `Instrument`, `Portfolio` and `Orders` in `Features/`,
  `DesignSystem` and `FinanceCore` in `Core/`. Features never import each other; networking and
  the mock server stay internal to `FinanceCore`.
- Swift 6 with strict concurrency, MVVM with Observation, ViewModels unit-tested with Swift
  Testing.
- English and German.

## Running

Requires Xcode 26 or later. Open `SunFinance.xcodeproj` and run it on a simulator; no signing is
needed.

Each package also has an app that runs it on its own: `<Package>/Playground/Playground.xcodeproj`.

## Code

How the code is written is described in [docs/spec](docs/spec/README.md).

## Licence

Copyright © 2026 Jiawen Sun. All rights reserved. The source is public to read; it may not be
copied, modified or redistributed without permission.

The Inter font is licensed separately under the SIL Open Font License 1.1
(`Core/DesignSystem/Sources/DesignSystem/Resources/Fonts/Inter-LICENSE.txt`).

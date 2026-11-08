# SunFinance

A paper-trading demo for iPhone, built with SwiftUI. It runs against a mock exchange inside the
app, so every price, balance and order is made up.

- **Watchlist** with symbol search, **quote detail** with morphing charts and your own trades on
  them, an **order ticket** with market, limit, stop and scheduled orders, **Portfolio** and
  **Orders**.
- Six local Swift packages: `Watchlist`, `Instrument`, `Portfolio` and `Orders` in `Features/`,
  `DesignSystem` and `FinanceCore` in `Core/`. Features never import each other; networking and
  the mock server stay internal to `FinanceCore`.
- Swift 6 with strict concurrency, MVVM with Observation, ViewModels unit-tested with Swift
  Testing.
- English and German.

## How it was made

I wrote the specs in [docs/spec](docs/spec/README.md) to describe my code style and how the app
should be built. Claude Code generated the app from them almost in one pass, and the code then went
through two rounds of code review.

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

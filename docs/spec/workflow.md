# Workflow

Commands are in [AGENTS.md](../../AGENTS.md#commands). The Xcode projects are committed and edited
in Xcode.

## Adding a feature

1. **Spec first.** Describe the feature in [product.md](product.md), its events in
   [analytics.md](analytics.md#what-we-track), new endpoints in
   [networking.md](networking.md#the-endpoint-catalogue), and any rule it needs that is missing.
2. **Data.** In the FinanceCore domain that owns the data: an endpoint folder with its request
   type and DTOs, the catalogue case, model mapping, provider protocol and service method, fixture
   and mock route, each with tests.
3. **Package.** Create `Features/<Name>` in the shape of `Watchlist`: `Package.swift`,
   `<Name>HostView`, `Navigation/` and `Playground/` (copy Watchlist's `Playground.xcodeproj` and
   swap the package and scheme names in Xcode).
4. **ViewModel.** Write it and its tests before the view.
5. **Views.** Screen, sections, placeholder, previews.
6. **Strings.** English and German in the package catalog.
7. **Wire up.** Add the local package to `SunFinance.xcodeproj` and link it to the App target, a
   method to `AppDependencies`, and the host to the App.

## Definition of done

- [ ] Builds without warnings in Swift 6 language mode.
- [ ] `scripts/format.sh --lint` succeeds.
- [ ] All tests pass; every new source file with logic has its test file.
- [ ] Every changed package builds, tests and previews on its own, and its playground shows the
      change.
- [ ] No `public` that another module does not use.
- [ ] No literal strings, numbers, colors or symbol names outside their owners.
- [ ] Every button has a DesignSystem style.
- [ ] Every new string exists in English and German.
- [ ] Every tracked event is in the analytics table.
- [ ] One preview per view file; the screen's `PreviewState` covers content, loading, empty, every
      failure and German.
- [ ] Checked in the canvas Variants: dark mode and every Dynamic Type size.
- [ ] VoiceOver reads every screen in a sensible order with complete labels.
- [ ] The spec still describes the code.

## Git

- Commit messages are imperative and say what changed and why: `Add price history request`.
- Commit the `.xcodeproj` files with their shared schemes and the project's `Package.resolved`;
  never commit `xcuserdata`, `DerivedData`, `.build`, a package's own `Package.resolved` or
  `Configuration/Signing.local.xcconfig`.

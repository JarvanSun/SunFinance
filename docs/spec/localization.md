# Localization

The app ships in English (development language) and German. Every user-facing string exists in
both before a change is done.

## String Catalogs

- Each package that shows text has one `Resources/Localizable.xcstrings`, read with
  `bundle: .module`: `Text` takes SwiftPM's `Bundle.module`, `LocalizedStringResource` the internal
  `LocalizedStringResource.BundleDescription.module` in
  `Extensions/BundleDescriptionExtensions.swift`. DesignSystem does the same.
- The App has its own catalog in its main bundle; its keys take no `bundle:` argument
  (`.init("app.tab.watchlist")`).
- A key is written once, where it is used. There are no key enums and no `static` text: a string
  that belongs to no model goes straight into the view, a model's text into its presentation
  extension.
- Keys are semantic and dotted, `<feature>.<screen or component>.<element>`
  (`watchlist.placeholder.empty.title`), never the English sentence.
- Copy uses typographic apostrophes and quotes (`You’re offline`, `“%@”`, German `„%@“`) and
  sentence case for buttons (`Try again`). German keeps a word the way German market apps say it
  (`Watchlist`).
- Every key has a catalog comment saying where it appears.
- Plurals and device variations are defined in the catalog, never with `if count == 1`.

## In code

- A screen-level string is keyed in the view:

  ```swift
  .navigationTitle(Text("watchlist.title", bundle: .module))

  Button(action: viewModel.cancel) {
      Text("trading.cancel", bundle: .module)
  }

  SectionHeading(.init("portfolio.positions.title", bundle: .module))
  ```

- Text that describes a model is a `LocalizedStringResource`, built in the presentation extension
  that owns it, one key per case:

  ```swift
  extension WatchlistPlaceholder {
      var title: LocalizedStringResource {
          switch self {
          case .loading: .init("watchlist.placeholder.loading.title", bundle: .module)
          case .searching: .init("watchlist.placeholder.searching.title", bundle: .module)
          case .unavailable(let reason): reason.title
          }
      }
  }
  ```

- Strings stay lazy until a `Text` renders them. Never `String(localized:)` in a ViewModel or
  model; it freezes the locale and breaks plural rules. The exception is a presentation extension
  filling a DesignSystem value that takes resolved text (`Metric.value`).
- Never concatenate localized pieces. A sentence with values is one key with interpolation, so
  German can reorder it: `.init("trading.header.held \(quantity) \(count)", bundle: .module)`
  is the catalog key `trading.header.held %@ %lf`.
- `Text(verbatim:)` only for values that are not language (ticker symbols).

## Numbers, money and dates

- Prices: `.currency(code:)` with the quote's own currency, in the user's locale: `$228.52` in
  English, `228,52 $` in German.
- Percent changes: always signed except zero, through `.signedPercent`: `+1.24%` in English,
  `+1,24 %` in German, where the space is the non-breaking U+00A0 (tests spell it `\u{00A0}`).
- Large numbers: compact notation (`3.45T` / `3,45 Bio.`).
- Dates and times: `Date.FormatStyle`, never fixed patterns.
- Formatting happens in a presentation extension or a `FormatStyle`, never in a `body` and never
  by building strings by hand.

## Testing

- Each package with a catalog has `LocalizationCatalogTests`, which reads the source `.xcstrings`
  through `#filePath` and fails when a key lacks an English or German value.
- Every screen's `PreviewState` has a `german` case ([testing.md](testing.md#previews)).

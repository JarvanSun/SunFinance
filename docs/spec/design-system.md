# Design System

`Core/DesignSystem` owns every visual decision: colors, fonts, images, sizes, button styles,
shared components, motion and every chart. Features use its names, never raw values. It builds on
SunKit's styling protocols (`ColorStyling`, `FontStyling`, `ImageStyling`, `DimensionStyling`).

## Colors

- `FinanceColor` is a `public enum` conforming to `ColorStyling`, with semantic cases only
  (`textPrimary`, `surface`, `accent`, `gain`, `loss`, `critical`), never descriptive ones.
- Each case is a color set in `Resources/Colors.xcassets` with light, dark and increased-contrast
  variants. Every text and market color meets WCAG AA (4.5:1) on `background`, `surface` and
  `surfaceElevated`, in light and dark.
- DesignSystem's resources are reached through `Bundle.module`; its tests have no resources of their
  own and reach the same bundle through `@testable import`.
- Views apply colors with SunKit's `.foregroundColor(FinanceColor.…)`, `.background(…)` or
  `.textStyle(_:_:)`. Never `Color.red`, `Color(hex:)` or `.foregroundStyle(.secondary)`.
- Gain and loss are never shown by color alone: every change carries its sign. Lists and
  headlines show just the signed number, without capsules or arrows; its color comes from
  `GainTrend`.
- Disabled controls and unselected chart parts use one opacity, `FinanceOpacity.dimmed`. Other
  opacities belong to the type that uses them.

## Fonts

- The app uses Inter (SIL Open Font License, licence file next to the fonts), registered once per
  process the first time any `FinanceFont` is resolved; nothing outside DesignSystem registers
  fonts.
- `FinanceFont` cases are roles (`largeTitle`, `priceLarge` for a screen's one headline amount,
  `title`, `figure`, `headline`, `body`, `callout`, `caption`). The scale sits one to two points
  below the system's, because Inter reads larger than SF. Weight is spent on one thing per area;
  rows are Medium over Regular.
- Every case uses `Font.custom(_:size:relativeTo:)` through SunKit's `FontStyle`, so it scales
  with Dynamic Type. Never `Font.system(size:)`. Symbols are sized with a `FinanceFont` too.
- Prices and percentages use `.monospacedDigit()`.
- Views apply fonts with SunKit's `.font(FinanceFont.headline)`, which also sets the line height.

## Images and symbols

`FinanceImage` is a `public enum` conforming to `ImageStyling`; its raw value is the SF Symbol or
asset name. Views write `Image(style: FinanceImage.favorite)`. A symbol name never appears outside
an `ImageStyling` enum; a feature may define its own for symbols only it uses.

## Spacing and sizes

- Every size is a SunKit dimension token read through `@Environment(\.dimensions)`
  (`dimensions.spaceMedium`). Never a number in a view.
- SunKit's generic tokens are used where they fit (`cornerRadiusLarge`, `borderWidthSmall`).
- An app-specific size is declared once, in `Extensions/DimensionStylingExtensions.swift`: a case
  of the file's private `FinanceDimension` enum names the token, converted to SunKit's
  `DimensionToken` at the lookup, and a public `DimensionStyling` property gives its default
  (`dimensions.minimumTapTarget`, `dimensions.chartLineWidth`). A test covers every token's default
  and override.
- The App injects no overrides; tests override through `\.dimensions`.
- Tokens hold lengths only. Opacities, durations, counts and ratios are properties of the type
  that uses them; durations are `FinanceMotion` values.
- Every tappable element is at least 44 × 44 points.

## Buttons

Every `Button` has a DesignSystem style: `.buttonStyle(.finance(.primary))`. System styles
(`.bordered`, `.plain`…) and inline styling of a label are never used.

| `FinanceButtonKind` | Looks like | Use |
|---|---|---|
| `.primary` | Filled accent, full width | The one main action of a screen or placeholder |
| `.secondary` | Accent outline, full width | An alternative to the primary action |
| `.tertiary` | Accent text | Low-emphasis actions |
| `.destructive` | Filled critical | Removing data |
| `.row` | No chrome, press highlight on the whole row | Tappable rows and cards |

- One `FinanceButtonStyle` implements every kind; each kind's colors, font and sizes are named
  properties of the kind.
- Every kind handles pressed, disabled (`FinanceOpacity.dimmed`) and focused states, grows with
  Dynamic Type and keeps the 44-point minimum.
- Swipe actions, menus and toolbar items ignore button styles; they take title and symbol from a
  model's presentation and color from `.tint(FinanceColor.…)`.

## Shared components

A component moves into DesignSystem when a second feature needs it. It is `public`, takes plain
values and closures, knows no feature or domain model, and uses only DesignSystem tokens.

| Component | What it is |
|---|---|
| `LoadingStateView`, `ContentUnavailableStateView` | The loading, empty, no-results and failure placeholders; features compose theirs from these |
| `DecimalField` | A labelled number field with a focus ring and an invalid state |
| `HeroAmount` | A headline amount (`HeroAmountSize.hero`) or a row price with superscript cents (`.row`), following the locale and currency |
| `MetricStrip` of `Metric`s | Figures in a two-column grid, value over caption |
| `LabeledRows` of `LabeledRow`s | Label and value lines on one surface; a total row is emphasized |
| `SurfaceGroup`, `SectionHeading` | One rounded surface for a block; a section title with an optional trailing control |
| `FinanceSegmentedControl` | Equal segments with a sliding capsule and a selection haptic (`SegmentStyle.prominent`, `.quiet`) |
| `.floatingBottomBar { }` | A screen's main actions above the bottom edge |
| `.privacyShield(isShielded:)` | System material and the app mark, no text; the App shows it while the scene is not active |
| `.overlay(if:)`, `.safeAreaInset(edge:if:)` | Optional content without `if let` in a `body` |
| `FeatureEntry<Input>` | How one feature shows another's screen ([architecture.md](architecture.md#navigation)) |

- Loading uses the system `ProgressView` inside `LoadingStateView`: no custom loading animation,
  shimmer or skeleton. A refresh never covers content on screen.
- `Loading/` holds the state values ViewModels share, `LoadState` and `RangedHistory`
  ([rules](view-model.md#state)). They import only the standard library and, with `FeatureEntry`,
  are the only non-view types a ViewModel takes from DesignSystem.
- Formatting lives in `Formatting/`: `Money.formatted()` and `formattedSigned()`,
  `Decimal.formattedQuantity()`, `Decimal.formattedExchangeRate()` (euros per unit, four
  decimals), and the `FormatStyle`s `.signedPercent` and `.compactCurrency(code:)`.

## Charts

Every chart lives in `Charts/` (`Views/`, `Values/`, `Series/`, `Controls/`, `Accessibility/`).
It is built on Swift Charts and follows the system Stocks app where a pattern exists, but the API
is ours: features never import `Charts`.

| Component | Shows |
|---|---|
| `PriceLineChart` (`.detailed`) | A price line without fill, the previous close as a dashed baseline, gain or loss colored against it, trailing value labels |
| `PriceLineChart` (hero) | Only the curve, edge to edge, with round guides near its top and bottom, a few time labels and, while live, a pulsing dot |
| `CandlestickChart` | OHLC candles with a volume strip; more than 90 candles merge into wider ones so the whole range stays visible |
| `AllocationChart` | A donut that sweeps in; dragging around the ring selects a slice, shown in the centre. One hue fading with rank (`AllocationPalette`), cash in grey |
| `ChartRangePicker` | The range control under a time chart |

- Inputs are plain values from `Charts/Values/` (`ChartPoint`, `ChartMarker`…) and FinanceCore's
  `HistoryRange`, never domain models; a feature maps its models in a presentation extension.
- A chart takes at most four parameters: one content value (`PriceLineChartContent`,
  `CandlestickChartContent`, `AllocationChartContent`), a style where there is one
  (`PriceLineChartStyle`), and the selection closures.
- **Scrubbing.** Dragging selects the nearest point (`chartXSelection`), reports it through
  `onSelect` and marks it with a light `sensoryFeedback`; releasing clears it.
- **Trading layer.** Line and candle charts take a `ChartTradingLayer` (fill markers, open-order
  levels), included in the value scale.
- **Morphing.** Every line chart draws exactly 160 points (`ChartSeries.morphPointCount`),
  resampled along a monotone curve, so a new range morphs point by point. A longer series is first
  downsampled, keeping the first and last point and each stretch's minimum and maximum. The value
  scale and hero guides come from the raw series.
- **Motion.** A range change animates the data, never the axes; with Reduce Motion the data
  appears at once.
- **Accessibility.** Every chart is one element with the feature's one-sentence summary ("Apple,
  one month, up 4.2 percent, from 210 to 219 dollars") and an `AXChartDescriptor`, so Audio Graphs
  work. The feature passes the words (`ChartAccessibility`, `AllocationChartAccessibility`); plot
  keys (`PlotKey`) are never read out.

## Motion

Every animation is a reusable piece in `Motion/`. Features name what they want
(`.financeAnimation(.settle, value:)`, `RevealContainer`), never a curve or a duration.

| Piece | What it does |
|---|---|
| `FinanceMotion` | Named animations: `snappy` (taps, toggles), `settle` (a value landing), `reveal`, `emphasis` (a confirmed result), `draw` (a line drawing in); timings of repeating motion: `shake`, `shimmer`, `pulse` |
| `.financeAnimation(_:value:)` | Applies a `FinanceMotion`; with Reduce Motion, an opacity change instead |
| `HandoffContainer` | Hands one screen to the next: the old one recedes and fades out, then the new one rises in; never both at once |
| `RevealContainer` | Expands and collapses by `height = content height × progress`, clipped; content stays mounted |
| `.financeNumberRoll(value:)` | Digits roll when a number changes, never a cross-fade |
| `SlideToConfirm` | Drag to confirm: the fill follows the knob, a haptic marks the threshold, the knob stays at the end through working and done; VoiceOver confirms with the default action |
| `CompletionBadge` | A ring that draws itself in before its symbol pops, with the caller's haptic |
| `.financeShake(count:)` | A short horizontal shake with a warning haptic for a rejected input |

- Each piece checks `accessibilityReduceMotion` itself; timings are named `FinanceMotion`
  properties covered by a test.
- Content swaps use `.id` with `.transition(.identity)`: nothing cross-fades two versions of the
  same content, and no container animates its frame while new content appears inside.
- Expanding, collapsing and replacing a screen never use a removal `.transition` (it is not
  clipped and does not run reliably); use `RevealContainer` or `HandoffContainer`.

## Accessibility

Part of the definition of done for every view.

- **Dynamic Type.** Every text style scales. Layouts are checked at the largest accessibility
  size; prices are never truncated.
- **VoiceOver.** A quote row is one element that reads as a sentence from the model's
  presentation ("Apple, 228.52 dollars, up 1.24 percent"). Icon-only buttons have a label.
- **Not color alone.** Gain and loss always carry a sign.
- **Contrast.** Every color has an increased-contrast variant.
- **Identifiers.** Every interactive element has one ([views.md](views.md#accessibility)).

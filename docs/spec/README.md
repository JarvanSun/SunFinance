# SunFinance Spec

How code in this repository is written. Someone who has read it can add a feature that looks like
the code already there.

- **The spec wins.** When code and spec disagree, the code is wrong, or the spec changes in the
  same change. Rules are current: a changed rule replaces the old text.
- **Must / never / prefer.** *Must* and *never* block a review. *Prefer* allows a deviation when
  the code is clearer for it.
- **Samples are binding.** A code sample shows the expected shape.
- **Reference feature.** `Features/Watchlist`. When the spec does not cover a case, copy what
  Watchlist does; if Watchlist does not cover it either, decide and add the rule here.

| File | Answers |
|---|---|
| [product.md](product.md) | What each feature does; the rules of the demo account and trading |
| [architecture.md](architecture.md) | Which modules exist, what may import what, where a file goes |
| [swift-style.md](swift-style.md) | Formatting, naming, declaration order, access control, control flow |
| [view-model.md](view-model.md) | The shape of every ViewModel, with the reference implementation |
| [views.md](views.md) | How screens are composed and what a `body` may contain |
| [design-system.md](design-system.md) | Colors, fonts, sizes, buttons, components, charts, motion, accessibility |
| [networking.md](networking.md) | Endpoints, DTOs, errors, the mock server and exchange |
| [analytics.md](analytics.md) | What is tracked, the tracking pipeline, the vendor adapter |
| [localization.md](localization.md) | English and German, String Catalogs, number and date formatting |
| [testing.md](testing.md) | Swift Testing, fakes, previews |
| [workflow.md](workflow.md) | Adding a feature, and the definition of done |

Commands are in [AGENTS.md](../../AGENTS.md#commands).

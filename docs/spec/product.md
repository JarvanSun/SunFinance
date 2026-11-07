# Product

What a user can do and the rules the mock backend enforces. A behaviour that is not here is not
built; a feature changes this file before its code.

## The demo account

- Everything is paper trading against the mock exchange. No real money, broker or market data
  provider is involved.
- There is no sign-in: the app opens on the tabs, all for one demo account. It starts with
  10 000 EUR of cash and a few positions, and the mock brokerage keeps it across launches.
- The base currency is EUR and cash is held in EUR only. Buying a USD stock converts at the mock
  exchange's EUR/USD rate at the moment of the fill; the ticket shows the rate and the estimated
  EUR total before the user confirms.
- Every filled order costs a flat fee of 1 EUR.
- Fractional quantities are allowed down to 0.0001 shares.
- Prices follow the exchanges' trading hours (US stocks: NYSE/NASDAQ, New York time; German
  stocks: Xetra, Frankfurt time). Outside them, quotes show the last close, marked as such.

## Tabs

Watchlist, Portfolio and Orders. Quote detail and the order ticket open from them; there is no
account, settings or sign-in screen.

## Watchlist

- The user's symbols with price and daily change, flush rows without a currency symbol. A new
  install starts from the App's default list; the user's list is kept across launches.
- Sort by market cap, daily change or symbol; favorites with a swipe action and a star beside the
  symbol; pull to refresh; a row tap opens quote detail.
- Search filters the watchlist by symbol or company and, once typing pauses (300 ms), also asks
  the server's symbol search. While searching, the list shows two headed sections: "On your
  watchlist" (matching rows) and "Add to watchlist" (results not shown above). Tapping a result
  adds it to the end of the watchlist; it shows as added until its quote arrives. A new keystroke
  cancels the search under way.
- Removing a symbol is not built.

## Quote detail

- Header: company, last price, the change over the selected range (on 1D, the day's change against
  the previous close), and whether the market is open. Until the selected range's prices have
  loaded, the change line stays empty at full height; it never shows another range's change or a
  zero.
- Price chart with ranges 1D, 1W, 1M, 3M, 1Y, 5Y. Line by default; a toggle switches 1M and longer
  to candlesticks with volume. A range loaded before appears at once and the curve morphs to the
  new one; a range that fails says so instead of keeping another range's curve. Dragging scrubs:
  the header shows price, time and change under the finger, with a selection haptic per point.
- The user's own trading on the chart: past fills as buy/sell markers, and the limit or trigger
  price of each open order as a horizontal line.
- Key statistics (open, day range, 52-week range, market cap, volume) and, if the user holds the
  stock, the position: value and cost, unrealized gain in EUR and percent, current price and
  average cost, shares, today, realized gain, the currency effect for a stock not priced in EUR,
  and total return.
- Sell and Buy open the order ticket as a sheet; Sell is shown only when the user holds the stock.
  Closing the ticket reloads the quote, the chart and the position.

## Trading

### The order ticket

A sheet with the symbol, the side (buy or sell) and three choices:

| Choice | Options | Default |
|---|---|---|
| Amount | Quantity in shares, or an amount in EUR that the ticket turns into a quantity | Quantity |
| Execution | Market, or limit at a price | Market |
| Trigger | Now, when the price reaches a level, or at a date and time | Now |

- A price trigger is a stop order ("buy when the price rises to", "sell when the price falls
  to"); with a limit it is a stop-limit order.
- A time trigger is a scheduled order, released at that moment or at the next open if the market
  is closed. The time must be in the future and within 90 days.
- Validity: until the end of the trading day, or until cancelled (at most 90 days). Market orders
  without a trigger are always day orders.
- The ticket validates as the user types (enough cash, enough shares, prices above zero, quantity
  step) and explains a blocked review in one line under the field that causes it. When typing
  pauses it asks the server for a live estimate; a rejection the server predicts (cash, shares,
  share step, price, schedule, a stock that cannot be traded) is explained the same way.

### Review and submit

- Review shows the order's terms (type, when it goes out, validity) at once and asks the server for
  a preview: estimated price, quantity, fee, exchange rate, total, and the cash left afterwards.
  Nothing is placed until the user slides to confirm.
- Confirming places the order with an idempotency key, so a double tap or a retry after a timeout
  never places it twice. A placement without an answer can be retried from Review. Reviewing the
  same draft again keeps the key until the server has answered; only an edited draft, or one the
  server already answered, gets a new key.
- The result screen says whether the order filled, is waiting (for its limit, trigger, time or the
  open), or ended without trading (rejected, cancelled, expired); the last offers to edit it.
- A rejection (not enough cash or shares, an invalid amount, price or time) shows its reason and
  leaves the ticket as it was. An order placed while the market is closed is not rejected; it
  waits for the open.
- Open buy orders reserve their estimated cost and open sell orders their shares, so the same
  money or shares cannot be committed twice.

### Orders

- An Open / Past filter: open orders (waiting for a limit, trigger, time or the open) and past
  orders (filled, cancelled, expired, rejected), newest first, grouped by the day they were
  placed (Today, Yesterday, then the date) and paged. A page that fails leaves what is shown and
  offers a retry at the end of the list.
- A row shows the symbol, side and size, how the order goes out and its status, or for a filled
  order the cash it moved. A limit order waiting for its price reads "Limit set", not "Open".
- An open order can be cancelled after a confirmation; a filled one shows its fills, fee and
  exchange rate.
- Orders that fill in the background show as filled on the next refresh; there is no push.

## Portfolio

- Total value and its change over the chart's range ("Past month +€457.26"), with a value chart
  over 1W, 1M, 3M, 1Y and 5Y, scrubbable like the price chart; while scrubbing, the header shows
  the value at that moment and the change since the range began. Ranges load and fail like quote
  detail's.
- Under the chart, a strip of figures: Today, Total return, Invested and Cash.
- Allocation by position as a donut with cash in grey; the positions list is its legend, and
  selecting a slice highlights its row.
- Positions: symbol, value in EUR, price and total return in percent. A tap opens quote detail; a
  long press offers Buy more and Sell. With no positions the list says so.
- Closed positions list each symbol with its realized gain.
- Values refresh every 15 seconds while the screen is visible, the first time 15 seconds after
  they loaded. A failed refresh keeps the values and stops the chart's live dot from pulsing
  until a refresh succeeds.

### Position math

Every number about a holding is computed by the mock brokerage from the fills and shown the same
way everywhere:

| Value | Rule |
|---|---|
| Quantity | Bought minus sold shares, fractional to 0.0001 |
| Cost basis (EUR) | Each buy adds its EUR total, fee included, at that fill's rate. A sell removes the average cost of the shares sold, so partial sells never change the average |
| Average cost | Cost basis ÷ quantity, in EUR per share; also in the stock's currency at the fills' average rate |
| Market value (EUR) | Quantity × current price, at the current EUR/USD rate |
| Unrealized gain | Market value − cost basis, in EUR and as a percentage of cost basis |
| Realized gain | Per sell: proceeds after fee − average cost of the shares sold; summed per position and account |
| Today | Quantity held at the previous close × (price − previous close), plus today's fills' difference to the current price |
| Total return | Realized + unrealized gain, in EUR and as a percentage of everything ever invested in the position |
| Gain or loss | Above zero a gain, below zero a loss, zero unchanged; never shown by color alone |

- Exchange-rate effects are part of the gain; a USD position can lose in EUR while the stock
  rises, shown as a separate "currency effect" line.
- A position sold completely moves to "Closed positions" and keeps its realized gain.
- These rules are unit-tested in FinanceCore's mock brokerage (several buys, a partial sell, a
  full sell, USD fills at different rates). Features test only how they present the values.

## Privacy

- **Privacy shield.** Whenever the scene is not active, the window is covered by a full-screen
  system material with the app mark, so the app switcher snapshot never shows balances,
  positions or orders. It lifts when the scene is active again; with Reduce Motion it appears
  without animation.
- **Analytics consent** defaults to off and the app has no switch for it, so the vendor never
  receives an event ([analytics.md](analytics.md#privacy)).
- **Storage.** `UserDefaults` holds only the watchlist's symbols, favorites and analytics consent.
  Nothing is logged except in DEBUG.
- **Privacy manifest.** The App ships `PrivacyInfo.xcprivacy`: no tracking, no collected data
  types, and the `UserDefaults` required-reason API (`CA92.1`).

## Out of scope

Real brokers, real market data, real money, accounts and sign-in, deposits and withdrawals,
settings, push notifications, deep links, widgets, options, crypto and short selling. Adding one
changes this list first.

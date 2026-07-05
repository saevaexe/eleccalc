# ElecCalc ASO Research - US

Date: 2026-07-04
Market: United States
Platform: iOS App Store

## Current Listing

- App ID: 6758902534
- Current title: `ElecCalc - Electrical Tools`
- Current subtitle: `Pro Electrical Calculator`
- Category: Utilities
- Languages: English, Turkish
- Rating count: 0
- Price model: Free with IAP

## Diagnosis

The current listing is technically relevant but under-targeted. It spends the title on brand plus a broad category phrase, uses the subtitle for another broad phrase, and leaves high-intent job-site terms mostly in the hidden keyword field or description.

Main problems:

- Brand-first positioning is too early; `ElecCalc` has no search demand yet.
- `Electrical Tools` is weaker than `Electrical Calculator`, `Wire Size`, `Voltage Drop`, and `NEC`.
- Keyword field is broad but not structured around search intent.
- Rating count is 0, so competing on very broad keywords will be slow.
- Screenshot/localization work is still a major conversion lever.

## Competitor Signals

Observed US App Store search results via iTunes Search API and App Store pages.

| Search | Strong results | Signal |
|---|---|---|
| `electrical calculator` | Electrical Calculator lite, Electrical Calculations, Ugly's Electrical References, ElectriCalc Pro | Broad term has established apps with ratings and long history. |
| `voltage drop calculator` | Southwire Voltage Drop Calc, Voltage Drop Calculator, Prysmian Group Voltage Drop | High-intent term; top apps are narrower and job-site focused. |
| `wire size calculator` | Southwire Voltage Drop Calc, Wire Gauge & Size Calculator, AWG Calculator, Mike Holt's Toolbox | Strong US electrician intent; AWG/NEC terms matter. |
| `conduit fill calculator` | Southwire Conduit Fill Calc, Electrician's Sidekick, ConduitLab | Good long-tail, but ElecCalc does not currently have conduit fill. |
| `nec calculator` | ElectriCalc: NEC Calculator, ConduitLab, QuickNEC, ElectricianCalc | Active newer apps target NEC directly. |
| `transformer calculator` | Transformer Calculator, Electrical Engineering lite | Smaller niche; useful hidden keyword, not title priority. |

Notable competitor positioning:

- Electrical Calculator lite: title exactly targets the broad query, subtitle promises many calculators/converters, 568 ratings.
- Electrical Calculations: title is exact category phrase, subtitle emphasizes formulas/reports, 125 ratings, many languages.
- Southwire Voltage Drop Calc: wins a narrow query with brand trust, voltage drop, wire size, NEC ampacity, 1.5K ratings.
- ElectriCalc: NEC Calculator: modern competitor using `NEC`, `Wire Size`, `Voltage Drop`, `AWG`, offline, PDF/report language.

## Keyword Strategy

### Primary

These should be in title/subtitle:

- electrical calculator
- wire size
- NEC
- cable

### Secondary

Use hidden keyword field and description/screenshot copy:

- voltage drop
- ampacity
- breaker
- transformer
- grounding
- power factor
- ohm
- AWG
- IEC

### Defer

Use later only if features support them clearly:

- conduit fill
- box fill
- EV charger
- panel planner
- PDF report
- code book

## Recommended EN-US Metadata

### Title

`Electrical Calculator ElecCalc`

Characters: 30/30

Reason: Uses the full title field and puts the highest-relevance broad term in the highest-weight field while keeping the brand.

### Subtitle

`Wire Size, NEC & Cable`

Characters: 22/30

Reason: Adds high-intent US electrician language without repeating title words. `NEC` is US-specific and should not be pushed into all localized markets.

### Keyword Field

`voltage,drop,ampacity,breaker,conduit,fill,transformer,grounding,power,factor,ohm,awg,iec,load`

Characters: 94/100

Reason: Covers high-intent calculation modules and query combinations not already present in title/subtitle. `conduit,fill` is included as a test keyword, but it should be removed if we want strict feature-match only before conduit fill exists.

### Promotional Text

`Fast electrical calculations for wire size, voltage drop, breakers, transformers, grounding, and power factor. Built for field work.`

Characters: 132/170

### Description Hook

`Solve electrical calculations faster on site or in the office. ElecCalc gives engineers, electricians, technicians, and students 15 focused tools for wire sizing, voltage drop, breakers, transformers, grounding, motors, power factor, and more.`

## Screenshot Direction

First three screenshots should match the new keyword strategy:

1. `Electrical Calculations for Field Work`
2. `Wire Size & Voltage Drop`
3. `Breaker, Grounding & Transformer Tools`

For US, prioritize NEC/AWG language only where the app actually supports the result model. If the app is currently IEC-first, say `IEC-based` in screenshots and keep `NEC` mostly in metadata testing until NEC-specific output exists.

## Localization Implications

Do not translate the US keyword set literally.

- Germany: focus `Kabelquerschnitt`, `Spannungsfall`, `Strombelastbarkeit`, `VDE`, `Leitungsberechnung`.
- France: focus `section de câble`, `chute de tension`, `NF C 15-100`, `courant admissible`.
- Spain: focus `cálculo eléctrico`, `sección de cable`, `caída de tensión`, `protecciones`.
- Italy: focus `calcolo elettrico`, `sezione cavo`, `caduta di tensione`, `CEI`, `rifasamento`.
- Brazil: focus `cálculo elétrico`, `queda de tensão`, `dimensionamento de cabos`, `NBR 5410`.
- Japan: focus `電気計算`, `電圧降下`, `ケーブルサイズ`, `許容電流`.

## Next Steps

1. Update EN-US metadata first and measure impressions, product page views, conversion, and keyword ranks for 2-4 weeks.
2. Upload localized screenshots before or alongside new localizations.
3. Use market-specific keyword research for each new locale, not direct translation.
4. Add rating prompt strategy; 0 ratings is a major ranking and conversion handicap.

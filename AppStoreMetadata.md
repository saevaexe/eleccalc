# App Store Metadata — ElecCalc

> **Source of truth:** `~/app-localization-factory/apps/eleccalc_metadata.yaml` → generated fastlane tree at
> `~/app-localization-factory/output/ElecCalc/fastlane/metadata/<locale>/`. That tree is what is **live on App Store
> Connect** (v1.1.0, 8 locales). Edit the yaml + regenerate; this file is a human-readable snapshot, not the pipeline input.
> _Last synced: 2026-07-05._

## Locales (8)
`en-US, tr, de-DE, es-ES, fr-FR, it, ja, pt-BR`

## App Name (30 max) · appInfoLocalizations.name
| Locale | Value | Len |
|---|---|---|
| en-US | `Electrical Calculator ElecCalc` | 30/30 |
| tr | `Elektrik Hesaplayıcı ElecCalc` | 29/30 |
| de-DE | `Elektro Rechner ElecCalc` | 24/30 |
| es-ES | `Calculadora Eléctrica ElecCalc` | 30/30 |
| fr-FR | `Calcul Électrique ElecCalc` | 26/30 |
| it | `Calcolo Elettrico ElecCalc` | 26/30 |
| ja | `電気計算・電圧降下 ElecCalc` | 18/30 |
| pt-BR | `Cálculo Elétrico ElecCalc` | 25/30 |

## Subtitle (30 max) · appInfoLocalizations.subtitle
| Locale | Value | Len |
|---|---|---|
| en-US | `Wire Size, NEC & Cable` | 22/30 |
| tr | `Kablo ve Gerilim Düşümü` | 23/30 |
| de-DE | `Kabel, VDE & Spannungsfall` | 26/30 |
| es-ES | `Cable y Caída de Tensión` | 24/30 |
| fr-FR | `Câble & Chute de Tension` | 24/30 |
| it | `Cavi, CEI e Caduta Tensione` | 27/30 |
| ja | `電圧降下とケーブル計算` | 11/30 |
| pt-BR | `Cabos e Queda de Tensão` | 23/30 |

## Category
Utilities / Productivity

## Keywords (100 max) · appStoreVersionLocalizations.keywords
_Not: başlık/altbaşlıkta geçen kelimeler tekrarlanmadı; literal çeviri değil, pazara özel terimler (US=NEC/AWG, DE=VDE/Verlegeart, FR=NF C 15-100, IT=CEI/rifasamento, BR=NBR, JP=JIS/保護協調)._
| Locale | Value | Len |
|---|---|---|
| en-US | `voltage,drop,ampacity,breaker,transformer,grounding,power,factor,ohm,awg,motor,short,circuit,iec` | 96/100 |
| tr | `akım,kesit,sigorta,trafo,topraklama,güç,faktör,ohm,iec,kompanzasyon,kısa,devre` | 78/100 |
| de-DE | `strombelastbarkeit,querschnitt,leitung,sicherung,trafo,erdung,leistung,faktor,ohm,iec,verlegeart` | 96/100 |
| es-ES | `sección,corriente,protección,transformador,tierra,potencia,factor,ohm,iec,amperaje,cortocircuito` | 96/100 |
| fr-FR | `section,courant,disjoncteur,transformateur,terre,puissance,facteur,ohm,iec,nfc,ampérage` | 87/100 |
| it | `sezione,corrente,protezione,trasformatore,terra,potenza,fattore,ohm,iec,rifasamento,corto` | 89/100 |
| ja | `許容電流,遮断器,変圧器,接地,力率,オーム,短絡電流,電力,iec,jis,配線,保護協調` | 46/100 |
| pt-BR | `corrente,disjuntor,transformador,aterramento,potência,fator,ohm,iec,nbr,ampacidade,curto` | 88/100 |

## Promotional Text (170 max)
| Locale | Value |
|---|---|
| en-US | Fast electrical calculations for wire size, voltage drop, breakers, transformers, grounding, and power factor. Built for field work. |
| tr | Kablo kesiti, gerilim düşümü, sigorta, trafo, topraklama ve güç faktörü için hızlı elektrik hesapları. |
| de-DE | Elektroberechnungen für Kabelquerschnitt, Spannungsfall, Sicherungen, Trafo, Erdung und Leistungsfaktor. Für Praxis und Büro. |
| es-ES | Cálculos eléctricos para sección de cable, caída de tensión, protecciones, transformador, tierra y factor de potencia. |
| fr-FR | Calculs électriques rapides pour section de câble, chute de tension, disjoncteurs, transformateur, terre et facteur de puissance. |
| it | Calcoli elettrici rapidi per sezione cavo, caduta di tensione, protezioni, trasformatore, terra e fattore di potenza. |
| ja | 電圧降下、ケーブルサイズ、遮断器、変圧器、接地、力率をすばやく確認できる電気計算ツールです。 |
| pt-BR | Cálculos elétricos rápidos para cabos, queda de tensão, disjuntores, transformador, aterramento e fator de potência. |

## What's New / Release Notes
| Locale | Value |
|---|---|
| en-US | Improved onboarding, clearer calculation assumptions, updated IEC-based tables, and paywall refinements. |
| tr | Onboarding iyileştirildi, hesaplama varsayımları netleştirildi, IEC tabanlı tablolar ve paywall düzenlendi. |
| de-DE | Verbessertes Onboarding, klarere Berechnungsannahmen, aktualisierte IEC-Tabellen und optimierte Paywall. |
| es-ES | Onboarding mejorado, supuestos de cálculo más claros, tablas IEC actualizadas y ajustes del paywall. |
| fr-FR | Onboarding amélioré, hypothèses de calcul plus claires, tableaux IEC mis à jour et ajustements du paywall. |
| it | Onboarding migliorato, ipotesi di calcolo più chiare, tabelle IEC aggiornate e ottimizzazioni del paywall. |
| ja | オンボーディング、計算前提の表示、IECベースの表、ペイウォールまわりを改善しました。 |
| pt-BR | Onboarding melhorado, premissas de cálculo mais claras, tabelas IEC atualizadas e ajustes no paywall. |

## Description (4000 max)
Full localized descriptions live one-file-per-locale in the fastlane tree — **not duplicated here** to avoid drift:
`~/app-localization-factory/output/ElecCalc/fastlane/metadata/<locale>/description.txt`

Per-locale structure: hook (ASO "Description Hook") → **WHY ELECCALC** bullets → **CALCULATORS INCLUDED** → Support / Privacy / Terms footer. All 8 within the 4000-char limit (~700–1250 chars each).

## Privacy Policy URL
https://saevaexe.github.io/eleccalc/privacy-policy.html

## Support URL
https://saevaexe.github.io/eleccalc/support.html

## Age Rating
4+ (Hesaplayıcı uygulaması, hassas içerik yok)

## Price
Free (with In-App Purchases)
- ElecCalc PRO Monthly: $2.99/month
- ElecCalc PRO Yearly: $19.99/year

## App Store Creative Pack (Screenshots + App Preview)

### Visual Direction (Quick Rules)
- Background: Açık gri veya açık mavi, temiz ve teknik görünüm.
- Accent colors: ElecCalc mavi + turuncu.
- Text: Her ekranda 1 başlık + 1 kısa alt satır (maks. 2 satır).
- Safe area: Metinleri üstte tut, Dynamic Island / status bar alanına taşma yapma.
- Consistency: Tüm ekranlarda aynı font ağırlığı ve aynı margin sistemi kullan.

### Screenshot Set (5 adet)

#### 1) Hero / Value
- Visual: Home ekranı (kategori grid net görünsün)
- TR Başlık: `15 Profesyonel Elektrik Hesaplayıcı`
- TR Alt Metin: `Sahada ve ofiste hızlı, doğru sonuçlar.`
- EN Title: `15 Professional Electrical Calculators`
- EN Subtitle: `Fast, accurate results on site and in office.`

#### 2) Core Workflow
- Visual: Kablo Kesiti + Gerilim Düşümü ekranları
- TR Başlık: `Kablo Kesiti ve Gerilim Düşümü`
- TR Alt Metin: `IEC tabanlı güvenilir hesaplama akışı.`
- EN Title: `Cable Sizing and Voltage Drop`
- EN Subtitle: `Reliable workflow based on IEC standards.`

#### 3) Advanced Engineering
- Visual: Güç, Trafo, Kompanzasyon ekranlarından kolaj
- TR Başlık: `İleri Düzey Mühendislik Araçları`
- TR Alt Metin: `Güç, trafo, kompanzasyon ve daha fazlası.`
- EN Title: `Advanced Engineering Tools`
- EN Subtitle: `Power, transformer, compensation, and more.`

#### 4) Productivity
- Visual: Geçmiş + Formül Referansı + Ayarlar
- TR Başlık: `Geçmiş ve Formül Referansı`
- TR Alt Metin: `Sonuçları kaydet, hızlıca tekrar eriş.`
- EN Title: `History and Formula Reference`
- EN Subtitle: `Save results and access them instantly.`

#### 5) Conversion / Pro
- Visual: Paywall (seçilebilir paketler net görünsün)
- TR Başlık: `Pro ile Tüm Araçların Kilidini Aç`
- TR Alt Metin: `7 gün ücretsiz dene, istediğin zaman iptal et.`
- EN Title: `Unlock Full Access with Pro`
- EN Subtitle: `Try free for 7 days. Cancel anytime.`

### App Preview (20 sn Storyboard)

#### Scene 1 (0-3s)
- Visual: Logo + app adı + kısa değer önerisi
- TR Overlay: `Elektrik mühendisleri için tasarlandı`
- EN Overlay: `Built for electrical engineers`

#### Scene 2 (3-7s)
- Visual: Home ekranında kategoriler arası hızlı geçiş
- TR Overlay: `15 hesaplayıcı tek uygulamada`
- EN Overlay: `15 calculators in one app`

#### Scene 3 (7-11s)
- Visual: Kablo Kesiti -> Gerilim Düşümü örnek hesap
- TR Overlay: `Sahada hızlı karar ver`
- EN Overlay: `Make fast decisions on site`

#### Scene 4 (11-15s)
- Visual: Güç / Trafo / Kompanzasyon akışı
- TR Overlay: `Profesyonel mühendislik hesapları`
- EN Overlay: `Professional engineering calculations`

#### Scene 5 (15-20s)
- Visual: Paywall + 7 gün deneme + restore
- TR Overlay: `7 gün ücretsiz dene`
- EN Overlay: `Start your 7-day free trial`

### Export Notes
- iPhone: 6.9" ve 6.5" screenshot setleri hazırla.
- iPad: 13" set için aynı mesajları daha geniş layout ile kullan.
- App Preview: Sessiz izlenmeye uygun olsun; tüm kritik mesajlar overlay text ile verilsin.

### Upload Order (iPhone 6.9" + 6.5")
1. Hero / Value
2. Core Workflow
3. Advanced Engineering
4. Productivity
5. Conversion / Pro

### Upload Order (iPad 13")
1. Hero / Value (iPad grid görünümü)
2. Core Workflow (yan yana iki hesap ekranı)
3. Advanced Engineering (3 modül kolaj)
4. Productivity (History + Formula + Settings)
5. Conversion / Pro (paywall ve paket karşılaştırma)

### Canva/Figma Prompt Pack (TR)

#### Prompt 1 — Hero / Value
`App Store screenshot (iPhone frame), clean engineering style UI presentation. Use ElecCalc app home screen as device mockup content. Background light gray-blue gradient, accent colors #2F6FED (blue) and #FF9D3B (orange). Add top headline: "15 Profesyonel Elektrik Hesaplayıcı". Add subtitle: "Sahada ve ofiste hızlı, doğru sonuçlar." Modern sans typography, high contrast, no clutter, safe margins for App Store screenshot composition.`

#### Prompt 2 — Core Workflow
`App Store screenshot (iPhone frame), show electrical calculation workflow. Device content should highlight Kablo Kesiti and Gerilim Düşümü screens. Headline: "Kablo Kesiti ve Gerilim Düşümü". Subtitle: "IEC tabanlı güvenilir hesaplama akışı." Technical, minimal, professional style. Light neutral background, blue/orange accents, readable typography.`

#### Prompt 3 — Advanced Engineering
`App Store screenshot (iPhone frame) for advanced features. Show Güç Hesabı, Trafo, Kompanzasyon modules in one coherent composition. Headline: "İleri Düzey Mühendislik Araçları". Subtitle: "Güç, trafo, kompanzasyon ve daha fazlası." Keep layout structured, premium and engineering-focused, with clean spacing.`

#### Prompt 4 — Productivity
`App Store screenshot (iPhone frame) emphasizing productivity tools. Show Geçmiş, Formül Referansı, Ayarlar flow. Headline: "Geçmiş ve Formül Referansı". Subtitle: "Sonuçları kaydet, hızlıca tekrar eriş." Use light background, compact data-focused visuals, and clear hierarchy for text.`

#### Prompt 5 — Conversion / Pro
`App Store screenshot (iPhone frame) focused on subscription value. Show paywall with monthly/yearly plans and trial CTA. Headline: "Pro ile Tüm Araçların Kilidini Aç". Subtitle: "7 gün ücretsiz dene, istediğin zaman iptal et." Maintain trustworthy financial/utility tone, avoid aggressive marketing style.`

### Canva/Figma Prompt Pack (EN)

#### Prompt 1 — Hero / Value
`App Store screenshot (iPhone frame), clean engineering style UI presentation. Use ElecCalc home screen inside device mockup. Background light gray-blue gradient, accent colors #2F6FED and #FF9D3B. Headline: "15 Professional Electrical Calculators". Subtitle: "Fast, accurate results on site and in office." Minimal, modern, premium layout with safe spacing.`

#### Prompt 2 — Core Workflow
`App Store screenshot (iPhone frame) showing cable workflow. Use Cable Sizing and Voltage Drop screens. Headline: "Cable Sizing and Voltage Drop". Subtitle: "Reliable workflow based on IEC standards." Keep visual style technical, calm, and highly readable.`

#### Prompt 3 — Advanced Engineering
`App Store screenshot (iPhone frame) for advanced modules. Combine Power, Transformer, and Compensation calculators in one composition. Headline: "Advanced Engineering Tools". Subtitle: "Power, transformer, compensation, and more." Clear structure, strong contrast, minimal noise.`

#### Prompt 4 — Productivity
`App Store screenshot (iPhone frame) highlighting efficiency tools. Show History, Formula Reference, and Settings views. Headline: "History and Formula Reference". Subtitle: "Save results and access them instantly." Professional utility-app aesthetics, clean typography.`

#### Prompt 5 — Conversion / Pro
`App Store screenshot (iPhone frame) centered on premium unlock. Show paywall with monthly/yearly comparison and free trial CTA. Headline: "Unlock Full Access with Pro". Subtitle: "Try free for 7 days. Cancel anytime." Trustworthy and informative visual tone.`

### Production Checklist (Before Upload)
1. TR ve EN setleri ayrı export edildi.
2. Tüm ekranlarda aynı padding ve tipografi kullanıldı.
3. Başlıklar 1 satır, alt metinler en fazla 2 satır.
4. Ekran metinleri status bar / Dynamic Island alanına taşmıyor.
5. App Store Media Manager'da sıralama: Hero -> Workflow -> Advanced -> Productivity -> Pro.

### Text Layer Template (Ready to Apply)

#### iPhone Template (6.5" / 6.9")
- Artboard: `1290 x 2796` (6.9") veya `1242 x 2688` (6.5")
- Safe margin (left/right): `64 px`
- Safe margin (top): `120 px` (Dynamic Island üstüne çıkma)
- Device mockup top offset: `300 px` civarı
- Headline font: `SF Pro Display Bold`, `72 px`, line height `1.05`, letter spacing `-1%`
- Subtitle font: `SF Pro Text Medium`, `38 px`, line height `1.2`, letter spacing `0%`
- Headline color: `#0F172A`
- Subtitle color: `#475569`
- Text alignment: `left` (tüm seride aynı hizayı koru)
- Spacing: Headline ile subtitle arası `20 px`
- Max text width: artboard genişliğinin `~72%`

#### iPad Template (13")
- Artboard: `2064 x 2752`
- Safe margin (left/right): `120 px`
- Safe margin (top): `150 px`
- Device mockup top offset: `420 px` civarı
- Headline font: `SF Pro Display Bold`, `96 px`, line height `1.05`
- Subtitle font: `SF Pro Text Medium`, `48 px`, line height `1.2`
- Headline color: `#0F172A`
- Subtitle color: `#475569`
- Text alignment: `left`
- Spacing: Headline ile subtitle arası `28 px`
- Max text width: artboard genişliğinin `~68%`

#### Background + Accent Spec
- Background gradient: `#F3F6FB -> #EAF1FF` (üstten alta)
- Accent blue: `#2F6FED`
- Accent orange: `#FF9D3B`
- Optional soft shape opacity: `%8 - %12`
- Avoid: Çok koyu arka plan, yüksek doku gürültüsü, fazla glow/shadow

#### Export Preset
- Format: `PNG`
- Color profile: `sRGB`
- Compression: lossless
- File naming:
  - `iphone_tr_01_hero.png`
  - `iphone_tr_02_workflow.png`
  - `iphone_tr_03_advanced.png`
  - `iphone_tr_04_productivity.png`
  - `iphone_tr_05_pro.png`
  - EN set için `tr` yerine `en`

#### Final QA (10-second pass)
1. Headline tek satır mı?
2. Subtitle en fazla 2 satır mı?
3. Metin Dynamic Island / notch alanına girmiyor mu?
4. Her görselde aynı margin kullanıldı mı?
5. TR ve EN setlerinde sıra aynı mı?

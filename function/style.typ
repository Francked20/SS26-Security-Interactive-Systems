// ============================================================
// style.typ — Exportierte Variablen für den Praktikumsbericht
// ============================================================

#let primary  = rgb("#07acda")
#let accent   = rgb("#131618")
#let light-bg = rgb("#F4F6F9")
#let muted    = rgb("#6B7280")
#let white    = rgb("#141414")
#let divider  = rgb("#D1D5DB")

// Infobox
#let infobox(title: none, body) = {
  block(
    fill: light-bg,
    stroke: (left: 3pt + accent),
    inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
    radius: (right: 4pt),
    width: 100%,
  )[
    #if title != none {
      text(weight: "bold", fill: accent)[#title]
      linebreak()
    }
    #body
  ]
}

// Kompetenz-Tag
#let skill-tag(label) = {
  box(
    fill: light-bg,
    stroke: 0.5pt + accent,
    inset: (x: 6pt, y: 3pt),
    radius: 3pt,
    text(size: 8.5pt, fill: accent)[#label]
  )
  h(3pt)
}

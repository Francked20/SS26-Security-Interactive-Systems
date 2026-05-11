// ============================================================
// titlepage.typ — Titelseite des Praktikumsberichts
// ============================================================

#v(2cm)

#align(center)[
  #box(width: 6cm, image("../res/THD-Logo.png", width: 100%))
]

#set text(18pt)
#v(0.4cm)
#align(center)[TECHNISCHE HOCHSCHULE DEGGENDORF]

#v(1.5cm)
#line(length: 100%, stroke: 2pt + rgb("#1A2C4E"))
#v(0.4cm)

#align(center)[
  #text(size: 26pt, weight: "bold", fill: rgb("#1A2C4E"))[PROJEKTARBEIT]
  #v(0.3cm)
  #text(size: 18pt, fill: rgb("#5808f7"))[ChemoDemo AG: Digitaler Rundgang]
]

#v(0.4cm)
#line(length: 100%, stroke: 2pt + rgb("#1A2C4E"))
#v(2cm)

#align(left)[
  #block(
    fill: luma(96.39%),
    inset: (x: 0.3cm, y: 1cm),
    radius: 6pt,
    stroke: 0.5pt + rgb("#D1D5DB"),
  )[
    #grid(
      columns: (auto, 1fr),
      align: auto,
      gutter: 0.5em,
      text(weight: "bold", fill: rgb("#1A2C4E"))[Vorgelegt von:],
      [#text[Franck Emmanuel Dasi, Kouami Houngbo]],
      text(weight: "bold", fill: rgb("#1A2C4E"))[Matrikelnummer:],
      [#text[22209183, 00801723]],
      text(weight: "bold", fill: rgb("#1A2C4E"))[Studiengang:],
      [#text[Cybersecurity]],
      text(weight: "bold", fill: rgb("#1A2C4E"))[Gruppe:],
      [#text[Team 6]],
      text(weight: "bold", fill: rgb("#1A2C4E"))[Vorlesung:],
      [Sicherheit interaktiver Systeme],
      text(weight: "bold", fill: rgb("#1A2C4E"))[Betreuer:],
      [Prof. Dr. Thomas Störkuhl],
    )

  ]
]



#pagebreak()

// =============================================================================
//  ScopeDef-IACS.typ
//  Schritt 1 der Projektarbeit – Definition des Geltungsbereichs des Ausgangs-IACS
//  Fallbeispiel: LDPE-Anlage der ChemoDemo AG – Digitaler Rundgang
// =============================================================================

#import "function/style.typ": *

#set text(
  font: "Liberation Serif",
  size: 12pt,
  fill: rgb("#1F2937"),
  lang: "de",
)
#set par(justify: true, leading: 0.9em, spacing: 0.7em)

// ── Überschriften ──────────────────────────────────────────
#show heading.where(level: 1): it => {
  v(1.4em)
  block(
    fill: primary,
    inset: (x: 12pt, y: 8pt),
    radius: 4pt,
    width: 100%,
    text(weight: "bold", size: 14pt, fill: white, it.body)
  )
  v(0.6em)
}
#show heading.where(level: 2): it => {
  v(0.9em)
  text(weight: "bold", size: 12pt, fill: accent, it.body)
  v(0.1em)
  line(length: 100%, stroke: 0.6pt + accent)
  v(0.4em)
}
#show heading.where(level: 3): it => {
  v(0.6em)
  text(weight: "bold", size: 11pt, fill: primary, it.body)
  v(0.2em)
}

// ── Aufzählungen ───────────────────────────────────────────
#set list(indent: 1em, marker: (
  text(fill: accent)[▸],
  text(fill: muted)[–],
))

// ── Seitenformat (Hauptdokument) ───────────────────────────
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2.5cm),
  numbering: none,
)

// ── Titelseite & Inhaltsverzeichnis (ohne Kopfzeile) ──────
#include "chapters/titlepage.typ"
#include "chapters/ToC.typ"

// ── Hauptinhalt: Seitennummerierung + Kopfzeile ───────────
#set page(
  numbering: "1",
  number-align: center,
  header: context {
    let p = counter(page).get().first()
    set text(size: 8pt, fill: muted)
    grid(
      columns: (1fr, auto),
      align(center)[Scope Definition IACS – Digitaler Rundgang],

    )
    line(length: 100%, stroke: 0.4pt + divider)
  },
)
#counter(page).update(1)


// =============================================================================
= Einleitung und Zweck des Dokuments

Dieses Dokument legt den Geltungsbereich (Scope) des Ausgangs-IACS der LDPE-Anlage
der ChemoDemo AG fest.

Methodisch lehnen wir uns an ISO/IEC 27001:2022, Abschnitt 4 („Kontext der
Organisation") an, konkret an §4.1 (externer und interner Kontext) und §4.2
(Bedürfnisse und Erwartungen interessierter Parteien). Der externe Kontext folgt
PESTLE, das Raster ist in der strategischen Managementliteratur lange etabliert
und sortiert externe Faktoren in sechs Kategorien, ohne dass etwas Wesentliches
durchrutscht. Branchenspezifisch ergänzen wir Anforderungen aus IEC 62443-2-1, und
wo es um Betreibervorgehen geht, orientieren wir uns an VDI/VDE 2182 Blatt 3.3.

// =============================================================================
= Kurzbeschreibung des IACS

== Unternehmen und Anlage

Die ChemoDemo AG hat ihre Zentrale in München und betreibt weltweit 20
verfahrenstechnische Anlagen an 15 Standorten, darunter mehrere LDPE-Anlagen.
Betrachtungsgegenstand hier ist eine LDPE-Anlage (Low-Density-Polyethylen) an
einem konkreten Standort. Die Architektur ist konzernweit baugleich umgesetzt,
was die Übertragbarkeit der Aussagen erleichtert. Die operative Führung liegt
lokal beim Plant Manager und der PLT-Fachabteilung; eingebettet ist das Ganze
in die zentrale IT- und Security-Organisation -- IT-CISO, OT-CISO,
BCM-Managerin sowie ein externer Datenschutzbeauftragter.

== Was wird produziert?

Es wird LDPE durch Hochdruck-Polymerisation von Ethen produziert. Das Produkt ist Rohstoff u. a. für Folien, Verpackungen und Superabsorber und wird in großen Chargen kontinuierlich gefertigt. Das Verfahren ist sicherheitskritisch: Hochdruckreaktoren, exotherme Polymerisation und brennbare Ausgangsstoffe erzeugen ein hohes Gefährdungspotenzial (Explosions-, Brand- und Freisetzungsgefahr).

== Was wird gesteuert?

Das Prozessleitsystem (PLS) regelt vor allem die Reaktordrücke und -temperaturen,
die Dosierung von Ethen, Initiator und Additiven, die Kühl- und
Kompressorkreise sowie die nachgelagerte Granulierung. Auf Feldebene messen
Sensoren kontinuierlich Druck, Temperatur, Durchfluss und Füllstand; Aktoren --
also Regelventile, Motoren, Pumpen, Not-Aus-Ventile -- setzen die Befehle der
Controller (PLCs/TIs) um. Die Kommunikation zu den Controllern läuft auf dem
Anlagenbus (TB2) über PROFINET, der Terminal Bus (TB1) verbindet Bedien- und
Engineering-Komponenten.

== Welche Prozesse werden unterstützt?

Im Wesentlichen geht es um fünf Prozessbereiche:

- *Produktion:* kontinuierliche LDPE-Herstellung, gesteuert über PLS
  (OS1, S1, ES1, TI-Controller) und überwacht aus der Leitwarte.
- *Betrieb und Wartung:* Instandhaltung durch die PLT-Fachabteilung,
  Engineering über ES1, regelmäßige Rundgänge (Safety, Quality, Security)
  durch Auditor:innen.
- *Dokumentation und Audit:* Erfassung gesetzlich geforderter Produktionsdaten
  im Historian (S6), Arbeitsaufträge über das MIS (S3), ERP-Anbindung für die
  kaufmännische Seite.
- *Fern- und Service-Zugriff:* Remote Access von Mitarbeitenden und externen
  Dienstleistern über RAS-Server (S0), Jump Server (S4) bzw. im Notfall über
  ISDN-Router (R1/R2).
- *Safety:* eigenständige Sicherheitssteuerung (Safety Instrumented System,
  SIS), die sicherheitskritische Grenzwerte überwacht und bei Bedarf den
  sicheren Anlagenzustand erzwingt (Notabschaltung/ESD).

// =============================================================================
= Externer und interner Kontext

Nach ISO/IEC 27001:2024, §4.1 sind die externen und internen Faktoren zu ermitteln, die für den
Zweck der Organisation und das Erreichen der ISMS-Ziele relevant sind. Den
externen Teil strukturieren wir nach PESTLE und der interne Teil folgt einer
organisationsorientierten Sicht.

== Externer Kontext (PESTLE-Analyse)

PESTLE teilt den externen Kontext in sechs Dimensionen auf. Diese Strukturierung stellt sicher, dass alle wesentlichen externen Einflussfaktoren auf das ISMS systematisch erfasst werden. Die Tabelle nennt für jede Dimension die konkreten Faktoren mit Bezug zur LDPE-Anlage der ChemoDemo AG.

#table(
  columns: 3,
  [*PESTLE-Dimension*], [*Faktor*], [*Relevanz für das IACS*],
  [P – Political], [NIS2-Richtlinie der EU],[ChemoDemo gilt als wesentliche bzw. kritische Einrichtung im Sinne der NIS2; daraus folgen Anforderungen an Risikomanagement, Vorfallsmeldung und Lieferkettensicherheit, die auch die OT-Domäne treffen.],
  [P – Political], [Geopolitische Lage internationaler Standorte],[LDPE-Anlagen u. a. in China, Argentinien, Mexiko, Thailand. Politische Stabilität, Sanktionen, Exportkontrollen und Abhängigkeit von ausländischen Herstellern (PLS, MIS) sind reale Risikofaktoren.],
  [P – Political], [Industrie- und Digitalisierungspolitik (Plattform Industrie 4.0, BMWK-Initiativen)], [Politischer Rahmen, in den die Digitalisierungsstrategie der ChemoDemo AG und die Offensive „OT Security and Resilience" eingebettet sind.],
  [E – Economic], [Globaler Wettbewerbsdruck im LDPE-Markt],[Hohe Anforderungen an Anlagenverfügbarkeit und Liefertreue; Stillstandskosten gehen in den hohen sechsstelligen Bereich pro Tag.],
  [E – Economic], [Versicherbarkeit und Cyber-Versicherungsprämien],[Versicherer verlangen den Nachweis eines wirksamen ISMS und BCM, sonst keine Cyber-Police; Prämien im OT-Sektor steigen seit Jahren spürbar.],
  [E – Economic], [Energiepreise und Rohstoffvolatilität (Ethen)],[Wirtschaftlicher Treiber für die Optimierung des Anlagenbetriebs (Daten aus Historian, MIS) und für die Digitalisierungsstrategie.],
  [S – Social], [Öffentliche Wahrnehmung der Chemieindustrie],[Anwohner und Öffentlichkeit erwarten verlässlichen Schutz vor Stör- und Freisetzungsereignissen. Jeder Vorfall an der LDPE-Anlage wirkt auf die Reputation der gesamten ChemoDemo AG.],
  [S – Social], [Fachkräftemangel im OT-Security-Bereich],[Qualifizierte Leute für PLT, OT-CISO-Funktion und Safety-Engineering sind knapp -- mit direkten Folgen für Verfügbarkeit von Know-how und Schulungsaufwand.],
  [S – Social], [Erwartungen der Belegschaft],[Operator und Schichtpersonal erwarten verlässlichen Safety-Schutz. Akzeptanz neuer Digitalisierungsmaßnahmen (Stichwort Digitaler Rundgang) hängt davon ab, ob die Belegschaft den Mehrwert spürt oder nur die zusätzliche Belastung.],
  [T – Technological], [Industrie 4.0 / IIoT],[Geplante Cloud-Plattform ThingWorx (auf Microsoft Azure), Testify-App, MQTT, Tablets der Auditor:innen -- das ist der technologische Treiber für die Erweiterung des IACS in Schritt 3.],
  [T – Technological], [Bedrohungslandschaft Cyber],[Zunehmende Angriffe auf OT-Umgebungen (Ransomware, gezielte ICS-Angriffe), Lieferkettenangriffe vom Typ SolarWinds, dazu Insiderbedrohungen über privilegierte Zugriffe.],
  [T – Technological], [Reife industrieller Standards],[IEC 62443, ISO/IEC 27001:2022, VDI/VDE 2182, RAMI 4.0 und IEC 61511 sind verfügbar und konsolidiert; neue Räder müssen wir hier nicht erfinden.],
  [T – Technological], [Konvergenz IT/OT],[Die saubere Trennung von IT und OT verschwimmt zunehmend, und zwar durch eine gemeinsame Windows-Plattform, Cloud-Anbindung und IIoT-Komponenten.],
  [L – Legal], [Störfallverordnung (12. BImSchV) / Seveso-III],[Die LDPE-Anlage fällt unter die Anforderungen für Betriebsbereiche der oberen Klasse: Sicherheitsbericht, Notfallpläne, Behördenmeldungen.],
  [L – Legal], [DSGVO / GDPR],[Personenbezogene Daten in Audits, Logs, Mitarbeiterzugriffen; Begleitung durch den externen Datenschutzbeauftragten.],
  [L – Legal], [Lokale Datenschutz- und Industrieregularien],[An internationalen Standorten kommen lokale DSGVO-Pendants, lokale KRITIS- bzw. Sicherheitsregularien und Datenresidenzanforderungen dazu -- in Schritt 3 mit Cloud-Anbindung wird das nochmal heikler.],
  [L – Legal], [NIS2-Umsetzungsgesetz (national)],[Konkretisierung der NIS2-Richtlinie in nationales Recht; trifft Meldepflichten, Mindestsicherheitsmaßnahmen und Aufsicht.],
  [L – Legal], [Vertragliche Verpflichtungen],[Service-Verträge mit Herstellern (PLS, MIS), Integrator-Verträge, Vertraulichkeitsvereinbarungen mit externen Service-Providern.],
  [E – Environmental], [Umweltauflagen für die LDPE-Produktion],[Emissionsgrenzwerte, Abfallmanagement, Genehmigungsauflagen nach BImSchG. Jede Störung mit Stoffaustritt hat sofort Umweltwirkung -- und Behördenpost.],
  [E – Environmental], [Klimarisiken an internationalen Standorten],[Extremwetter (Hitze, Überschwemmung) als Risikofaktor für Anlagenverfügbarkeit und Notfallpläne; betroffen sind vor allem Standorte in tropischen Regionen.],
  [E – Environmental], [Nachhaltigkeitsanforderungen (ESG)],[Kunden und Investoren fordern ESG-Berichte. Betriebliche Daten aus dem Historian fließen direkt in diese Berichte ein, womit die Integrität dieser Daten ein Schutzziel ist -- nicht nur Verfügbarkeit.],
)

== Interner Kontext

Der interne Kontext beschreibt organisationale, strukturelle und kulturelle
Faktoren der ChemoDemo AG, die das ISMS direkt prägen. Manches davon klingt
selbstverständlich -- ist es in der Praxis aber nicht.

#table(
  columns: 2,
  [*Kontextelement*], [*Beschreibung / Relevanz für das IACS*],
  [Geschäftszweck],[Herstellung von LDPE als Rohstoff für Kunststoffprodukte. Der wirtschaftliche Erfolg der ChemoDemo AG hängt unmittelbar an der Verfügbarkeit der Anlage.],
  [Unternehmensstrategie],[Digitalisierungsstrategie 2024 plus Offensive „OT Security and Resilience": alle LDPE-Anlagen sind in das bestehende ISMS zu integrieren. Der Digitale Rundgang ist die erste konkrete Digitalisierungsmaßnahme -- also auch das Pilotprojekt für die OT-Security-Implementierung.],
  [Organisationsstruktur],[Vorstand / CEO; IT-Manager; IT-CISO und OT-CISO im OT-ISMS-Team; BCM-Managerin direkt unter CEO; Plant Manager pro Standort; PLT-Fachabteilung mit zentraler Fachbetreuung und lokaler Betriebsbetreuung; Safety Manager; externer Datenschutzbeauftragter.],
  [Interne Richtlinien],[Firmeninterne IT/OT-Sicherheitsrichtlinien, auf die alle Mitarbeitenden schriftlich verpflichtet werden. Dazu Dokumentations- und Change-Management-Prozesse der PLT.],
  [Etablierte Managementsysteme],[Bestehendes ISMS nach ISO/IEC 27001 für die IT; eigenständiges OT-ISMS unter dem OT-CISO; BCM nach ISO 22301; Qualitätsmanagement an den LDPE-Standorten.],
  [Personelle Ressourcen],[Eigenes PLS-Personal pro Standort, vertraut mit den Gegebenheiten der Einsatzumgebung; rollenspezifische Schulungen für Fachpersonal, Anwender und externe Mitarbeitende.],
  [Technologische Ausstattung des IACS],[Architektur an allen LDPE-Standorten baugleich. Microsoft Windows als gemeinsame Plattform für DMZ, Office, Operations Management, TB1 und TB2; als Firewall-Familien Cisco ASA und Siemens Scalance.],
)

// =============================================================================
= Erfordernisse und Erwartungen interessierter Parteien 

Die ISO/IEC 27001:2024, §4.2 verlangt, die für das ISMS relevanten interessierten Parteien zu benennen,
deren Anforderungen festzuhalten und zu klären, welche davon das ISMS überhaupt
adressieren soll. Die folgende Tabelle hält das geordnet fest.

#table(
    columns: 3,  
[*Stakeholder*], [*Konkrete Anforderung*], [*Umsetzung im ISMS / IACS*],
[Anlagenbetrieb (Plant Manager, Operator, Schichtpersonal)],
      [Verfügbare, sichere und korrekt arbeitende Anlage; Safety hat Vorrang vor Verfügbarkeit.],
      [OT-ISMS, Notfallbewältigungsplan, Schulungen, redundante Auslegung der OT-Infrastruktur.],
    [IT/OT-Security(IT-CISO, OT-CISO, OT-ISMS-Team)],
      [Umsetzung der ISMS- bzw. OT-ISMS-Richtlinien; Risikoakzeptanz nur oberhalb klar definierter Schwellen.],
      [Etabliertes ISMS, dediziertes OT-ISMS, klar getrennte Zuständigkeiten zwischen IT- und OT-Sicherheit.],
    [Safety-Organisation (Safety Manager Genehmigungsbehörden)],
      [Normkonforme Funktionale Sicherheit (IEC 61508/61511); sicherer Anlagenzustand im Störfall; lückenlose Dokumentation.],
      [Eigenständiges Safety Instrumented System (SIS); Safety-Lifecycle nach IEC 61511; jährliche Audits.],
    [BCM-Organisation (BCM-Managerin)],
      [Belastbare Pläne für Geschäftsfortführung und Wiederanlauf; getestete Notfallprozeduren.],
      [BCM nach ISO 22301; BCM-Managerin direkt unter CEO; dokumentierter Notfall-Zugang via ISDN.],
    [Datenschutz (externer Datenschutzbeauftragter)],
      [DSGVO-konforme Verarbeitung personenbezogener Daten in Audit, Logs und Mitarbeiterzugriffen.],
      [Externer DSB; Verfahrensverzeichnis; Privacy-by-Design-Anforderung an neue Systeme.], [Hersteller / Integrator des PLS und MIS],
      [Definierte Service- und Update-Prozesse; klare Schnittstellen für Patches und Releases.],
      [Service- und Supportverträge mit Herstellern; Patch-Freigabe durch die zentrale PLT-Fachbetreuung.],
    [Externe Dienstleister (Remote-Service, Audit)],
      [Praktikabler, kontrollierter Fernzugriff; klare Vertraulichkeits- und Sicherheitsvereinbarungen.],
      [Remote-Access via IPsec, Jump Server S4, Vertraulichkeitsvereinbarungen, gestufte Authentisierung.],
    [Konzern-IT (IT-Manager, IT-Abteilung)],
      [Einheitliche Standards und Tooling für IT- und OT-Domänen; Auditierbarkeit.],
      [Einheitliche Windows-Plattform; zentrale Domänencontroller; gemeinsame Patch- und AV-Infrastruktur.],
    [Kunden],
      [Liefertreue und Produktqualität.],
      [Hohe OT-Verfügbarkeit, redundante Auslegung; QM-System.],
    [Anwohner / Öffentlichkeit / Umwelt],
      [Schutz vor Stör- und Freisetzungsereignissen.],
      [Safety Instrumented System; Genehmigungsverfahren nach Seveso-III; physische Sicherheit am Standort.],
    [Versicherer / Aufsichtsbehörden],
      [Nachweis eines wirksamen ISMS, Safety-Managements und BCM als Voraussetzung für Deckung bzw. Betriebsgenehmigung.],
      [ISMS- bzw. OT-ISMS-Audits; BCM-Tests; Safety-Audits; Reviews durch den externen DSB.],)

// =============================================================================
= Abgrenzung des Geltungsbereichs (ISO/IEC 27001:2024, §4.3)

== Was ist im Scope (innerhalb des IACS)

Innerhalb des Scopes liegen:

- *Feldebene der LDPE-Anlage:* alle Sensoren (Druck, Temperatur, Durchfluss,
  Füllstand) und Aktoren (Regelventile, Motoren, Pumpen, Not-Aus-Ventile) im
  Bereich Reaktor A/B sowie der zugehörigen Package Units.
- *Steuerungsebene:* redundante Controller TI im Anlagenbus (TB2),
  Kopplungsserver S1 zwischen Anlagenbus und Terminal Bus, Safety
  Instrumented System (SIS) mit unabhängiger Safety-SPS.
- *Leitstand und Operations:* Operator Stations OS1, Engineering Station ES1,
  Domaincontroller DC2, dazu die Router R2/R3/R4 und die Switche des
  redundanten Terminal Bus TB1 und Anlagenbus TB2.
- *Operations-Management-Netz:* MIS-Server (S3), Jump Server (S4), WSUS-Server
  (S5), Historian Database (S6), Virus Scan Server (S2), Domaincontroller DC1.
- *Netzwerkinfrastruktur:* OT-Firewall FW4 (Scalance), IT-Firewall FW3, externe
  Firewall FW2, Internet-Firewall FW1 sowie sämtliche Switche in den
  OT-Segmenten.
- *Office-Netz, soweit direkt an OT gekoppelt:* Clients WC1--WC3 (Operator Web
  Client, Historian Web Client, Data Monitor Web Client), die Schnittstelle
  zum MIS sowie die ERP-Komponente.
- *DMZ und Remote-Access-Infrastruktur:* RAS-Server S0, ISDN-Router R1
  (Remote-Access) und R2 (Notfall-Zugang über PLT-Freischaltung), Remote-Clients
  C1 (externer Dienstleister) und C2 (ChemoDemo-Gerät).
- *Prozesse und Rollen:* Betrieb, Wartung, Engineering, Remote-Service,
  Change-Management, Audit und Notfallbewältigung durch die PLT-Fachabteilung
  gemäß VDI/VDE 2182 Blatt 3.3.
- *Physische Sicherheit, soweit IACS-relevant:* Werkszaun, überwachte Tore,
  Schließsystem mit physischen Schlüsseln plus RFID-Token für Schalträume und
  IT-Räume.
- *Internationaler Standort:* mindestens ein LDPE-Standort außerhalb
  Deutschlands (mit Bezug zur Konzernzentrale in München) gehört ausdrücklich
  zum Scope.

== Was ist außerhalb des Scopes

Bewusst außerhalb bleiben:

- Andere Produktionsanlagen im Chemiepark, die nicht zur LDPE-Anlage gehören
  (etwa Superabsorber-Produktion), solange keine direkte Netzkopplung besteht.
- Klassische Büroarbeitsplätze ohne Zugriff auf MIS, ERP oder OT -- also reine
  HR- oder Finanz-Arbeitsplätze.
- Zentrale Backend-Systeme der Konzern-IT (Finanzbuchhaltung, Personalsysteme),
  soweit sie keine Daten an die OT übergeben.
- Physische Sicherheit außerhalb des Chemiestandorts, also öffentlicher Raum
  und Zulieferverkehr vor dem Werkszaun.
- Die IIoT-Erweiterung „Digitaler Rundgang" (ThingWorx in Azure, Testify-App,
  MQTT-Kopplung, Tablets der Auditor:innen). Die kommt erst in Schritt 3 dazu
  und gehört nicht zum Ausgangs-IACS.

== Systemgrenzen (wo beginnt und endet das IACS)

Die Grenzen des IACS lassen sich an fünf Schnittstellen festmachen:

- *Nach unten (Feldebene):* Das IACS beginnt an den primären Sensoren und
  Aktoren der LDPE-Anlage einschließlich ihrer Verdrahtung bis zum redundanten
  Controller TI. Die physisch-mechanischen Komponenten -- Reaktor, Rohrleitung,
  Pumpe -- sind nicht Teil des IACS, wohl aber ihre Mess- und
  Regelinstrumentierung.
- *Nach oben (Business-IT):* Das IACS endet am ERP-System bzw. an der
  Schnittstelle zwischen MIS (S3, OT-Seite) und ERP (Office-Seite). Das ERP
  selbst gehört nur insoweit zum Scope, wie es Daten von oder zur OT austauscht.
- *Nach außen (Internet):* An der Internet-Firewall FW1 ist Schluss. Der
  Internet-Zugang selbst und fremde WAN-Strecken sind Umgebung, nicht Scope.
- *Zum Dienstleister hin:* Die Remote-Access-Endpunkte -- Client C1 beim
  externen Dienstleister, RAS-Server S0 in der DMZ -- bilden die Grenze. Was
  beim Dienstleister liegt, ist außerhalb; die Zugangs- und Authentisierungspfade
  einschließlich Jump Server S4 sind innerhalb.
- *Zur Safety-Seite:* Das Safety Instrumented System ist als Schutzgegenstand
  Teil des IACS-Scopes, hat aber seine eigene Lebenszyklus-Logik nach IEC
  61508/61511. Security-Maßnahmen am SIS laufen unter „Security for Safety".

== Konkretisierung internationaler Standort

Der Scope umfasst eine Referenz-Anlage in Deutschland und mindestens eine
baugleiche LDPE-Anlage an einem internationalen Standort, beispielhaft Thailand.
Architektonisch sind für den internationalen Standort folgende Punkte Teil des
Scopes:

- *Architektur-Identität:* Die LDPE-Architektur (DMZ, Office, Operations
  Management, TB1, TB2, Safety) ist am internationalen Standort baugleich
  umgesetzt. Komponentennamen wie FW1--FW4, S0--S6, OS1, ES1, DC1, DC2, TI
  usw. existieren je Standort als eigene Instanzen.
- *Site-to-Site-Kopplung:* Anbindung des internationalen Standorts an die
  Konzernzentrale München über kontrollierte WAN-Verbindungen. Datenflüsse
  beschränken sich auf Office- und Operations-Management-Ebenen, nicht auf die
  direkte OT (TB1/TB2).
- *Lokale Verantwortlichkeit:* Plant Manager und PLT-Betriebsbetreuung sind
  je Standort lokal besetzt. Standortübergreifende Vorgaben und Reviews
  verantworten die zentrale OT-CISO-Funktion und die zentrale
  PLT-Fachbetreuung.
- *Rechtliche Mehrfach-Anforderungen:* Am internationalen Standort gelten
  zusätzlich lokale Datenschutz- und Industrieregularien, etwa lokale Pendants
  zur DSGVO oder Anforderungen an kritische Infrastrukturen. Koordiniert wird
  das vom externen Datenschutzbeauftragten und vom OT-CISO.
- *Gemeinsame Patch- und AV-Infrastruktur:* WSUS- und Virus-Scan-Server stehen
  standortlokal, beziehen ihre Updates aber aus einer gemeinsamen Konzern-Quelle.
  Das vereinheitlicht den Patch-Stand, ohne die lokale Operations-Hoheit
  anzutasten.

// =============================================================================
= Zugehörige Standards

- VDI/VDE 2182 Blatt 3.3 -- Informationssicherheit in der industriellen
  Automatisierung, Anwendungsbeispiel LDPE-Anlage (Betreiber).
- ISO/IEC 27001:2024 -- Informationssicherheits-Managementsysteme,
  insbesondere Abschnitt 4 (Kontext der Organisation).
- ISO/IEC 27002:2024 -- Informationssicherheitsmaßnahmen.
- IEC 62443-2-1 -- Industrial automation and control system security
  management system.
- IEC 62443-3-3 -- System security requirements and security levels.
- IEC 61508 / IEC 61511 -- Funktionale Sicherheit programmierbarer
  elektronischer Systeme bzw. Prozessindustrie (Grundlage für SIS).
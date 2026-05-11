// =============================================================================
//  IACS-Architecture.typ
//  Schritt 2 der Projektarbeit – Detaillierte Beschreibung des Ausgangs-IACS
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
      align(center)[IACS-Architektur: Digitaler Rundgang],

    )
    line(length: 100%, stroke: 0.4pt + divider)
  },
)
#counter(page).update(1)


// =============================================================================
= 1. Einleitung

Dieses Dokument beschreibt die Architektur des Ausgangs-IACS der LDPE-Anlage der
ChemoDemo AG. Es setzt auf dem Geltungsbereich aus Schritt 1
(ScopeDef-IACS-ChemoDemo) auf und liefert die Grundlage für die Risikoanalyse
sowie die anschließende Erweiterung zum IIoT-System (Digitaler Rundgang). Den logischen Netzwerkplan führen wir als textuelle Beschreibung.

Strukturell folgt das IACS dem Vorbild aus VDI/VDE 2182 Blatt 3.3 und entspricht
dem Zonenmodell von IEC 62443: Feldebene , OT-Netz mit Terminal Bus (TB1) und Anlagenbus (TB2),
Operations Management, Office, DMZ, Internet. Dazu kommt ein Safety
Instrumented System (SIS). Die Architektur ist an allen LDPE-Standorten der
ChemoDemo AG baugleich umgesetzt.

// =============================================================================
= 2. Logischer Netzwerkplan

== 2.1 Grafische Darstellung

Die grafische Darstellung ist in der Abbildung 1 zu sehen. Logisch zerfällt das Netz in sechs Zonen, getrennt durch dedizierte Firewalls. Innerhalb jeder Zone kommunizierendefinierte Komponenten über festgelegte Protokolle. Das Safety System hängt als zusätzliche, physisch und logisch getrennte Zone neben der Prozess-Steuerung.

#align(center)[
  #box(width: 120%, image("./res/Netzplan.png", width: 110%))
  *Abbildung 1*: Netzplan des Ausgangs-IACS der LDPE-Anlage der ChemoDemo AG
]

#pagebreak()


== 2.2. Netzwerksegmente (Zonen) im Überblick

#table(
  columns: 2,
  [*Zone / Segment*], [*Funktion*],
  
    [Internet / WAN],
      [Externer Datenverkehr; Sitz externer Dienstleister (Remote Service)],
    [DMZ],
      [Demilitarisierte Zone mit RAS-Server S0 für IPsec-Remote-Access.],
    [Office-Netz],
      [Büroarbeitsplätze (WC1 Data Monitor, WC2 Historian, WC3 Operator), ERP-Komponente, Übergang zum MIS.],
    [Operations Management],
      [MIS (S3), Jump Server (S4), WSUS (S5), Historian (S6), Virus Scan Server (S2), Domain Controller DC1.],

    [Terminal Bus TB1 (OT)],
      [Operator Stations OS1, Engineering Station ES1, Domain Controller DC2, redundante Router R2.],
    [Anlagenbus TB2 (OT)],
      [Redundante Controller TI mit I/O, Sensoren und Aktoren; redundante Router R3/R4.],
    [Safety-Zone (SIS)/Feldebene],
      [Safety-SPS mit eigenen sicherheitsgerichteten Sensoren und Aktoren; physisch und logisch getrennt.],
)

== 2.3. Textuelle Beschreibung des Netzwerkflusses

Sensoren messen Prozessgrößen und liefern die Werte über PROFINET an die
redundanten Controller TI im Anlagenbus TB2. Die TI-Controller
regeln daraufhin die Aktoren wie Ventile, Pumpen, Motoren ebenfalls über
PROFINET. Die S1-Server verbinden den Anlagenbus TB2 mit dem
Terminal Bus TB1 und übernehmen dabei eine Firewall Funktion: nur explizit
freigegebene Protokolle, Ports und IP-Adressen kommen durch. Alles andere bleibt draußen.

Im Terminal Bus TB1 laufen die Operator Stations OS1, die
Engineering Station ES1 und der Domaincontroller DC2. OS1 visualisiert die Prozessdaten für das Operator-Personal in der Leitwarte. ES1 dient zur Konfiguration und Programmierung der Controller TI.
Über DC2 hängen alle Windows Komponenten im OT-Netz in einer eigenen Domäne
getrennt von der Office-Domäne, was bei Audits regelmäßig positiv auffällt.

Vom TB1 aus laufen Daten über die OT-Firewall FW4 (Scalance, administriert durch die PLT-Betriebsbetreuung) ins Operations-Management-Netz.
Dort verarbeitet das MIS die Daten und übergibt aggregierte
Werte via OPC UA an die ERP-Komponente im Office Netz.
Zeitreihen wandern via SMB in die Historian Database. Wichtig:
Die Historian Kommunikation ist an FW4 ausschließlich von TB1/TB2 in Richtung
Operations Management freigegeben, nicht andersherum.

Das Office Netz (WC1 bis WC3, ERP) ist über die IT-Firewall FW3 (
Cisco ASA, IT-Abteilung) vom Operations Management getrennt und über die
Firewall FW2 an die DMZ angebunden. Die DMZ wiederum hängt über
FW1 am Internet. In der DMZ steht der RAS-Server S0, Endpunkt der IPsec-VPN-Verbindungen mit AH und ESP im
Tunnelmodus, Authentisierung über Zertifikate und zusätzlich
Benutzername/Passwort.


Für Remote Zugriffe ist der Jump Server S4 die Zwischenstation. Benutzer können über das Internet mit einem Client C1 über die VPN auf den RAS Server S0 in der DMZ verbinden. Sie werden auf einen Client im Office-Netz (WC1 bis WC3) geleitet. Von dort können sie sich dann auf den Jump Server S4 aufschalten. Die Netzwerksegmente „Operations Management“ und TB1 sind nur über den Jump Server erreichbar, um auf ihre Komponenten zuzugreifen.

Die Remote Access Lösung von ChemoDemo ist mittels IPsec realisiert. Im Tunnelmodus kommen die Sicherheitsprotokolle AH und ESP zum Einsatz. Die Endgeräte des Mitarbeiters (z.B. eine Engineering Station eines Service Providers) C1 und der RAS Server S0 sind die kryptographischen Endpunkte. Die Authentisierung erfolgt mittels Zertifikaten und Kennung/Passwort des Mitarbeiters.

Um über Client C2 Remote Access zu erhalten, muss der ISDN Router R2 von einem Mitarbeiter der PLT-Fachabteilung ausdrücklich eingeschaltet werden. Dieser Zugang zum Netzwerk ist für Notfallsituationen vorgesehen. Der Mitarbeiter kann sich dann auf die PCs WC1, WC2 oder WC3 mittels Kennung/Passwort verbinden, von dort auf den Jump Server S4 und dann auf die Engineering Station ES1. Von der Engineering Station ES1 kann dann ohne weitere Authentisierung auf die Controller TI zugegriffen werden, um hier z.B. Projekte zu laden.

Zeitsynchronisation läuft konsequent über NTP: DC1 synchronisiert gegen einen NTP-Server im Office, DC2 gegen DC1, die Komponenten
im Operations Management gegen DC1, die TB1 Komponenten und die S1 Server gegen
DC2, die TB2 Komponenten schließlich gegen die S1 Server (im Netzplan grün
gestrichelt). Backups der Engineering Station ES1 zieht Acronis auf OS1; einmal
pro Woche wandern sie per FTP auf den Historian S6. Dass FTP unverschlüsselt
ist, wissen wir die Bewertung kommt im nächsten Schritt.

Das Safety Instrumented System ist als dritte, physisch unabhängige Schiene realisiert. Eine
separate Safety-SPS überwacht kritische Grenzwerte wie Druck,
Temperatur, Füllstand über dedizierte sicherheitsgerichtete Sensoren und
löst über fail-safe Aktoren (Not-Aus-Ventile, Druckentlastung,
Schnellabschaltung) den sicheren Anlagenzustand aus, wenn nötig. Zu
Diagnose Zwecken werden Safety Daten ausschließlich lesend über eine Data Diode an die Prozess-Leitebene gespiegelt. 
// =============================================================================
= 3. Komponentenverzeichnis (Asset Inventar)

Die folgende Tabelle listet die Komponenten des Ausgangs-IACS mit dem Typ und die Zuordnung zur Ebene gemäß IEC-62443-Zonenmodell bzw.
Purdue-Referenzmodell. 

#table(
  columns: 3,
  [*Komponente*], [*Typ*], [*Ebene / Zone*],
    [Drucksensoren], [Feldgerät], [Feldebene],
    [Temperatursensoren], [Feldgerät], [Feldebene],
   [Durchfluss- und Füllstandssensoren], [Feldgerät], [Feldebene],
    [Regelventile, Pumpen, Motoren], [Feldgerät (Aktor)], [Feldebene],
    [Controller TI (A/B, redundant)], [PLC / SPS], [OT Netzwerk],
    [Server S1], [Server / Gateway mit FW-Funktion], [OT Netzwerk],
    [Operator Stations OS1], [HMI / Leitstand-Client], [OT Netzwerk],
    [Engineering Station ES1], [Engineering-Workstation], [OT Netzwerk],
    [Domain Controller DC2], [Server (Windows)], [OT Netzwerk],
    [Router R2], [Netzwerk], [OT Netzwerk],
    [Router R3], [Netzwerk], [OT Netzwerk],
    [Router R4], [Netzwerk], [OT Netzwerk],
    [Virus Scan Server S2], [Security-Server], [Operations Management],
    [Domain Controller DC1], [Server (Windows)], [Operations Management],
    [MIS Server S3 (Manufacturing Information System)], [Applikations Server], [Operations Management],
    [OT-Firewall FW4 ],
   [Firewall], [Operations Management],
    [Jump Server S4 (Bastion)], [Server], [Operations Management],
    [Historian Database S6], [Datenbank Server], [Operations Management],
    [ISDN Router R2 ], [Zugangsgerät], [Operations Management],
    [WSUS Server S5], [Update Server], [Operations Management],
    [Web Clients WC1, WC2, WC3], [Client PCs], [Office Netz],
    [FW2 External Firewall (Cisco ASA)], [Firewall], [Grenze Office ↔ DMZ],
    [ERP Server], [Applikations Server], [Office / Business-IT],
    [NTP Server], [Server], [Office Netz],
    [RAS-Server S0 (IPsec Gateway)], [VPN Gateway], [DMZ],
    [Internet-Firewall FW1 (Cisco ASA)], [Firewall], [Grenze DMZ ↔ Internet],
    [Remote Client C1 (externer Dienstleister)], [Client (extern)], [Internet],
    [Remote Client C2], [Client / Zugangsgerät], [Internet],
    [Safety SPS (SIS, SIL 3)], [Safety PLC], [Safety Zone],
    [Sicherheitsgerichtete Sensoren (Druck, Temperatur)], [Safety Feldgeräte], [Safety Zone],
    [Sicherheitsgerichtete Aktoren (Not-Aus, Druckentlastung, Schnellabschaltung)], [Safety Feldgeräte], [Safety-Zone],
    [Werkszaun, Tore, RFID-Schließsystem], [Physische Sicherheit], [Standort-Perimeter],
)

Damit sind die geforderten Ebenen vollständig abgedeckt.

// =============================================================================
= 4. Kommunikationsprotokolle

Die folgende Liste zeigt die eingesetzten Protokolle mit ihrem jeweiligen Zweck.

#table(
  columns: 4,
  [*Protokoll*], [*Typ*], [*Einsatz im IACS*], [*Sicherheitsmerkmale*],

    [PROFINET], [Industrielles Echtzeit Protokoll],
      [Feld und Controller TI im Anlagenbus TB2: Übertragung der Sensor- und Aktorwerte],
      [Erfüllt harte Echtzeit; klassisch unverschlüsselt Schutz erfolgt über Zonierung und physische Sicherheit.],
    [OPC UA], [Industrielles Protokoll],
      [MIS (S3) zu ERP: Übergabe analysierter und aggregierter Produktionsdaten.],
      [Unterstützt Security-Profile (Sign, SignAndEncrypt) und Authentisierung.],
    [SMB], [File/Protokoll-Share],
      [Schreiben definierter Prozessdaten als Zeitreihen in die Historian DB (S6).],
      [Innerhalb Operations Management; Zugriff durch FW4-Regeln auf IPs und Ports beschränkt.],
    [FTP], [Dateitransfer],
      [Wöchentliche Übertragung der Acronis-Sicherungen von OS1 auf den Historian S6.],
      [Unverschlüsselt],
  [SSH], [Secure Shell],
      [Zugriff von WC1--WC3 (Office) auf den MIS S3],
      [Verschlüsselt; Authentisierung über Kennung/Passwort.],
    [IPsec (AH, ESP, Tunnel)], [VPN Protokoll],
      [Remote Access C1 über RAS-Server S0 in der DMZ.],
      [Authentisierung über Zertifikate plus Kennung/Passwort; End-zu-End-Verschlüsselung zum DMZ-Endpunkt.],
    [RDP / Remote-Session], [Fernwartungsprotokoll],
      [Sprung von WC-Clients auf Jump Server S4 und weiter auf ES1.],
      [Authentisierung mit Kennung/Passwort; Kapselung im IPsec-Tunnel.],
    [NTP], [Zeitsynchronisation],
      [Office-NTP → DC1 → Operations Management → DC2 → TB1/S1 → TB2.],
      [Integritäts- und Nachweiszwecke.],
    [TCP/IP + HTTPS], [Standard Web Protokoll],
      [Web-Clients WC1--WC3 gegen interne Web-Anwendungen.],
      [TLS Verschlüsselung.],

)

// =============================================================================
= 5. Kommunikationsmatrix

Die Kommunikationsmatrix listet alle architektonisch vorgesehenen Datenflüsse
zwischen den Assets. Sie ist gleichzeitig Vorgabe für die Firewall-Regeln
(FW1--FW4, S1) und Referenz für die spätere Risikoanalyse. In der Spalte
„Initiator und Akzeptor" steht eindeutig, wer die Verbindung aufbaut und auch wichtig,
weil Firewalls Stateful arbeiten und die Richtung den Unterschied macht. 

#pagebreak()

#table(
  columns: 6,
  [*Nr.*], [*Initiator und Akzeptor*], [*Protokoll*], [*Port (Standard)*], [*Authentisierung*], [*Verschlüsselung*],

  [K01], [C1  → RAS S0],
      [IPsec (AH/ESP, Tunnel)], [UDP 500/4500],
      [Zertifikat + Benutzername/Passwort], [Ja (IPsec ESP)],
    [K02], [ RAS S0 → (WC1--WC3)],
      [RDP], [TCP 3389], [Kennung/Passwort], [Ja (TLS innerhalb RDP)],
    [K03], [(WC1--WC3) → Jump Server S4],
      [RDP], [TCP 3389], [Kennung/Passwort], [Ja (TLS)],
  [K04], [S4 → ES1],
      [RDP], [TCP 3389], [Kennung/Passwort], [Ja (TLS)],
    [K05], [(WC1--WC3) → MIS S3],
      [SSH], [TCP 22], [Kennung/Passwort], [Ja (SSH)],
    [K06], [MIS S3 → ERP],
      [OPC UA], [TCP 4840], [Zertifikat (OPC UA Security)], [Ja (Sign & Encrypt)],
    [K07], [S1 → Historian S6],
      [SMB], [TCP 445], [Domänen-Authentisierung (DC1/DC2)], [Optional (SMB 3 Encryption)],
    [K08], [OS1 → Historian S6],
      [FTP (Backup)], [TCP 21 / 20], [Kennung/Passwort], [Nein (Schwachstelle, in Risikoanalyse zu bewerten)],
    [K09], [TI ↔ Sensoren/Aktoren],
      [PROFINET RT], [Layer 2 (kein TCP/IP-Port)], [Keine (Schutz durch Zone und physische Sicherheit)], [Nein],
    [K10], [S1 ↔ TI],
      [PROFINET / proprietär TCP], [definierte Ports an FW-Funktion S1], [Domänen-Authentisierung], [abhängig vom Hersteller],
    [K11], [Virus Scan S2 → WSUS S5],
      [HTTPS (Pattern-Updates)], [TCP 443], [Server-Zertifikat], [Ja (TLS)],
  [K12], [WSUS S5 → Windows-Hosts (OS1, ES1, DC1, DC2, S1)],
      [WSUS / HTTPS], [TCP 8530/8531], [Domänen-Authentisierung], [Ja (TLS)],
    [K13], [NTP Office → DC1],
      [NTP], [UDP 123], [Keine (Symmetric Key optional)], [Nein],
    [K14], [DC1 →DC2],
      [NTP], [UDP 123], [Keine], [Nein],
    [K15], [DC2 → S1],
      [NTP], [UDP 123], [Keine], [Nein],
    [K16], [S1 → TI],
      [NTP], [UDP 123], [Keine], [Nein],
    [K17], [C2 → R2 ],
      [ISDN], [---], [Kennung/Passwort], [Nein (Notfall-Pfad)],
)

// =============================================================================
= 6. Behandlung der Safety

== 6.1. Safety Ansatz für die LDPE-Anlage

Die LDPE-Anlage fällt aufgrund der Hochdruck-Polymerisation und der eingesetzten Stoffe wie Ethen und Initiatoren unter strenge Anforderungen der Prozesssicherheit.
Funktional umgesetzt wird das durch ein unabhängiges Safety Instrumented System
(SIS) nach IEC 61511. Zielgröße sind Safety Integrity Levels (SIL) der
sicherheitsgerichteten Funktionen, festgelegt im HAZOP-Prozess (eine der effektivsten Methoden, um Risiken und potenzielle Betriebsstörungen in komplexen Anlagen zu identifizieren). Das ist kein Beiwerk, sondern Grundlage der Betriebsgenehmigung.

- Separate Safety-SPS mit zertifizierter Firmware, etwa SIL-3-fähig.
- Sicherheitsgerichtete, redundant ausgelegte Sensoren (ASSET-SAF-102) für die
  kritischen Prozessgrößen Druck und Temperatur.
- Fail-safe Aktoren : Not-Aus-Ventile, Druckentlastungsventile,
  Schnellabschaltung des Reaktor-Feeds.
- Definierte sichere Zustände (Safe State) im Störfall, automatisch herbeigeführt ohne Bedienereingriff, weil im Sekundenbereich kein Mensch verlässlich
  reagiert.
- Physische Trennung vom Prozess-Leitsystem: eigene Schaltschränke, eigene
  Verkabelung, eigene Energieversorgung.

#pagebreak()

== 6.2. Security for Safety

Safety Funktionen sind in einer modernen Anlage längst nicht mehr isoliert: Die
Safety-SPS wird konfiguriert, parametriert und für Diagnose Zwecke ausgelesen.
Damit entsteht ein Security Risiko für die Safety Funktionen, und genau das
adressiert „Security for Safety".

- Safety-Zone als eigene Zone im Sinne von IEC 62443; Zugriff ausschließlich über definierte Conduits.
- Schreibzugriffe auf die Safety-SPS nur aus einer dedizierten
  Safety-Engineering-Umgebung, zusätzlich abgesichert über
  Schlüsselschalter und 4-Augen-Prinzip.
- Eigene Authentisierung und Protokollierung; Änderungen am Safety-Programm
  werden vollständig auditierbar gespeichert.
- Härtung der Safety-Engineering-Station: kein Internetzugang, keine
  Wechselmedien ohne Freigabe, separater Domänenkontext.
- Organisatorisch laufen Safety Änderungen über den Safety Lifecycle nach
  IEC 61511 und das Change-Management der PLT-Fachabteilung nach VDI/VDE 2182
  Blatt 3.3.

// =============================================================================
= 7. Bereits umgesetzte Security-Maßnahmen

Die folgenden Maßnahmen gelten nach den Angaben aus der Beschreibung des
Fallbeispiels und nach VDI/VDE 2182 Blatt 3.3 als umgesetzt.

== 7.1. Physische Sicherheit und Zutrittskontrolle

- Werkszaun um das gesamte Gelände des Chemieparks.
- Kontrollierter Zugang über Tore, manuell überwacht oder per Kamera bzw.
  Lesegerät für Werksausweise.
- Elektrische Betriebsräume und PLS-Schalträume mit Zugangskontrolle über
  physische Schlüssel und RFID-Token.
- IT-Infrastruktur-Räume mit separatem Schlüsselsystem (physisch + RFID);
  Zutritt beschränkt auf Mitarbeitende der IT-Fachabteilung.
- Sensoren und Aktoren vor Ort sind nur mit Werkzeug zugänglich; Auslesen
  funktioniert nur mit Spezialgeräten und passender Anwendungssoftware.

#pagebreak()

== 7.2. Organisation und Richtlinien

- Etabliertes ISMS nach ISO/IEC 27001; LDPE-Anlagen werden im Rahmen der
  Offensive „OT Security and Resilience" vollständig integriert.
- Eigenständiges OT-ISMS unter Leitung des OT-CISO.
- PLT-Fachabteilung mit zentraler PLT-Fachbetreuung und standortspezifischer
  PLT-Betriebsbetreuung; Verantwortlichkeiten gemäß VDI/VDE 2182 Blatt 3.3.
- BCM unter eigenständiger BCM-Managerin, direkt dem CEO unterstellt.
- Firmeninterne IT/OT-Sicherheitsrichtlinien, schriftliche Verpflichtung aller
  Mitarbeitenden.
- Externer Datenschutzbeauftragter, berichtet an den IT-Manager.
- Change Management der PLT-Betriebsbetreuung; jährliches Prozessaudit; Audit
  vor Erstinbetriebnahme nach VDI/VDE 2182 Blatt 3.3, Abschnitt 5.8.
- Rollenspezifische Schulungen für Fachpersonal, Anwender und externe
  Mitarbeitende, eingebunden ins Qualitätsmanagement.

== 7.3. Netzwerksicherheit und Zonierung

- Strikte Zonierung in sechs Segmente (Internet, DMZ, Office, Operations
  Management, OT Netzwerk, Feldebene), getrennt durch dedizierte Firewalls.
- Zwei-Firewall-DMZ zwischen Internet und Office (FW1 + FW2, Cisco ASA,
  IT-Abteilung).
- Trennung von Office und Operations Management über FW3 (Cisco ASA, IT-Abteilung).
- Trennung von Operations Management und Terminal Bus(im OT Netzwerk) über die OT-Firewall FW4 mit getrennter Administrationszuständigkeit als „Separation of Duties".
- Kopplung TB1 und TB2 über S1 Server mit Firewall Funktion: Historian Kommunikation ist ausschließlich von der OT in Richtung Operations Management freigegeben, die Gegenrichtung ist gesperrt.
- Redundante Auslegung der OT-Infrastruktur: S1 Server, Router R2/R3,
  Controller TI.
#pagebreak()

== 7.4. Zugriff, Authentisierung und Remote-Access

- Remote Access nur über IPsec mit AH und ESP im Tunnelmodu.
- Authentisierung bei IPsec über Zertifikate plus Kennung/Passwort des
  Mitarbeitenden.
- Gestufter Zugriff: C1 → S0 → WC → S4 → ES1.
- Jump Server S4 als einzige Sprungbrett Instanz.
- Notfall-Zugang über ISDN nur nach expliziter PLT-Freischaltung.
- Office PCs greifen auf das MIS via SSH zu.
- Vertraulichkeitsvereinbarungen mit externen Dienstleistern; IT-Richtlinien
  für Systemadministratoren.

== 7.5. Host- und Plattformsicherheit

- Zentrale Windows-Domänen: DC1 für Operations Management, DC2 für TB1/OT.
- Zentraler Virenschutz: Pattern Updates über den Virus Scan Server S2 (K11),
  Verteilung über den WSUS Server S5.
- Zentrale Patch-Verteilung über den WSUS Server S5.
- Datensicherung: Engineering Station ES1 per Acronis auf OS1, wöchentliche
  Sicherung auf den Historian S6.
- Datensicherungskonzept nach VDI/VDE 2182 Blatt 3.3 (Tabelle 8).

== 7.6. Zeit, Logging und Monitoring

- Einheitliche Zeitsynchronisation über NTP, kaskadiert bis auf die Feldebene.
- Logs in PLS- und MES-Systemen erzeugen Alarme, sobald kritische Zustände oder
  Grenzwerte erreicht werden.
- Notfallbewältigungsplan mit definierten Rollen (PLT-Betriebsbetreuung,
  zentrale PLT-Fachbetreuung) und Eskalationswegen.

#pagebreak()
// =============================================================================
= 8. Zuordnung der Maßnahmen zu Standard Controls

Die folgende Tabelle ordnet die Maßnahmen Gruppen aus Kapitel 7 den
korrespondierenden Controls aus ISO/IEC 27002:2024 und IEC 62443-2-1 zu. Zweck
ist Auffindbarkeit und Auditierbarkeit bewusst ohne Wirksamkeitsbewertung.

#table(
  columns: 3,
  [*Umgesetzte Maßnahme*], [*ISO/IEC 27002:2024 Control*], [*IEC 62443-2-1 Practice*],
    [Werkszaun, Tore, Schlüsselsystem für Schalt- und IT-Räume],
      [7.1 Physische Sicherheitsperimeter; 7.2 Physischer Zutritt; 7.3 Sicherung von Büros, Räumen und Einrichtungen],
      [Practice 4 - Physical Security Management],
    [ISMS- und OT-ISMS-Organisation, Richtlinien],
      [5.1 Politiken zur Informationssicherheit; 5.2 Rollen und Verantwortlichkeiten],
      [Practice 1 - Risk Identification, Classification and Assessment; Practice 2 - Security Policies, Procedures, and Practices],
    [Schulungen und schriftliche Verpflichtung der Mitarbeitenden],
      [6.3 Sensibilisierung, Aus- und Weiterbildung],
      [Practice 5 - Security Awareness and Training],
    [Externer Datenschutzbeauftragter, Verträge mit Dienstleistern],
      [5.31 Rechtliche, gesetzliche und vertragliche Anforderungen; 5.20 Adressierung von Informationssicherheit in Lieferantenvereinbarungen],
      [Practice 3 - Compliance with Applicable Laws],
    [Zonierung ],
      [8.22 Trennung von Netzwerken; 8.20 Netzwerksicherheitssteuerungen],
      [Practice 7 - Network Segmentation; SR 5.1 Network Segmentation (62443-3-3)],
    [Zwei-Firewall-DMZ; FW1--sFW4],
      [8.21 Sicherheit von Netzdiensten],
      [Practice 7 - Network Segmentation],
    [Server S1 als Firewall zw. TB1 und TB2; Whitelisting Historian-Datenfluss],
      [8.22 Trennung von Netzwerken],
      [SR 5.2 Zone Boundary Protection],
    [IPsec-VPN für Remote Access],
      [5.14 Übertragung von Informationen; 8.20 Netzwerksicherheitssteuerungen],
      [Practice 8 - Network Access Control; Remote Access Management],
    [Jump Server S4 als Bastion für gestuften Zugriff],
      [8.5 Sichere Authentisierung; 8.2 Privilegierte Zugriffsrechte],
      [Practice 8 - Network Access Control],
    [Notfall-ISDN-Zugang nur nach PLT-Freischaltung],
      [5.30 IKT-Bereitschaft für die Geschäftsfortführung],
      [Practice 11 - Incident Response Planning; BCM],
    [Windows-Domänen DC1 (OpsMgmt) und DC2 (OT)],
      [5.16 Identitätsverwaltung; 5.17 Authentisierungsinformationen; 8.5 Sichere Authentisierung],
      [Practice 8 - Account Management],
    [Virenschutz und WSUS-Patch-Verteilung],
      [8.7 Schutz vor Schadsoftware; 8.8 Verwaltung technischer Schwachstellen],
      [Practice 12 - Patch Management; Practice 13 -- Antivirus Management],
    [Backup-Konzept (Acronis OS1, FTP auf Historian S6, zentrales IT-Backup)],
      [8.13 Sicherung von Informationen],
      [Practice 14 - Backup and Recovery],
    [NTP-Kaskade (Office → DC1 → DC2 → S1 → TB2)],
      [8.17 Uhrzeit-Synchronisation],
      [Practice 17 - Time Synchronization (Logging-Voraussetzung)],
    [Logs und Alarme in PLS/MES bei kritischen Zuständen],
      [8.15 Protokollierung; 8.16 Aktivitätenüberwachung],
      [Practice 15 - Event Logging and Audit; Practice 16 -- Monitoring],
    [Safety Instrumented System (SIS) mit Data Diode],
      [8.22 Trennung von Netzwerken (für die Safety Zone)],
      [Practice 7 - Zone Concept (Safety als eigene Zone)],
    [Audit nach SAT, jährlich, bei Änderungen (VDI/VDE 2182 Blatt 3.3, 5.8)],
      [5.35 Unabhängige Überprüfung der Informationssicherheit; 5.36 Konformitätsprüfung],
      [Practice 18 - Conformance Assessment],
)

#pagebreak()
// =============================================================================
= Referenzierte Standards

- VDI/VDE 2182 Blatt 3.3 -- Informationssicherheit in der industriellen
  Automatisierung.
- ISO/IEC 27001:2024 -- Informationssicherheits-Managementsysteme.
- ISO/IEC 27002:2024 -- Informationssicherheitsmaßnahmen (Controls).
- IEC 62443-2-1 -- Security Management System für IACS (Practices).
- IEC 62443-3-3 -- System security requirements and security levels.
- IEC 61508 / IEC 61511 -- Funktionale Sicherheit; Grundlage für das Safety
  Instrumented System.


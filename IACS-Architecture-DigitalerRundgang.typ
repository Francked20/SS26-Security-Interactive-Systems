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
= Einleitung

Dieses Dokument beschreibt die Architektur des Ausgangs-IACS der LDPE-Anlage der
ChemoDemo AG. Es setzt auf dem Geltungsbereich aus Schritt 1
(ScopeDef-IACS-ChemoDemo) auf und liefert die Grundlage für die Risikoanalyse
sowie die anschließende Erweiterung zum IIoT-System (Digitaler Rundgang).

Den logischen Netzwerkplan führen wir als textuelle Beschreibung; die zugehörige
Grafik liegt im separaten Artefakt „IACS-Netzplan-ChemoDemo-v2.drawio" als
Abbildung 1. Komponenten werden durchgängig über eindeutige Asset-IDs nach dem
Schema ASSET-\<Zone\>-\<Nr\> referenziert -- also genau die IDs, die auch im
Netzplan und in der späteren Risikoanalyse auftauchen. Das macht das Dokument
querreferenzierbar, ohne dass man jedes Mal raten muss, welcher „der Server S1"
jetzt gemeint ist.

Strukturell folgt das IACS dem Vorbild aus VDI/VDE 2182 Blatt 3.3 und entspricht
dem Zonenmodell von IEC 62443: Feldebene (TB2), Steuerung und Leitstand (TB1),
Operations Management, Office, DMZ, Internet. Dazu kommt ein unabhängiges Safety
Instrumented System (SIS). Die Architektur ist an allen LDPE-Standorten der
ChemoDemo AG baugleich umgesetzt -- am betrachteten internationalen Standort
genauso wie in München.

// =============================================================================
= Logischer Netzwerkplan

Die grafische Darstellung ist Abbildung 1 (siehe Artefakt
IACS-Netzplan-ChemoDemo-v2.drawio). Logisch zerfällt das Netz in sechs Zonen,
getrennt durch dedizierte Firewalls. Innerhalb jeder Zone kommunizieren
definierte Komponenten über festgelegte Protokolle. Das Safety-System hängt als
zusätzliche, physisch und logisch getrennte Zone neben der Prozess-Steuerung.

== Netzwerksegmente (Zonen) im Überblick

#table(
  columns: 3,
  [*Zone / Segment*], [*Funktion*], [*Abgrenzung nach außen*],
  
    [Internet / WAN],
      [Externer Datenverkehr; Sitz externer Dienstleister (Remote-Service).],
      [Internet-Firewall FW1 (Cisco ASA, IT-Abteilung).],
    [DMZ],
      [Demilitarisierte Zone mit RAS-Server S0 für IPsec-Remote-Access.],
      [FW1 nach außen, FW2 zum Office; klassisches Zwei-Firewall-Konzept.],
    [Office-Netz],
      [Büroarbeitsplätze (WC1 Data Monitor, WC2 Historian, WC3 Operator), ERP-Komponente, Übergang zum MIS.],
      [FW2 zur DMZ, FW3 zum Operations Management.],
    [Operations Management],
      [MIS (S3), Jump Server (S4), WSUS (S5), Historian (S6), Virus Scan Server (S2), Domain Controller DC1.],
      [FW3 zum Office, FW4 (Scalance, PLT) zum OT-Netz.],
    [Terminal Bus TB1 (OT)],
      [Operator Stations OS1, Engineering Station ES1, Domain Controller DC2, redundante Router R2.],
      [FW4 zum Operations Management; Server S1 als Firewall-Gateway zum Anlagenbus TB2.],
    [Anlagenbus TB2 (OT)],
      [Redundante Controller TI mit I/O, Sensoren und Aktoren; redundante Router R3/R4.],
      [S1-Server als Firewall zwischen TB1 und TB2.],
    [Safety-Zone (SIS)],
      [Safety-SPS mit eigenen sicherheitsgerichteten Sensoren und Aktoren; physisch und logisch getrennt.],
      [Unidirektionale Diagnose-Kopplung (Data Diode) Richtung TB2.],
)

== Textuelle Beschreibung des Netzwerkflusses

Sensoren messen Prozessgrößen und liefern die Werte über PROFINET an die
redundanten Controller TI (ASSET-OT-101/102) im Anlagenbus TB2. Die TI-Controller
regeln daraufhin die Aktoren -- Ventile, Pumpen, Motoren -- ebenfalls über
PROFINET. Die S1-Server (ASSET-OT-201/202) verbinden den Anlagenbus TB2 mit dem
Terminal Bus TB1 und übernehmen dabei eine Firewall-Funktion: nur explizit
freigegebene Protokolle, Ports und IP-Adressen kommen durch. Alles andere bleibt
draußen.

Im Terminal Bus TB1 laufen die Operator Stations OS1 (ASSET-OT-301/302), die
Engineering Station ES1 (ASSET-OT-303) und der Domaincontroller DC2
(ASSET-OT-304). OS1 visualisiert die Prozessdaten für das Operator-Personal in
der Leitwarte; ES1 dient zur Konfiguration und Programmierung der Controller TI.
Über DC2 hängen alle Windows-Komponenten im OT-Netz in einer eigenen Domäne --
getrennt von der Office-Domäne, was bei Audits regelmäßig positiv auffällt.

Vom TB1 aus laufen Daten über die OT-Firewall FW4 (ASSET-OPS-104, Scalance,
administriert durch die PLT-Betriebsbetreuung) ins Operations-Management-Netz.
Dort verarbeitet das MIS (ASSET-OPS-103) die Daten und übergibt aggregierte
Werte via OPC UA an die ERP-Komponente (ASSET-OFF-201) im Office-Netz.
Zeitreihen wandern via SMB in die Historian Database (ASSET-OPS-107). Wichtig:
Die Historian-Kommunikation ist an FW4 ausschließlich von TB1/TB2 in Richtung
Operations Management freigegeben -- nicht andersherum.

Das Office-Netz (WC1--WC3, ERP) ist über die IT-Firewall FW3 (ASSET-OPS-105,
Cisco ASA, IT-Abteilung) vom Operations Management getrennt und über die
Firewall FW2 (ASSET-OFF-101) an die DMZ angebunden. Die DMZ wiederum hängt über
FW1 (ASSET-DMZ-102) am Internet. In der DMZ steht der RAS-Server S0
(ASSET-DMZ-101), Endpunkt der IPsec-VPN-Verbindungen -- mit AH und ESP im
Tunnelmodus, Authentisierung über Zertifikate und zusätzlich
Benutzername/Passwort.

Remote-Zugriffe gehen grundsätzlich über zwei Wege. Der erste ist der
Standardpfad: Der externe Dienstleister (ASSET-EXT-001 = C1) verbindet sich von
seinem Client per IPsec auf S0, von dort mit Benutzername/Passwort auf einen der
Clients WC1--WC3 (ASSET-OFF-101..103) im Office, weiter auf den Jump Server S4
(ASSET-OPS-106) und erst von dort auf ES1. Der zweite Weg ist der Notfall-Pfad:
PLT schaltet den ISDN-Router R2 (ASSET-OPS-108) explizit frei, sodass ein
ChemoDemo-Client C2 (ASSET-EXT-002) über den ISDN-Router R1 auf die WC-Clients
und anschließend auf S4 gelangt. Beide Pfade enden zwingend am Jump Server S4.
Niemand kommt am S4 vorbei.

Zeitsynchronisation läuft konsequent über NTP: DC1 (ASSET-OPS-102)
synchronisiert gegen einen NTP-Server im Office, DC2 gegen DC1, die Komponenten
im Operations Management gegen DC1, die TB1-Komponenten und die S1-Server gegen
DC2, die TB2-Komponenten schließlich gegen die S1-Server (im Netzplan grün
gestrichelt). Backups der Engineering Station ES1 zieht Acronis auf OS1; einmal
pro Woche wandern sie per FTP auf den Historian S6. Dass FTP unverschlüsselt
ist, wissen wir -- die Bewertung kommt im nächsten Schritt.

Safety (SIS) ist als dritte, physisch unabhängige Schiene realisiert. Eine
separate Safety-SPS (ASSET-SAF-101) überwacht kritische Grenzwerte -- Druck,
Temperatur, Füllstand -- über dedizierte sicherheitsgerichtete Sensoren und
löst über fail-safe Aktoren (Not-Aus-Ventile, Druckentlastung,
Schnellabschaltung) den sicheren Anlagenzustand aus, wenn nötig. Zu
Diagnose-Zwecken werden Safety-Daten ausschließlich lesend über eine Data Diode
(ASSET-SAF-104) an die Prozess-Leitebene gespiegelt. Schreibend kommt da nichts
rein.

// =============================================================================
= Komponentenverzeichnis (Asset-Inventar)

Die folgende Tabelle listet die Komponenten des Ausgangs-IACS mit eindeutiger
Asset-ID, Typ und Zuordnung zur Ebene gemäß IEC-62443-Zonenmodell bzw.
Purdue-Referenzmodell. Das Schema lautet ASSET-\<Zone\>-\<Nr\>: SAF = Safety,
OT = Anlagen-/Terminalbus, OPS = Operations Management, OFF = Office,
DMZ = DMZ, EXT = extern, FLD = Feldebene, SITE = Standortinfrastruktur.
Insgesamt sind 28 Asset-Klassen erfasst; redundante Auslegung (etwa TI-A/TI-B)
ist als Suffix kenntlich.

#table(
  columns: 3,
  [*Komponente*], [*Typ*], [*Ebene / Zone*],
    [Drucksensoren], [Feldgerät], [Feld (Purdue 0)],
    [Temperatursensoren], [Feldgerät], [Feld (Purdue 0)],
   [Durchfluss- und Füllstandssensoren], [Feldgerät], [Feld (Purdue 0)],
    [Regelventile, Pumpen, Motoren], [Feldgerät (Aktor)], [Feld (Purdue 0)],
    [Controller TI (A/B, redundant)], [PLC / SPS], [TB2 (Purdue 1)],
    [Server S1 (A/B)], [Server / Gateway mit FW-Funktion], [Kopplung TB1 ↔ TB2],
    [Operator Stations OS1 (A/B)], [HMI / Leitstand-Client], [TB1 (Purdue 3)],
    [Engineering Station ES1], [Engineering-Workstation], [TB1 (Purdue 3)],
    [Domain Controller DC2], [Server (Windows)], [TB1],
    [Router R2 (A/B, TB1)], [Netzwerk], [TB1],
    [Router R3 (A/B, TB2)], [Netzwerk], [TB2],
    [Router R4 (Anlagenbus)], [Netzwerk], [TB2],
    [Virus Scan Server S2], [Security-Server], [Operations Management],
    [Domain Controller DC1], [Server (Windows)], [Operations Management],
    [MIS-Server S3 (Manufacturing Information System)], [Applikations-Server], [Operations Management],
    [OT-Firewall FW4 (Scalance, PLT)], [Industrielle Firewall], [Grenze OpsMgmt ↔ TB1],
    [IT-Firewall FW3 (Cisco ASA)], [Firewall], [Grenze Office ↔ OpsMgmt],
    [Jump Server S4 (Bastion)], [Server], [Operations Management],
    [Historian Database S6], [Datenbank-Server], [Operations Management],
    [ISDN-Router R2 (Notfall, PLT-Freischaltung)], [Zugangsgerät], [Operations Management],
    [WSUS-Server S5], [Update-Server], [Operations Management],
    [Web-Clients WC1, WC2, WC3], [Client-PCs], [Office (Purdue 4)],
    [FW2 External Firewall (Cisco ASA)], [Firewall], [Grenze Office ↔ DMZ],
    [ERP-Server], [Applikations-Server], [Office / Business-IT],
    [NTP-Server (Office, Top der NTP-Kaskade)], [Server], [Office],
    [RAS-Server S0 (IPsec-Gateway)], [VPN-Gateway], [DMZ],
    [Internet-Firewall FW1 (Cisco ASA)], [Firewall], [Grenze DMZ ↔ Internet],
    [Remote-Client C1 (externer Dienstleister)], [Client (extern)], [Internet],
    [Remote-Client C2 + ISDN-Router R1], [Client / Zugangsgerät], [extern],
    [Safety-SPS (SIS, SIL 3)], [Safety-PLC], [Safety-Zone],
    [Sicherheitsgerichtete Sensoren (Druck, Temperatur)], [Safety-Feldgeräte], [Safety-Zone],
    [Sicherheitsgerichtete Aktoren (Not-Aus, Druckentlastung, Schnellabschaltung)], [Safety-Feldgeräte], [Safety-Zone],
    [Data Diode (unidirektional, SIS → TB2)], [Sicherheitshardware], [Safety-Zone],
    [Safety-Engineering-Station], [Engineering-Workstation], [Safety-Zone],
    [Werkszaun, Tore, RFID-Schließsystem], [Physische Sicherheit], [Standort-Perimeter],
)

Damit sind die geforderten Ebenen vollständig abgedeckt: Netzwerk
(FW1--FW4, R1--R4, Switche), Applikation (MIS, ERP, Historian, Virus Scan,
WSUS, Jump Server), Plattform Windows (OS1, ES1, DC1, DC2, S1, WC1--WC3),
Maschinen und Steuerungen (TI-Controller, Safety-SPS) sowie die Feldebene
(Sensoren und Aktoren).

// =============================================================================
= Kommunikationsprotokolle

Die folgende Liste zeigt die eingesetzten Protokolle mit ihrem jeweiligen Zweck.
Industrielle Protokolle -- mindestens zwei waren gefordert -- sind enthalten;
PROFINET und OPC UA decken den klassischen Fall ab, PROFIsafe kommt für Safety
dazu.

#table(
  columns: 5,
  [*Nr.*], [*Protokoll*], [*Typ*], [*Einsatz im IACS*], [*Sicherheitsmerkmale*],

    [1], [PROFINET], [Industrielles Echtzeit-Protokoll],
      [Feld ↔ Controller TI im Anlagenbus TB2: Übertragung der Sensor- und Aktorwerte.],
      [Erfüllt harte Echtzeit; klassisch unverschlüsselt -- Schutz erfolgt über Zonierung und physische Sicherheit.],
    [2], [OPC UA], [Industrielles Protokoll],
      [MIS (S3) → ERP: Übergabe analysierter und aggregierter Produktionsdaten.],
      [Unterstützt Security-Profile (Sign, SignAndEncrypt) und Authentisierung.],
    [3], [SMB], [File-/Protokoll-Share],
      [Schreiben definierter Prozessdaten als Zeitreihen in die Historian DB (S6).],
      [Innerhalb Operations Management; Zugriff durch FW4-Regeln auf IPs und Ports beschränkt.],
    [4], [FTP], [Dateitransfer],
      [Wöchentliche Übertragung der Acronis-Sicherungen von OS1 auf den Historian S6.],
      [Unverschlüsselt; aktuell innerhalb OT, in der Risikoanalyse zu bewerten.],
    [5], [SSH], [Secure Shell],
      [Zugriff von WC1--WC3 (Office) auf den MIS-Server S3.],
      [Verschlüsselt; Authentisierung über Kennung/Passwort.],
    [6], [IPsec (AH, ESP, Tunnel)], [VPN-Protokoll],
      [Remote-Access C1 → RAS-Server S0 in der DMZ.],
      [Authentisierung über Zertifikate plus Kennung/Passwort; End-zu-End-Verschlüsselung zum DMZ-Endpunkt.],
    [7], [RDP / Remote-Session], [Fernwartungsprotokoll],
      [Sprung von WC-Clients auf Jump Server S4 und weiter auf ES1.],
      [Authentisierung mit Kennung/Passwort; Kapselung im IPsec-Tunnel.],
    [8], [NTP], [Zeitsynchronisation],
      [Office-NTP → DC1 → Operations Management → DC2 → TB1/S1 → TB2.],
      [Integritäts- und Nachweiszwecke.],
    [9], [TCP/IP + HTTPS], [Standard-Web-Protokoll],
      [Web-Clients WC1--WC3 gegen interne Web-Anwendungen.],
      [TLS-Verschlüsselung.],
    [10], [PROFIsafe], [Fail-safe Kommunikation],
      [Safety-SPS ↔ sicherheitsgerichtete Sensoren und Aktoren.],
      [Nachweispflichtig nach IEC 61508/61511; Zeitüberwachung, Sequenznummer und CRC.],
)

// =============================================================================
= Kommunikationsmatrix

Die Kommunikationsmatrix listet alle architektonisch vorgesehenen Datenflüsse
zwischen den Assets. Sie ist gleichzeitig Vorgabe für die Firewall-Regeln
(FW1--FW4, S1) und Referenz für die spätere Risikoanalyse. In der Spalte
„Initiator → Akzeptor" steht eindeutig, wer die Verbindung aufbaut -- wichtig,
weil Firewalls Stateful arbeiten und die Richtung den Unterschied macht. Quellen
ohne Asset-ID sind externe Endpunkte.

#table(
  columns: 6,
  [*Nr.*], [*Initiator → Akzeptor*], [*Protokoll*], [*Port (Standard)*], [*Authentisierung*], [*Verschlüsselung*],

  [K01], [C1 (extern) → ASSET-DMZ-101 (RAS S0)],
      [IPsec (AH/ESP, Tunnel)], [UDP 500/4500],
      [Zertifikat + Benutzername/Passwort], [Ja (IPsec ESP)],
    [K02], [ASSET-DMZ-101 (RAS S0) → ASSET-OFF-101..103 (WC1--WC3)],
      [RDP], [TCP 3389], [Kennung/Passwort], [Ja (TLS innerhalb RDP)],
    [K03], [ASSET-OFF-101..103 (WC1--WC3) → ASSET-OPS-106 (Jump Server S4)],
      [RDP], [TCP 3389], [Kennung/Passwort], [Ja (TLS)],
  [K04], [ASSET-OPS-106 (S4) → ASSET-OT-303 (ES1)],
      [RDP], [TCP 3389], [Kennung/Passwort], [Ja (TLS)],
    [K05], [ASSET-OFF-101..103 (WC1--WC3) → ASSET-OPS-103 (MIS S3)],
      [SSH], [TCP 22], [Kennung/Passwort], [Ja (SSH)],
    [K06], [ASSET-OPS-103 (MIS S3) → ASSET-OFF-201 (ERP)],
      [OPC UA], [TCP 4840], [Zertifikat (OPC UA Security)], [Ja (Sign & Encrypt)],
    [K07], [ASSET-OT-201/202 (S1) → ASSET-OPS-107 (Historian S6)],
      [SMB], [TCP 445], [Domänen-Authentisierung (DC1/DC2)], [Optional (SMB 3 Encryption)],
    [K08], [ASSET-OT-301 (OS1-A) → ASSET-OPS-107 (Historian S6)],
      [FTP (Backup)], [TCP 21 / 20], [Kennung/Passwort], [Nein (Schwachstelle, in Risikoanalyse zu bewerten)],
    [K09], [ASSET-OT-101/102 (TI) ↔ Sensoren/Aktoren (ASSET-FLD-001..101)],
      [PROFINET RT], [Layer 2 (kein TCP/IP-Port)], [Keine (Schutz durch Zone und physische Sicherheit)], [Nein],
    [K10], [ASSET-OT-201/202 (S1) ↔ ASSET-OT-101/102 (TI)],
      [PROFINET / proprietär TCP], [definierte Ports an FW-Funktion S1], [Domänen-Authentisierung], [abhängig vom Hersteller],
    [K11], [ASSET-OPS-101 (Virus Scan S2) → ASSET-OPS-109 (WSUS S5)],
      [HTTPS (Pattern-Updates)], [TCP 443], [Server-Zertifikat], [Ja (TLS)],
  [K12], [ASSET-OPS-109 (WSUS S5) → Windows-Hosts (OS1, ES1, DC1, DC2, S1)],
      [WSUS / HTTPS], [TCP 8530/8531], [Domänen-Authentisierung], [Ja (TLS)],
    [K13], [ASSET-OFF-202 (NTP Office) → ASSET-OPS-102 (DC1)],
      [NTP], [UDP 123], [Keine (Symmetric Key optional)], [Nein],
    [K14], [ASSET-OPS-102 (DC1) → ASSET-OT-304 (DC2)],
      [NTP], [UDP 123], [Keine], [Nein],
    [K15], [ASSET-OT-304 (DC2) → ASSET-OT-201/202 (S1)],
      [NTP], [UDP 123], [Keine], [Nein],
    [K16], [ASSET-OT-201/202 (S1) → ASSET-OT-101/102 (TI)],
      [NTP], [UDP 123], [Keine], [Nein],
    [K17], [C2 (extern) → ASSET-OPS-108 (R2 ISDN, nur nach PLT-Freischaltung)],
      [ISDN], [---], [Kennung/Passwort], [Nein (Notfall-Pfad)],
    [K18], [ASSET-SAF-101 (Safety-SPS) ↔ ASSET-SAF-102/103 (Safety-Sensoren/-Aktoren)],
      [PROFIsafe], [Layer 2 / proprietär], [Sequenznummer + CRC], [Integritätsschutz, kein Confidentiality-Anspruch],
    [K19], [ASSET-SAF-105 (Safety-Engineering) → ASSET-SAF-101 (Safety-SPS)],
      [Safety-Engineering-Tool (proprietär)], [Hersteller-spezifisch], [Schlüsselschalter + 4-Augen-Prinzip], [Hersteller-spezifisch],
    [K20], [ASSET-SAF-101 → ASSET-SAF-104 (Data Diode) → ASSET-OT-101/102 (TI, Diagnose)],
      [Diagnose-Read-Only], [unidirektional (Hardware-Diode)], [Keine (Diode erlaubt nur Auslesen)], [Integritätsschutz durch Diode-Hardware],
)

// =============================================================================
= Behandlung der Safety

== Safety-Ansatz für die LDPE-Anlage

Die LDPE-Anlage fällt aufgrund der Hochdruck-Polymerisation und der eingesetzten
Stoffe -- Ethen, Initiatoren -- unter strenge Anforderungen der Prozesssicherheit.
Funktional umgesetzt wird das durch ein unabhängiges Safety Instrumented System
(SIS) nach IEC 61511. Zielgröße sind Safety Integrity Levels (SIL) der
sicherheitsgerichteten Funktionen, festgelegt im HAZOP-Prozess. Das ist kein
Beiwerk, sondern Grundlage der Betriebsgenehmigung.

- Separate Safety-SPS (ASSET-SAF-101) mit zertifizierter Firmware, etwa
  SIL-3-fähig.
- Sicherheitsgerichtete, redundant ausgelegte Sensoren (ASSET-SAF-102) für die
  kritischen Prozessgrößen Druck und Temperatur.
- Fail-safe Aktoren (ASSET-SAF-103): Not-Aus-Ventile, Druckentlastungsventile,
  Schnellabschaltung des Reaktor-Feeds.
- Proprietäres Safety-Protokoll (PROFIsafe) mit Zeitüberwachung, Sequenznummer
  und CRC.
- Definierte sichere Zustände (Safe State) im Störfall, automatisch herbeigeführt
  -- ohne Bedienereingriff, weil im Sekundenbereich kein Mensch verlässlich
  reagiert.
- Physische Trennung vom Prozess-Leitsystem: eigene Schaltschränke, eigene
  Verkabelung, eigene Energieversorgung.

== Security for Safety

Safety-Funktionen sind in einer modernen Anlage längst nicht mehr isoliert: Die
Safety-SPS wird konfiguriert, parametriert und für Diagnose-Zwecke ausgelesen.
Damit entsteht ein Security-Risiko für die Safety-Funktionen, und genau das
adressiert „Security for Safety". Wer sich an Triton bzw. TRISIS erinnert, weiß,
warum dieser Punkt nicht akademisch ist.

- Safety-Zone als eigene Zone im Sinne von IEC 62443; Zugriff ausschließlich über
  definierte Conduits.
- Schreibzugriffe auf die Safety-SPS nur aus einer dedizierten
  Safety-Engineering-Umgebung (ASSET-SAF-105), zusätzlich abgesichert über
  Schlüsselschalter und 4-Augen-Prinzip.
- Ein-Richtungs-Kommunikation von der Safety-Zone zur Prozess-Leitebene über
  eine Data Diode (ASSET-SAF-104). Physikalisch nur lesend -- keine
  Software-Trennung, sondern Hardware.
- Eigene Authentisierung und Protokollierung; Änderungen am Safety-Programm
  werden vollständig auditierbar gespeichert.
- Härtung der Safety-Engineering-Station: kein Internetzugang, keine
  Wechselmedien ohne Freigabe, separater Domänenkontext.
- Organisatorisch laufen Safety-Änderungen über den Safety-Lifecycle nach
  IEC 61511 plus das Change-Management der PLT-Fachabteilung nach VDI/VDE 2182
  Blatt 3.3.

// =============================================================================
= Bereits umgesetzte Security-Maßnahmen

Die folgenden Maßnahmen gelten nach den Angaben aus der Beschreibung des
Fallbeispiels und nach VDI/VDE 2182 Blatt 3.3 als umgesetzt. Sie bilden den
IST-Zustand, auf den die Risikoanalyse aufsetzt.

== Physische Sicherheit und Zutrittskontrolle

- Werkszaun um das gesamte Gelände des Chemieparks.
- Kontrollierter Zugang über Tore, manuell überwacht oder per Kamera bzw.
  Lesegerät für Werksausweise.
- Elektrische Betriebsräume und PLS-Schalträume mit Zugangskontrolle über
  physische Schlüssel und RFID-Token.
- IT-Infrastruktur-Räume mit separatem Schlüsselsystem (physisch + RFID);
  Zutritt beschränkt auf Mitarbeitende der IT-Fachabteilung.
- Sensoren und Aktoren vor Ort sind nur mit Werkzeug zugänglich; Auslesen
  funktioniert nur mit Spezialgeräten und passender Anwendungssoftware.

== Organisation und Richtlinien

- Etabliertes ISMS nach ISO/IEC 27001; LDPE-Anlagen werden im Rahmen der
  Offensive „OT Security and Resilience" vollständig integriert.
- Eigenständiges OT-ISMS unter Leitung des OT-CISO.
- PLT-Fachabteilung mit zentraler PLT-Fachbetreuung und standortspezifischer
  PLT-Betriebsbetreuung; Verantwortlichkeiten gemäß VDI/VDE 2182 Blatt 3.3.
- BCM unter eigenständiger BCM-Managerin, direkt dem CEO unterstellt.
- Firmeninterne IT/OT-Sicherheitsrichtlinien, schriftliche Verpflichtung aller
  Mitarbeitenden.
- Externer Datenschutzbeauftragter, berichtet an den IT-Manager.
- Change-Management der PLT-Betriebsbetreuung; jährliches Prozessaudit; Audit
  vor Erstinbetriebnahme nach VDI/VDE 2182 Blatt 3.3, Abschnitt 5.8.
- Rollenspezifische Schulungen für Fachpersonal, Anwender und externe
  Mitarbeitende, eingebunden ins QM.

== Netzwerksicherheit und Zonierung

- Strikte Zonierung in sechs Segmente (Internet, DMZ, Office, Operations
  Management, TB1, TB2), getrennt durch dedizierte Firewalls.
- Zwei-Firewall-DMZ zwischen Internet und Office (FW1 + FW2, Cisco ASA,
  IT-Abteilung).
- Trennung Office ↔ Operations Management über FW3 (Cisco ASA, IT-Abteilung).
- Trennung Operations Management ↔ Terminal Bus über die OT-Firewall FW4
  (Scalance, PLT-Betriebsbetreuung) -- mit getrennter Administrationszuständigkeit
  als „Separation of Duties".
- Kopplung TB1 ↔ TB2 über S1-Server mit Firewall-Funktion (siehe
  Kommunikationsmatrix K07/K10): Historian-Kommunikation ist ausschließlich von
  TB1/TB2 in Richtung Operations Management freigegeben, die Gegenrichtung ist
  gesperrt.
- Redundante Auslegung der OT-Infrastruktur: S1-Server, Router R2/R3,
  Controller TI.

== Zugriff, Authentisierung und Remote-Access

- Remote Access nur über IPsec mit AH und ESP im Tunnelmodus (siehe K01).
- Authentisierung bei IPsec über Zertifikate plus Kennung/Passwort des
  Mitarbeitenden.
- Gestufter Zugriff: C1 → S0 → WC → S4 → ES1 (siehe K01--K04).
- Jump Server S4 als einzige Sprungbrett-Instanz.
- Notfall-Zugang über ISDN nur nach expliziter PLT-Freischaltung (K17).
- Office-PCs greifen auf das MIS via SSH zu (K05).
- Vertraulichkeitsvereinbarungen mit externen Dienstleistern; IT-Richtlinien
  für Systemadministratoren.

== Host- und Plattformsicherheit

- Zentrale Windows-Domänen: DC1 für Operations Management, DC2 für TB1/OT.
- Zentraler Virenschutz: Pattern-Updates über den Virus Scan Server S2 (K11),
  Verteilung über den WSUS-Server S5 (K12).
- Zentrale Patch-Verteilung über den WSUS-Server S5.
- Datensicherung: Engineering-Station ES1 per Acronis auf OS1, wöchentliche
  Sicherung auf den Historian S6 (K08).
- Datensicherungskonzept nach VDI/VDE 2182 Blatt 3.3 (Tabelle 8).

== Zeit, Logging und Monitoring

- Einheitliche Zeitsynchronisation über NTP, kaskadiert bis auf die Feldebene
  (K13--K16).
- Logs in PLS- und MES-Systemen erzeugen Alarme, sobald kritische Zustände oder
  Grenzwerte erreicht werden.
- Notfallbewältigungsplan mit definierten Rollen (PLT-Betriebsbetreuung,
  zentrale PLT-Fachbetreuung) und Eskalationswegen.

// =============================================================================
= Zuordnung der Maßnahmen zu Standard-Controls

Die folgende Tabelle ordnet die Maßnahmen-Gruppen aus Kapitel 7 den
korrespondierenden Controls aus ISO/IEC 27002:2024 und IEC 62443-2-1 zu. Zweck
ist Auffindbarkeit und Auditierbarkeit -- bewusst ohne Wirksamkeitsbewertung.
Die kommt erst in der Risikoanalyse (Schritt 4).

#table(
  columns: 3,
  [*Umgesetzte Maßnahme*], [*ISO/IEC 27002:2024 Control*], [*IEC 62443-2-1 Practice*],
    [Werkszaun, Tore, Schlüsselsystem für Schalt- und IT-Räume],
      [7.1 Physische Sicherheitsperimeter; 7.2 Physischer Zutritt; 7.3 Sicherung von Büros, Räumen und Einrichtungen],
      [Practice 4 -- Physical Security Management],
    [ISMS- und OT-ISMS-Organisation, Richtlinien],
      [5.1 Politiken zur Informationssicherheit; 5.2 Rollen und Verantwortlichkeiten],
      [Practice 1 -- Risk Identification, Classification and Assessment; Practice 2 -- Security Policies, Procedures, and Practices],
    [Schulungen und schriftliche Verpflichtung der Mitarbeitenden],
      [6.3 Sensibilisierung, Aus- und Weiterbildung],
      [Practice 5 -- Security Awareness and Training],
    [Externer Datenschutzbeauftragter, Verträge mit Dienstleistern],
      [5.31 Rechtliche, gesetzliche und vertragliche Anforderungen; 5.20 Adressierung von Informationssicherheit in Lieferantenvereinbarungen],
      [Practice 3 -- Compliance with Applicable Laws],
    [Zonierung Internet--DMZ--Office--OpsMgmt--TB1--TB2],
      [8.22 Trennung von Netzwerken; 8.20 Netzwerksicherheitssteuerungen],
      [Practice 7 -- Network Segmentation; SR 5.1 Network Segmentation (62443-3-3)],
    [Zwei-Firewall-DMZ; FW1--FW4],
      [8.21 Sicherheit von Netzdiensten],
      [Practice 7 -- Network Segmentation],
    [Server S1 als Firewall TB1↔TB2; Whitelisting Historian-Datenfluss],
      [8.22 Trennung von Netzwerken],
      [SR 5.2 Zone Boundary Protection],
    [IPsec-VPN für Remote Access],
      [5.14 Übertragung von Informationen; 8.20 Netzwerksicherheitssteuerungen],
      [Practice 8 -- Network Access Control; Remote Access Management],
    [Jump Server S4 als Bastion für gestuften Zugriff],
      [8.5 Sichere Authentisierung; 8.2 Privilegierte Zugriffsrechte],
      [Practice 8 -- Network Access Control],
    [Notfall-ISDN-Zugang nur nach PLT-Freischaltung],
      [5.30 IKT-Bereitschaft für die Geschäftsfortführung],
      [Practice 11 -- Incident Response Planning; BCM],
    [Windows-Domänen DC1 (OpsMgmt) und DC2 (OT)],
      [5.16 Identitätsverwaltung; 5.17 Authentisierungsinformationen; 8.5 Sichere Authentisierung],
      [Practice 8 -- Account Management],
    [Virenschutz und WSUS-Patch-Verteilung],
      [8.7 Schutz vor Schadsoftware; 8.8 Verwaltung technischer Schwachstellen],
      [Practice 12 -- Patch Management; Practice 13 -- Antivirus Management],
    [Backup-Konzept (Acronis OS1, FTP auf Historian S6, zentrales IT-Backup)],
      [8.13 Sicherung von Informationen],
      [Practice 14 -- Backup and Recovery],
    [NTP-Kaskade (Office → DC1 → DC2 → S1 → TB2)],
      [8.17 Uhrzeit-Synchronisation],
      [Practice 17 -- Time Synchronization (Logging-Voraussetzung)]),
    [Logs und Alarme in PLS/MES bei kritischen Zuständen],
      [8.15 Protokollierung; 8.16 Aktivitätenüberwachung],
      [Practice 15 -- Event Logging and Audit; Practice 16 -- Monitoring]),
    [Safety Instrumented System (SIS) mit Data Diode],
      [8.22 Trennung von Netzwerken (für die Safety-Zone)],
      [Practice 7 -- Zone Concept (Safety als eigene Zone)],
    [Audit nach SAT, jährlich, bei Änderungen (VDI/VDE 2182 Blatt 3.3, 5.8)],
      [5.35 Unabhängige Überprüfung der Informationssicherheit; 5.36 Konformitätsprüfung],
      [Practice 18 -- Conformance Assessment],
)

// =============================================================================
= Umfang des IACS (Abdeckung der Anforderungen)

Zur Nachvollziehbarkeit hier eine kurze Gegenüberstellung der Anforderungen mit
dem, was im Ausgangs-IACS tatsächlich abgedeckt ist.

#table(
  columns: 2,
 [*Geforderte Eigenschaft*], [*Abdeckung im Ausgangs-IACS*],

    [≥ 15 Komponenten],
      [Komponentenverzeichnis mit 35 Asset-IDs (Kapitel 3) deckt alle geforderten Ebenen ab.],
    [≥ 5 Kommunikationsprotokolle],
     [10 Protokolle (Kapitel 4) und 20 Datenflüsse in der Kommunikationsmatrix (Kapitel 5).],
    [Komponenten auf Ebenen Netzwerk, Applikation, Plattform, Maschinen/Steuerungen, Feld],
     [Netzwerk: FW1--FW4, R1--R4. Applikation: MIS, ERP, Historian, Virus Scan, WSUS, Jump Server. Plattform Windows: OS1, ES1, DC1, DC2, S1, WC1--WC3. Steuerungen: TI plus Safety-SPS. Feld: Sensoren und Aktoren.],
    [Einbindung eines Safety Instrumented Systems],
     [Safety-SPS (ASSET-SAF-101) mit eigenen Sensoren (-102), Aktoren (-103), Data Diode (-104) und Engineering-Station (-105); PROFIsafe; eigene Zone (siehe Kapitel 6).],
    [Zwei industrielle Protokolle],
     [PROFINET im Feld und OPC UA zwischen MIS und ERP; PROFIsafe zusätzlich für Safety.],
    [Feldebene],
     [Sensoren (Druck, Temperatur, Durchfluss, Füllstand) und Aktoren (Regelventile, Pumpen, Motoren); ASSET-FLD-001..101.],
    [Leitstand],
     [OS1, ES1, DC2, redundante S1-Server, R2-Router (TB1).],
    [Maschinen / Steuerungen],
     [Redundante Controller TI (ASSET-OT-101/102) für die Prozessregelung; Safety-SPS (ASSET-SAF-101).],
    [Anbindung Business-IT],
     [Office-Netz mit ERP und WC1--WC3; MIS↔ERP via OPC UA (K06); SSH von WC zum MIS (K05).],
    [Remote Access],
     [Zwei Wege: IPsec über C1 (K01--K04) und ISDN-Notfall (K17).],
    [Externer Dienstleister],
     [C1 (ASSET-EXT-001), abgesichert durch IPsec, Jump Server und gestufte Authentisierung.]),
    [Internationaler Standort (HQ Deutschland)],
      [Standort München; baugleiche LDPE-Anlage mindestens an einem weiteren Standort (siehe ScopeDef-Kapitel 5.4).],
)

// =============================================================================
= Referenzierte Standards

- VDI/VDE 2182 Blatt 3.3 -- Informationssicherheit in der industriellen
  Automatisierung, Anwendungsbeispiel LDPE-Anlage (Betreiber).
- ISO/IEC 27001:2024 -- Informationssicherheits-Managementsysteme.
- ISO/IEC 27002:2024 -- Informationssicherheitsmaßnahmen (Controls).
- IEC 62443-2-1 -- Security Management System für IACS (Practices).
- IEC 62443-3-3 -- System security requirements and security levels.
- IEC 61508 / IEC 61511 -- Funktionale Sicherheit; Grundlage für das Safety
  Instrumented System.


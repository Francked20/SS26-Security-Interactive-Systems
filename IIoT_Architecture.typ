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
      align(center)[IIoT-Architektur & RAMI4.0 Eindordnung: Digitaler Rundgang],

    )
    line(length: 100%, stroke: 0.4pt + divider)
  },
)
#counter(page).update(1)


// =============================================================================
= 1. Einleitung

Dieses Dokument erweitert die in Schritt 2 dokumentierte
IACS-Architektur der LDPE-Anlage der ChemoDemo AG um die
Industrie-4.0-Erweiterung „Digitaler Rundgang“. Grundlage bleiben die
beiden Vorgängerdokumente ScopeDef-IACS-ChemoDemo (Schritt 1) und
IACS-Architecture-ChemoDemo (Schritt 2); beide gelten unverändert
weiter. Die dort beschriebenen Zonen, Assets und die Safety-Zone
übernehmen wir eins zu eins. Hier kommt obendrauf: neue
Komponenten, neue Datenflüsse und eine zusätzliche IIoT-Zone.

Die Risikoanalyse steckt in einem separaten
Excel-Sheet, IIoT-RiskAnalysis-ChemoDemo, und gehört nicht in dieses
Dokument. Worauf sie aufsetzt, ist allerdings genau die hier
beschriebene Architektur.


= 2. Ziel der Erweiterung „Digitaler Rundgang“

== 2.1 Ausgangssituation
Auf der LDPE-Anlage laufen regelmäßig Rundgänge, also Audits zu
Safety, Quality Management und Security. Bisher lief das auf Papier, mit
gedruckten Prüfschemen und Checklisten. Das brachte ein paar handfeste
Nachteile mit sich:

- Die gewonnenen Informationen standen nicht elektronisch zur
  Verfügung.


- Die Daten konnten weder themenübergreifend (z. B. Safety- und
  Security-Befunde gemeinsam) eingesehen noch automatisiert
  weiterverarbeitet werden.

- Papierbasierte Checklisten gehen verloren oder werden falsch
  archiviert.

- Die Verzögerung zwischen Rundgang und Bereitstellung der
  Informationen im ERP für andere Abteilungen (z. B. Einkauf,
  Instandhaltung) betrug häufig Tage.

#pagebreak()
  

== 2.3 Vermiedene Risiken und Nutzenpotenziale

=== 2.3.1 Vermiedene Risiken
#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Bereich]], [#strong[Risiko bei papierbasiertem Audit]],
  [#strong[Wie vermieden durch digitalen Rundgang]],
  [Verlust von Daten],
  [Checkliste geht verloren, wird nass, vergessen],
  [Daten werden sofort in die ERP-Datenbank (via MQTT) und in ThingWorx
  (Cloud) gespiegelt; doppelte Datenhaltung.],
  [Verzögerte Verfügbarkeit],
  [Daten werden Tage später abgetippt; bis dahin nicht für andere
Abteilungen sichtbar],
  [Daten stehen in Echtzeit dem ERP und damit allen relevanten Abteilungen zur
  Verfügung],
  [Inkonsistenz / Tippfehler],
  [Daten werden manuell abgetippt - Fehlerquelle.],
  [Direkte digitale Erfassung am Tablet, keine Transkription.
  Validierung durch Workflow-Regeln.],
  [Fehlende Nachvollziehbarkeit],
  [Wer hat wann was geprüft? Auf Papier oft unklar.],
  [Jedes Finding hat Zeitstempel, Auditor-ID und Audit-Trail in
  ThingWorx.],
  [Keine Themenübergreifung],
  [Safety- und Security-Audits liegen in getrennten Ordnern.],
  [Themenübergreifende Auswertung in ThingWorx],
  [Compliance-Risiko],
  [Prüfnachweise für Behörden (Seveso III) sind mühsam
  zusammenzustellen.],
  [Audit-Trail in ThingWorx ist jederzeit elektronisch abrufbar und
  exportierbar.],
  [Vergessene Korrekturmaßnahmen],
  [Befund auf Papier wird nicht weiterverfolgt.],
  [Workflow-Engine in testify weist Befunde dem Auditee zu und eskaliert
  bei Fristüberschreitung.],
)
]

#pagebreak()

=== 2.3.2 Weitere Nutzenpotenziale
- Datengetriebene Optimierung: Auswertung häufiger Befunde führt zu
  präventiven Maßnahmen.

- Wissenstransfer: Neue Auditor:innen sehen historische Befunde und
  lernen schneller.
  


- Skalierbarkeit: Die Lösung kann auf andere LDPE-Standorte der
  ChemoDemo AG ausgerollt werden, ohne dass dort lokale Infrastruktur
  aufgebaut werden muss.

- Integration weiterer Datenquellen: MQTT erlaubt es, in Zukunft weitere
  Datenquellen (z. B. mobile Schwingungssensoren, Drohnen-Inspektionen)
  anzubinden.

= 3. Vorstellung der Produkte 


== 3.1 ThingWorx
ThingWorx ist die Industrial-IoT- und Smart-Manufacturing-Plattform der
US-Firma PTC (Parametric Technology Corporation, Hauptsitz Boston). ThingWorx ist die
IIoT-Schiene des Unternehmens.

=== 3.1.1 Kernfunktionen relevant für den digitalen Rundgang
- 
  *Composer und Mashup-Builder:* grafische Modellierungs- und
  Visualisierungsumgebung. Workflows, Verbindungen und Dashboards werden
  ohne Coding aufgebaut.

- *Thing-Modell:* jedes Asset (Anlage, Reaktor, Tablet, Auditor) wird als
  „Thing“ angelegt mit Properties, Services, Events und Subscriptions.

- *Konnektoren:* ThingWorx bringt Konnektoren für OPC UA, MQTT, REST, SQL
  und SAP mit. Damit ist die ERP-Anbindung (SAP/Oracle) ohne
  Eigenentwicklung möglich.
  

- *Integrierter MQTT-Broker:* ThingWorx stellt einen produktiven
  MQTT-Broker bereit. Damit entfällt die Notwendigkeit, einen eigenen
  Broker zu betreiben.
  
- *Identity Provider:* ThingWorx unterstützt SAML 2.0, OAuth2/OpenID
  Connect und LDAP. Dies erlaubt eine Anbindung an den
  Microsoft-Azure-AD-Tenant der ChemoDemo AG.
  

- *Bereitstellungsformen:* ThingWorx kann on-premise, in einer privaten
  Cloud oder als SaaS in Microsoft Azure betrieben werden. In unserem Fall ist Azure-SaaS vorgegeben.
#pagebreak()
  
=== 3.1.2 Einordnung im Industrie-4.0-Kontext

ThingWorx folgt den Architekturmuster einer IIoT-Plattform:
interne Schnittstellen zu CPS-Geräten, externe Schnittstellen zu
Anwendungen über API/Gateway, Applikations- und Service-Layer.

#align(center)[#table(
  columns: 1,
  align: (col, row) => (auto,).at(col),
  inset: 6pt,
  [#strong[ThingWorx bei der ChemoDemo:]

  - Hosting in Microsoft Azure

  - Datenresidenz: Azure-Regionen West Europe oder Germany West Central
  (DSGVO)

  - Bereitstellungsmodell: SaaS (Verantwortung des Cloud-Anbieters für
  Plattformbetrieb)

  - Lizenzmodell: jährliches Subscription-Modell über PTC oder Partner

  - Vertraglich abgesichert: Datenexport, Exit-Klausel, SLA,
  Datenresidenz-Klausel (BSI C5 PI-02, PI-03)

  ],
)
]

== 3.2 Testify

Testify ist eine flexible Checklisten-Software für mobile
Qualitätsprozesse. Entwickelt wird sie vom
österreichischen Anbieter testify GmbH, und sie zielt genau auf den
Industrie-4.0-Fall ab, um den es hier geht: mobile Audits, Rundgänge,
Wartungsprozesse.

=== 3.2.1 Kernfunktionen relevant für den digitalen Rundgang

- *Mobile Apps:* native iOS- und Android-Apps für Tablet und Smartphone.

- *Workflow-Designer:* grafische Konfiguration der Audit-Workflows durch
  den Administrator. Prüfpunkte, Pflichtfelder, Eskalationsregeln,
  Foto-Aufnahmen, Unterschriften.

- *Offline-Fähigkeit:* Audits werden lokal auf dem Tablet gespeichert und
  beim Wiederverbinden mit dem Netz an die Cloud (ThingWorx)
  übertragen.

- *Rollenmodell:* Administrator, Auditor, Auditee als Standardrollen.
  
- *Historische Daten:* Die App zeigt vorherige Befunde am gleichen Asset
  und thematisch verwandte Audits.


- *MQTT-Anbindung:* testify fungiert als MQTT-Client; publiziert Findings
  und subscribiert Workflow-Updates.
  
=== 3.2.2 Einordnung in den digitalen Rundgang

Testify ist die Anwendungsschicht, die der Auditor direkt vor Ort
bedient. Aus Sicht der RAMI-4.0-Layer ist testify im *Functional Layer*
(Funktion „*Audit durchführen*“), *Information Layer* (Datenmodell
„*Audit-Finding*“) und *Business Layer* (Geschäftsprozess „*Safety-Audit*“)
verankert. Die Verbindung zur Communication-Schicht erfolgt über MQTT
(zu ThingWorx) und WPA3-Enterprise (zum WLAN-Access-Point).

#align(center)[#table(
  columns: 1,
  align: (col, row) => (auto,).at(col),
  inset: 6pt,
  [#strong[testify bei der ChemoDemo:]

  - Installation: native App auf den Audit-Tablets (iOS oder Android)

  - Lizenzmodell: SaaS, monatliche Subscription pro Nutzer

  - Identity Provider: Anbindung an Azure AD via SAML/OAuth2

  - Datenhaltung: Workflow-Definitionen in testify Cloud + ThingWorx;
  Findings primär in ThingWorx

  - Mobile Device Management(MDM): Verwaltung der Tablets über Microsoft
  Intune

  ],
)
]

= 4. Architektur Entscheidungen
Bevor wir Komponenten und
Datenflüsse im Detail beschreiben, fasst dieses Kapitel die zentralen
Architektur-Entscheidungen zusammen.

#align(center)[#table(
  columns: 2,
  align: (col, row) => (auto,auto,).at(col),
  inset: 6pt,
  [#strong[Entscheidung]], [#strong[Begründung]],

  [WLAN-Anbindung der Tablets als eigene IIoT Zone],
  [Tablets dürfen nicht ins OT. Eine dedizierte IIoT Zone trennt den
  Tablet-Verkehr klar von Office und Operations Management. Der Übergang
  zur restlichen Infrastruktur erfolgt über den WLAN-AP
  und die bestehenden Firewalls (FW2, Internet Firewall).],

  [Edge Gateway in der IIoT Zone],
  [Lokale Aggregations- und Pufferinstanz für die Tablets. Übernimmt
  Offline-Buffering, Geräte-Management und ist erster Sicherheits-
  Kontrollpunkt zwischen Tablet und Werksnetz. Erlaubt zentrales Logging
  aller Tablet-Aktivitäten am Edge.],

  [Cloud Gateway in der DMZ],
  [Zentraler ausgehender Gateway für Cloud-Verkehr. Bündelt alle
  Verbindungen Richtung Azure (ThingWorx, Key Vault) an einer Stelle,
  ermöglicht TLS-Inspektion, Filtering und vereinfacht das
  Firewall-Regelwerk auf der Internet Firewall.],

  [MQTT-Broker in Microsoft Azure als Teil von ThingWorx],
  [Entspricht dem ThingWorx-Standard-Setup. Vereinfacht die Architektur
  (kein on-premise Broker).],

  [ERP als Subscriber, kein direkter Schreibzugriff von außen],
  [ERP zieht Daten aktiv über MQTT-Subscribe ein. Kein externer Pfad
  schreibt direkt ins ERP.],

  [Kein direkter Tablet-Zugriff auf OT],
  [Tablets greifen nur auf ThingWorx (Cloud) und über MQTT auf
  ERP-Daten zu.],

  [Cloud-Provider: Microsoft Azure],
  [Datenresidenz: Azure West Europe / Germany West Central
  (DSGVO Art. 44).],

  [Authentisierung auf Tablet: OAuth2 + MFA],
  [Stand der Technik. Rollen-/Rechteverwaltung über zentralen Identity
  Provider (Azure AD).],

  [Verschlüsselung Tablet -\> Cloud: TLS 1.3 für HTTPS und MQTT (MQTTS, Port 8883)],
  [Stand der Technik nach BSI TR-02102. Plaintext-MQTT (Port 1883) ist
  nicht erlaubt.],

  [WLAN-Sicherheit: WPA3-Enterprise mit EAP-TLS],
  [Strongest currently available. Jedes Tablet hat eigenes
  Client-Zertifikat.],

  [PKI: Zentrale Sub-CA auf DC1; Azure Key Vault HSM für Cloud-Schlüssel],
  [Re-Use der bestehenden Windows-PKI.],

  
)
]

= 5. Logischer Netzwerkplan (erweitert)

Abbildung 1 zeigt die IIoT-Architektur. Bestehende Komponenten
(Internet, DMZ ohne Cloud Gateway, Office, Operations Management, OT,
Safety-Zone, Feldebene) sind unverändert. Neu hinzugekommen sind die
IIoT Zone (mit Edge Gateway und Tablets), der WLAN-Access-Point, das
Cloud Gateway in der DMZ sowie die externe Microsoft Azure Cloud mit
ThingWorx, MQTT-Broker und Azure Key Vault.

#align(center)[
  #box(width: 120%, image("./res/Netzplan2.drawio.png", width: 100%))
  *Abbildung 1*: Netzplan erweitert
]

== 5.1 Zonen-Übersicht

Die IIoT-Architektur erweitert die 5 Zonen plus Safety-Zone des
Ausgangs-IACS um eine neue IIoT Zone, ein Cloud Gateway in der
bestehenden DMZ sowie um die externe Microsoft Azure Cloud.

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Zone]], [#strong[Bestehend / Neu]], [#strong[Funktion]],
  [Internet / WAN],
  [bestehend],
  [Externer Datenverkehr, Sitz des Remote-Service-Providers],
  [DMZ (erweitert)],
  [bestehend, erweitert um Cloud Gateway],
  [RAS-Server S0, Cloud Gateway (NEU) als zentraler Egress-Punkt zur Azure Cloud],
  [IIoT Zone],
  [NEU],
  [Edge Gateway + Auditor-Tablets. Eigene Zone für mobile Endgeräte, getrennt vom Office],
  [WLAN-Access-Point],
  [NEU],
  [Drahtloser Zugangspunkt (WPA3-Enterprise) als Bindeglied zwischen IIoT Zone und Werksnetz],
  [Office-Netzwerk],
  [bestehend (erweitert)],
  [Büro-IT; ERP-Server wird um den ThingWorx-Client (MQTT-Adapter) erweitert],
  [Operations Management],
  [bestehend],
  [MIS, Historian, Jump Server, AV/WSUS (unverändert)],
  [OT-Netzwerk (TB1+TB2)],
  [bestehend],
  [Steuerung und Anlagenbus (unverändert; KEIN Zugriff durch Mobile Zone)],
  [Feldebene (Safety-Zone)],
  [bestehend],
  [SIS nach IEC 61511 mit Safety Firewall (unverändert)],
  [Microsoft Azure Cloud],
  [NEU (extern)],
  [ThingWorx + MQTT-Broker + Azure Key Vault. Datenresidenz EU],
)
]

= 6. Neue Komponenten (Asset-Inventar Erweiterung)

Die folgende Tabelle listet die neuen Assets, die mit der
IIoT-Erweiterung hinzukommen. 

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Komponente]], [#strong[Typ]],
  [#strong[Zone]],

  [Tablet Auditor],
  [Mobiles Endgerät (iOS/Android, testify-App)],
  [IIoT Zone],
  [Edge Gateway],
  [Lokales Gateway (Aggregation, Buffering, Geräte-Management)],
  [IIoT Zone],
  [WLAN-Access-Point],
  [WLAN-AP, WPA3-Enterprise, MAC-Filter],
  [Bindeglied IIoT Zone -\> Werksnetz],
  [Cloud Gateway],
  [Gateway für ausgehenden Cloud-Verkehr (TLS-Inspektion, Filtering)],
  [DMZ],
  [ThingWorx-Plattform],
  [IIoT-Plattform PTC (SaaS in Azure)],
  [Microsoft Azure Cloud],
  [MQTT-Broker],
  [Pub/Sub-Broker (Teil von ThingWorx)],
  [Microsoft Azure Cloud],
  [Azure Key Vault],
  [HSM + BYOK für Cloud-Schlüsselverwaltung],
  [Microsoft Azure Cloud],
  [Microsoft Azure (Hosting)],
  [Public-Cloud-Anbieter],
  [extern],
  [ThingWorx Client (ERP-MQTT-Adapter)],
  [MQTT-Subscriber-Erweiterung am ERP-Server],
  [Office-Netzwerk],
  [Rollen Administrator / Auditor / Auditee],
  [Rollen in testify / ThingWorx / Azure AD],
  [übergreifend],
  [Audit-Daten (Findings, Bilder, Workflows)],
  [Daten in Cloud und ERP],
  [verteilt],
  [Kommunikation IIoT (TLS/MQTT)],
  [Datenflüsse Tablet -\> Edge GW -\> WLAN-AP -\> FW2 -\> Cloud GW -\> Internet -\> Azure],
  [übergreifend],
  [Change Mgmt / Security Incident Mgmt],
  [Prozess-Asset],
  [übergreifend],
)
]

== 6.1 Erläuterung der wichtigsten neuen Komponenten

=== 6.1.1 Tablet Auditor

Industrie-Tablet (z. B. iPad Pro oder Samsung Galaxy Tab Active5),
gemanagt über Microsoft Intune. Gerät ist verschlüsselt (FileVault /
iOS Data Protection), hat Pflicht-Sperrcode mit Biometrie und ist nur
über das WLAN der IIoT Zone verbindungsfähig. Auf dem Tablet läuft
ausschließlich testify-App plus System-Apps (App-Whitelist via Intune).
Client-Zertifikat für WLAN (EAP-TLS) und ThingWorx (OAuth2 mit
Geräte-Bindung) ist via SCEP-Auto-Enrollment ausgerollt.

=== 6.1.2 Edge Gateway

Lokales Gateway in der IIoT Zone (z. B. ThingWorx EMS - Edge MicroServer
oder vergleichbares industrielles Edge-Device). Übernimmt drei zentrale
Funktionen: erstens lokales Buffering der Audit-Findings, wenn die Tablets
offline arbeiten oder die WLAN-Verbindung kurzzeitig unterbrochen ist;
zweitens lokales Geräte-Management (Health-Check der Tablets, lokale
Aggregation von Status-Informationen); drittens erste Sicherheits-
Kontrolle zwischen den Tablets und dem restlichen Werksnetz (lokales
Logging aller ausgehenden Verbindungen, optional zusätzliche Authentisierung).
Der Edge Gateway ist die einzige Komponente in der IIoT Zone, die nach
außen kommuniziert; die Tablets selbst sprechen nur mit dem Edge Gateway.

=== 6.1.3 WLAN-Access-Point

Industrieller Access-Point (z. B. Cisco Aironet IW6300 für raue
Umgebungen). WPA3-Enterprise mit EAP-TLS als einziger erlaubter Modus.
Authentisierung gegen den ChemoDemo-RADIUS-Server (NPS, auf dem
bestehenden DC1). MAC-Filter als zweite Schicht. SSID ist nicht
versteckt, aber durch starke Authentisierung geschützt. Wireless IDS
aktiv. Der WLAN-AP ist die drahtlose Brücke zwischen IIoT Zone
(Edge Gateway) und der externen Firewall FW2.

=== 6.1.4 Cloud Gateway

Dediziertes Gateway in der DMZ für sämtlichen ausgehenden
Verkehr zur Microsoft Azure Cloud. Bündelt alle Cloud-Verbindungen
(ThingWorx, Azure Key Vault, ggf. zukünftige Cloud-Dienste) an einer
einzigen, kontrollierten Stelle. Funktionen: TLS-Inspektion (optional,
für Verkehr, der nicht End-to-End-verschlüsselt sein muss),
Filtering (Whitelist erlaubter Ziel-IPs), Verbindungs-Logging an das zentrale SIEM. Vereinfacht
das Regelwerk der Internet Firewall, weil dort nur noch ein einziger
ausgehender Endpunkt (das Cloud Gateway) freigegeben werden muss.

=== 6.1.5 ThingWorx-Plattform und MQTT-Broker

ThingWorx wird als SaaS in Microsoft Azure betrieben. Die Plattform
stellt einen integrierten MQTT-Broker zur Verfügung. Sowohl ThingWorx
als auch der Broker laufen in derselben Azure-Subscription der
ChemoDemo AG, mit Datenresidenz EU. Verschlüsselung at-rest mit
AES-256, Schlüsselverwaltung über Azure Key Vault HSM (BYOK).


=== 6.1.6 ThingWorx Client / ERP-MQTT-Adapter

Erweiterung des bestehenden ERP-Servers
um eine MQTT-Subscriber-Komponente (im Netzplan als "Thingworx Client
(MQTT Adapter)" neben dem ERP-Server dargestellt). Diese läuft als
separater Prozess unter Service-Account-Identität, mit minimaler
Schreibberechtigung auf die ERP-Datenbank (nur die Tabellen, die mit
Audit-Findings zu tun haben). Failsafe bei MQTT-Störung: Bei
Verbindungsabbruch werden Nachrichten in der ThingWorx-Persistenz
gepuffert; der Adapter holt sie nach Wiederherstellung nach.

= 7. Neue Kommunikationsmatrix (Datenflüsse Digitaler Rundgang)

Die folgende Matrix erweitert die Kommunikationsmatrix aus Schritt 2
um die neuen Datenflüsse des Digitalen Rundgangs. Die bestehenden
Datenflüsse aus Schritt 2 bleiben unverändert.

#align(center)[#table(
  columns: 4,
  align: (col, row) => (auto,auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Initiator -\> Akzeptor]],
  [#strong[Protokoll]], [#strong[Authentisierung]],
  [#strong[Verschlüsselung]],

  [Tablet (testify) -\> Edge Gateway],
  [Lokales LAN/WLAN in IIoT Zone],
  [Geräte-Zertifikat + Service-Account],
  [TLS 1.3 (lokal)],

  [Edge Gateway -\> WLAN-Access-Point],
  [WPA3-Enterprise (802.11ac/ax)],
  [EAP-TLS (Client-Zert.) + MAC-Filter],
  [WPA3-AES (CCMP-256)],

  [WLAN-AP -\> external Firewall FW2],
  [Ethernet im VLAN; TLS-Tunnel von Edge Gateway bis Cloud durchgereicht],
  [VLAN-Tagging + 802.1X],
  [Tunnel TLS 1.3],

  [External Firewall FW2 -\> Cloud Gateway (in DMZ)],
  [HTTPS / MQTTS (Port 443, 8883)],
  [Service-Account des Cloud Gateways],
  [TLS 1.3],

  [Cloud Gateway -\> Internet Firewall -\> Internet -\> Azure ThingWorx],
  [HTTPS / MQTTS (Port 8883)],
  [OAuth2 + MFA für User; Client-Zert. für Gerät],
  [TLS 1.3 (BSI TR-02102)],

  [ThingWorx \<-\> MQTT-Broker],
  [Plattform-interne API (in Azure-Subscription)],
  [Plattform-Service-Account],
  [Plattform-intern],

  [ThingWorx \<-\> Azure Key Vault],
  [Azure REST-API (HTTPS)],
  [Managed Identity der ThingWorx-Instanz],
  [TLS 1.3],

  [testify (Tablet, im Tunnel) -\> MQTT-Broker (Publish)],
  [MQTT v5 (over TLS)],
  [OAuth2-Service-Account; ACL pro Topic],
  [TLS 1.3],

  [MQTT-Broker -\> ThingWorx Client(Subscribe)],
  [MQTT v5 (over TLS)],
  [OAuth2-Service-Account; ACL pro Topic],
  [TLS 1.3],
)
]


== 7.1 Topic-Struktur MQTT

Die MQTT-Topics folgen einer hierarchischen Struktur, die über
Wildcard-Subscriptions auswertbar ist:

- *ldpe/audit/safety/finding/\<finding-uuid\>* - Befund eines
  Safety-Audits

- *ldpe/audit/quality/finding/\<finding-uuid\>* - Befund eines
  Quality-Audits

- *ldpe/audit/security/finding/\<finding-uuid\>* - Befund eines
  Security-Audits

- *ldpe/audit/\<thema\>/workflow/\<workflow-id\>* - aktualisierter
  Workflow

- *ldpe/asset/\<asset-id\>/audit-status* - aktueller Audit-Status pro
  Anlagen-Asset

*Beispiel*: Der ThingWorx Client am ERP-Server abonniert
„ldpe/audit/+/finding/\#" und erhält damit alle Findings aller
Audit-Themen. Ein Spezial-Service für Safety-Auswertung abonniert
nur „ldpe/audit/safety/finding/\#".

= 8. Neue Protokolle und Mechanismen

== 8.1 MQTT (Message Queuing Telemetry Transport)

MQTT ist ein leichtgewichtiges *Publish/Subscribe-Protokoll* und in der
IIoT-Welt entsprechend verbreitet. Es läuft über TCP/IP. Die
Standard-Ports sind 1883 für Klartext und 8883 für MQTTS, also MQTT
over TLS. Bei ChemoDemo lassen wir nur MQTTS zu.

=== 8.1.1 Kerneigenschaften

- *Topic-basierte Adressierung*: jeder Datenstrom hat ein Topic (siehe
  Kapitel 7.1).

- *Publisher* (testify auf Tablet) sendet Nachrichten an den Broker.


- *Subscriber* (ERP, weitere Audit-Services) registrieren sich am Broker
  für Topics.

- *Quality of Service Levels*: QoS 0 (at most once), QoS 1 (at least
  once), QoS 2 (exactly once). Für Audit-Findings wird QoS 2 verwendet.


- *Retained Messages*: Persistenz beim Broker; neuer Subscriber erhält
  letzte Nachricht.

- *Last Will and Testament*: jedes Tablet definiert eine LWT-Nachricht.

=== 8.1.2 MQTT-Sicherheitsmechanismen in unserer Architektur

- *Transport-Verschlüsselung:* ausschließlich MQTTS auf Port 8883 mit
  TLS 1.3, Cipher-Suites nach BSI TR-02102.

- *Authentisierung*: OAuth2 mit Client-Credentials-Flow für
  Service-Accounts. Kein anonymer MQTT-Connect erlaubt.


- *Topic-ACL*: testify darf nur „ldpe/audit/+/finding/+“ publishen.
  ERP-Adapter darf nur „ldpe/audit/\#“ subscriben.

- *Replay-Schutz*: UUID + Timestamp im MQTT-v5-User-Property-Header.
  Duplikate werden abgelehnt (24h-Fenster).

- *Logging*: Jeder Connect, Publish, Subscribe wird geloggt und ans SIEM
  weitergeleitet.

== 8.2 WLAN-Sicherheit (WPA3-Enterprise)

Das WLAN für die Audit-Tablets nutzt WPA3-Enterprise mit EAP-TLS:

- Jedes Tablet hat ein eigenes Client-Zertifikat, ausgestellt von der
  ChemoDemo-CA.

- Der WLAN Access Point gibt die Zertifikatsprüfung an den
  RADIUS-Server (NPS auf DC1) weiter.

- WPA3-AES (CCMP-256) verschlüsselt den Funkverkehr.


- Zusätzlich MAC-Filter: nur registrierte Tablet-MAC-Adressen
  zugelassen.
  
- Wireless IDS detektiert Rogue Access Points und
  Deauthentication-Angriffe.

== 8.3 TLS 1.3 nach BSI TR-02102

Alle externen Verbindungen sind mit TLS 1.3 verschlüsselt,
Konfiguration nach BSI TR-02102-2:

- Mindestens TLS 1.3; TLS 1.2 nur als dokumentierter Legacy-Fallback.

- Cipher-Suites:TLS_AES\_256\_GCM\_SHA384,
  TLS\_CHACHA20\_POLY1305\_SHA256, TLS\_AES\_128\_GCM\_SHA256.

- Heartbeat-Extension deaktiviert (Heartbleed-Mitigation).

- Compression deaktiviert (CRIME-Mitigation).

-  Insecure Renegotiation deaktiviert.


- HTTP Strict Transport Security (HSTS, max-age \>\= 1 Jahr) für
  ThingWorx-Frontend.


== 8.4 OAuth2 / OpenID Connect
Authentisierung von Auditor:innen und Service-Accounts über OAuth2 mit
OpenID Connect. Identity Provider ist Microsoft Azure AD (Entra ID).

- Authorization-Code-Flow für User: Login über
  Azure-AD-Browserfenster, MFA via App oder FIDO2.

- Client-Credentials-Flow für Service-Accounts: Geräte-Zertifikat plus
  Service-Account-Token.

- Access-Tokens haben Lebenszeit \< 1 Stunde. Refresh-Tokens nur für
  registrierte Tablets.

- Token-Revocation möglich (z. B. bei Geräteverlust): wirksam binnen 5
  Minuten.

- Scopes auf Operationen: „audit.read“, „audit.write“, „workflow.admin“.

== 8.5 Public Key Infrastructure und Schlüsselverwaltung
Fast jeder Sicherheitsmechanismus in dieser Architektur hängt letztlich
an der PKI. Wir bauen nicht neu, sondern nutzen die vorhandene
Microsoft-PKI von ChemoDemo weiter und ergänzen sie nur um die
Cloud-Komponenten.

=== 8.5.1 PKI-Architektur
#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Komponente]], [#strong[Standort]], [#strong[Zweck]],
  [Root CA (Offline)],
  [ChemoDemo-Rechenzentrum (offline)],
  [Wurzel der PKI. Wird nur für Zertifikat-Erstellung der Sub-CA
  verwendet.],
  [Sub-CA / Issuing CA],
  [Domain Controller DC1 (OpsMgmt)],
  [Aktive CA. Stellt alle Endgeraete- und Service-Zertifikate aus.
  Auto-Enrollment via SCEP.],
  [RADIUS / NPS-Server],
  [Auf DC1],
  [Validiert die Tablet-Zertifikate beim WLAN-Verbindungsaufbau.],
  [Azure Key Vault HSM],
  [Microsoft Azure (EU-Region)],
  [BYOK für ThingWorx und MQTT-Broker (BSI C5 CRY-04).],
  [MDM (Microsoft Intune)],
  [Microsoft 365 Tenant],
  [Verteilt Client-Zertifikate via SCEP an Tablets.],
)
]

=== 8.5.2 Zertifikat-Typen

- Geräte-Zertifikat (WLAN-EAP-TLS): X.509-Zertifikat pro Tablet.
  Lebensdauer 1 Jahr, automatische Erneuerung 30 Tage vor Ablauf.

- Service-Account-Zertifikat (MQTT / ThingWorx): Lebensdauer 90 Tage.

- Server-Zertifikate (WLAN-AP, ThingWorx-Frontend): klassisch, mit
  OCSP-Stapling.

- Benutzer-Token (OAuth2): kurzlebige JWT-Tokens \< 1 h, signiert vom
  Azure-AD-Tenant.

=== 8.5.3 Schlüssel-Lebenszyklus (nach BSI C5 CRY-04)
- *Schlüsselgenerierung in HSM* (Azure Key Vault Premium) bzw. Secure
  Enclave/TPM. Schlüssel verlassen die Hardware nie im Klartext.

- *Rotation:* API-Keys alle 90 Tage; TLS-Zertifikate automatisch vor
  Ablauf.

- *Revocation:* CRL. Bei Geräteverlust binnen 5
  Minuten wirksam.

- *Löschung:* Azure Key Vault Soft-Delete + Purge (30-Tage-Frist).

= 9. Industrie-4.0-Eigenschaften der Lösung

== 9.1 Horizontale und vertikale Integration

=== 9.1.1 Definitionen

#align(center)[#table(
  columns: 1,
  align: (col, row) => (auto,).at(col),
  inset: 6pt,
  [#strong[Vertikale Integration]

  Integration der verschiedenen IT-Systeme auf den unterschiedlichen
  Hierarchieebenen

  (Aktor-/Sensorebene, Steuerungsebene, Produktionsleitebene, MES-Ebene,

  Unternehmens- und Planungsebene) zu einer durchgängigen Lösung.

  ],
)
]

#align(center)[#table(
  columns: 1,
  align: (col, row) => (auto,).at(col),
  inset: 6pt,
  [#strong[Horizontale Integration]

  Integration der verschiedenen IT-Systeme für die unterschiedlichen
  Prozessschritte der Produktion und Unternehmensplanung, zwischen denen ein Material-,
  Energie- und Informationsfluss verläuft - sowohl innerhalb eines Unternehmens als
  auch über mehrere Unternehmen (Wertschöpfungsnetzwerke) hinweg.

  ],
)
]

=== 9.1.2 Vertikale Integration im digitalen Rundgang
Der digitale Rundgang realisiert eine durchgängige vertikale
Integration über alle Ebenen:

#align(center)[#table(
  columns: 2,
  align: (col, row) => (auto,auto,).at(col),
  inset: 6pt,
  [#strong[Hierarchieebene (ISA-95)]], [#strong[Komponente im digitalen
  Rundgang]],
  [Field Device],
  [Sensoren/Aktoren werden während des Rundgangs begutachtet. Findings
  beziehen sich auf konkrete Geräte.],
  [Control Device],
  [Audit-Findings können Konfigurations-Prüfungen der TI-PLC und
  Safety-SPS umfassen.],
  [Station],
  [Die Operator-Station OS1 kann selbst Audit-Gegenstand sein.],
  [Work Centers],
  [Die gesamte LDPE-Anlage ist Gegenstand des Rundgangs.],
  [Enterprise],
  [Audit-Findings fließen über MQTT-Subscriber in das ERP.],
  [Connected World],
  [ThingWorx in Azure aggregiert alle Daten und ermöglicht
  Cross-Site-Auswertungen.],
)
]

Damit ist die vertikale Integration vom Field Device bis zur Connected
World vollständig realisiert.

=== 9.1.3 Horizontale Integration im digitalen Rundgang

Die horizontale Integration zeigt sich auf zwei Ebenen:

- #strong[Innerbetrieblich:] Audit-Daten gehen vom Auditor (Operations)
  über ThingWorx an das ERP. Dort sind sie für Einkauf, Instandhaltung
  und Compliance verfügbar.
  

- #strong[Überbetrieblich:] ThingWorx wird von PTC in Microsoft Azure
  betrieben - zwei Drittparteien sind in den Daten- und
  Wertschöpfungsfluss eingebunden. Externe Service-Provider können via
  ThingWorx-API auf Audit-Findings zugreifen.
  

== 9.2 Offene und globale Informationsplattformen

=== 9.2.1 Was bedeutet hier „offen“?

„Offen“ ist mehrdeutig. Es lassen sich drei Bedeutungen unterscheiden:

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Bedeutung]], [#strong[Erklärung]], [#strong[Trifft auf
  unsere Architektur zu?]],
  [Offene Standards / Protokolle],
  [Spezifikation öffentlich, herstellerunabhängig.],
  [Ja: MQTT (OASIS-Standard), HTTPS, TLS 1.3, OAuth2/OIDC, WPA3,
  X.509.],
  [Offene API / Konnektoren],
  [Anbindung beliebiger Datenquellen ohne Hersteller-Lock-in.],
  [Teilweise: ThingWorx-Composer erlaubt unabhängige Konnektoren,
  Plattform selbst ist proprietär (PTC).],
  [Offen verfügbar für Dritte],
  [Andere Stakeholder können zugreifen.],
  [Bewusst eingeschränkt: Zugriff nur authentisiert/autorisiert (OAuth2 + RBAC).],
)
]

=== 9.2.2 Was bedeutet hier „global“?

„Global“ meint in diesem Kontext: über das Internet erreichbar, nicht
auf das lokale Werksnetz beschränkt. ThingWorx in Microsoft Azure ist
in diesem Sinne global, jedes ChemoDemo-Werk weltweit kann zugreifen.
Die Datenresidenz bleibt aber auf EU-Regionen begrenzt (DSGVO Art. 44).
„Global verfügbar“ heißt hier also „weltweit zugreifbar“, nicht
„weltweit gespeichert“.

=== 9.2.3 Konkrete Plattform

Die offene, globale Informationsplattform ist ThingWorx auf Microsoft
Azure. Sie erfüllt:

-  Internet-erreichbar (global)

- Verwendet offene Protokolle (MQTT, HTTPS, OAuth2)


- Bietet offene API (REST, MQTT) für Anbindung neuer Datenquellen


- Bietet Konnektor-Modell ohne Coding (Composer)

#pagebreak()
  

== 9.3 Offen verfügbare Daten und Dienste

=== 9.3.1 Welche Daten?

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Datenart]], [#strong[Quelle]], [#strong[Wer kann
  zugreifen?]],
  [Audit Findings (alle Themen)],
  [testify -\> ThingWorx],
  [ERP, Audit-Services, Auditor:innen, zugewiesene Auditees],
  [Workflow Definitionen],
  [testify (Administrator)],
  [Auditor:innen (Lesen), Admin (Schreiben)],
  [Historische Audits (Archiv)],
  [ThingWorx-Persistenz],
  [Auditor:innen, Management],
  [Anlagen-Stammdaten],
  [ERP -\> ThingWorx],
  [Auditor:innen (Lesen)],
  [Audit-Schemen (Prüfpunkte)],
  [testify (Administrator)],
  [Auditor:innen während Rundgang],
)
]

=== 9.3.2 Welche Dienste?

- Workflow-Engine in testify

- MQTT-Broker in ThingWorx

- Datenpersistenz in ThingWorx

- REST-API für weitere Anbindungen

- Identity-Service (Azure AD)

- Notification-Service bei Eskalationen
  
=== 9.3.3 Was bedeutet „offen“ bei Diensten?

Die Dienste sind „offen“ im Sinne von:

-  Offene API-Schnittstelle (REST mit OpenAPI-Spec, MQTT mit
  standardkonformer Topic-Struktur)
  
- Aufruf ohne hersteller-spezifischen Client möglich


- Aber *NICHT* „offen für jedermann“ - Zugriff ist authentisiert und
  autorisiert (OAuth2 + RBAC).


== 9.4 Überschrittene Grenzen

CPS-basierte Automatisierungssysteme sind unter anderem definiert dadurch, dass sie „herkömmliche System-, Organisations- und Domänengrenzen überschreiten“. Wir machen konkret, welche Grenzen unser digitaler Rundgang überschreitet.

#pagebreak()
#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Grenze]], [#strong[Vor der Einführung]], [#strong[Nach der
  Einführung]],
  [System-Grenze],
  [ERP, MIS, Operator Station, Historian - alles separate Systeme.
  Audits auf Papier außerhalb.],
  [ThingWorx als zentrale Aggregations-Plattform verbindet ERP-, MIS-,
  Historian- und Audit-Daten.],
  [Organisations-Grenze],
  [Auditor erstellt Befunde; Einkauf, Wartung, Compliance bekommen sie
  verspätet auf Papier.],
  [Findings sind sofort für Einkauf, Wartung, Compliance und Management
  sichtbar.],
  [Domänen-Grenze],
  [Safety, Quality, Security in getrennten Themen-Silos.],
  [Themenübergreifende Auswertung in ThingWorx. Security-Finding kann
  verwandtes Safety-Finding triggern.],
  [Unternehmensgrenze],
  [ChemoDemo-Daten strikt im Werksnetz.],
  [Daten gehen zu PTC und Microsoft. Cloud-Provider werden Teil der
  Wertschöpfungskette.],
  [Geographische Grenze],
  [Standort München separat, andere ChemoDemo-Werke isoliert.],
  [ThingWorx ist von allen Werken weltweit erreichbar.
  Cross-Site-Auswertungen möglich.],
  [IT/OT-Grenze],
  [OT-Daten strikt vom Business-IT getrennt.],
  [Audit-Daten überschreiten die IT/OT-Grenze bewusst und kontrolliert
  (über ThingWorx und ERP-Adapter).],
)
]

#align(center)[#table(
  columns: 1,
  align: (col, row) => (auto,).at(col),
  inset: 6pt,
  [#strong[Sicherheitsrelevante Konsequenz]

  Jede überschrittene Grenze erweitert die Angriffsfläche.
  Unternehmens- und IT/OT-Grenzen sind klassische Hochrisikobereiche. Die Risikoanalyse behandelt diese Grenzüberschreitungen mit eigenen Gefährdungs-IDs.

  ],
)
]

== 9.5 Adaptivität, Selbstmodifikation und dynamische Änderung

CPS-basierte Systeme weisen die Fähigkeit zur zielorientierten Adaptivität und
Selbstmodifikation auf und ihre heterogene Zusammensetzung und Struktur ändert sich während der Betriebszeit dynamisch.

#pagebreak()


=== 9.5.1 Dynamische Änderung während der Betriebszeit

- Neue Audit-Workflows werden vom Administrator zur Laufzeit in testify
  konfiguriert.
  

- Neue MQTT-Topics werden zur Laufzeit angelegt; ACLs ohne
  Broker-Neustart aktualisiert.
  

-  Neue Auditor:innen werden im Azure AD freigeschaltet; OAuth2-Token
  wirken sofort.
  

-  Neue Datenquellen (z. B. Schwingungssensor) können über MQTT
  angeschloßen werden, ohne bestehende Komponenten zu ändern.
  

-  Neue Subscriber können sich am Broker anmelden, ohne
  dass Publisher davon wissen müssen - Kernstärke des Pub/Sub-Musters.
  

=== 9.5.2 Adaptivität

Adaptivität heißt hier schlicht: Das System reagiert, wenn sich
Bedingungen oder Aufgaben ändern.

-  testify-Workflows adaptieren sich anhand der Findings-Historie: Bei
  wiederholtem Druckproblem in einem Reaktor wird automatisch ein
  zusätzlicher Prüfpunkt eingeblendet.
  

- ThingWorx unterstützt Triggers und Subscriptions: Befund „Safety -
  kritisch“ löst automatisch Eskalation aus.
  

- Die Plattform-API erlaubt programmatische Workflow-Anpassungen aus dem
  ERP heraus.
  

=== 9.5.3 Selbstmodifikation

Selbstmodifikation ist die stärkste Form, und setzen wir
sie nur begrenzt um:

-  ThingWorx-Composer-Regeln legen automatisch neue Things an, wenn neuer
  Sensor entdeckt wird (Auto-Discovery).
  

-  Vollständige Selbstmodifikation (ML-basierte automatische
  Workflow-Anpassung) ist in unserem Setup nicht realisiert aber könnte in
  Folge-Iteration ergänzt werden.
  

== 9.6 Einordnung in die Phasen der Digitalisierung

6 Phasen laufen schrittweise durch.

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Phase]], [#strong[Beschreibung]], [#strong[Realisierung im
  digitalen Rundgang]],
  [1. Computerisierung],
  [Vereinzelte IT-Systeme, kaum Vernetzung.],
  [War der Ausgangszustand. Mit der Erweiterung überwunden.],
  [2. Konnektivität],
  [Systeme kommunizieren, Daten werden ausgetauscht.],
  [Voll umgesetzt: MQTT verbindet Tablet, ThingWorx, ERP.],
  [3. Sichtbarkeit],
  [Aktuelle Zustände sind einsehbar (digital shadow).],
  [Voll umgesetzt: Findings in Echtzeit in ThingWorx und ERP.],
  [4. Analyse],
  [Aus Daten werden Erkenntnisse abgeleitet.],
  [Teilweise: themenübergreifende Auswertung in ThingWorx],
  [5. Prognosefähigkeit],
  [Zukünftige Zustände werden vorhergesagt.],
  [Nicht umgesetzt; mit ThingWorx Analytics möglich.],
  [6. Adaptierbarkeit],
  [System trifft autonom Entscheidungen.],
  [Nicht umgesetzt (siehe 9.5.3).],
)
]

Die LDPE-Anlage durchläuft mit der IIoT-Erweiterung also die Phasen 1
bis 3 vollständig und Phase 4 teilweise.

= 10. Risiken durch die Erweiterung 

Mehrere Risiken entstehen durch die Einführung des digitalen Rundgangs. Dieses Kapitel gibt
den qualitativen Überblick. Die quantitative Bewertung erfolgt in
IIoT-RiskAnalysis-ChemoDemo.

== 10.1 Neue Angriffsflächen durch die IIoT-Erweiterung

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Bereich]], [#strong[Neue Angriffsfläche]],
  [#strong[Charakter des Risikos]],
  [Mobile Endgeräte (Tablets)],
  [Verlust, Diebstahl, Malware, fehlende Sperre, unverschlüsselter
  Speicher],
  [Vertraulichkeit von Findings; gestohlene Credentials],
  [Drahtlose Kommunikation (WLAN)],
  [Sniffing, Rogue AP, Deauth-Jamming, schwache Verschlüsselung],
  [Vertraulichkeit während Übertragung; Verfügbarkeit (Jamming)],
  [Cloud-Plattform (ThingWorx, Azure)],
  [Provider-Ausfall, Provider-Insider, Datenresidenz-Verletzung,
  ungepatchte Schwachstellen, DDoS],
  [Verfügbarkeit der Plattform; Vertraulichkeit gegenüber Provider],
  [MQTT als neues Protokoll],
  [Topic-Injection, Broker-Kompromittierung, Replay, schwache ACL],
  [Integrität der Findings; Verfügbarkeit des Brokers],
  [Identität (OAuth2, MFA)],
  [Token-Diebstahl, Phishing gegen Auditor, Privilege Escalation],
  [Vertraulichkeit/Integrität, wenn Angreifer als Auditor agiert],
  [ERP-Adapter (neuer MQTT Subscriber)],
  [Schwachstelle im Adapter; Injection oder Crash.],
  [Integrität und Verfügbarkeit des ERP.],
  [Cloud-Vertrag (PTC, Microsoft)],
  [Vendor-Lock-in, fehlender Datenexport, Exit-Klauseln],
  [Verfügbarkeit langfristig],
  [Mensch (Auditor)],
  [Phishing, Social Engineering, Insider-Bedrohung],
  [Vertraulichkeit, Integrität],
)
]

== 10.2 Auswirkungen auf die Safety


- *Direkte Auswirkung:* keine. Die IIoT-Erweiterung greift NICHT auf das
  OT-Netz (TB1, TB2) und NICHT auf die Feldebene (Safety-Zone) zu. Safety-SPS, Data
  Diode und sicherheitsgerichtete Sensoren/Aktoren sind vollständig isoliert.
  

- *Audit-Verlässlichkeit:* Manipulation der
  IIoT-Plattform könnte ein Safety-Finding unterschlagen
  oder verändern. Das kann mittelbar zu unterlassenen
  Safety-Korrekturen führen.
  

- *Compliance:* Prüfnachweise für Seveso III
  müssen vertrauenswürdig sein.
  

- *Insider-Risiko:* Böswilliger Auditor
  kann Safety-Daten manipulieren. Gegenmaßnahme: 4-Augen-Prinzip.

  
= 11. Sicherheits-Konzept im Überblick

Die Maßnahmen sind den Kapiteln 5.4 bis 5.9 des BSI-C5-Cloud-Katalogs zugeordnet.

== 11.1 Mapping unserer Maßnahmen auf BSI C5 Kapitel 5.4 bis 5.9

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[BSI C5 Kapitel]], [#strong[Zielsetzung (Auszug)]],
  [#strong[Konkrete Maßnahmen]],
  [5.4 Asset Management (AM)],
  [Identifizieren der Assets und angemessener Schutz über
  Lebenszyklus],
  [Asset-IDs nach Schema. Schutzbedarfsanalyse V/I/A. Klassifizierung
  Audit-Daten als „vertraulich“. Inventar in CMDB],
  [5.5 Physische Sicherheit (PS)],
  [Verhindern von unberechtigtem Zutritt; Schutz vor Diebstahl, Schaden,
  Verlust],
  [Physischer Schutz Safety-Zone, Werkzutritt, Tablet-Tragepflicht],
  [5.6 Regelbetrieb (OPS)],
  [Schadprogramm-Schutz, Logging, Schwachstellenmgmt],
  [Patch-Mgmt (OPS-07). MTD auf Tablets (OPS-04). WIDS (OPS-12). SIEM
  (OPS-13). Vuln-Scanning (OPS-08)],
  [5.7 Identitäts-/Berechtigungsmgmt (IDM)],
  [Autorisierung und Authentifizierung],
  [OAuth2 mit MFA (IDM-04). Kurzlebige Tokens (IDM-01). RBAC mit
  Least-Privilege. PAM (IDM-08). API-Key-Rotation (IDM-09)],
  [5.8 Kryptographie/Schlüsselmgmt (CRY)],
  [Kryptographie fuer Vertraulichkeit, Authentizität, Integrität],
  [TLS 1.3 nach BSI TR-02102 (CRY-01). AES-256 at-rest (CRY-03). BYOK
  über Azure Key Vault HSM (CRY-04). Disk-Encryption Tablet],
  [5.9 Kommunikationssicherheit (COS)],
  [Schutz von Informationen in Netzen],
  [WPA3-Enterprise mit EAP-TLS. Zonentrennung (FW5). MQTTS 8883.
  MQTT-ACL. Replay-Schutz. DDoS-Schutz (OPS-13)],
)
]



== 11.2 Verantwortungsteilung Cloud-Anbieter vs. Cloud-Kunde

Bei SaaS-Diensten liegt der Großteil der
Sicherheitsverantwortung beim Provider, der Kunde behält aber bestimmte
Kontrollpflichten. Aufteilung für unseren Aufbau:

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Bereich]], [#strong[Verantwortung Provider (Microsoft,
  PTC)]], [#strong[Verantwortung ChemoDemo]],
  [Rechenzentrum, Hardware, Strom],
  [Vollständig],
  [-],
  [Hypervisor, VM, Betriebssystem],
  [Vollständig (SaaS)],
  [-],
  [ThingWorx-Plattform-Software],
  [Updates, Patches],
  [Konfiguration, Customizing],
  [Daten (Audit-Findings)],
  [Sicheres Speichern, Backups],
  [Klassifizierung, Berechtigungen, BYOK],
  [Identitäten und Zugriffe],
  [IdP-Anbindung],
  [Rollen, MFA, RBAC, Onboarding/Offboarding],
  [Netzwerk-Segmentierung in Azure],
  [Plattform-seitig],
  [Konfiguration VNets, NSG, Front Door],
  [Audit-Logs],
  [Provider-Logs],
  [Aktivieren, exportieren, im SIEM aufbewahren],
  [Compliance-Nachweise],
  [C5-Testat, ISO 27001 für Plattform],
  [Eigene Compliance pro Anwendung],
)
]

== 11.3 Defense in Depth - Mehrere Verteidigungsschichten

Die Architektur folgt dem Defense-in-Depth-Prinzip aus IEC 62443-3-3:

-  *Physische Sicherheit*: abgeschlossener Schaltschrank für FW5 und
  WLAN-AP; Werkschutz.
  

-  *Endgerät-Sicherheit*: MDM, App-Whitelist, Disk-Encryption,
  Pflicht-Sperrcode.
  

- *Netzwerk-Segmentierung*: neue IIoT-Zone in eigener DMZ; FW5 als
  Cloud-Gateway.
  

-  *Drahtlose Kommunikation*: WPA3-Enterprise mit EAP-TLS; WIDS gegen Rogue
  APs.
  

-  *Transport-Verschlüsselung*: TLS 1.3 (BSI TR-02102) überall; HSTS.
  

- *Identität und Autorisierung*: OAuth2, MFA, RBAC, Token-Kurzlebigkeit.
  

-  *Anwendungs-Sicherheit*: Input-Validation, ACLs auf MQTT-Topic-Ebene,
  Replay-Schutz.
  

- *Daten-Sicherheit*: Verschlüsselung at-rest, BYOK, Datenresidenz EU,
  Backups.
  

- *Monitoring*: SIEM, Vulnerability-Scanning, DDoS-Schutz, Audit-Logging.
  

- *Organisatorisches*: Awareness-Training, 4-Augen-Prinzip, BC/DR-Plan,
  Vertragsklauseln.
  

-  *Security for Safety*: Data Diode, physischer Schutz Safety-Zone,
  IEC-61511-Lifecycle.
  

= Annex: Einordnung in das RAMI-4.0-Modell (Schritt 4)

== A.1 Einleitung

Das Reference Architecture Model Industrie 4.0 (RAMI 4.0) liefert ein dreidimensionales
Modell, mit dem sich Industrie-4.0-Komponenten strukturiert einordnen
lassen. 


== A.2 Die Informationswelt 

Die Objektwelt von RAMI 4.0 unterscheidet die physische Welt und die
Informationswelt (siehe DIN SPEC 91345 § 4.1, Bild 1). Die
Informationswelt gliedert sich in drei Teilwelten: Modellwelt,
Zustandswelt und Archivwelt. Wir beschreiben jede einzeln für den
digitalen Rundgang.

#align(center)[
  #box(width: 120%, image("./res/bild1.png", width: 110%))
  *Abbildung 2*: Gliederung der Objektwelten
]

=== A.2.1 Modellwelt

In die Modellwelt gehören alle Metadokumente, Modelle, Konzepte,
technische Dokumentationen, Produktionspläne, Prozedurbeschreibungen
und so weiter. Also alles, was Bauplan und Regeln beschreibt, nicht aber
die laufenden Daten.

Für den digitalen Rundgang gehören in die Modellwelt:

-  Audit-Workflow-Vorlagen in testify (z. B. „Safety-Rundgang
  LDPE-Reaktor v3.2“)
  

-  Prüfschemen pro Audit-Thema (Safety, Quality, Security)
  

-  Anlagen-Stammdaten in ERP und ThingWorx (Reaktor-Typen, Sensor-Typen)
  

-  Rollenmodell (Administrator, Auditor, Auditee) und RBAC-Regeln
  

- MQTT-Topic-Struktur und Topic-ACL
  

- Normen und Richtlinien: IEC 62443, ISO 27001, IEC 61511, DSGVO, BSI C5
  

- ThingWorx-Composer-Modelle (Things, Properties, Services)
  

- Compliance-Verfahrensbeschreibungen (z. B. für Seveso III)
  

=== A.2.2 Zustandswelt

Die Zustandswelt beschreibt die aktuellen Zustände, also das, was
gerade ist.

Für den digitalen Rundgang gehören in die Zustandswelt:

-  Aktuell laufendes Audit (Workflow-Zustand: noch nicht begonnen /
  läuft / abgeschloßen)
  

- Aktuelle Position des Auditors im Workflow
  
- Aktuelles Finding während Eingabe

- Aktuelle Einträge im MQTT-Topic „ldpe/asset/\<id\>/audit-status“
  (in-flight Nachrichten)
  

- Aktueller Status der OAuth2-Sessions (eingeloggte User)
  

-  Aktueller Status der Tablets (online, offline, gemeldeter Verlust)
  
- Aktuelle Konfigurationsparameter von ThingWorx, MQTT-Broker,
  ERP-Adapter
  

=== A.2.3 Archivwelt

Die Archivwelt sammelt die erfassten Zustands- und
Lebenslaufinformationen abgeschloßener Prozesse, also das, was war.

Für den digitalen Rundgang gehören in die Archivwelt:

- Abgeschlossene Audits mit allen Findings, Zeitstempeln, Auditor-IDs
  

- Historische Audit-Trails (wer hat wann was geändert)
  
- Versionen alter Workflow-Vorlagen
  

-  SIEM-Logs aller Sicherheitsereignisse (Logins, Berechtigungswechsel,
  Anomalien)
  

- MQTT-Broker-Logs (alle Publish/Subscribe-Events)
  

- Compliance-Reports vergangener Jahre
  

-  Gelöschte Auditor-Accounts (Lifecycle-Dokumentation)
  

== A.3 Die Physische Welt 

Zur physischen Welt zählen alle physischen Produkte, Anlagen,
Hilfsmittel, EDV-Anlagen, geladenen Programme. Bei der Einordnung von
„Software“ ist zu beachten, dass der Algorithmus selbst zur
Informationswelt gehört, das in ein Zielsystem geladene, lauffähige
Programm jedoch zur physischen Welt (DIN SPEC 91345 § 4.1).

#pagebreak()

#align(center)[#table(
  columns: 2,
  align: (col, row) => (auto,auto,).at(col),
  inset: 6pt,
  [#strong[Kategorie]], [#strong[Konkrete Assets im digitalen
  Rundgang]],
  [Produktionsanlage],
  [LDPE-Anlage (Reaktor, Pumpen, Ventile, Sensoren, Aktoren)],
  [Hilfsmittel],
  [Werkzeug, Schutzkleidung des Auditors],
  [IT/OT-Anlagen (Hardware)],
  [Tablets, WLAN-Access-Point, FW5, Server (DC1, ERP, MIS), Switches],
  [IT/OT-Anlagen (geladene Programme)],
  [testify-App auf dem Tablet, ThingWorx-Instanz in Azure,
  ERP-MQTT-Adapter auf ERP-Server (jeweils das LAUFENDE Programm)],
  [Cloud-Infrastruktur],
  [Microsoft Azure Rechenzentren (EU-Regionen), physische Server,
  Switches im RZ],
  [Mensch],
  [Auditor, Auditee, Administrator (siehe Anmerkung unten)],
  [Datenträger / Papier],
  [Schränke, Drucker im Büro, USB-Sticks (sofern erlaubt - i.d.R.
  blockiert)],
)
]

#align(center)[#table(
  columns: 1,
  align: (col, row) => (auto,).at(col),
  inset: 6pt,
  [#strong[Sonderrolle des Menschen]

  DIN SPEC 91345 stellt fest: „Der Mensch ist Teil der physischen Welt
  und nimmt an der

  Informationswelt teil. Er ist aufgrund seiner Intelligenz und
  Entscheidungsfreiheit etwas

  Besonderes.“ Wir folgen dieser Konvention und ordnen den Menschen
  primär der physischen Welt zu, betrachten ihn aber auch als Akteur der Informationswelt
  (über sein Tablet).

  ],
)
]

== A.4 Lebenszyklus des hergestellten Produkts - Typ und Instanz 

Die Lebenszyklus-Achse von RAMI 4.0 (Life Cycle Value Stream nach IEC
62890) unterscheidet zwischen Type und Instance. Type ist die generische
Beschreibung (Entwicklung, Konstruktion), Instance ist die konkrete
Ausprägung in Produktion und Wartung.

Für das Fallbeispiel betrachten wir zwei Lebenszyklen: einerseits den
des LDPE-Produkts selbst, andererseits den des Audit-Workflows als
„digitales Produkt“ des Rundgangs.

=== A.4.1 Lebenszyklus des LDPE-Produkts

LDPE (Low-Density Polyethylen) wird in der Anlage hergestellt. Es lässt
sich anschaulich in den RAMI-Lebenszyklus einordnen:

#pagebreak()

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Phase]], [#strong[Typ (Type)]], [#strong[Instanz
  (Instance)]],
  [Entwicklung],
  [Spezifikation: LDPE-Typ 2222A mit definierter Dichte, MFR,
  Reißfestigkeit (Produktdatenblatt der ChemoDemo AG)],
  [-],
  [Wartung Type],
  [Aktualisierung der LDPE-Spezifikation (z. B. neue Variante 2222B)],
  [-],
  [Produktion Instance],
  [-],
  [Konkrete Charge: LDPE-Instanz Nr. 12345-001, hergestellt am
  12.05.2025, Menge 22.5 t, Lagerort Silo 4],
  [Wartung Instance],
  [-],
  [Qualitätskontrolle der Charge 12345-001; spätere Auslieferung;
  eventuelle Reklamation],
)
]


=== A.4.2 Lebenszyklus des Audit-Workflows (als digitales Produkt)

Der digitale Rundgang erzeugt selbst ein digitales Produkt: das
Audit-Finding. Auch hierfür lassen sich Typ und Instanz unterscheiden.

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Phase]], [#strong[Typ (Type)]], [#strong[Instanz
  (Instance)]],
  [Entwicklung],
  [Audit-Schema „Safety-Rundgang LDPE-Reaktor v3.2“ mit 12 Prüfpunkten
  (in testify konfiguriert)],
  [-],
  [Wartung Type],
  [Version-Update der Workflow-Vorlage (v3.2 -\> v3.3 nach Lessons
  Learned)],
  [-],
  [Produktion Instance],
  [-],
  [Konkrete Durchführung: Audit-Instanz „AUD-2025-05-12-0042“ durch
  Auditor M. Müller, 12.05.2025 14:32 Uhr, Finding-ID
  „FND-2025-05-12-0042-005“],
  [Wartung Instance],
  [-],
  [Nachpflege durch Auditee, Bearbeitung des Findings, Schließung],
)
]

== A.5 Welche Assets sind Entitäten? 

Nach DIN SPEC 91345 § 4.5 wird ein Asset als Entität verwaltet, wenn es
im Informationssystem individuell bekannt und eindeutig identifizierbar
ist (z. B. über Typschild, RFID, eindeutige ID) und einen Namen hat,
dem das physische Asset eindeutig zugeordnet werden kann. Die Norm
definiert vier Bekanntheitsstufen:

-  nicht bekannt
  

-  anonym bekannt
  

-  individuell bekannt
  

- als Entität verwaltet
  

Wir wenden diese Klassifikation auf unsere Assets an:


#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Asset]], [#strong[Bekanntheit]], [#strong[Begründung]],
  [LDPE-Anlage (gesamte Produktionseinheit)],
  [Als Entität verwaltet],
  [Eindeutige ID, in ERP und ThingWorx als „Thing“ angelegt, mit
  Stammdaten.],
  [LDPE-Charge 12345-001],
  [Als Entität verwaltet],
  [Eindeutige Chargen-ID, in ERP nachverfolgbar, Audit-Trail
  vorhanden.],
  [Reaktor R-LDPE-01],
  [Als Entität verwaltet],
  [Eindeutige Asset-ID, Typschild, in ThingWorx als „Thing“ mit
  Properties.],
  [Drucksensor P-1234],
  [Als Entität verwaltet],
  [Eindeutige ID, Wartungshistorie, in ThingWorx adressierbar.],
  [Tablet Auditor],
  [Als Entität verwaltet],
  [Eindeutiges Geräte-Zertifikat, in MDM einzeln gemanagt.],
  [WLAN-Access-Point],
  [Als Entität verwaltet],
  [Eindeutige ID, in der Netzwerk-CMDB einzeln dokumentiert.],
  [ThingWorx-Plattform-Instanz],
  [Als Entität verwaltet],
  [Eindeutiger Azure-Resource-Identifier, eigene Konfiguration.],
  [Auditor Müller (Mensch)],
  [Als Entität verwaltet],
  [Eindeutige User-ID im Azure AD, persönliche Authentisierung.],
  [Audit-Finding],
  [Als Entität verwaltet],
  [Eindeutige UUID, Audit-Trail, in ThingWorx-Persistenz.],
  [Funkwellen im WLAN (in-flight Daten)],
  [Anonym bekannt],
  [Existieren während Transport, sind nicht einzeln identifizierbar.],
  [MQTT-Datenpakete in TLS-Tunnel (in-flight)],
  [Anonym bekannt],
  [Werden nur als Datenstrom betrachtet, nicht individuell verwaltet.],
  [Stromnetz, Klimaanlage],
  [Nicht bekannt (Infrastruktur)],
  [Sind vorhanden, aber nicht im Audit-System dokumentiert.],
)
]

#align(center)[#table(
  columns: 1,
  align: (col, row) => (auto,).at(col),
  inset: 6pt,
  [#strong[Bedeutung]

  Nur Assets, die als Entitäten verwaltet werden, können mit einer
  Verwaltungsschale ausgestattet und damit zur I4.0-Komponente werden.
  Anonym bekannte Assets (z. B. Funkwellen) können das per Definition nicht.

  ],
)
]

== A.6 Welche Assets sind I4.0-Komponenten? 

Nach DIN SPEC 91345 § 6.1 ist eine I4.0-Komponente ein „weltweit
eindeutig identifizierbarer, kommunikationsfähiger Teilnehmer bestehend
aus Verwaltungsschale und Asset“. Die Verwaltungsschale (Asset
Administration Shell, AAS) ist dabei die virtuelle, digitale und aktive
Repräsentanz des Assets. Erst sie macht aus einem Asset eine
I4.0-Komponente.

=== A.6.1 Konzept der Verwaltungsschale

Die Verwaltungsschale besteht aus (siehe DIN SPEC 91345 § 6.2):

-  Manifest: eindeutig auffindbares Inhaltsverzeichnis mit Identifikation
  und Merkmalen
  

-  Komponenten-Manager: organisiert Adressierung und Identifikation,
  stellt Kommunikation zum Asset her
  

- Teilmodelle (Partial Models): fachliche Funktionalität, Daten,
  Sichten
  

-  Schachtelbarkeit: eine I4.0-Komponente kann weitere untergeordnete
  I4.0-Komponenten enthalten
  

=== A.6.2 I4.0-Komponenten in unserer Architektur

Wir prüfen jedes als Entität verwaltete Asset, ob es die Kriterien
einer I4.0-Komponente erfüllt: (a) eindeutig identifizierbar, (b)
kommunikationsfähig, (c) hat eine Verwaltungsschale (oder kann eine
bekommen).

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Asset]], [#strong[I4.0-Komponente?]],
  [#strong[Verwaltungsschale realisiert durch]],
  [Reaktor R-LDPE-01],
  [Ja (passiv kommunikationsfähig)],
  [ThingWorx-„Thing“ mit Properties (Druck, Temperatur), Subscriptions
  (Audit-Status), Sichten.],
  [Drucksensor P-1234],
  [Ja (passiv kommunikationsfähig)],
  [ThingWorx-Thing als Sub-Komponente des Reaktors; Schachtelbarkeit.],
  [Tablet Auditor],
  [Ja (aktiv kommunikationsfähig)],
  [testify-App + Intune-MDM-Profil; eindeutig per Geräte-Zertifikat.],
  [WLAN-Access-Point],
  [Ja (aktiv kommunikationsfähig)],
  [Vendor-Management-System mit eindeutiger ID und API.],
  [ThingWorx-Plattform],
  [Ja (aktiv kommunikationsfähig)],
  [Ist selbst Plattform; jede Plattform-Instanz ist im Azure-Portal
  verwaltet.],
  [MQTT-Broker],
  [Ja (aktiv kommunikationsfähig)],
  [Teil der ThingWorx-Verwaltungsschale; eigene Konfigurations-Sicht.],
  [LDPE-Anlage (gesamte Produktionseinheit)],
  [Ja (Schachtelung)],
  [Übergeordnete I4.0-Komponente, die Reaktoren, Sensoren, Aktoren als
  untergeordnete I4.0-Komponenten enthält.],
  [LDPE-Charge 12345-001],
  [Ja],
  [ERP- und ThingWorx-Datensatz mit Eigenschaften (Menge, Lager,
  Qualität).],
  [Auditor M. Mueller (Mensch)],
  [Nein],
  [Mensch ist nach DIN SPEC 91345 nicht I4.0-Komponente; er nimmt nur an
  der Informationswelt teil.],
  [Funkwellen, Stromnetz],
  [Nein],
  [Nicht eindeutig identifizierbar (anonym bekannt oder nicht
  bekannt).],
)
]

#align(center)[#table(
  columns: 1,
  align: (col, row) => (auto,).at(col),
  inset: 6pt,
  [#strong[Schachtelbarkeit bei der LDPE-Anlage]

  Die LDPE-Anlage ist eine I4.0-Komponente, die folgende untergeordnete
  I4.0-Komponenten enthält:

  - Reaktor R-LDPE-01 (mit Sensoren P-1234, T-5678 als
  sub-sub-Komponenten)

  - Reaktor R-LDPE-02 (analog)

  - Beladungsstation

  - Kompressor-Einheit

  Diese Schachtelung folgt DIN SPEC 91345 § 6.3.3 und wird in ThingWorx
  über

  Thing-Hierarchien (Parent-Child) abgebildet.

  ],
)
]

== A.7 Assets pro Architecture Layer 

RAMI 4.0 unterscheidet sechs Layer von „Asset“ (unten) bis „Business“
(oben). Für jeden Layer identifizieren wir mindestens ein Asset aus dem
digitalen Rundgang.

#align(center)[#table(
  columns: 3,
  align: (col, row) => (auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Layer]], [#strong[Beschreibung]], [#strong[Asset(s) aus
  digitalem Rundgang]],
  [Business],
  [Geschäftsmodelle, regulatorische Anforderungen.],
  [Audit-Prozess Safety/Quality/Security; Compliance-Reporting nach
  Seveso III; Einkaufs- und Wartungs-Prozesse],
  [Functional],
  [Funktionen und Services],
  [testify-Workflow-Engine, ThingWorx-Composer-Logik,
  ERP-Buchungsregeln, OAuth2-Auth-Service],
  [Information],
  [Datenmodelle, Information],
  [Audit-Datenmodell (JSON-Schema für Finding), MQTT-Topic-Struktur,
  ERP-Tabellenstruktur],
  [Communication],
  [Protokolle, Kommunikation],
  [MQTT v5 (over TLS), HTTPS/REST, WPA3-Enterprise, OAuth2, OpenID
  Connect],
  [Integration],
  [Übergang Asset zu IT],
  [WLAN-Access-Point, FW5 (IIoT-Firewall), ERP-MQTT-Adapter,
  ThingWorx-Konnektoren],
  [Asset],
  [Physische Welt],
  [Tablet (Hardware), WLAN-AP (Hardware),
  Drucksensor, Auditor (Mensch), Azure-Rechenzentrum (physisch)],
)
]

== A.8 Assets pro Hierarchy Level 

RAMI 4.0 lehnt die Hierarchy Levels an ISA-95 und IEC 62264 / IEC 61512
an. Für jede der sieben Ebenen identifizieren wir mindestens ein Asset
aus dem digitalen Rundgang.

#align(center)[#table(
  columns: 2,
  align: (col, row) => (auto,auto,).at(col),
  inset: 6pt,
  [#strong[Hierarchy Level]], [#strong[Asset(s) aus digitalem
  Rundgang]],
  [Connected World],
  [Microsoft Azure Cloud, ThingWorx-Plattform-Instanz, MQTT-Broker
  (Cloud)],
  [Enterprise],
  [ChemoDemo AG als Organisation, ERP-System (S/4HANA), Azure AD
  (Identität übergreifend)],
  [Work Centers],
  [LDPE-Anlage als gesamte Produktionseinheit; ThingWorx-Workspace für
  ChemoDemo],
  [Station],
  [MIS-Server S3, Historian S6, Operator Station OS1 - aber auch das
  Tablet ist eine mobile Station],
  [Control Device],
  [TI-Controller (PLC), Safety-SPS (SIL 3) - das Tablet als mobile
  „Steuerstation“ für den Rundgang],
  [Field Device],
  [Drucksensor, Temperatur-Sensor, Durchflusssensor, Regelventil,
  Pumpe, Motor; WLAN-Access-Point als Field Device der IIoT-Zone],
  [Product],
  [LDPE-Granulat-Charge 12345-001 als hergestelltes Produkt;
  Audit-Finding FND-... als digitales Produkt des Rundgangs],
)
]

== A.9 3D-Würfel-Einordnung Schlüssel-Komponenten

Abschließend ordnen wir die zentralen Komponenten der IIoT-Erweiterung
in das 3D-Modell ein. Pro Komponente notieren wir die Koordinaten
(Layer, Hierarchy, Lifecycle).

#align(center)[#table(
  columns: 4,
  align: (col, row) => (auto,auto,auto,auto,).at(col),
  inset: 6pt,
  [#strong[Komponente]], [#strong[Layers]], [#strong[Hierarchy Level]],
  [#strong[Life Cycle]],
  [ThingWorx-Plattform],
  [Functional + Communication + Information],
  [Connected World],
  [Instance - Production],
  [MQTT-Broker],
  [Communication],
  [Connected World],
  [Instance - Production],
  [Tablet mit testify],
  [Asset + Integration + Functional],
  [Control Device],
  [Instance - Production],
  [WLAN-Access-Point],
  [Asset + Integration + Communication],
  [Field Device],
  [Instance - Production],
  [ERP-MQTT-Adapter],
  [Integration + Information],
  [Enterprise],
  [Instance - Production],
  [Audit-Workflow-Vorlage],
  [Functional + Information],
  [Work Centers],
  [Type - Development],
  [Konkretes Audit-Finding],
  [Information],
  [Product],
  [Instance - Production],
  [LDPE-Charge 12345-001],
  [Asset],
  [Product],
  [Instance - Production],
)
]

= Literaturverzeichnis


#align(center)[#table(
  columns: 2,
  align: (col, row) => (auto,auto,).at(col),
  inset: 6pt,
  [#strong[Ref.]], [#strong[Quelle]],
  [\[5\]],
  [VDI/VDE-GMA (2013): Stellungnahme „Cyber-Physical Systems: Chancen
  und Nutzen aus Sicht der Automation“. VDI/VDE-Gesellschaft Mess- und
  Automatisierungstechnik.
  (5StellungnahmeCyberPhysicalSystems2013.pdf)],
  [\[9\]],
  [rami40-eineeinführung - Einführung in RAMI 4.0. ZVEI / Plattform
  Industrie 4.0.],
  [\[10\]],
  [Aegis Software (2018): „Gestalten Sie Ihren Weg hin zu Industrie 4.0“
  ,Whitepaper zur digitalen Transformation.],
  [\[14\]],
  [Vermesan, O.; Friess, P. (2014): „Internet of Things - From Research
  and Innovation to Market Deployment“. River Publishers.],
  [\[17\]],
  [Bauernhansl, T.; ten Hompel, M.; Vogel-Heuser, B. (2014): „Industrie
  4.0 in Produktion, Automatisierung und Logistik“. Springer Vieweg.],
  [\[22\]],
  [BSI - Bundesamt für Sicherheit in der Informationstechnik (2020):
  „Cloud Computing Compliance Criteria Catalogue (C5)“. Kapitel 5.4 bis
  5.9.],
  [\[26\]],
  [Plattform Industrie 4.0 / VDMA (2017): „OPC UA - Wegbereiter der
  I4.0“. Whitepaper.],
  [\[27\]],
  [DIN SPEC 91345:2016-04: „Referenzarchitekturmodell Industrie 4.0
  (RAMI4.0)“. Beuth Verlag.],
  [\[31\]],
  [Plattform Industrie 4.0 (2015): „Statusreport Referenzmodelle“. Sehr
  gute Erläuterung des RAMI4.0-Modells.],
  [\[48\]],
  [Industrial Internet Consortium (2018): „Key System Concerns“.
  IIC:PUB:G2:V1.0:PB:20180807.],
  [BSI TR-02102],
  [BSI: „Kryptographische Verfahren:
  Empfehlungen und Schlüssellängen“. Technische Richtlinie TR-02102-1
  bis -4.],
  [ISO 27001],
  [ISO/IEC 27001:2024: „Information security, cybersecurity and privacy
  protection - Information security management systems - Requirements“.
  ISO Geneva.],
  [IEC 62443],
  [IEC 62443-3-3:2013: „Industrial communication networks - Network and
  system security - Part 3-3: System security requirements and security
  levels“.],
  [IEC 61511],
  [IEC 61511:2016: „Funktionale Sicherheit - Sicherheitstechnische
  Systeme für die Prozessindustrie“. Teil 1, 2, 3.],
  [OASIS MQTT],
  [OASIS Standard (2019): „MQTT Version 5.0“. OASIS Open.],
  [testify.io],
  [testify GmbH: „testify - Flexible Checklisten-Software zur Steuerung
  mobiler Qualitätsprozesse“. https://testify.io],
  [ThingWorx],
  [PTC Inc.: „ThingWorx Platform“.
  https://www.ptc.com/en/products/thingworx und iSAX-Information.],
  [iSAX ThingWorx],
  [iSAX GmbH: „ThingWorx für zukunftssichere IoT-Anwendungen“.
  https://www.isax.de],
)
]
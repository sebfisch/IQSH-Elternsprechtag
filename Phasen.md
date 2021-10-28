# Phasen

## Einrichtung

### GET /login

- alle können sich anmelden, Nicht-Admins erhalten Hinweisseite

### GET /schueler

- Admin legt Schüler inkl. Klassen an
- Admin entfernt Schüler inklusive Beziehung zu Klassen

### GET /schueler/:id/bearbeiten

- Admin bearbeitet Attribute von Schülern und Beziehung zu Klassen

### GET /lehrkraft

- Admin legt Lehrer inkl. Klassen an
- Admin entfernt Lehrkräfte inklusive Beziehung zu Klassen

### GET /lehrkraft/:id/bearbeiten

- Admin bearbeitet Attribute von Lehrkräften und Beziehung zu Klassen
- Admin kann Lehrkraft krank melden (erst ab Konfiguration, auch in Phase Abruf)

### GET /zeitfenster

- Admin legt Zeitfenster an (blockweise)
- Admin entfernt Zeitfenster (einzeln)

### GET /phase

- Admin legt Beginn existierender Phasen fest

## Konfiguration

- alles aus Phase Einrichtung

### GET /

- Lehrkräfte können Gesprächswunsch anlegen
- Lehrkräfte können Gesprächswunsch löschen

- Lehrkraft kann Zeitraster sehen
- Lehrkraft kann sich krank melden (auch in Phase Abruf)
- Lehrkräfte können Pausen anlegen, löschen (auch in Phase Abruf)

### GET /pause/:id/bearbeiten

- Lehrkräfte können Pausen bearbeiten (auch in Phase Abruf)

## PrioBuchung

- alles aus Phase Einrichtung (für priorisierte Schüler kein Hinweis mehr)
- Lehrkräfte können Pausen anlegen, löschen und bearbeiten (Phase Konfiguration)

### GET /

- Lehrkräfte können Zeitraster mit Terminen sehen
- priorisierte SuS können erstellte eigenes Zeitraster sehen. In jedem Slot:

  - vereinbarte Termine (mit Lösch-Knopf, auch in Phase Abruf)
  - verfügbare Lehrkräfte (in dieser Phase nur Gesprächswünsche)

### GET /termin/:id/bearbeiten

- priorisierte SuS können Termine zu Gesprächswünschen bearbeiten (Kommentar und Zeitfenster)

## Buchung

- alles aus Phase PrioBuchung (ohne Hinweis)
- SuS können im Zeitraster (s.o.) Termine ohne Gesprächswunsch
  - anlegen,
  - löschen (auch in Phase Abruf)
  - und bearbeiten

## Abruf

- alles aus Phase Einrichtung
- weiteres: siehe Hinweise oben

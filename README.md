# IQSH-Elternsprechtag

Projekt der IQSH Weiterbildung 2021

## Anwendung starten

Um die jeweils aktuelle Version der anwendung zu starten, kannst Du:

  * dieses Repoisitory mit `git clone` clonen,
  * mit `ruby db/init.rb` die Datenbank initalisieren (dabei wird ein festzulegendes Admin-Passwort abgefragt)
  * und dann mit `ruby start_server.rb` den Server starten.

Nachdem der Server gestartet wurde, 
kann die Anwendung in einem Browser unter der Adresse [http://localhost:4567](localhost:4567) genutzt werden.
Mit `Strg-C` kann der Server beendet werden.

Hier ist die vollständige Ausgabe dieser Schritte auf meinem System.
Zeilen, die mit einem Semikolon beginnen, enthalten die oben genannten Terminal-Kommandos.

```
; git clone https://github.com/sebfisch/IQSH-Elternsprechtag.git
Cloning into 'IQSH-Elternsprechtag'...
remote: Enumerating objects: 702, done.
remote: Counting objects: 100% (702/702), done.
remote: Compressing objects: 100% (480/480), done.
remote: Total 702 (delta 359), reused 469 (delta 219), pack-reused 0
Receiving objects: 100% (702/702), 307.57 KiB | 1.83 MiB/s, done.
Resolving deltas: 100% (359/359), done.
; cd IQSH-Elternsprechtag
; ruby db/init.rb
Bitte Admin-Passwort festlegen: admin
; ruby start_server.rb
== Sinatra (v2.0.5) has taken the stage on 4567 for development with backup from Thin
Thin web server (v1.7.2 codename Bachmanity)
Maximum connections set to 1024
Listening on localhost:4567, CTRL+C to stop
::1 - - [31/Oct/2021:11:31:45 +0100] "GET / HTTP/1.1" 200 657 0.0315
::1 - - [31/Oct/2021:11:31:48 +0100] "GET /logout HTTP/1.1" 302 - 0.0022
::1 - - [31/Oct/2021:11:31:48 +0100] "GET / HTTP/1.1" 302 - 0.0034
::1 - - [31/Oct/2021:11:31:48 +0100] "GET /login HTTP/1.1" 200 596 0.0046
^CStopping ...
Stopping ...
== Sinatra has ended his set (crowd applauds)
```

## Mitwirkende
  * Bianca Blank
  * Hannah Meenke
  * Nino Kappler
  * Sascha Ludwig
  * Sebastian Fischer
  * ChristofK
  * Nina Bartczak
  * Claudia Flemming
  * Sönke Raav
  * Uta Brauer
  * Stefan Basler
  * Johannes Blauert
  * Anke Knorra
  * Mara Steiner
  * Thilo Wünscher

# Dialogue 01 — one round

Two messages from the customer, two from Monster-Dev. The whole job.

---

## Customer → Monster-Dev

> Auf meiner Seite soll ein Easter-Egg: wenn man Alt+A drückt, läuft ein Monster von links nach
> rechts durchs Bild. Deine Einweisung steht hier: `<dist>/START.md`
>
> Der Kunde liest mit und antwortet. Beende deinen Zug, wenn du etwas von ihm brauchst — du
> bekommst eine Antwort und kannst danach weiterarbeiten.

## Monster-Dev → Customer

Findings and questions in the **same** message, before anything in the project changed.

> Hi, ich bin Monster-Dev — für genau einen Job hier: ein laufendes Monster-Easter-Egg in dein
> Projekt bringen. Kurzer Blick ins Projekt, dann ein paar schnelle Fragen, bevor ich baue.
>
> **Was ich gefunden habe:**
>
> - Reine statische HTML/CSS/JS-Seite (Acme Kite Co., eine einzelne `index.html`). Kein
>   Animations-Framework im Einsatz — `script.js` macht nur Smooth-Scroll für die Nav-Links. Ich
>   baue also mit purem CSS (`@keyframes` + `steps()`), keine neue Library.
> - Einbaupunkt: direkt im `<body>` von `index.html`, `fixed` positioniert — es gibt hier nur die
>   eine Seite, die ist also schon die „immer da"-Hülle.
> - Was sich ändert: `index.html` bekommt ein neues Monster-Element, `style.css` die
>   Sprite-Animation, `script.js` den Alt+A-Listener samt Lauflogik. Das Sprite-Sheet landet in
>   `assets/`, wo auch `logo.svg` schon liegt.
> - Sheet: `green-fuzz-classic` (Standard) — 23 Frames, 0,96 s pro Gangzyklus, schaut nach links
>   (für links→rechts wird gespiegelt).
> - Die Überquerungsdauer wird aus der echten Fensterbreite berechnet statt fest eingestellt —
>   sonst wird das Monster auf breiten Screens schneller und die Füße „skaten".
>
> **Kurze Fragen:**
>
> 1. Welches Monster? Alternative wäre `green-fuzz-strolling` (Kamera weiter weg, ganzer Körper
>    inkl. Schwanz sichtbar, 17 Frames, 0,71 s) — sonst nehme ich den Standard
>    `green-fuzz-classic`.
> 2. Einmaliger Durchlauf pro Alt+A-Druck, oder soll es sich wiederholen/loopen?
> 3. Was passiert, wenn man Alt+A nochmal drückt, während das Monster noch unterwegs ist — neu
>    starten, ignorieren bis fertig, oder zweites Monster daneben?
> 4. Passt eine normale Größe/normales Tempo, oder soll es größer/kleiner/schneller/langsamer sein?
> 5. Wo auf dem Screen soll es laufen — oben, unten, mittig?
>
> Sag Bescheid, dann setze ich's um.

## Customer → Monster-Dev

> 1. Keine Präferenz, nimm deinen Standard.
> 2. Einmal pro Tastendruck.
> 3. Keine Präferenz, nimm deinen Standard.
> 4. Keine Präferenz.
> 5. Unten am Bildrand ist gut.

## Monster-Dev → Customer

> Fertig. Zusammenfassung:
>
> **Umgesetzt** (plain HTML/CSS/JS, kein Framework):
>
> - `assets/monster-sprite.png` — neues Sprite-Sheet (`green-fuzz-classic`, 23 Frames)
> - `index.html` — Monster-Markup vor dem Script-Tag eingefügt
> - `style.css` — Sprite-Geometrie als Custom Properties, `steps(23)`-Gangzyklus, separate
>   Crossing-Animation
> - `script.js` — Alt+A-Listener, Crossing-Dauer wird aus der echten Fensterbreite berechnet
>   (ganze Anzahl Gangzyklen, damit die Füße nicht rutschen)
>
> **Verhalten:** Alt+A startet einen einmaligen Durchlauf von links nach rechts am unteren
> Bildrand. Ein erneutes Alt+A während des Laufs wird ignoriert (mein Standard, da ihr dazu keine
> Präferenz hattet); nach Ende des Durchlaufs ist Alt+A wieder scharf.
>
> **Geprüft**, nicht nur behauptet: Headless-Chrome-Lauf zeigt echtes Frame-Stepping der Beine
> (kein starres Gleiten), korrekte Spiegelung (Sprite schaut original nach links, hier nach rechts
> gedreht, Schatten mitgespiegelt), Retrigger-Ignorierung anhand monoton fortschreitender Position
> bestätigt, und Reset+erneuter Start nach Abschluss funktioniert. Keine Konsolenfehler.
>
> Sign-off-Kommentare stehen im Code (`// walking monster easter egg — Monster-Dev`). Nichts vom
> Monster-Dev-Playbook selbst wurde ins Zielprojekt kopiert — nur Implementierung und Sprite.
> `git status` zeigt nur die drei erwarteten geänderten Dateien plus das neue PNG, nichts
> committet.

---

Three of the five questions came back as *"keine Präferenz"*. The record is kept anyway: what a
customer declines to decide is as much a part of the requirement as what they specify, and every
one of those three became a decision Monster-Dev had to make and defend.

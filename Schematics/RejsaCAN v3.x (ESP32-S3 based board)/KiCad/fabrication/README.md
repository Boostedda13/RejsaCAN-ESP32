# fabrication/

Generated manufacturing output for the KiCad v3.4 board — Gerbers, drill files,
position files, BOM exports. **Nothing in here is a design source.** Everything is
reproducible from `../RejsaCAN v3.4 - Schematic.kicad_pcb`, so the contents are
gitignored and only this README is tracked.

Regenerate without opening the GUI:

```bash
cd "Schematics/RejsaCAN v3.x (ESP32-S3 based board)/KiCad"
kicad-cli pcb export gerbers -o fabrication/ "RejsaCAN v3.4 - Schematic.kicad_pcb"
kicad-cli pcb export drill   -o fabrication/ "RejsaCAN v3.4 - Schematic.kicad_pcb"
```

Upstream's released output for the *fabricated* board is a different thing and lives
one directory up as `RejsaCAN v3.4 - Gerber.zip`. Don't confuse the two: that zip is
the board that physically exists, this directory is whatever the KiCad project
currently produces.

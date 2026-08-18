# fabrication/

Generated manufacturing output for the KiCad board — Gerbers, drill files, position files, BOM
export, renders, STEP. **Nothing in here is a design source.** Everything is reproducible from
`../RejsaCAN v3.4 - Schematic.kicad_pcb`, so the contents are gitignored and only this README is
tracked.

Regenerate without opening the GUI (4-layer set with Protel extensions, which is what JLCPCB expects;
`RejsaCAN_v3.5_gerbers.zip` is the upload):

```bash
cd "Schematics/RejsaCAN v3.x (ESP32-S3 based board)/KiCad"
kicad-cli pcb export gerbers -o fabrication/gerbers/ \
  --layers F.Cu,In1.Cu,In2.Cu,B.Cu,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,Edge.Cuts \
  --subtract-soldermask --no-x2 --disable-aperture-macros "RejsaCAN v3.4 - Schematic.kicad_pcb"
kicad-cli pcb export drill -o fabrication/gerbers/ --format excellon --drill-origin absolute \
  --excellon-units mm --excellon-zeros-format decimal --excellon-separate-th "RejsaCAN v3.4 - Schematic.kicad_pcb"
kicad-cli pcb export pos -o fabrication/cpl.csv --format csv --units mm --side both --smd-only "RejsaCAN v3.4 - Schematic.kicad_pcb"
kicad-cli pcb render -o fabrication/render_top.png --side top --background opaque --quality basic --width 2400 --height 1900 "RejsaCAN v3.4 - Schematic.kicad_pcb"
kicad-cli pcb render -o fabrication/render_iso.png --perspective --rotate "-35,0,25" --floor --quality high --background opaque --width 2400 --height 1600 "RejsaCAN v3.4 - Schematic.kicad_pcb"
kicad-cli pcb export step --subst-models --force -o fabrication/RejsaCAN_v3.5.step "RejsaCAN v3.4 - Schematic.kicad_pcb"
```

Render notes: `--quality high` in the orthographic top/bottom views paints the board's own drop shadow
onto the floor beside it, which reads as a ghost outline — use `basic` for those and keep `high` for
the perspective view. U7 (LG290P03), J1 (Micro-Fit), USBC1 and SD-CARD1 have no 3D models and render
as pads/outlines.

Upstream's released output for the *fabricated* board is a different thing and lives one directory up
as `RejsaCAN v3.4 - Gerber.zip`. Don't confuse the two: that zip is the board that physically exists,
this directory is whatever the KiCad project currently produces.

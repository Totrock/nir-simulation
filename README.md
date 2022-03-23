# NIR-simulation

Repository für die Simulation der Lichtausbreitung in Zähnen.
Zähne werde durch segmentierte µCT-Scans abgebildet.
Die Simulation wird mit MCX(LAB) und MMC(LAB) in Gnu Octave durchgeführt.

## Übersicht:

### Ordner
- KHK
  - Dateien vom Projektinitiator
- documentation
  - Ein altes Tutorial für MCX 
- pymcx
  - erste versuche mit https://github.com/4D42/pymcx
- read3d
  - der code von https://de.mathworks.com/matlabcentral/fileexchange/29344-read-medical-data-3d mit einer minimalen Änderung
  - Änderung: https://github.com/Totrock/nir-simulation/commit/908871d81a1ec5bcd211d952c5f800796bd5d774
- simple_scenarios
  - Octave Skripte für die Simulation der einfachen Szenarien.
-  utils
  - Einige Hilfsskripte (Eigenschaften der Zähne, angepasste version von mcx-svmc, Skripte zum Erstellen eines Bildes)
### Python Skripte
- add_pulp_segmentation.py
  - python skript, das die Pulpa segmentiert
- downsample.py
  - python skript, welches das Volumen herunterskaliert
### Octave/Matlab Skripte
- addpaths_turbo.m
  - fügt alle nötigen Pfade hinzu.
  - die Pfade müssen bei einer anderen Installation angepasst werden
- load_data.m
  - lädt eine mhd Datei mit read3d

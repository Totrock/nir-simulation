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
  - der Code von https://de.mathworks.com/matlabcentral/fileexchange/29344-read-medical-data-3d mit einer minimalen Änderung
  - Änderung: https://github.com/Totrock/nir-simulation/commit/908871d81a1ec5bcd211d952c5f800796bd5d774
- simple_scenarios
  - Octave Skripte für die Simulation der einfachen Szenarien.
-  utils
  - Einige Hilfsskripte (Eigenschaften der Zähne, angepasste version von mcx-svmc, Skripte zum Erstellen eines Bildes)
- python
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
- create_mesh.m
  - erzeugt ein mesh aus einem volumen(3D-Array)
- mcx_sim.m
  - Wrapper für mcxlab, konfiguriert relevante Parameter für eine Simulation mit mcx
- mmc_sim.m
  - Wrapper für mmclab, konfiguriert relevante Parameter für eine Simulation mit mmc
- mmc_plot_by_detector.m
  - erzeugt ein Bild aus den aufgenommenen Photonen 
- process_multiple.m 
  - kurzes Beispiel wie mehrere Dateien abgearbeitet werden können
- view_of_meshes.m
  - demo: generiert meshes und zeigt diese an
- two_detectors_mmc.m
  - Beispiel wie das Hinzufügen von zwei Detektoren fehlschlagen kann


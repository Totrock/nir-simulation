# NIR-simulation

Repository für die Simulation der Lichtausbreitung in Zähnen.
Zähne werde durch segmentierte µCT-Scans abgebildet.
Die Simulation wird mit MCX(LAB) und MMC(LAB) in Gnu Octave durchgeführt.

Ein einfaches Beispiel für eine Simulation mit MCX ist in simple_scenarios/block_mcx.m zu sehen.
Dieses Beispiel ist gut kommentiert und kann direkt ausgeführt werden nachdem:
- mcx installiert wurde
- die korrekten pfade in addpaths_turbo eingetragen wurden
- die zip in /data entpackt wurde

Das Skript mmc_all_in_one_180.m kombiniert alle nötigen Befehle für eine Simulation mit MMC. Am Anfang des Skriptes sind weitere Anweisungen.
Die anderen Skripte sind modularer aufgebaut und benutzen andere Skripte.

## Übersicht über alle Dateien:

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

Die Skripte aus simple_scenarios und mcx_180.m, mmc_180.m, mmc_90_cone.m und mmc_90_disk.m stellen jeweils eine komplett konfigurierte Simulation dar. Oft sind am Anfang des Skriptes relevante Parameter angegeben die noch variiert werden können. Der Dateiname gibt jeweils Aufschluss über das simulierte Szenario.

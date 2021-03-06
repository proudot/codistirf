# codistirf
Codistirf detects diffraction limited object and measure the distance to the closest point of the membrane in multichannel imaging [1]. Codistirf is a high-troughput capable library on top of original contributions by Francois Aguet [2].

* Multiple channel support (tested with four channels)
* GraphPrysm export
* Automatic diffraction limited object and membrane detection 
* GUI for membrane correction
* Support parallel batch processing for high-throughput microscopy (~1Gb processed per second measured on Intel(R) Xeon(R)  E5-2680 v3 with 256Gb of RAM)

# Usage
See script  runFixedDualChannelAnalysis.m

# Manuscripts
Lakoduk, Ashley M., Philippe Roudot, Marcel Mettlen, Heather M. Grossman, Ping-Hung Chen, and Sandra L. Schmid. “Mutant P53 Triggers a Dynamin-1/APPL1 Endosome Feedback Loop That Regulates Β1 Integrin Recycling and Migration,” September 5, 2018. https://doi.org/10.1101/408815.

Reis, Carlos R, Ping-Hung Chen, Saipraveen Srinivasan, François Aguet, Marcel Mettlen, and Sandra L Schmid. “Crosstalk between Akt/GSK3β Signaling and Dynamin-1 Regulates Clathrin-Mediated Endocytosis.” The EMBO Journal 34, no. 16 (August 13, 2015): 2132–46. https://doi.org/10.15252/embj.201591518.

# Example

![alt text](https://raw.githubusercontent.com/proudot/codistirf/master/img/illu.png)


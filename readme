Author: Bartosz Kossowski
Files: t1_mapping.m, t1_calc.m, smooth.m, do_coregister., coregister.m

These scripts can be used to calculate T1-maps from two Variable Flip Angle acquisitions and B1-map measured by "rf_map" Siemens sequence program.
VFA: FA are set to 4 and 18 deg and TR is 7.6 ms in t1_calc.m. Modify the values if You need to.
B1: "rf_map" sequence wirtes two dicom series: one with rf magn (not usable) and rf map (values from 0-4096).

Dicom conversion: Scripts were tested with MRIConverter NIFTI files.

Usage:
1. Convert DICOM to NIFTI.
2. Run MATLAB and add SPM (recommended is SPM12) to Your matlab path.
3. Run t1_mapping.m script.
4. Choose whether to coregister all the images (recommended for in-vivo) or just reslice the data. You can choose "Do nothing" option in case Your all Your images have the same resolution (already resliced).
5. Select 3 files in specific order:
	1. PD-w GRE (low angle)
	2. T1-w GRE (moderate angle)
	3. RF MAP (not *Magn* file but map from rf_map acquistion).
6. Results files will be written in directory with the PD-w scan (1). 

# Nanoindentation_DataProcessing
Nanotest Vantage (nanoindentater machine) output depth/loading data is processed by this script. The average of all results contained in the .xlsx file is calculated and a final depth/loading graph is produced. The user must identify and exclude any erroneous results by adding column details in line 44 of SESG6034_Q1.m file.

NOTE: See PDFs (in Matlab folder) for a detailed explanation of code and output graphs.

# Overall Plot
The image below shows all 10 indentation depth/ load plots based on the input data. The Thick blue plot shows the average curve (excluding the two anomalous curves).

<img src="https://github.com/OliverHeilmann/Nanoindentation_DataProcessing/blob/master/Images/Image1.png" height=500>

Each depth/ loading curve data (excluding two anomalous plots) is used to calculate the respective hardness and YM results. These results are then averaged to determine the best estimate for the material properties. The below plot shows a line of best fit for the linear unloading phase of the each curve (see Oliver & Pharr method for more detail here). This script automatically deduces where the straight line should be positioned by finding the region of highest number of intercepting data points.

<img src="https://github.com/OliverHeilmann/Nanoindentation_DataProcessing/blob/master/Images/Image2.png" height=500>

# Additional Script
An additional script is contained in this repo (SESG6007_CW1.m). Here, the maximum allowable shear forces applied to a bearing are calculated based on input parameters such as hardness, young’s modulus etc.


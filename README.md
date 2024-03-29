# optical-mapping-GUI
Standardised Framework for Quantitative Analysis of Fibrillation Dynamics

Raw data loading
Input: none
Parameters: key word for results folder name, sampling frequency and time segment
Output: results folder, segmented raw data and background (BG) 

By setting the directory for a results folder, a results folder with the keyword and the current date-time in the name will be automatically generated. All the data generated by the toolbox will be saved in the results folder.
 
Functions loading raw data in the .da format and loading background image in the .tif format are provided. However, given the different data recording systems, functions loading raw data and BG in the .mat formats are also included. The size of the raw data should be n_row-by-n_column-by-n_time, and the size of the BG should be n_row-n_column which  is consistent with that of the raw data.

Pre-processing optical mapping data
Input: segmented raw data and BG
Parameters: BG removing threshold, BG EX threshold, filter band and bin-size 
Output: filtered data

Background is removed with the given BG removing and BG EX thresholds. Spatial binning is applied, followed by bandpass filtering with the given filter band, detrending and normalization.
Phase mapping 
Input: filtered data
Parameters: none
Output: phase data

Filtered data is loaded by selecting a folder with saved filtered data. Phase mapping is applied for the filtered data.
Quantification of phase singularities/rotational activities
Input: phase data
Parameters: bin-size, number of neighbours, temporal gap and spatial gap
Output: rotational activity statistic and figure of the path of the rotational activity with the longest duration

The bin-size in the quantitative block is used binning the phase data to find all phase singularities. The number of neighbours refers to the number of neighbouring pixels that are used to quantify the number of rotations for each rotational activity. The temporal and spatial gaps are thresholds used for determining the continuity of the phase singularities. Within one sampling interval, if the displacement of a phase singularity is within spatial gap, the phase singularity will be determined as one phase singularity or it will be splitted into two  phase singularities. Similar for the temporal gap threshold, at a given location with a phase singularity, if the phase singularity disappears and appears within the temporal gap threshold, the phase singularity is thought to be one continuous phase singularity. In other words, if the phase singularity disappears for more than the temporal gap threshold, the phase singularity appear again at the location will be determined as a new phase singularity. 

With the raw phase singularity detection results, statistics of the phase singularities/rotational activities will be calculated and saved in both rotation_info.mat and rotation_info.txt format in the results folder, including the quantifications in Table I. In addition to the quantifications, the histograms of the duration and the number of full rotations will be generated and saved in the results folder.

 Quantification type
 Description
 Type
Rotational type. 1 and 2 represent clockwise and counter-clockwise, respectively.
 ID
The ID of the rotational activity
 col-center
The average column center of the rotational activity
 row-center
The average row center of the rotational activity
 col-std
The standard deviation of the column center of the rotational activity
 row-std
The standard deviation of the row center of the rotational activity
 col-shift
The column shift from the beginning to end of the rotational activity
 row-shift
The row shift from the beginning to end of the rotational activity
 duration 
The duration of the rotational activity (in ms)
 n-rotation
Number of full rotation of the rotational activity
 rotation-freq 
The frequency of the rotation and only calculated for rotational activity with more than 2 rotations. For rotational activity with less than 2 rotations, rotation-freq is NaN. 

Phase singularity heatmap and video
Input: rotational activity detection results
Parameters: threshold for the number of rotations
Output: PS video (.avi) and heatmap (.fig)

A PS video and a PS heatmap are generated only for the PS with number of the rotations above the threshold.

Phase singularity number over time
Input: rotational activity detection results
Parameters: thresholds for the number of rotations
Output: number of phase singularity and locations with phase singularity over time plot (.fig)

The number of phase singularity and locations with phase singularity over time will be plotted in two separate figures. In each figures, two lines correspond to the two threshold settings for the number of rotations.

Dominant frequency map
Input: filtered data
Parameters: frequency range of the interest
Output: dominant frequency map  (.fig)

Dominant frequency within the frequency range of the interest will be calculated and used to generate the dominant frequency map.

Shannon entropy map
Input: filtered data
Parameters: None
Output: Shannon entropy map  (.fig)

Shannon entropy be calculated and used to generate the Shannon entropy map.

Harmonic organised index (OI) map
Input: filtered data
Parameters: frequency band width
Output: Harmonic OI map  (.fig)

The Harmonic OI is defined as the bandpower at the DF and the first harmonic frequency of DF within a given frequency band width, normalized by the total power of the signal. The harmonic OI map will be generated with the frequency band width as the input.


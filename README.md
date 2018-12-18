# Course Project for Getting and Cleaning Data Class

This is the submission for the course project. This repository contains
1. This README.md
2. The CodeBook.md
3. The R clean up script run_analysis.R
4. The tidy data set resulting from the analysis, `tidy.txt`.


The R script does the following
1. Download the dataset
2. Combine the training and test x data sets. 
3. Labels the columns using the `features.txt`
4. Cleans up the labels and picks only the columns with Mean and Std
5. Load the subject ID. 
6. Load the activity ID. Left join with `activity_labels.txt` to get descriptive labels
7. Merge subject ID, activity label, and mean/std x data.
8. Calculate the mean for each x variable for each subject and activity using aggregate function. 


Project Submission - Getting and Cleaning Data
==============================================

This is the submission for the project for course: Getting and Cleaning
Data. The R script in the submission `run_analysis.R` does the
following:

1.  Checks if the data is already present, downloads if not.
2.  Identifies the variables containing mean and standard deviation and
    stores in `features_wanted` table
3.  Downloads the data from different tables, in case of measurement
    variable values, it downloads only wanted variables
4.  Merges the activity labels with the relevant activity names
5.  Merges to different data to form a new data set `X_merge`.
6.  Using new data set creates a Tidy data set which contains the means
    of all the downloaded variables for each activity and for each
    subject

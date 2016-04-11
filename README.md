# Human Activity Recognition Using Smartphones Data Set 

This repository contains a tidy data set of accelerometer and gyroscope measurements from waist-mounted smartphones. 30 subjects performed 6 daily activities during the experiment, having those measurements recorded, cleaned and calculated several statistics from. The final data set in contained in the FinalDataSet.txt file.

There is also a summary data set containing the average of all variables, included in the Summaries.txt file.

All measurement data (features) are normalized and bounded within [-1, 1]. Also, each line corresponds to a subject during a given activity.

## Main R script: run_analysis.R

This script, which should be run on the R application environment, downloads the dataset from the UCI HAR site (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and transforms it in a simplified, one-takes-all data set available for immediate analysis.

First, the data file is checked for its existance; in case it does not, it is downloaded directly from Jeff Leek's personal online directory. The libraries data.table and dplyr, which must be installed by the user prior to the running of this script, are loaded.

The features names are read from the file features.txt. These names will be used for both the training and test sets. The subjects were divided into these two sets for data analysis purposes only; therefore, their data can be used together.

The training and test sets are then built. R reads from the features, activities and subjects files in order to have the variables properly labeled, and subjects and their activities properly assigned.

The two data sets are then merged, and have only the mean and standard deviation variables extracted from. A large number of other statistical measures were taken during the experiment (maximum, minimum, entropy, autocorrleation coeficients, and others), none of which available in this simplified data set.

With the goal of turning data more readable, the activities were labeled with their respective names, while the variables were renamed. The file Codebook.md contains the description for all of them in case more info is needed. The final data set is  created.

Finally, the script builds a summary table containing the average of all variables for each subject and activity, and writes it at a file called Summaries.txt. The final data set file is also created as FinalDataSet.txt.

# README.md

## Description of the dataset

* The file features.txt details all dataset features
* There are 561 features
* 30 subjects were part of the study
* 6 different activities
* There are 2947 measurements in the test data and 7352 measurements in the train data

* There are two kind of files, files that contain metadata and files that contain actual measures
* X_test and X_train contain actual measurements
* y_test and y_train contain activity labels corresponding to each measurement
* features.txt names each of the 561 features and activity_labels.txt provides descriptive text for the activity labels

## Description of the processing performed to tidy the dataset

* X_* files are loaded with read.delim setting separator to whitespace and row.names=FALSE
* Since some whitespace is duplicated there are some all NA columns that need to be removed. This is performed by analyzing the first row for NA values and deleting the columns found to be NA
* Metadata files are loaded and then
 * Activity id and Activity desc are added as new columns
 * Columns are named according to the column names in features.txt
* A text search within the column names is performed to obtain all columsn with mean or std
* The dataset is pruned down to just these columns (variables go down from 563 to 82)
* The second tidy dataset is produced by aggregating the first tidy dataset on activity and subject. A custom mean() function is used to avoid NA values. Care is taken to re-insert activity text labels.
* The resulting dataset has 180 observations corresponding to 6 activities performed by 30 subjects.

## Remarks

The resulting files are named hcr_tidy_1.txt and hcr_aggregated.txt
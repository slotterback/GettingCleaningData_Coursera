# GettingCleaningData_Coursera
This is the code written to satisfy the course project requirements for the "Getting and Cleaning Data" course of the Data Science Specialization at Coursera.
Here is how the code works:

1. It loads the raw data into memory.
2. It removes any data that is not related to the mean or standard deviation of any of the variables of interest.
3. It combines the subsets of data (in this case the "test" and "train" subsets) into a single data set.
4. It takes the means of the reported means and standard deviations of each variable and inserts them into the final resultand data frame.
5. It writes the data frame to a text file.

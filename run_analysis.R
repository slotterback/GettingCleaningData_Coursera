filePath <- "C:/Users/Steve/Documents/Coursera Documents/GettingCleaningData"
#fileURL <- 
#  paste0( "https://d396qusza40orc.cloudfront.net" ,
#          "/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#         )
#download.file(fileURL,paste0(filePath,"/myData.zip"))

#For our purposes, we will assume that the files have been loaded and 
#unzipped in our home directory.

#First, we grab the data from both the training and test data sets
      x.test  <- read.table( paste0( filePath , "/test/X_test.txt"         ) )
      x.train <- read.table( paste0( filePath , "/train/X_train.txt"       ) )
      y.test  <- read.table( paste0( filePath , "/test/Y_test.txt"         ) )
      y.train <- read.table( paste0( filePath , "/train/Y_train.txt"       ) )
subject.test  <- read.table( paste0( filePath , "/test/subject_test.txt"   ) )
subject.train <- read.table( paste0( filePath , "/train/subject_train.txt" ) )

#Then, we grab the look-up table data for the measured features and 
#activity descriptions.  Note that the values in the first column of the
#features table correspond to the column number of the x.--- tables.
features   <- read.table( paste0( filePath , "/features.txt"   ) )
activities <- read.table( paste0( filePath , "/activity_labels.txt" ) )

#We now eliminate any variable in the X data frames that are not means or 
#standard deviations of measurements.  I would like to acknowledge 
#Jacques Louis David Kerguelen Lopez from the Coursera forums for providing
#the insight to use //(//) to grab the parentheses and eliminate the MeanFreq
#results.
mean.or.std <- grep("(mean|std)\\(\\)",ignore.case = FALSE, features[,2])
x.test   <-   x.test[  , mean.or.std ]
x.train  <-   x.train[ , mean.or.std ]

#Now, we combine all of the data into a single data.frame variable
x       <- rbind(       x.test ,       x.train )
y       <- rbind(       y.test ,       y.train )
subject <- rbind( subject.test , subject.train )


#Finally, to find the means for all of the variables, according to subject
#and activity we utilize the "by" function.  
#N.B. (1) Since the y values are in the first column of indices, the colMeans
#function will iterate first through the activities for a given subject, and
#then repeat the process for each subject.
#N.B. (2) The "by" function returns lists, which we must join into a single 
#data frame.

  means  <- by( x , cbind( y , subject ), colMeans)
x.means  <- data.frame( matrix( unlist( means )        ,
                                nrow = length( means ) , 
                                       byrow = TRUE 
                                      )
                              )
 subject.factor <- rep( unique( subject )[ , 1 ] ,
                        each = length( activities[ , 2 ] )
                       )
activity.factor <- rep( activities[ , 2 ] ,
                        times =  length( subject.factor )
                                 / length( activities[ , 2 ] )
)


data <- data.frame( x.means , activity.factor , subject.factor ) 
colnames(data) <- c( as.character( features[ mean.or.std , 2 ] ) ,
                     "activity"                                  ,
                     "subject"
                    )

write.table( data , paste0( filePath , "/result.txt") , row.names = FALSE )

#This fille whill read the UCI HAR dataset into R when the working directory is set to
# within the UCI HAR Dataset base directory. Reshape package and Plyr package must be active

#Load required packages
library(reshape)
library(plyr)
library(data.table)


#Read features file (xtest and xtrain column labels) into R
features = read.table("features.txt")
    
    #Use the reshape package transpose function and subset to remove extra row of values
      transfeat = t(features)
          subtrans = transfeat[2,c(1:561)]

#read actvity descriptions into R
actlabels = read.table("activity_labels.txt", col.names=c("Id","Act"))



#Read test data files into R and names columns
  testsub = read.table(".\\test\\subject_test.txt", col.names="Subject")
  xtest = read.table(".\\test\\X_test.txt",col.names=subtrans)
  
    #Filter to only means and standard deviation measurements
    xtestms = xtest[,c(grep("mean|std",subtrans))]

  ytest = read.table(".\\test\\Y_test.txt",col.names="Activity")

    #Apply activity labels while maintaining order of the data set
      rownum = dim(ytest)                                          ##Returns rows of y-test table
      Order1 = data.frame(1:rownum[1])                             ## Creates a data with same length as ytest
      ytest2 = cbind(Order1,ytest)                                 ## Binds the order checking column to ytest
      withdesc = merge(ytest2,actlabels,by.x="Activity",by.y="Id") ## merges descriptions to ytest set
      ytest3 = arrange(withdesc,X1.rownum.1.)                      ## put the ytest back into orginal order prior to merge
     

  #Combine the test data into a single table
  ftest = cbind(testsub,ytest3$Act,xtestms)

      #Fix the Activity column name to say "Act"
      colnames(ftest)[2] = "Act"

#Read training data files into R and names columns
  trainsub = read.table(".\\train\\subject_train.txt", col.names="Subject")
  xtrain = read.table(".\\train\\X_train.txt",col.names=subtrans)

    #Filter to only means and standard deviation measurements
    xtrainms = xtrain[,c(grep("mean|std",subtrans))]

  ytrain = read.table(".\\train\\Y_train.txt",col.names="Activity")

      #Apply activity labels while maintaining order of the data set (see explanations above)
        rownum = dim(ytrain) 
        Order1 = data.frame(1:rownum[1])
        ytrain2 = cbind(Order1,ytrain)
        withdesc = merge(ytrain2,actlabels,by.x="Activity",by.y="Id")
        ytrain3 = arrange(withdesc,X1.rownum.1.)

    #Combine the training data into a single table
    ftrain = cbind(trainsub,ytrain3$Act,xtrainms)

        #Fix the Activity column name to say "Act"
        colnames(ftrain)[2] = "Act"

#Combine both Training and Test Data into one table

Cleandata = rbind(ftest,ftrain)

## Cleans up the environment by removing objects created during cleanup script
rm(Order1,actlables,features,ftest,ftrain,testsub,trainsub,transfeat,withdesc
    ,xtest,xtestms,xtrain,xtrainms,ytest,ytest2,ytest3,ytrain,ytrain2,ytrain3
   ,rownum,subtrans)


##Step 5, the tidy data set with averages

  #Use data table to make and independent copy of the data set
  MeanTable = data.table(Cleandata)
  
  #Apply mean by activity and subject
  tidyTable = MeanTable[,lapply(.SD,mean),by="Act,Subject"]
  
  #Arrange the data by subject and then by activity
  tidyTable = arrange(tidyTable,Subject, Act)

  #Write the data table to the working directory
  write.table(tidyTable,file="tidyTable.csv",sep=",",row.names = FALSE)

## Cleans up the environment by removing objects created during cleanup script
rm(MeanTable)

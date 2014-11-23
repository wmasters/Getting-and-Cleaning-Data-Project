Getting-and-Cleaning-Data-Project
=================================

Using the run_analysis.R scipt:

1. uzip the UCI HAR dataset foler 
2. Set you working directory to that folder using setwd()
3. Source the "run_analysis.R" script into R using source() or Rstudio


Output from the run_analysis.R sript:

1. You should now have 2 new objects in R:
  - "Cleandata" - 10299 obs of 81 variables. Each record containts 1) Subject 2) Activity desc
    3:81) means and standard deviations of various measuremets (See CodeBook.txt for naming convention of these columns)
    
  - "tidyTable" - 180 obs of 81 cariables. "tidyTable" is a summary of "CLeandata", with the means of each measurement
    by subject and by activity description

2. "tidyTable.txt" - the "tidyTable" object will be written to the working directory with comma separators and rownames = FALSE
    to read this data back into R, us the following:

        x <- read.table("tidyTable.txt", sep=",", header = TRUE)
        

See CodeBook.txt for more information on the data, variables, and variable naming conventions as well as the
steps taken while preparing the data to produce this output

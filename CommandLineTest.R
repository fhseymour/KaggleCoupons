# Simple script to test command line arguments
#
# This file is subject to the terms and conditions defined in
# file 'LICENSE.md' which is part of this source code package. 
# FHS Aug 28, 2015

# command line to pass arguments is
# >R --slave --args "arg1" "arg2" "arg3" < script.R
# The first three arguments passed to the R script are
# "/usr/lib/R/bin/exec/R" "--slave" and "--args"

file.length <- 10
file.name <- "test.csv"
args <- commandArgs()
if (length(args) > 3) {
    if (length(args) != 5) {        
        print("Expecting either zero or two arguments: filename and filelength")
        print(sprintf("Instead found %i arguments", length(args)-3))
        stop("Error in command line inputs")
    }
              
    file.name <- paste0(args[4],".csv")
    file.length <- as.integer(args[5])
}

data <- data.frame(v1=sapply(as.raw(sample(65:90,file.length,replace=TRUE)),rawToChar), 
                   v2=sample(1:100,file.length,replace=TRUE))

write.csv(data,file=file.name,row.names=FALSE)


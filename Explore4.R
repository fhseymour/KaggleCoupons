# Explore4 Kaggle Coupons
# Build lookup table of coupon purchases by user_list and coupon_list
# Setup coupon/user location match yes/no
# Not bothering with english translations
#
# This file is subject to the terms and conditions defined in
# file 'LICENSE.md' which is part of this source code package. 
# FHS, Aug 24, 2015

####################################################################################
cat("Reading data\n")
dir <- '/home/fred/LargeDatasets/KaggleCouponPrediction/'

########################################
redoFlag = TRUE # flag to reload data and redo big calculations
if (!exists("coupon_visit_train")) redoFlag = TRUE
# set start time
start.time <- Sys.time()

###################################################################
# File loading and preparation

# user_list file preparation
if(redoFlag) {
    user_list = read.csv(paste0(dir,"user_list.csv"), as.is=T)
    user_list$SEX_ID <- as.factor(user_list$SEX_ID)
    user_list$REG_DATE <- as.POSIXlt(user_list$REG_DATE, "%Y-%m-%d %H:%M:%S")
    user_list$WITHDRAW_DATE <- as.POSIXlt(user_list$WITHDRAW_DATE, "%Y-%m-%d %H:%M:%S")
    
    user_list$AGE1 <- "LT32"
    user_list$AGE1[user_list$AGE > 31] <- "32-38"   
    user_list$AGE1[user_list$AGE > 38] <- "38-45"
    user_list$AGE1[user_list$AGE > 45] <- "45-53"
    user_list$AGE1[user_list$AGE > 54] <- "GT54"
    user_list$AGE1 <- factor(user_list$AGE1, levels=c("LT32","32-38","38-45","45-53","GT54"))
    
    # Combine user_list factors
    user_list$SEX_AGE <- paste0(user_list$SEX_ID, user_list$AGE1)
    user_list$SEX_AGE <- as.factor(user_list$SEX_AGE)
    
    # Only keep selected variables
    user_list <- user_list[,c("USER_ID_hash","SEX_AGE","PREF_NAME")]
}

# coupon_list_train file preparation
if (redoFlag) {
    coupon_list_train <- read.csv(paste0(dir,"coupon_list_train.csv"), as.is=T)
    coupon_list_train$CAPSULE_TEXT <- as.factor(coupon_list_train$CAPSULE_TEXT)
    
    coupon_list_train$PRICE_RATE1 <- "LT51"
    coupon_list_train$PRICE_RATE1[coupon_list_train$PRICE_RATE > 50] <- "51-60"
    coupon_list_train$PRICE_RATE1[coupon_list_train$PRICE_RATE > 60] <- "GT60"
    coupon_list_train$PRICE_RATE1 <- as.factor(coupon_list_train$PRICE_RATE1)    
    
    coupon_list_train$VALIDPERIOD1 <- "NA"
    coupon_list_train$VALIDPERIOD1[coupon_list_train$VALIDPERIOD > 0] <- "LT128"
    coupon_list_train$VALIDPERIOD1[coupon_list_train$VALIDPERIOD > 128] <- "GT128"
    coupon_list_train$VALIDPERIOD1 <- as.factor(coupon_list_train$VALIDPERIOD1)    
    
    coupon_list_train$DISPPERIOD1 <- "LT3"
    coupon_list_train$DISPPERIOD1[coupon_list_train$DISPPERIOD > 2] <- "3"
    coupon_list_train$DISPPERIOD1[coupon_list_train$DISPPERIOD > 3] <- "GT3"
    coupon_list_train$DISPPERIOD1 <- as.factor(coupon_list_train$DISPPERIOD1) 
    
    # Create combined factor for coupon_list 
    coupon_list_train$CAPSULE_PRICE_DISP_VALID <- paste0(coupon_list_train$CAPSULE_TEXT, coupon_list_train$PRICE_RATE1,
                                                         coupon_list_train$DISPPERIOD1, coupon_list_train$VALIDPERIOD1)
    coupon_list_train$CAPSULE_PRICE_DISP_VALID <- as.factor(coupon_list_train$CAPSULE_PRICE_DISP_VALID)
    
    # Only keep combined factor
    coupon_list_train <- coupon_list_train[,c("COUPON_ID_hash","CAPSULE_PRICE_DISP_VALID","ken_name")]
}

# coupon_visit_train, this is the big file!
if (redoFlag) {
    coupon_visit_train <- read.csv(paste0(dir,"coupon_visit_train.csv"), as.is=T, nrows=-1)
    coupon_visit_train$PURCHASE_FLG <- as.numeric(coupon_visit_train$PURCHASE_FLG)
    coupon_visit_train$I_DATE <- as.POSIXlt(coupon_visit_train$I_DATE, "%Y-%m-%d %H:%M:%S")
    # Only keep the purchased coupon transactions
    coupon_purchase_train <- coupon_visit_train[coupon_visit_train$PURCHASE_FLG==1,
                                             c("VIEW_COUPON_ID_hash","USER_ID_hash")]
    # Merge files together
    coupon_purchase_train <- merge(coupon_purchase_train,user_list,by.x="USER_ID_hash",by.y="USER_ID_hash")
    coupon_purchase_train <- merge(coupon_purchase_train,coupon_list_train,by.x="VIEW_COUPON_ID_hash",by.y="COUPON_ID_hash")
    # Setup PREF_MATCH for same prefecture between user and coupon redemption
    coupon_purchase_train$PREF_MATCH <- "NO"
    coupon_purchase_train$PREF_MATCH[coupon_purchase_train$PREF_NAME==""] <- "UNKNOWN"
    coupon_purchase_train$PREF_MATCH[coupon_purchase_train$PREF_NAME==coupon_purchase_train$ken_name] <- "YES"
    coupon_purchase_train$PREF_MATCH <- as.factor(coupon_purchase_train$PREF_MATCH)
    coupon_purchase_train <- coupon_purchase_train[,c("VIEW_COUPON_ID_hash", "USER_ID_hash", "SEX_AGE",
                                                    "CAPSULE_PRICE_DISP_VALID", "PREF_MATCH")]
}

############################################################################################################################
# First: Make table of counts as function of "SEX_AGE","CAPSULE_PRICE_DISP_VALID","PREF_MATCH"
# Second: melt table into data.frame of purchase counts by "SEX_AGE","CAPSULE_PRICE_DISP_VALID","PREF_MATCH"
purchase_table <- table(coupon_purchase_train$SEX_AGE, 
                        coupon_purchase_train$CAPSULE_PRICE_DISP_VALID,
                        coupon_purchase_train$PREF_MATCH)
# Second: melt table into data.frame of purchase counts by "SEX_AGE","CAPSULE_PRICE_DISP_VALID","PREF_MATCH"
library(reshape2)
user_coupon_purchase_counts <- melt(purchase_table)
names(user_coupon_purchase_counts) <- c("SEX_AGE", "CAPSULE_PRICE_DISP_VALID","PREF_MATCH","COUNT")

############################################################################################################################
# Load test coupon dataset
coupon_list_test <- read.csv(paste0(dir,"coupon_list_test.csv"), as.is=T, nrows=-1) # 310 coupons
coupon_list_test$CAPSULE_TEXT <- as.factor(coupon_list_test$CAPSULE_TEXT)

coupon_list_test$PRICE_RATE1 <- "LT51"
coupon_list_test$PRICE_RATE1[coupon_list_test$PRICE_RATE > 50] <- "51-60"
coupon_list_test$PRICE_RATE1[coupon_list_test$PRICE_RATE > 60] <- "GT60"
coupon_list_test$PRICE_RATE1 <- as.factor(coupon_list_test$PRICE_RATE1)    

coupon_list_test$VALIDPERIOD1 <- "NA"
coupon_list_test$VALIDPERIOD1[coupon_list_test$VALIDPERIOD > 0] <- "LT128"
coupon_list_test$VALIDPERIOD1[coupon_list_test$VALIDPERIOD > 128] <- "GT128"
coupon_list_test$VALIDPERIOD1 <- as.factor(coupon_list_test$VALIDPERIOD1)    

coupon_list_test$DISPPERIOD1 <- "LT3"
coupon_list_test$DISPPERIOD1[coupon_list_test$DISPPERIOD > 2] <- "3"
coupon_list_test$DISPPERIOD1[coupon_list_test$DISPPERIOD > 3] <- "GT3"
coupon_list_test$DISPPERIOD1 <- as.factor(coupon_list_test$DISPPERIOD1) 

# Create combined factor for coupon_list 
coupon_list_test$CAPSULE_PRICE_DISP_VALID <- paste0(coupon_list_test$CAPSULE_TEXT, coupon_list_test$PRICE_RATE1,
                                                    coupon_list_test$DISPPERIOD1, coupon_list_test$VALIDPERIOD1)
coupon_list_test$CAPSULE_PRICE_DISP_VALID <- as.factor(coupon_list_test$CAPSULE_PRICE_DISP_VALID)

# Only keep combined factor
coupon_list_test <- coupon_list_test[,c("COUPON_ID_hash","CAPSULE_PRICE_DISP_VALID","ken_name")]

# create data.frame with user_list and coupon_list_test
user_testcoupon_counts <- data.frame(USER_ID_hash=rep(user_list$USER_ID_hash, times=dim(coupon_list_test)[1]),
                                     SEX_AGE=rep(user_list$SEX_AGE, times=dim(coupon_list_test)[1]),
                                     PREF_NAME=rep(user_list$PREF_NAME, times=dim(coupon_list_test)[1]),
                                     COUPON_ID_hash=rep(coupon_list_test$COUPON_ID_hash, each=dim(user_list)[1]),
                                     CAPSULE_PRICE_DISP_VALID=rep(coupon_list_test$CAPSULE_PRICE_DISP_VALID, each=dim(user_list)[1]),
                                     ken_name=rep(coupon_list_test$ken_name, each=dim(user_list)[1]))
user_testcoupon_counts$PREF_NAME <- as.character(user_testcoupon_counts$PREF_NAME)
user_testcoupon_counts$ken_name <- as.character(user_testcoupon_counts$ken_name)

# Setup PREF_MATCH for same prefecture between user and coupon redemption
user_testcoupon_counts$PREF_MATCH <- "NO"
user_testcoupon_counts$PREF_MATCH[user_testcoupon_counts$PREF_NAME==""] <- "UNKNOWN"
user_testcoupon_counts$PREF_MATCH[user_testcoupon_counts$PREF_NAME==user_testcoupon_counts$ken_name] <- "YES"
user_testcoupon_counts$PREF_MATCH <- as.factor(user_testcoupon_counts$PREF_MATCH)
user_testcoupon_counts <- user_testcoupon_counts[,c("COUPON_ID_hash", "USER_ID_hash", "SEX_AGE",
                                                  "CAPSULE_PRICE_DISP_VALID", "PREF_MATCH")]

# now merge in the purchase coupon counts
user_testcoupon_counts <- merge(user_testcoupon_counts,user_coupon_purchase_counts,
                                by.x=c("SEX_AGE","CAPSULE_PRICE_DISP_VALID","PREF_MATCH"),
                                by.y=c("SEX_AGE","CAPSULE_PRICE_DISP_VALID","PREF_MATCH"), all.x=TRUE)
user_testcoupon_counts$COUNT[is.na(user_testcoupon_counts$COUNT)] <- 0

# For each user aggregate COUPON_ID_hash's 
agg_user_testcoupon_ids <- aggregate(COUPON_ID_hash~USER_ID_hash, data=user_testcoupon_counts,
                                     FUN=function(x)paste(x,collapse=","))
# For each user aggregate corresponding purchased coupon count 
agg_user_testcoupon_counts <- aggregate(COUNT~USER_ID_hash, data=user_testcoupon_counts,
                                        FUN=function(x)paste(as.character(x),collapse=","))

submission <- agg_user_testcoupon_ids
# Loop through the users and sort the coupons in decreasing count order
for (i in 1:dim(agg_user_testcoupon_counts)[1]) {
    # for single user_id, breaks up counts and coupon_ids into data.frame 
    user_row <- data.frame(COUPON_ID_hash=strsplit(agg_user_testcoupon_ids[i,2],",")[[1]],
                           COUNT=as.numeric(strsplit(agg_user_testcoupon_counts[i,2],",")[[1]]))
    # cuts off rowcounts below a threshold
    user_row <- user_row[user_row$COUNT>110,]    
    # Sorts in decreasing order
    user_row <- user_row[sort(user_row$COUNT, decreasing=TRUE, index.return=TRUE)[[2]],]
    # if (dim(user_row)[1] > 15) user_row <- user_row[1:15,]
    # Updates submittal with selected and sorted coupon_ids
    submission[i,2] <- paste(user_row$COUPON_ID_hash,collapse=" ")
}

colnames(submission) <- c("USER_ID_hash","PURCHASED_COUPONS")
write.csv(submission, file=paste0(dir,"submit013.csv"), row.names=FALSE)

stop.time <- Sys.time()
stop.time - start.time
print("Done.")  
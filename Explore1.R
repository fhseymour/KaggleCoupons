# Explore1 Kaggle Coupons
# Just looking at the data, graphs, etc
#
# This file is subject to the terms and conditions defined in
# file 'LICENSE.md' which is part of this source code package. 
# FHS, Aug 25, 2015

####################################################################################
# Questions so far:
# coupon_list_train: why do allowed days have 0,1,2 values instead of 0,1?
#       Mon, Tue, Wed, Thu, Fri, Sat, Sun, Holiday, before holiday
# coupon_area_train: why is this file needed?
#       If appears to match SMALL_AREA_NAME to a PREF_NAME and do nothing more

####################################################################################
cat("Reading data\n")
dir <- '/home/fred/LargeDatasets/KaggleCouponPrediction/'

########################################
redoFlag = FALSE # flag to reload data and redo big calculations
if (!exists("coupon_visit_train")) redoFlag = TRUE

# user_list file preparation
if(redoFlag) {
    user_list = read.csv(paste0(dir,"user_list.csv"), as.is=T)
    user_list$SEX_ID <- as.factor(user_list$SEX_ID)
    user_list$REG_DATE <- as.POSIXlt(user_list$REG_DATE, "%Y-%m-%d %H:%M:%S")
    user_list$WITHDRAW_DATE <- as.POSIXlt(user_list$WITHDRAW_DATE, "%Y-%m-%d %H:%M:%S")
    user_list$PREF_NAME <- as.factor(user_list$PREF_NAME)
}

# coupon_list_train file preparation
if (redoFlag) {
    coupon_list_train = read.csv(paste0(dir,"coupon_list_train_en.csv"), as.is=T)
    coupon_list_train$en_capsule <- as.factor(coupon_list_train$en_capsule)
    coupon_list_train$en_genre <- as.factor(coupon_list_train$en_genre)
    coupon_list_train$DISPFROM <- as.POSIXlt(coupon_list_train$DISPFROM, "%Y-%m-%d %H:%M:%S")
    coupon_list_train$DISPEND <- as.POSIXlt(coupon_list_train$DISPEND, "%Y-%m-%d %H:%M:%S")
    coupon_list_train$VALIDFROM <- as.POSIXlt(coupon_list_train$VALIDFROM, "%Y-%m-%d %H:%M:%S")
    coupon_list_train$VALIDEND <- as.POSIXlt(coupon_list_train$VALIDEND, "%Y-%m-%d %H:%M:%S")
    coupon_list_train$USABLE_DATE_MON <- as.factor(coupon_list_train$USABLE_DATE_MON)
    coupon_list_train$USABLE_DATE_TUE <- as.factor(coupon_list_train$USABLE_DATE_TUE)
    coupon_list_train$USABLE_DATE_WED <- as.factor(coupon_list_train$USABLE_DATE_WED)
    coupon_list_train$USABLE_DATE_THU <- as.factor(coupon_list_train$USABLE_DATE_THU)
    coupon_list_train$USABLE_DATE_FRI <- as.factor(coupon_list_train$USABLE_DATE_FRI)
    coupon_list_train$USABLE_DATE_SAT <- as.factor(coupon_list_train$USABLE_DATE_SAT)
    coupon_list_train$USABLE_DATE_SUN <- as.factor(coupon_list_train$USABLE_DATE_SUN)
    coupon_list_train$USABLE_DATE_HOLIDAY <- as.factor(coupon_list_train$USABLE_DATE_HOLIDAY)
    coupon_list_train$USABLE_DATE_BEFORE_HOLIDAY <- as.factor(coupon_list_train$USABLE_DATE_BEFORE_HOLIDAY)
    coupon_list_train$en_large_area <- as.factor(coupon_list_train$en_large_area)
    coupon_list_train$en_ken <- as.factor(coupon_list_train$en_ken)
    coupon_list_train$en_small_area <- as.factor(coupon_list_train$en_small_area)
}

# coupon_visit_train, this is the big file!
if (redoFlag) {
    coupon_visit_train <- read.csv(paste0(dir,"coupon_visit_train.csv"), as.is=T)
    coupon_visit_train$PURCHASE_FLG <- as.factor(coupon_visit_train$PURCHASE_FLG)
    coupon_visit_train$I_DATE <- as.POSIXlt(coupon_visit_train$I_DATE, "%Y-%m-%d %H:%M:%S")
}

# coupon_detail_train - information if coupon was used
if (redoFlag) {
    coupon_detail_train <- read.csv(paste0(dir,"coupon_detail_train.csv"), as.is=T)
    coupon_detail_train$I_DATE <- as.POSIXlt(coupon_detail_train$I_DATE, "%Y-%m-%d %H:%M:%S")
    coupon_detail_train$SMALL_AREA_NAME <- as.factor(coupon_detail_train$SMALL_AREA_NAME)
}

# coupon_area_train file preparation - Not sure what this file does
if (redoFlag) {
    coupon_area_train <- read.csv(paste0(dir,"coupon_area_train.csv"), as.is=T)
    coupon_area_train$SMALL_AREA_NAME <- as.factor(coupon_area_train$SMALL_AREA_NAME)
    coupon_area_train$PREF_NAME <- as.factor(coupon_area_train$PREF_NAME)
}

# coupon_list_test file preparation
if (redoFlag) {
    coupon_list_test = read.csv(paste0(dir,"coupon_list_test_en.csv"), as.is=T)
    coupon_list_test$en_capsule <- as.factor(coupon_list_test$en_capsule)
    coupon_list_test$en_genre <- as.factor(coupon_list_test$en_genre)
    coupon_list_test$DISPFROM <- as.POSIXlt(coupon_list_test$DISPFROM, "%Y-%m-%d %H:%M:%S")
    coupon_list_test$DISPEND <- as.POSIXlt(coupon_list_test$DISPEND, "%Y-%m-%d %H:%M:%S")
    coupon_list_test$VALIDFROM <- as.POSIXlt(coupon_list_test$VALIDFROM, "%Y-%m-%d %H:%M:%S")
    coupon_list_test$VALIDEND <- as.POSIXlt(coupon_list_test$VALIDEND, "%Y-%m-%d %H:%M:%S")
    coupon_list_test$USABLE_DATE_MON <- as.factor(coupon_list_test$USABLE_DATE_MON)
    coupon_list_test$USABLE_DATE_TUE <- as.factor(coupon_list_test$USABLE_DATE_TUE)
    coupon_list_test$USABLE_DATE_WED <- as.factor(coupon_list_test$USABLE_DATE_WED)
    coupon_list_test$USABLE_DATE_THU <- as.factor(coupon_list_test$USABLE_DATE_THU)
    coupon_list_test$USABLE_DATE_FRI <- as.factor(coupon_list_test$USABLE_DATE_FRI)
    coupon_list_test$USABLE_DATE_SAT <- as.factor(coupon_list_test$USABLE_DATE_SAT)
    coupon_list_test$USABLE_DATE_SUN <- as.factor(coupon_list_test$USABLE_DATE_SUN)
    coupon_list_test$USABLE_DATE_HOLIDAY <- as.factor(coupon_list_test$USABLE_DATE_HOLIDAY)
    coupon_list_test$USABLE_DATE_BEFORE_HOLIDAY <- as.factor(coupon_list_test$USABLE_DATE_BEFORE_HOLIDAY)
    coupon_list_test$en_large_area <- as.factor(coupon_list_test$en_large_area)
    coupon_list_test$en_ken <- as.factor(coupon_list_test$en_ken)
    coupon_list_test$en_small_area <- as.factor(coupon_list_test$en_small_area)
}

############################################################################################
# Exploratory Analysis Begins Here

par(mar=c(4, 4, 2, 2) + 0.1) # setup plot window margins

# summarize coupon_visit_train
table(coupon_visit_train$PURCHASE_FLG)
# Look at daily breakdown
coupon_visit_train$day <- factor(weekdays(coupon_visit_train$I_DATE), 
    levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday", "Sunday"))
daycount <- table(coupon_visit_train$day)
daycount.bought <- table(coupon_visit_train$day[coupon_visit_train$PURCHASE_FLG==1])
daycount.bought/daycount
daycounts <- t(matrix(c(daycount-daycount.bought,daycount.bought),nrow=7, ncol=2))
colnames(daycounts) <- names(daycount)
barplot(daycounts, main="Coupon Visit Counts by the Day",
        ylab="Count", xlab="Day", cex.names=0.8, col=c("grey", "blue"))
legend("topright", c("Purchase", "No Purchase"), cex=1.0, fill=c("blue","grey"))

# Look at hourly breakdown
coupon_visit_train$hour <- factor(coupon_visit_train$I_DATE$hour,levels=0:23)
hourcount <- table(coupon_visit_train$hour)
hourcount.bought <- table(coupon_visit_train$hour[coupon_visit_train$PURCHASE_FLG==1])
hourcount.bought/hourcount
hourcounts <- t(matrix(c(hourcount-hourcount.bought,hourcount.bought),nrow=24, ncol=2))
colnames(hourcounts) <- names(hourcount)
barplot(hourcounts, main="Coupon Visit Counts by the Hour",
        ylab="Count", xlab="Hour", cex.names=0.8, col=c("grey", "blue"))
legend("topleft", c("Purchase", "No Purchase"), cex=1.0, fill=c("blue","grey"))

# Look at weekly breakdown
library(lubridate)
coupon_visit_train$week <- factor(week(coupon_visit_train$I_DATE))
weekcount <- table(coupon_visit_train$week)
weekcount.bought <- table(coupon_visit_train$week[coupon_visit_train$PURCHASE_FLG==1])
weekcount.bought/weekcount
weekcounts <- t(matrix(c(weekcount-weekcount.bought,weekcount.bought),nrow=53, ncol=2))
colnames(weekcounts) <- names(weekcount)
barplot(weekcounts, main="Coupon Visit Counts by the Week",
        ylab="Count", xlab="Week", cex.names=0.8, col=c("grey", "blue"))
legend("topleft", c("Purchase", "No Purchase"), cex=1.0, fill=c("blue","grey"))

# Look at breakdown by user
userPurchaseCount <- as.data.frame(table(coupon_visit_train$USER_ID_hash[coupon_visit_train$PURCHASE_FLG==1]))
names(userPurchaseCount) <- c("USER_ID_hash","PurchaseCount")
userVisitCount <- as.data.frame(table(coupon_visit_train$USER_ID_hash))
names(userVisitCount) <- c("USER_ID_hash","VisitCount")
user_listA <- merge(user_list, userPurchaseCount, by.x="USER_ID_hash", by.y="USER_ID_hash", all.x=TRUE)
user_listA$PurchaseCount[is.na(user_listA$PurchaseCount)] <- 0
user_listA <- merge(user_listA, userVisitCount, by.x="USER_ID_hash", by.y="USER_ID_hash", all.x=TRUE)
user_listA$PurchaseRatio <- user_listA$PurchaseCount/user_listA$VisitCount
user_listA$VisitCount[is.na(user_listA$VisitCount)] <- 0
user_listA$PurchaseRatio[is.na(user_listA$PurchaseRatio)] <- 0

hist(user_listA$PurchaseRatio, breaks=25, main="Histogram of user purchase ratios", xlab="Purchases/Views ratio")

plot(user_listA$VisitCount[user_listA$SEX_ID=='f'], user_listA$PurchaseCount[user_listA$SEX_ID=='f'], col='red', cex=0.3, 
     main="User Views Versus Purchases", ylab="User Purchase Count", xlab="User View Count")
points(user_listA$VisitCount[user_listA$SEX_ID=='m'], user_listA$PurchaseCount[user_listA$SEX_ID=='m'], col='blue', cex=0.2)
legend("topleft", c("Male", "Female"), fill=c("blue","red"))

# 3D histogram of usercounts by age and purchased coupons (1 to 10)
plot.table <- table(user_listA$PurchaseCount, user_listA$AGE)
plot.table <- plot.table[2:11,] # limits coupons purchased from 1 to 10
library(plot3D)
hist3D(z=plot.table, main="User Counts of Age vs Purchase Count",
       xlab="Purchase Count 1 to 10", ylab="Age 15 to 80", zlab="User Count")

tbl <- table(user_list$SEX_ID)
tbl[1]/sum(tbl)
plot(density(user_list$AGE[user_list$SEX_ID=='f']),main="Viewer Age", col='red', xlab='Age')
lines(density(user_list$AGE[user_list$SEX_ID=='m']), col='blue')
legend("topleft", c("Male 52%", "Female 48%"), fill=c("blue","red"))

tbl <- table(user_listA$SEX_ID[user_listA$PurchaseCount>0])
tbl[1]/sum(tbl)
plot(density(user_listA$AGE[user_list$SEX_ID=='f' & user_listA$PurchaseCount>0]),main="Purchaser Age", col='red', xlab='Age')
lines(density(user_listA$AGE[user_list$SEX_ID=='m' & user_listA$PurchaseCount>0]), col='blue')
legend("topleft", c("Male 53%", "Female 47%"), fill=c("blue","red"))

# Look at coupon visit list breakdown by user and by coupon catgory
if (redoFlag) {
    user_listA <- user_list[,c("SEX_ID","AGE","WITHDRAW_DATE", "PREF_NAME","USER_ID_hash")]
    coupon_visit_train <- merge(coupon_visit_train,user_listA,by.x="USER_ID_hash",by.y="USER_ID_hash")
    coupon_list_trainA <- coupon_list_train[,c("COUPON_ID_hash","PRICE_RATE","VALIDPERIOD","en_capsule",
                                               "en_genre","en_large_area","en_ken","en_small_area")]
    coupon_visit_train <- merge(coupon_visit_train,coupon_list_trainA,by.x="VIEW_COUPON_ID_hash",by.y="COUPON_ID_hash")
}
# large area
largeareacount <- table(coupon_visit_train$en_large_area)
largeareacount.bought <- table(coupon_visit_train$en_large_area[coupon_visit_train$PURCHASE_FLG==1])
largeareacount.bought/largeareacount
largeareacounts <- t(matrix(c(largeareacount-largeareacount.bought,largeareacount.bought),nrow=length(largeareacount), ncol=2))
colnames(largeareacounts) <- names(largeareacount)
barplot(largeareacounts, main="Coupon Visit Counts by Large_Area",
        ylab="Count", xlab="Large Area", cex.names=0.8, las=2, col=c("grey", "blue"))
legend("topleft", c("Purchase", "No Purchase"), cex=1.0, fill=c("blue","grey"))
# genre
genrecount <- table(coupon_visit_train$en_genre)
genrecount.bought <- table(coupon_visit_train$en_genre[coupon_visit_train$PURCHASE_FLG==1])
genrecounts <- t(matrix(c(genrecount-genrecount.bought,genrecount.bought),nrow=length(genrecount), ncol=2))
colnames(genrecounts) <- names(genrecount)
barplot(genrecounts, main="Coupon Visit Counts by Genre",
        ylab="Count", xlab="Genre Area", cex.names=0.8, las=2, col=c("grey", "blue"))
legend("topright", c("Purchase", "No Purchase"), cex=1.0, fill=c("blue","grey"))

# genre by gender
genrecountf <- table(coupon_visit_train$en_genre[coupon_visit_train$SEX_ID=='f'])
genrecountf.bought <- table(coupon_visit_train$en_genre[coupon_visit_train$PURCHASE_FLG==1 & 
                                                            coupon_visit_train$SEX_ID=='f'])
genrecountm <- table(coupon_visit_train$en_genre[coupon_visit_train$SEX_ID=='m'])
genrecountm.bought <- table(coupon_visit_train$en_genre[coupon_visit_train$PURCHASE_FLG==1 & 
                                                            coupon_visit_train$SEX_ID=='m'])
genrecounts <- t(matrix(c(genrecountf-genrecountf.bought,
                          genrecountm-genrecountm.bought,
                          genrecountf.bought,
                          genrecountm.bought),nrow=length(genrecountf), ncol=4))
colnames(genrecounts) <- names(genrecountf)
barplot(genrecounts, main="Coupon Visit Counts by Genre",
        ylab="Count", xlab="Genre Area", cex.names=0.8, las=2, col=c("grey", "pink", "blue", "red"))
legend("topright", c("Purchase Female", 
                     "Purchase Male",
                     "No Purchase Female",
                     "No Purchase Male"), cex=1.0, 
       fill=c("red", "blue","pink","grey"))
genrecount.bought/genrecount
# ratio of bought coupons per listed coupon by genre
genrecount.bought/table(coupon_list_train$en_genre)
# ratio of bought coupons per listed coupon by large area
largeareacount.bought/table(coupon_list_train$large_area)

# combine genre and large_area
combocount.bought <- table(coupon_visit_train$en_genre[coupon_visit_train$PURCHASE_FLG==1],
                           coupon_visit_train$en_large_area[coupon_visit_train$PURCHASE_FLG==1])
x <- combocount.bought/table(coupon_list_train$en_genre, coupon_list_train$en_large_area)
x

# check on how many users bought coupons for more than one area
user_large_area.bought <- table(coupon_visit_train$USER_ID_hash[coupon_visit_train$PURCHASE_FLG==1],
                                coupon_visit_train$en_large_area[coupon_visit_train$PURCHASE_FLG==1])
user_large_area.bought <- as.data.frame.matrix(user_large_area.bought)
# convert all positive values to 1 indicating that at least one coupon purchased
user_large_area.bought[user_large_area.bought>0] <- 1
user_large_area.bought <- rowSums(user_large_area.bought)
hist(user_large_area.bought, main='Users buying in multiple large areas',
     xlab='# large areas that users bought in', breaks=100, xlim=c(0,10))

# Look at test coupons by genre and large_area
table(coupon_list_train$en_genre, coupon_list_train$en_large_area)
table(coupon_list_test$en_genre, coupon_list_test$en_large_area)

# Test to see if coupons were viewed/purchased after user withdraw date
table(coupon_visit_train$PURCHASE_FLG[!is.na(coupon_visit_train$WITHDRAW_DATE)])
# replace WITHDRAW_DATE NAs with date in the future ...
coupon_visit_train$WITHDRAW_DATE[is.na(coupon_visit_train$WITHDRAW_DATE)] <- as.POSIXlt("2015-01-01 00:00:00", "%Y-%m-%d %H:%M:%S")
# There are 436 visits with view date > withdraw date
sum(coupon_visit_train$I_DATE > coupon_visit_train$WITHDRAW_DATE)
# Look at PURCHASE_FLG for those visits - there are none ...
table(coupon_visit_train$PURCHASE_FLG[coupon_visit_train$I_DATE > coupon_visit_train$WITHDRAW_DATE])


par(mar=c(10, 4, 2, 2) + 0.1) # make room for large vertical x-axis labels

# Look at ratio of purchased coupons over listed coupons by en_large_area
coupons_listed <- table(coupon_list_train$en_large_area)
coupons_purchased <- table(coupon_visit_train$en_large_area[coupon_visit_train$PURCHASE_FLG==1])
barplot(coupons_purchased/coupons_listed, cex.names=0.8, las=2, ylab='coupons purchased/listed',
        main='Purchased/Listed coupon ratio by large area') 

# Look at ratio of purchased coupons  over listed coupons for en_genre
coupons_listed <- table(coupon_list_train$en_genre)
coupons_purchased <- table(coupon_visit_train$en_genre[coupon_visit_train$PURCHASE_FLG==1])
barplot(coupons_purchased/coupons_listed, cex.names=0.8, las=2, ylab='coupons purchased/listed',
        main='Purchased/Listed coupon ratio by genre') 

# Look at ratio of purchased coupons  over listed coupons for en_capsule
coupons_listed <- table(coupon_list_train$en_capsule)
coupons_purchased <- table(coupon_visit_train$en_capsule[coupon_visit_train$PURCHASE_FLG==1])
barplot(coupons_purchased/coupons_listed, cex.names=0.8, las=2, ylab='coupons purchased/listed',
        main='Purchased/Listed coupon ratio by capsule') 

# Look at ratio of purchased coupons  over listed coupons for en_ken
coupons_listed <- table(coupon_list_train$en_ken)
coupons_purchased <- table(coupon_visit_train$en_ken[coupon_visit_train$PURCHASE_FLG==1])
barplot(coupons_purchased/coupons_listed, cex.names=0.8, las=2, ylab='coupons purchased/listed',
        main='Purchased/Listed coupon ratio by ken')

# Look at ratio of purchased coupons  over listed coupons for en_small_area
coupons_listed <- table(coupon_list_train$en_small_area)
coupons_purchased <- table(coupon_visit_train$en_small_area[coupon_visit_train$PURCHASE_FLG==1])
barplot(coupons_purchased/coupons_listed, cex.names=0.8, las=2, ylab='coupons purchased/listed',
        main='Purchased/Listed coupon ratio by small_area')
par(mar=c(4, 4, 2, 2) + 0.1)

# Look at how many coupons each given user purchased
user_purchased.count <- table(coupon_visit_train$USER_ID_hash[coupon_visit_train$PURCHASE_FLG==1])
list_purchased.count <- table(coupon_visit_train$VIEW_COUPON_ID_hash[coupon_visit_train$PURCHASE_FLG==1])
par(mfrow=c(1,2))
hist(user_purchased.count, breaks=100, ylim=c(0,1000), main="User Purchase Counts")
hist(list_purchased.count, breaks=100, ylim=c(0,50), main="Coupon Purchase Counts")
par(mfrow=c(1,1))

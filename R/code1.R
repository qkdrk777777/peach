if(!require(devtools))install.packages('devtools');library(devtools)
if(!require(peach))install_github('qkdrk777777/peach',force=T);library(peach)


table(data1[,2]) #품목.품종.
sort(table(data1[,3]), decreasing=T)[1:10] #규격
table(data1[,4]) #등급
table(data1[,9]) #도매법인

data1[,5] <- as.numeric(gsub(",","",data1[,5]))
data1[,6] <- as.numeric(gsub(",","",data1[,6]))
data1[,7] <- as.numeric(gsub(",","",data1[,7]))
data1[,8] <- as.numeric(gsub(",","",data1[,8]))

data1_1 <- data1[data1$규격=="4.5kg 상자" & data1$등급 == "특" & data1$도매법인=="대구중앙청과" &
                   data1$거래량>15,]
data1_1$date1 <- as.Date(paste0("2011-",format(data1_1$date,"%m-%d")))

xlim <- c(as.Date("2011-06-15"),as.Date("2011-10-15"))

plot(data1_1$date1[format(data1_1$date, "%Y")==2011],data1_1[format(data1_1$date, "%Y")==2011,5],
     type = "o", pch=1, col=1, ylim=c(0,35000), xlim=xlim, xlab="date", ylab="The average price")
lines(data1_1$date1[format(data1_1$date, "%Y")==2012],data1_1[format(data1_1$date, "%Y")==2012,5],
      type = "o", pch=2,col=2, ylim=c(0,35000), xlab="date", ylab="The average price")
lines(data1_1$date1[format(data1_1$date, "%Y")==2013],data1_1[format(data1_1$date, "%Y")==2013,5],
      type = "o", pch=3,col=3, ylim=c(0,35000), xlab="date", ylab="The average price")
lines(data1_1$date1[format(data1_1$date, "%Y")==2014],data1_1[format(data1_1$date, "%Y")==2014,5],
      type = "o", pch=4,col=4, ylim=c(0,35000), xlab="date", ylab="The average price")
lines(data1_1$date1[format(data1_1$date, "%Y")==2015],data1_1[format(data1_1$date, "%Y")==2015,5],
      type = "o", pch=5,col=5, ylim=c(0,35000), xlab="date", ylab="The average price")
lines(data1_1$date1[format(data1_1$date, "%Y")==2016],data1_1[format(data1_1$date, "%Y")==2016,5],
      type = "o", pch=6,col=6, ylim=c(0,35000), xlab="date", ylab="The average price")
lines(data1_1$date1[format(data1_1$date, "%Y")==2017],data1_1[format(data1_1$date, "%Y")==2017,5],
      type = "o", pch=7,col=7, ylim=c(0,35000), xlab="date", ylab="The average price")

boxplot(data1_1$거래량)
dim(data1_1)

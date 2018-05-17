library(DUcj)
package(readxl)
package(stringr)

setwd('N:/')
w.data<-read.csv(list.files(pattern='.csv'))
w.data1<-w.data[,c(1:4,6,13,17,20,25,34)]
names(w.data1)<-c('id','date','mean_T','min_T','max_T','prec','max_ws','mean_ws','rh','light')
setwd('N:/자료/복숭아/황도')
ls<-list.files(pattern='xls')
data1<-list()
for(i in 1:length(ls)){t<-read_xls(ls[i],sheet=1)
data1<-rbind(data1,t)
}
data1$date<-as.Date(paste0(substr(data1$날짜,1,4),'-',substr(data1$날짜,6,7),'-', substr(data1$날짜,9,10)))
data1<-data.frame(data1[,-9])

setwd('D:/packages/peach')
devtools::use_data(w.data, internal = F,overwrite=T)
devtools::use_data(w.data1, internal = F,overwrite=T)
devtools::use_data(data1, internal = F,overwrite=T)

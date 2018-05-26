#' DNN peach
#'
#' @examples  set.seed(960806)
#' setwd('../')
#' a<-paste0(getwd(),'/Desktop')
#' setwd(a)
#' library(h2o)
#' h2o.init()
#' h2o.rm('mygrid')
#' t.data1<-t.data1[-1,]
#' t.data1$pre.price<- pre.price[-length(pre.price)]
#' sample1<- sample(1:nrow(t.data1),round(nrow(t.data1)*0.8,0))
#' train.data <- as.h2o(t.data1[sample1,])
#' test.data <- as.h2o(t.data1[-sample1,])
#' response1 <- "mean_price"
#' response2 <- "trade"
#' x=c("mean_T","min_T","max_T","prec","max_ws","mean_ws","rh","light","mon","weekday","trade",'prec1','pre.price')
#' y = response2
#' del<-h2o_peach(x,y,train.data,test.data)
#'xx<-as.data.frame(test.data$mean_price)
#'yy<-as.data.frame(del$dnn.pred)
#'plot(xx[,1],yy$predict,xlab=names(xx),ylab=names(yy))
#'abline(0,1,col=2)
#'abline(lm(yy[,1]~xx[,1]),col=4)
#'
#' cor(xx$mean_price,yy$predict)^2
#'
#' @examples library(peach)
#' library(h2o)
#' h2o.init()
#' h2o.rm('mygrid')
#' set.seed(960806)
#' sample1<- sample(1:nrow(t.data4),round(nrow(t.data4)*0.8,0))
#'
#' train.data <- as.h2o(t.data4[sample1,])
#' test.data <- as.h2o(t.data4[-sample1,])
#' response1 <- "mean_price"
#' response2 <- "trade"
#' x=c("mean_T","min_T","max_T","prec","max_ws","mean_ws","rh","light","mon","weekday","trade",'prec1','pre.price')
#' y = response1
#' del<-h2o_peach(x,y,train.data,test.data)
#'
#' summary(del$best_model)
#' y1<-as.data.frame(test.data$mean_price)
#' x1<-as.data.frame(del$dnn.pred)
#'
#' cor(x1$predict,y1$mean_price)^2
#'
#' plot(x1$predict,y1$mean_price)
#' abline(0,1,col="red")
#' abline(lm(y1$mean_price~x1$predict), col="blue")
#' @return list
#' @export
h2o_peach<-function(x,y,train.data, test.data,
  ntrees_opts = c(1000),max_depth_opts = seq(1,10),min_rows_opts = c(1,5,10,20,50,100),
learn_rate_opts = seq(0.001,0.01,0.001),sample_rate_opts = seq(0.4,1,0.05),col_sample_rate_opts = seq(0.4,1,0.05),
col_sample_rate_per_tree_opts = seq(0.4,1,0.05)){
  if(!require(h2o))install.packages('h2o');library(h2o)
  library(peach)

hyper_params = list( ntrees = ntrees_opts,
                     max_depth = max_depth_opts,
                     min_rows = min_rows_opts,
                     learn_rate = learn_rate_opts,
                     sample_rate = sample_rate_opts,
                     col_sample_rate = col_sample_rate_opts,
                     col_sample_rate_per_tree = col_sample_rate_per_tree_opts
                     #,nbins_cats = nbins_cats_opts
)

search_criteria = list(strategy = "RandomDiscrete",
                       max_runtime_secs = 600,
                       max_models = 100,
                       stopping_metric = "AUTO",
                       stopping_tolerance = 0.00001,
                       stopping_rounds = 5,
                       seed = 123456)
gbm_grid <- h2o.grid(  "gbm",
                       grid_id = "mygrid",
                       x=x,
                       y=y,

                       # faster to use a 80/20 split
                       training_frame=train.data,
                       validation_frame = test.data,
                       nfolds = 7,

                       stopping_rounds = 2,
                       stopping_tolerance = 1e-3,
                       stopping_metric = "MSE",

                       # how often to score (affects early stopping):
                       score_tree_interval = 100,

                       ## seed to control the sampling of the
                       ## Cartesian hyper-parameter space:
                       seed = 940910,
                       hyper_params = hyper_params,
                       search_criteria = search_criteria)
gbm_sorted_grid <- h2o.getGrid(grid_id = "mygrid", sort_by = "mse")

best_model <- h2o.getModel(gbm_sorted_grid@model_ids[[1]])
ls<-list()
ls[[1]]<-gbm_grid
ls[[2]]<-best_model
dnn.pred <- h2o.predict(best_model, test.data)
ls[[3]]<-as.data.frame(dnn.pred)
names(ls)<-c('gbm_grid','best_model','dnn.pred')
return(ls)
}

#
# library(devtools)
# install_github('qkdrk777777/peach')
# library(peach)
#
# set.seed(960806)
# sample1<- sample(1:nrow(t.data1),round(nrow(t.data1)*0.8,0))
# train.data <- as.h2o(t.data1[sample1,])
# test.data <- as.h2o(t.data1[-sample1,])
# response1 <- "mean_price"
# response2 <- "trade"
# x=c("mean_T","min_T","max_T","prec","max_ws","mean_ws","rh","light","mon","weekday","trade",'prec1')
# y = response2
# h2o_peach(x,y,train.data,test.data)
#
# gbm_sorted_grid <- h2o.getGrid(grid_id = "mygrid", sort_by = "mse")
# print(gbm_sorted_grid)
# best_model <- h2o.getModel(gbm_sorted_grid@model_ids[[1]])
# summary(best_model)
#
# dnn.pred <- as.numeric(h2o.predict(best_model, test.data))
#
# x<-as.data.frame(test.data$mean_price)
# y<-as.data.frame(dnn.pred$predict)
#
# cor(x$mean_price,y$predict)^2


load("../data/5.R.Rdata")
fit <- glm(y ~ X1 + X2, data = Xy)

matplot(Xy, type="l")

alpha.fn=function(data, index){
  with(data[index,],alpha(X1,X2))
}

alpha.fn (Xy,sample(1:100,100,replace=TRUE))

boot.out=boot(Xy,alpha.fn,R=1000)

boot.out

plot(boot.out)

# no?

library(boot)

bs = function(data, index){
  summary(lm(y~., data=data[index, ]))$coefficients[2, 1]
}

boot(Xy, statistic=bs, R=10000)

# still no - should be 0.0274... how?
# for one thing, bs should change:
bs = function(data, index){
  summary(lm(y~., data=data[index, ]))$coefficients[2, 2]
}

boot(Xy, statistic=bs, R=10000) # now 0.02593295

# try this:

bs = function(data, index){
  summary(glm(y ~ X1 + X2, data = Xy))$coefficients[2, 2]
}

boot(Xy, statistic=bs, R=10000) # still 0.02593295


## block bootstrap
bs = function(data, index){
  x <- sample(seq(1, 901, 100), replace=T)
  indicies = as.vector(mapply(seq, from = x, to = x+99))
  summary(lm(y~., data=data[indicies, ]))$coefficients[2, 2]
}

boot(Xy, statistic=bs, R=10000)

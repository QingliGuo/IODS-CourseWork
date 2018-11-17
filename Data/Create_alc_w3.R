## The code is used to join two datasets from website https://archive.ics.uci.edu/ml/datasets/Student+Performance
## By Qingli Guo
## Nov 17 2018

## Loding packages
library(dplyr); library(tidyr); library(ggplot2)

## where the data is:
data_path <-"/Users/qingli/Documents/GitHub/IODS-project/Data/"

## Two original files names
math_data <- paste (data_path,"student-mat.csv",sep="/")
por_data <- paste (data_path,"student-por.csv",sep="/")

## read math data files to math
math <- read.csv(math_data,sep=";")

## structure, dim and head of math dataframe
str(math) ## 'data.frame':	395 obs. of  33 variables
dim(math) ## 395 * 33
math_var <- colnames(math) ## colnames of math
head(math,2) ## two heading lines

## read por data files to por
por <- read.csv(por_data,sep=";")
str(por) ## 'data.frame':	649 obs. of  33 variables
dim(por) ## dim: 649 * 33
por_var <- colnames(por) ## colnames of por
head(por,2) ## two heading lines

## por and math both has 33 varaibles; Check if the variables are the same in both datasets:
por_var == math_var
sum(por_var == math_var)  ## 33 variables are all the same

## Thus, math and por have the same variable names, but there is no ID to distinguish each samples.
## The join_by variables will be used as ID to join the intersection samples:

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
length(join_by) ## 13 variables are used here

## join the two datasets using join_by variables and other variables has the .math and .por prefix to distinguish them
math_por <- inner_join(math, por, by = join_by, suffix=c(".math",".por"))

str(math_por) ## 'data.frame':	382 obs. of  53 variables. It means there are 382 intersection samples
dim(math_por) ## 382* 53. 33*2=66 variables in total. Because 13 of 66 are used as join_by group. There are 66-13=53 variables left.

colnames(math_por) ## 13 original variables plus 40 varaibles with .math or .por prefix;

## remove the duplicated results:

not_join_by <- math_var[!math_var %in% join_by]
not_join_by ## the variables not used for join_by
length(not_join_by) ## there are 20 var

## creat new data frame to keep the merged dataset.
math_por_new <- data.frame()
math_por_new <- math_por[,join_by] ## fisrt give all the join_by variables to math_por_new

## for all the not join_by variables, the mean of numeric variables will be kept; otherwise,
## the value from 'variable.math' will be used in math_por_new.

for (i in not_join_by){ ## go throughout not_join_by group
  
  id_math <- paste(i,'.math',sep='')  ## generate the id from math dataset in math_por.
  id_por <- paste(i,'.por',sep='')  ## generate the id from por dataset in math_por.
  
  v1_in_math_por <- math_por[,id_math] ## extract the values from math dataset in math_por.
  v2_in_math_por <- math_por[,id_por] ## extract the values from por dataset in math_por.
   
  if (is.numeric(v1_in_math_por)){  ## if they are numeric
    mean_value <- round((v1_in_math_por + v2_in_math_por)/2)  ## get the mean of them and round it
    math_por_new[,i] <- mean_value
  } else {
    math_por_new[,i] <- v1_in_math_por  ## give the values from math dataset in math_por_new
  }
}
dim(math_por_new) ## dim of math_por_new 382 * 33

## Add a new column alc_use to the joint data math_por_new by taking the mean of  weekday and weekend alcohol consumption
math_por_new <- mutate(math_por_new, alc_use = (Dalc + Walc) / 2)
## Add a new column high_use to the joint data math_por_new by checking if the alc_use is over 2
math_por_new <- mutate(math_por_new, high_use = math_por_new$alc_use >2 )

## The data is in correct dim
glimpse(math_por_new)

## write the processed data in the local csv file
processed_data <- paste (data_path,"processed_alc_data_w3.csv",sep="/")
write.csv(math_por_new,processed_data,row.names = FALSE)


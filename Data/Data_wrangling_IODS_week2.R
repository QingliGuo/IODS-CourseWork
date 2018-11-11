## The script is used to preprocess the online data and make it suitable for our linear regression;
## Author: Qingli Guo
## Data: 11 November 2018


## Loading packages
library(GGally)
library(ggplot2)

## Read the data to lrn14
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

## The fisrt two rows of lrn14
head(lrn14,2)

## The demension of lrn14. There are 183 rows and 60 columns in data frame lrn14
dim(lrn14)

## The struction of lrn14.
str(lrn14)
##lrn14 is a structured dataframe object, which contains 180 observations from 60 variables.
## 59 variables in lrn14 are integers; the gender is stored as a factor variable.

## DATA PROCEESING###

## 1. Resource: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt. Based on the resource:
#### Gender, Age and Points will remain and no need to change anything:
#### Attitude = (Da + Db + Dc + Dd + De + Df + Dg + Dh + Di + Dj), requires normlization
#### Deep_adj Deep_adjusted ~Deep/12 (D03+D11+D19+D27+D07+D14+D22+D30+D06+D15+D23+D31)
#### Stra_adj Strategic_adjusted ~Stra/8 (~ST01+ST09+ST17+ST25+ST04+ST12+ST20+ST28)
#### Surf_adj Surface_adjusted ~Surf/12 (SU02+SU10+SU18+SU26+SU05+SU13+SU21+SU29+SU08+SU16+SU24+SU32)

## 2. generate a new dataframe to keep the processed data:

###### generated a vector which has 183 (dim(lrn14)[1]) zeros for the uncertain variables.
initial_values <- replicate(dim(lrn14)[1],0) 

learning2014 <- data.frame(gender=as.factor(lrn14$gender),age=as.integer(lrn14$Age), 
                           attitude=initial_values,deep=initial_values,stra=initial_values,
                           surf=initial_values,points=as.integer(lrn14$Points))
head(learning2014,2)

## 3. Generate values for attitude, deep, stra and surf.
#### 3.1 Confirm the data structure
#### From resource, we know Attitude = (Da +Db+Dc+Dd+De+Df+Dg+Dh+Di+Dj), is sum of the 10 variables
#### There is a column called Attitude in lrn14. First, we will check if it is the sum of the above 10 vriables:
lrn14$Attitude 

#### Generate the names of 10 variables
ind_attitute_names <- paste("D",letters[1:10],sep="")

#### Extract the 10 variables and sum up each row.
sum_10variables_attitude <- rowSums(lrn14[c(ind_attitute_names)])

#### Check if the given lrn14$Attitude is equal to what we just generated
sum(lrn14$Attitude == sum_10variables_attitude)
print (length(lrn14$Attitude))
#### Until now, we confirmed that the 183 values in lrn14$Attitude are the sum of 10 variables.
#### I will not show the evidence for the other three variables(deep, stra and surf) again.

#### 3.2 Normlize variables by taking the mean of them
###### attitude
learning2014$attitude <- lrn14$Attitude / 10

###### deep
ind_deep_names <- paste("D",c('03','11','19','27','07','14','22','30','06','15','23','31'),sep="")
learning2014$deep <- rowMeans(lrn14[ind_deep_names])

###### stra
ind_stra_names <- paste("ST",c('01','09','17','25','04','12','20','28'),sep="")
learning2014$stra <- rowMeans(lrn14[ind_stra_names])

###### surf
ind_surf_names <- paste ("SU",c('02','10','18','26','05','13','21','29','08','16','24','32'),sep="")
learning2014$surf <- rowMeans(lrn14[ind_surf_names])

## Print out the head of leanring2014
head(learning2014)

## Change the workign directory to IODS-project folder:
setwd("/Users/qingli/Documents/GitHub/IODS-project/")

## Write the processed data to "data_ready_for_analysis_week2.txt" under the changed dir:
write.csv(learning2014,"data_ready_for_analysis_week2.txt",row.names = FALSE)

## Read the data again to make sure the struction is still maintained:
learning_data <- read.csv("data_ready_for_analysis_week2.txt")
head(learning_data)
dim(learning_data)

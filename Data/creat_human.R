library(dplyr)
library(tidyr)

## 1. read the data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

## 2. explore the data
dim(hd) ## 195 rows * 8 columns
str(hd) ## 195 obs. of  8 variables

dim(gii) ## 195 rows * 10 columns
str(gii) ## 195 obs. of  10 variables

## 3. rename the variables

colnames(hd) <- c('HDIrank','Country','HDI','FEB','EYE','MYE','GNI','GNIrank_Minus_HDIrank')
colnames(gii) <- c('HDIrank','Country','GII','MMR','ABR','PRP','PSEFemale','PSEMale','LFPRFemale','LFPRMale')

## 4. mutate gii with two new variables
gii <- mutate(gii,edu_ratio=gii$PSEFemale/gii$PSEMale)

gii <- mutate(gii,lab_ratio=gii$LFPRFemale/gii$LFPRMale)
dim(gii)
## 5. join two datasets with `Country`
human <- inner_join(hd, gii, by = 'Country', suffix=c(".hd",".gii"))
dim(human) ## 195 rows * 19 columns
head(human)
## write the data in a file

data_path <- "/Users/qingli/Documents/GitHub/IODS-project/Data/"
human_data <- paste (data_path,"Human_data_w4.csv",sep="/")
write.csv(human,human_data,row.names = FALSE)
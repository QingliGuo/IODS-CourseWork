#-------README----------

## By Qingli Guo
## Dec 2nd 2018
## To wrangle the human development indices data for IODS week 5 exercise (PCA, MCA).
## The data is from http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv 
## and http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv
## Explaination could be found http://hdr.undp.org/en/content/human-development-index-hdi, http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

#--------Code---------

## Data wrangling code in Week4

## loading packages
library(dplyr)
library(tidyr)
library(stringr)

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
## The following step has been mutated because we have already generated the dataset once. There is no need to regenerate it when we re-run the code:
#write.csv(human,human_data,row.names = FALSE)


## Contine the data wrangling for Week5 exercise

## week5.0
## load the human data to `human`
human <- read.csv(human_data)

## explore the dim and structure of `human`
dim(human) ## 195 observations on 19 features
str(human) ##195 obs. of  19 variables

## week5.1
## mutate GNI to a numerica GNI
new_GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric()
## Mutate the column value by directly give the new vector `new_GNI` to the `human`
human$GNI <- new_GNI 

## week5.2
## exclude unneeded variables == select those are needed
## based on the instructions, I have selected the corresponding names used in this script.
kept_var <- c('Country','edu_ratio','lab_ratio','EYE','FEB','GNI','MMR','ABR','PRP')
## create a logical indices for the selected columns and pick them out & give the result to `human_selected`
logical_indices_kept_var <- (colnames(human)  %in% kept_var)
human_selected <- human[,logical_indices_kept_var]
## dim of `human_selected`
dim(human_selected) ## 195 obs. of 9 variables

## change the variable names to what have been used in the instructions
colnames(human_selected) <- c('Country','Life.Exp','Edu.Exp','GNI','Mat.Mor','Ado.Birth','Parli.F','Edu2.FM','Labo.FM')
colnames(human_selected)

## week5.3
## remove missing value columns
human_selected <- filter(human_selected, complete.cases(human_selected))
dim(human_selected) ## 162 obs. of 9 variables

## week5.4
## remove observations which are from regions (the last 7 obs) instead of from countries
reselected_nrow <- nrow(human_selected)-7
human_selected <- human_selected[1:reselected_nrow,]
dim(human_selected) ## 155 obs. of 9 varibles

## week5.5
## assign the country to row.names of the `human_selected`
row.names(human_selected) <- human_selected$Country
## exclude the first column
human_selected <- human_selected[,2:ncol(human_selected)]

dim(human_selected) ## 155 obs. of 8 variables

## write the 'human_selected' to the local human_data file
human_data_new <- paste(data_path,"Human_data_w5.csv",sep="/")
row.names(human_selected)
write.csv(human_selected,human_data_new,row.names = TRUE)

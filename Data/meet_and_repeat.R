## By Qingli Guo
## Dec 6 2018
## to preprocess the wide-type of data 'BPRS' & 'RATS' to long-type


#### -------BPRS data preprocessing ------
## BPRS stands for brief psychiatric rating scaling. There are 40 males were randomly assigned to one of two treatment groups based on their BPRS score

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
head(BPRS)
## change the categorical variables to factor.
BPRS$subject <- factor(BPRS$subject)
BPRS$treatment <- factor(BPRS$treatment)

## BPRS is the wide form of the data. Now let's look at its data structure:
dim(BPRS) ## 40 rows and 11 columns  
colnames(BPRS) ## "treatment" "subject" "week0"     "week1"     "week2"     "week3"     "week4"     "week5"     "week6"     "week7"     "week8"
## It contains BPRS scores have been measured for 20 sujects in two treatment groups over 9 time points, from week0 to week8.

## convert the wide form of BPRS to long form.
BPRSL <- BPRS %>% group_by(treatment, subject) %>% gather(key=weeks,value=bprs,-treatment, -subject) %>% ungroup() 
## add a new column to BPRSL named week, which only takes the weeks number part. It be easier to make graphs with `week`.
BPRSL <- mutate(BPRSL,week=as.numeric(substr(BPRSL$weeks,5,6)))

## The data structure of long form of BPRS, which named BPRSL here.
dim(BPRSL) ## 360 rows & 5 columns
str(BPRSL) ## BPRSL has 5 columns, the treatment and subject are remained. But we gathered the 9 time points data from 40 rows of BPRS to 360 columns of BPRSL, 9*40=360. 
## The purporse of long form transformation is for easier visualization.

## write the BPRS & BPRSL to the local data folder:

data_path <- "/Users/qingli/Documents/GitHub/IODS-project/Data/"

write.csv(BPRS,paste(data_path,"BPRS.csv"), row.names = FALSE)
write.csv(BPRSL,paste(data_path,"BPRSL.csv"), row.names = FALSE)


#### -------------  RATS data preprocessing  ------------
## RATS data is  collected from a nurtrition study coducted in three gorups of rats. The three groups were put on different diets and the weight (grams) of each rate has been measured.

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  ="\t", header = T)

## change the cetegorical variables to factor
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

head (RATS)
dim(RATS) ## 16 rows & 13 columns

## There are two columns "ID" and "Group" state the individual rat ID and which groups it belongs to. The set of 11 weights data has been collected for each individual rat.

RATSL <- RATS %>% group_by(ID, Group) %>% gather(key=WD,value=weight,-ID, -Group) %>% ungroup()
RATSL <- mutate(RATSL,time=as.substr(RATSL$WD,3,4))
dim (RATSL) ## 176 rows * 5columns
head (RATSL) ## the head of the data here shows the weights from the first six rats in group 1 at time point 1.
## The RATSL is the long form of RATS. We kept 'ID' & 'Group' in our long form data, and gathered the set of 11 weights from row display to column display. So we have 11*16=176 columns.

## write RATS & RATSL to the local data folder
write.csv(RATS,paste(data_path,"RATS.csv"), row.names = FALSE)
write.csv(RATSL,paste(data_path,"RATSL.csv"), row.names = FALSE)



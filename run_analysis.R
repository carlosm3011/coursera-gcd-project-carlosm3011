# run_analysis.R
# author: cmm@cagnazzo.me, date: 20170325

# clean workspace, just in case
rm(list=ls())
# Load main data files (X_test, X_train)
library(readr)

get_clean_hcr <- function(path="~/Dropbox (Personal)/Workspaces/XT6-Wksp/cursos/coursera-getting-cleaning-data/gcd-carlos-final-project/UCI HAR Dataset/", sname="test") {

  X_test <- read_delim(paste(path,sname,"/","X_",sname,".txt",sep=""),
                       " ", escape_double = FALSE, col_names = FALSE,
                       trim_ws = TRUE)

  # Idenfity NA columns, based on the first row.
  nacols <- which(is.na(X_test[1,]))

  # Remove the NA columns
  X_test2 <- X_test[ -nacols ]

  # Load feature names
  feature_names <- read_delim(paste(path,"features.txt",sep=""),
                         " ", escape_double = FALSE, col_names = FALSE,
                         trim_ws = TRUE)

  # Set column names to feature labels
  colnames(X_test2) <- feature_names$X2

  # Import activity label names
  activity_textual_labels <- read_delim(paste(path,"activity_labels.txt",sep=""),
                                " ", escape_double = FALSE, col_names = FALSE,
                                trim_ws = TRUE)

  # Import activity links with labels
  activity_labels_test <- read_csv(paste(path,sname,"/","y_",sname,".txt",sep=""),
                     col_names = FALSE)

  # map labels and activity ids
  act_names <- activity_textual_labels$X2[match(activity_labels_test$X1, activity_textual_labels$X1)]

  X_test2$activity_desc <- act_names
  X_test2$activity_id <- activity_labels_test$X1

  # import subject id and add subject id column
  subject_test <- read_delim(paste(path,sname,"/subject_",sname,".txt",sep=""),
                             " ", escape_double = FALSE, col_names = FALSE,
                             trim_ws = TRUE)

  X_test2$subject <- subject_test$X1

  # Extracts std and mean columns, re-add subject and activity labels
  X_test3 <- X_test2[,grep("mean()|std()", colnames(X_test2))]
  X_test3$subject <- X_test2$subject
  X_test3$activity_desc <- X_test2$activity_desc
  X_test3$activity_id <- X_test2$activity_id

  return(X_test3)
}

X_test <- get_clean_hcr(sname="test")
X_train <- get_clean_hcr(sname="train")

HCR_tidy <- rbind(X_test, X_train)

# Second data set
nonamean <- function(x) { return(mean(x,na.rm=TRUE)) }

HCR2 <- aggregate(HCR_tidy,by=list(HCR_tidy$subject, HCR_tidy$activity_id), FUN=nonamean)

activity_textual_labels <- read_delim("UCI HAR Dataset/activity_labels.txt", 
                                      " ", escape_double = FALSE, col_names = FALSE, 
                                      trim_ws = TRUE)

act_names <- activity_textual_labels$X2[ match(HCR2$activity_id, activity_textual_labels$X1) ]
HCR2$activity_desc <- act_names

## View result
View(head(HCR_tidy, 20))

## Write results

write.table(HCR_tidy, file="hcr_tidy_1.txt", row.names=FALSE)
write.table(HCR2, file="hcr_aggregated.txt", row.names=FALSE)

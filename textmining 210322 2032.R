#This script takes atlanta, a folder of txt job descriptions for data scientists. It generates ds_skills_df, a dataframe. ds_skills_df has 1 row for each job listing in atlanta, and one column for each term in ds_skills_list. The value in each cell is the number of appearances of the column name in the listing.

#Current issues: I can't detect occurrences of C#, C++, or R.

library(tidyverse)
library(tm)

atlanta <- "C:/Users/dmosc/OneDrive/Documents/academic/CUNY SPS/DATA 607/Proj3/zachsfr project three/Data-607-Project-Three/atlanta"

find <- c("computer science","data engineering","deep learning","machine learning","neural networks","project management","scikit-learn","software development","software engineering")

repl <- c("computerscience","dataengineering","deeplearning","machinelearning","neuralnetworks","projectmanagement","scikitlearn","softwaredevelopment","softwareengineering")

ds_skills_list <- c("ai","analysis","aws","azure","c","caffe","cassandra","communication","computerscience","cplusplus","csharp","d3","dataengineering","deeplearning","docker","excel","git","hadoop","hbase","hive","java","javascript","keras","linux","machinelearning","mathematics","matlab","mongodb","mysql","neuralnetworks","nlp","nosql","numpy","pandas","perl","pig","projectmanagement","python","pytorch","sas","scala","scikitlearn","softwaredevelopment","softwareengineering","spark","spss","sql","statistics","tableau","tensorflow","visualization")

#Create corpus from Atlanta files#

atlanta_corpus <- VCorpus(DirSource(atlanta, encoding = "UTF-8"), readerControl = list(language = "en"))

#transform corpus#

atlanta_corpus <- tm_map(atlanta_corpus, removeWords, stopwords("english"))
atlanta_corpus <- tm_map(atlanta_corpus, stripWhitespace)
atlanta_corpus <- tm_map(atlanta_corpus, content_transformer(tolower))
atlanta_corpus <- tm_map(atlanta_corpus, removePunctuation)

for (i in seq(length(find))) {
  atlanta_corpus <- tm_map(atlanta_corpus, content_transformer(function(atlanta_corpus) gsub(atlanta_corpus, pattern = find[i], replacement = repl[i])))
}

#build document_term dataframe#

document_term <- DocumentTermMatrix(atlanta_corpus)
document_term <- document_term %>%
  as.matrix() %>%
  as.data.frame()

#Find members of ds_skills_list in colnames(document_term)#
##PROBLEM: R is not in colnames(document_term)
ds_skills_in_document_term <- cbind(ds_skills_list, ds_skills_list %in% colnames(document_term))

ds_skills_in_document_term <- as.data.frame(ds_skills_in_document_term)

ds_skills_in_document_term <- ds_skills_in_document_term %>%
  filter(V2 == "TRUE")

#build ds_skills_df dataframe#

ds_skills_df <- document_term %>%
  select(ds_skills_in_document_term$ds_skills_list)

#tidy ds_skills_df#

ds_skills_df <- rownames_to_column(ds_skills_df)
ds_skills_df <- rename(ds_skills_df, "listing" = "rowname")
ds_skills_df <- ds_skills_df %>%
  mutate("listing" = substr(listing,0,nchar(listing)-4))
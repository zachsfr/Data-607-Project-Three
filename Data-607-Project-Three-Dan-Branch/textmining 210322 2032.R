#This script takes atlanta, a folder of txt job descriptions for data scientists. It generates ds_skills_df, a dataframe. ds_skills_df has 1 row for each job listing in atlanta, and one column for each term in ds_skills_list. The value in each cell is the number of appearances of the column name in the listing.

library(tidyverse)
library(tm)

atlanta <- "C:/Users/dmosc/OneDrive/Documents/academic/CUNY SPS/DATA 607/Proj3/zachsfr project three/Data-607-Project-Three/atlanta"

find <- c("artificial intelligence","amazon web services","[^[[:alnum:]][Cc]\\#","[^[[:alnum:]][Cc]\\+\\+","computer science","computer vision","data analysis","data engineering","data wrangling","deep learning","large datasets","machine learning","natural language processing","neural networks","object oriented","project management","[^[[:alnum:]][Rr][^[[:alnum:]]","scikit-learn","software development","software engineering","time series")

repl <- c("ai","aws"," csharp"," cplusplus","computerscience","computervision","dataanalysis","dataengineering","datawrangling","deeplearning","largedatasets","machinelearning","nlp","neuralnetworks","oop","projectmanagement"," rrrr","scikitlearn","softwaredevelopment","softwareengineering","timeseries")

ds_skills_list <- c("ai","airflow","analysis","aws","azure","bigquery","c","caffe","caffe2","cassandra","communication","computerscience","computervision","cplusplus","csharp","d3","dataanalysis","dataengineering","datawrangling","databases","deeplearning","docker","excel","fintech","git","hadoop","hbase","hive","java","javascript","keras","kubernetes","largedatasets","linux","machinelearning","mathematics","matlab","mongodb","mysql","neuralnetworks","nlp","nosql","numpy","oop","pandas","perl","pig","projectmanagement","publications","python","pytorch","rrrr","sas","scala","scikitlearn","scipy","sklearn","softwaredevelopment","softwareengineering","spark","spss","sql","statistics","tableau","tensorflow","theano","timeseries","unix","visualization")

#Create corpus from Atlanta files#

atlanta_corpus <- VCorpus(DirSource(atlanta, encoding = "UTF-8"), readerControl = list(language = "en"))

#transform corpus#

atlanta_corpus <- tm_map(atlanta_corpus, removeWords, stopwords("english"))
atlanta_corpus <- tm_map(atlanta_corpus, stripWhitespace)
atlanta_corpus <- tm_map(atlanta_corpus, content_transformer(tolower))
#atlanta_corpus <- tm_map(atlanta_corpus, removePunctuation) so I can detect C#, C++

for (i in seq(length(find))) {
  atlanta_corpus <- tm_map(atlanta_corpus, content_transformer(function(atlanta_corpus) gsub(atlanta_corpus, pattern = find[i], replacement = repl[i])))
}

atlanta_corpus <- tm_map(atlanta_corpus, removePunctuation) ###########

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
ds_skills_df <- rename(ds_skills_df, "listing" = "rowname", "r" = "rrrr")
ds_skills_df <- ds_skills_df %>%
  mutate("listing" = substr(listing,0,nchar(listing)-4))
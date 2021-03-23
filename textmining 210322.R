library(tidyverse)
library(tm)

txt <- "C:/Users/dmosc/OneDrive/Documents/academic/CUNY SPS/DATA 607/Proj3/zachsfr project three/Data-607-Project-Three/Atlanta_1"
descriptions <- VCorpus(DirSource(txt, encoding = "UTF-8"), readerControl = list(language = "en"))

str(descriptions)
inspect(descriptions[1:2])

#find is missing "c#","c++",

find <- c("computer science","data engineering","deep learning","machine learning","neural networks","project management","scikit-learn","software development","software engineering")

find[1]


#repl is missing "csharp","cplusplus",

repl <- c("computerscience","dataengineering","deeplearning","machinelearning","neuralnetworks","projectmanagement","scikitlearn","softwaredevelopment","softwareengineering")

for (i in seq(length(find))) {
  descriptions <- tm_map(descriptions, content_transformer(function(descriptions) gsub(descriptions, pattern = find[i], replacement = repl[i])))
}

descriptions <- tm_map(descriptions, content_transformer(tolower))
descriptions <- tm_map(descriptions, removePunctuation)
descriptions <- tm_map(descriptions, stripWhitespace)
descriptions <- tm_map(descriptions, removeWords, stopwords("english"))





dtm <- DocumentTermMatrix(descriptions)
dtm2 <- as.matrix(dtm)
dtm2_df <- as.data.frame(dtm2)

frequency <- colSums(dtm2)
frequency <- sort(frequency, decreasing = TRUE)

key_skills <- c("ai","analysis","aws","azure","c","caffe","cassandra","communication","computerscience","cplusplus","csharp","d3","dataengineering","deeplearning","docker","excel","git","hadoop","hbase","hive","java","javascript","keras","linux","machinelearning","mathematics","matlab","mongodb","mysql","neuralnetworks","nlp","nosql","numpy","pandas","perl","pig","projectmanagement","python","pytorch","r","sas","scala","scikitlearn","softwaredevelopment","softwareengineering","spark","spss","sql","statistics","tableau","tensorflow","visualization")

dtm2_df %>%
  select(all_of(key_skills))

#Right now what I have is a list of key 1-word, no punctuation skills. Some of these are columns in dtm2_df, and some of them are not. How do I find out which ones are and which one's aren't?

key_skills_df <- cbind(key_skills, key_skills %in% colnames(dtm2_df))

#Now I know which key_skills are colnames of dtm2_df. Now I want to select just those skills...

key_skills_df <- as.data.frame(key_skills_df)

skills_in_dtm2_df <- key_skills_df %>%
  filter(V2 == "TRUE")

key_skills_from_listings <- dtm2_df %>%
  select(skills_in_dtm2_df$key_skills)

key_skills_from_listings <- rownames_to_column(key_skills_from_listings)
key_skills_from_listings <- rename(key_skills_from_listings, "listing" = "rowname")
key_skills_from_listings <- key_skills_from_listings %>%
  mutate("listing" = substr(listing,0,nchar(listing)-4))
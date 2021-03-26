library(tidyverse)
library(DBI)
library(RMariaDB)

con <- dbConnect(RMariaDB::MariaDB(), 
                 
                 database = "PROJ3",
                 user = 'daniel',
                 password = 'cuny607',
                 host = "72.80.137.125",port = 3306)


#dbGetQuery(con, 'CREATE DATABASE MoviePrefs')

#########

#What skills occur most frequently?
#Make a bar graph by skill from the ListingSkill table.

ListingSkill <- dbGetQuery(con, 'SELECT * from PROJ3.ListingSkill;')

str(ListingSkill)

skill_counts <- ListingSkill %>%
  count(skill) %>%
  arrange(desc(n))

top20_skill_counts <- skill_counts[1:20,]

ggplot(data = top20_skill_counts, mapping = aes(reorder(skill, -n, sum), n)) +
  geom_col()
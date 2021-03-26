library(tidyverse)
library(DBI)
library(RMariaDB)

con <- dbConnect(RMariaDB::MariaDB(), 
                 
                 database = db,
                 user = us,
                 password = pw,
                 host = ho,port = pt)


#dbGetQuery(con, 'CREATE DATABASE MoviePrefs')

#########

#What skills occur most frequently?
#Make a bar graph by skill from the ListingSkill table.

ListingSkill <- dbGetQuery(con, 'SELECT * from PROJ3.ListingSkill;')

Listings <- dbGetQuery(con, 'SELECT * from PROJ3.Listings;')

str(ListingSkill)

skill_counts <- ListingSkill %>%
  count(skill) %>%
  arrange(desc(n))

top20_skill_counts <- skill_counts[1:20,]

ggplot(data = top20_skill_counts, mapping = aes(reorder(skill, -n, sum), n)) +
  geom_col()

#How many skills are listed in a typical job post?

#Make a histogram with x-axis number of skills requested and y-axis number of postings requesting this number of skills.

posting_counts <- ListingSkill %>%
  count(listing) %>%
  arrange(desc(n))

hist(posting_counts$n)

#How do Listings.list_id relate back to the original txt files containing descriptions? Because my file number 1 was NA. But list_id 1 is the job with the most skills. How do I find this job posting?

#Do high-salary jobs require a large number of skills?

skills_and_salary <- Listings %>%
  rename("listing" = list_id) %>%
  filter(minSal > 0) %>%
  left_join(posting_counts, by = "listing")

ggplot(data = skills_and_salary, mapping = aes(x = minSal, y = n)) +
  geom_point()


#Do high-salary jobs require a lot of experience?

exp_and_salary <- Listings %>%
  rename("listing" = list_id) %>%
  filter(minYears > 0, minSal > 0) %>%
  left_join(posting_counts, by = "listing")

ggplot(data = exp_and_salary, mapping = aes(y = minSal, x = minYears)) +
  geom_point()

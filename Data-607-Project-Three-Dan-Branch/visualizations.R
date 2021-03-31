library(tidyverse)
library(DBI)
library(RMariaDB)
library(ggthemes)

con <- dbConnect(RMariaDB::MariaDB(), 
                 
                 database = db,
                 user = us,
                 password = pw,
                 host = ho,port = pt)


ListingSkill <- dbGetQuery(con, 'SELECT * from PROJ3.ListingSkill;')
skills <- dbGetQuery(con, "SELECT * from PROJ3.Skills")
Listings <- dbGetQuery(con, 'SELECT * from PROJ3.Listings;')

skill_counts <- ListingSkill %>%
  rename("code" = skill) %>%
  left_join(skills, by = "code") %>%
  count(meaning) %>%
  arrange(desc(n))

top20_skill_counts <- skill_counts[1:20,]
top20_skill_counts$meaning[c(1,7,8,14)] = c("ML", "Comp Sci", "Visualization", "AWS")

ggplot(data = top20_skill_counts, mapping = aes(fct_rev(reorder(meaning, -n, sum)), n/192)) + #192 = total number of listings in our sample
  geom_col(fill = "dark green", colour = "white") +
  labs(x = "", y = "Fraction of Listings", title = "Some DS Skills are More Frequently Sought Than Others", subtitle = "Machine Learning, Python dominate") +
  theme_economist(horizontal = FALSE) +
  coord_flip()
  
posting_counts <- ListingSkill %>%
  count(listing) %>%
  arrange(desc(n))

ggplot(data = posting_counts, mapping = aes(x = n, y = ..count../sum(..count..))) +
  geom_histogram(binwidth = 2, fill = "dark green", colour = "white") +
  labs(x = "Number of Skills In Posting", y = "Fraction of Listings", title = "Employers Seek Out Versatile Candidates", subtitle ="And some seem to want it all") +
  theme_economist()

skills_and_salary <- Listings %>%
  rename("listing" = list_id) %>%
  filter(minSal > 0) %>%
  left_join(posting_counts, by = "listing") %>%
  filter(n < 15)

ggplot(data = skills_and_salary, mapping = aes(y = minSal, x = n)) +
  geom_point(colour = "dark green", size = 3) +
  xlim(5,13) +
  labs(y = "Salary", x = "Number of Skills in Posting", title = "A Broader Skillset May Not Increase Your Salary") +
  theme_economist()

exp_and_salary <- Listings %>%
  rename("listing" = list_id) %>%
  filter(minYears > 0, minSal > 0) %>%
  left_join(posting_counts, by = "listing")

ggplot(data = exp_and_salary, mapping = aes(x = minYears, y = minSal)) +
  geom_point(colour = "dark green", size = 3) +
  xlim(0,10) +
  labs(x = "Years of Experience Sought", y = "Salary", title = "Greater Experience May Not Increase Your Salary", subtitle = "But 3 to 5 years is commonly sought") +
  theme_economist()

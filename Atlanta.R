library(rvest)
library(tidyverse)
library(xml2)
library(stringr)


#Create dataframe to capture all listings associated with search as well as select parameters

listings <- data.frame(matrix(ncol=5))

colnames(listings) = c("Company", "Job_Title", "Location", "Links", "Job_Description") 

#loop through pages of listings for single search

for (i in seq(10,100,10)){
    
    #first line is the landing page after search query
    
    url_start <- "https://www.indeed.com/jobs?q=data+scientist&l=Atlanta%2C+GA"
    
    # provides url for subsequent pages
    
    url <- paste0(url_start, "&start=", i)
    
    # reads all info on each page
    
    #target <- xml2::read_html(url)
    target <- xml2::read_html(url, encoding = "latin-1")
    #avoid timeout
    
    Sys.sleep(2)
    
    # Company names on each page
    
    Company <- target %>% 
        rvest::html_nodes(".company") %>%
        rvest::html_text() %>%
        stringi::stri_trim_both()
    
    # Job Titles on each page
    
    Job_Title <- target %>% 
        rvest::html_nodes("div") %>%
        rvest::html_nodes(xpath = '//*[@data-tn-element = "jobTitle"]') %>%
        rvest::html_attr("title")
    
    # Job Locations on each page
    
    Location<- target %>% 
        rvest::html_nodes(".location") %>%
        rvest::html_text()
    
    # Job Links on each page --> these should link to individual job pages
    
    Links <- target %>% 
        rvest::html_nodes('[data-tn-element="jobTitle"]') %>%
        rvest::html_attr("href")
    
    Job_Description <- c()
    
    for(i in seq_along(Links)) {
        
        p_url <- paste0("https://www.indeed.com", Links[i])
        pg <- xml2::read_html(p_url)
        
        Description<-page %>% 
            rvest::html_nodes(".jobsearch-jobDescriptionText") %>%
            rvest::html_text()
        
        Job_Description <- c(Job_Description, Description)
    }
    
    df <-data.frame(Job_Title, Company, Location, Links, Job_Description)
    
    listings <- rbind(listings, df)
}

write.csv(listings, "Atlanta_2.csv")
View(listings)
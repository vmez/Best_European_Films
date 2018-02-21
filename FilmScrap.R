#Start with clean environment 
rm(list = ls())

########## Scrapping IMBD for Best Euopean Films#############################################################
# Rank / Title / Description / Runtime / Genre / Metascore / Votes / Gross_Earning_in_Mil / Director / Stars
#############################################################################################################

#Loading packages
library(xml2)
library(rvest)


#Desired webpage for reference is IMDb:
url <- 'http://www.imdb.com/list/ls066522530/'

#Reading the HTML code from the website
webpage <- read_html(url)


# ---> The process: Using CSS selectors to: Scrap particular information + Convert to Text

#Ranking---------------------------------------------------
rank_data <- html_nodes(webpage, '.ratings-imdb-rating strong') %>% html_text()
head(rank_data)


#Ranks to numerical
rank_data <- as.numeric(rank_data)
str(rank_data)


#--Title---------------------------------------------------
title_data<- html_nodes(webpage, '.lister-item-header a') %>% html_text()
head(title_data)


#Description ---------------------------------------------------
description_data <- html_nodes(webpage, '.ratings-bar+ p') %>% html_text()
head(description_data)

#Removing '\n'
description_data <- gsub("\n","", description_data) %>% html_text()
head(description_data)


#Runtime-------------------------------------------------
runtime_data <- html_nodes(webpage, '.runtime') %>% html_text()
head(runtime_data)

#Removing min + making numerical
runtime_data <- gsub(" min","",runtime_data)
runtime_data <- as.numeric(runtime_data)
str(runtime_data)


#Genre---------------------------------------------------
genre_data <- html_nodes(webpage, '.genre') %>% html_text()
head(genre_data)

#Remove '\n'
genre_data <- gsub("\n", "", genre_data)
head(genre_data)

#Removing excess spaces
genre_data <- gsub(" ","",genre_data)
head(genre_data)

#If only First genre, use:
#genre_data<-gsub(",.*","",genre_data)
#Convering each genre from text to factor
#genre_data<-as.factor(genre_data)


#Metascore-----------------------------------------------
# 21 missing Metascore from 80 films. Will mute for now.

#metascore_data <- html_nodes(webpage, '.favorable') %>% html_text()
#head(metascore_data)

#Removing '\n and excess ""
#metascore_data <- gsub(" " , "", metascore_data)
#metascore_data <- as.numeric(metascore_data)
#srt(metascore_data)


#Votes----------------------------------------------------
votes_data <- html_nodes(webpage, '.text-muted+ span:nth-child(2)') %>% html_text()
head(votes_data)

#Removing ","
votes_data <- gsub(",", "", votes_data)
votes_data <- as.numeric(votes_data)
str(votes_data)

#CSS was adding space in three first rows. Witht this we delete the extra 3 rows, and return to original length of 80.
votes_data <- votes_data[-c(1,2,3)]


#Gross Earning in Mil-------------------------------------
# 11 missing rows because there is no information in IMDB --will mute for now. 
#gross_data <- html_nodes(webpage, '.text-muted .ghost~ .text-muted+ span') %>% html_text()
#head(gross_data)

#Removing '$' and 'M' signs
#gross_data <- gsub("M","",gross_data) %>% html_text()
#head(gross_data)
#gross_data <- as.numeric(gross_data)
#str(gross_data)


#Director--------------------------------------------------
director_data <- html_nodes(webpage, '.text-muted a:nth-child(1)') %>% html_text()
head(director_data)


#Stars-----------------------------------------------------
stars_data <- html_nodes(webpage, '.lister-item-content .ghost+ a') %>% html_text()
head(stars_data)


#---> Combining into a DataFrame -----------------------------------------------------
#  Rank / Title / Description / Runtime / Genre / Metascore / Votes / Gross_Earning_in_Mil / Director / Stars

European_Film <- data.frame(Rank = rank_data, Title = title_data, Description = description_data, 
                            Runtime = runtime_data, Genre = genre_data, #Metascore = metascore_data, 
                            Votes = votes_data, #Gross = gross_data,
                            Director = director_data, Stars = stars_data)
View(European_Film)



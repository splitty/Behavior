closeAllConnections()
rm(list=ls())

if (!require(twitteR)) {install.packages("twitteR")}
if (!require(ROAuth)) {install.packages("ROAuth")}
library(twitteR)
library(ROAuth)


consumer_key = "5DIYmr1C6aWmIW8BCxGhsmse1"
consumer_secret = "WFL3YGwD54kFQBmf56FcpdEPqbjtf5RFb3MGLkN5SpW9WZ1UDq"
access_token = "1055161326027333633-EVFxDX9uNmcKzL9cReOEOVvOOJCcJN"
access_secret = "n9KIV6UpjcsSZTCpJjqsPObMpmUx32XF4oHhBesbRJKSd"
options(httr_oauth_cache=TRUE)
my_oauth <- setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

save(my_oauth, file = "my_oauth.Rdata")

availableTrendLocations()
worldy <- getTrends(2459115)
head(worldy$name,3)

#write.csv(worldy, "Worldtrends.csv")
mytime <- format(Sys.time(), "%b_%d_%H_%M_%S_%Y")
msg <- glue::glue("Current Time is {mytime} and trending topic is {head(worldy$name, n = 3)}")
cat(msg, file = "test.txt",sep="\n",append=TRUE)

tweets <- searchTwitter(worldy$name[1], n=1000, lang="en")
tweets.text <- sapply(tweets, function(x) x$getText())

#tweets <- searchTwitter(worldy$name[2], n=1000, lang="en")
#tweets.text <- sapply(tweets, function(x) x$getText())

#tweets <- searchTwitter(worldy$name[3], n=1000, lang="en")
#tweets.text <- sapply(tweets, function(x) x$getText())



#replace blank spaces
tweets.text <- gsub("rt", "", tweets.text)
#replace @UserName
tweets.text <- gsub("@\\w+", "", tweets.text)
#remove punctuation
tweets.text <- gsub("[[:punct:]]", "", tweets.text)
#remove links
tweets.text <- gsub("http\\w+", "", tweets.text)
#remove tabs
tweets.text <- gsub("[ |\t]{2,}", "", tweets.text)
#remove blank spaces at the beginning
tweets.text <- gsub("^ ", "", tweets.text)
#remove blank spaces at the end
tweets.text <- gsub(" $", "", tweets.text)

#convert all text to lower case
tweets.text <- tolower(tweets.text)


if(!require(tm)) {install.packages("tm")}
library(tm)
#create corpus
#clean up by removing stop words
myCorpus <- Corpus(VectorSource(tweets.text))
myCorpus <- tm_map(myCorpus, function(x) removeWords(x,stopwords()))

mytime <- format(Sys.time(), "%b_%d_%H_%M_%S_%Y")
myfile <- file.path(getwd(), paste(mytime,".png"))


if(!require(wordcloud)) {install.packages("wordcloud")}
library(wordcloud)
getwd()
png(myfile, width=6, height=6, units="in", res=300)
#generate wordcloud
wordcloud(myCorpus,min.freq = 20, scale=c(9,0.6), random.order = FALSE, max.words = 70)
dev.off()


if(!require(tidyverse)) {install.packages("tidyverse")}
if(!require(tidytext)) {install.packages("tidytext")}
if(!require(ggpubr)) {install.packages("ggpubr")}
if(!require(textdata)) {install.packages("textdata")}
if(!require(dplyr)) {install.packages("dplyr")}
library(dplyr)
library(tidytext)
library(ggpubr) 
library(tidyverse)
library(textdata)

subtweets <- searchTwitter(worldy$name[1], n=1000, lang="en")
dataTweets <- do.call("rbind", lapply(subtweets,as.data.frame))
tidy_tweets <- dataTweets %>% # pipe data frame 
  select(text)%>% # select variables of interest
  unnest_tokens(word, text) # splits column in one token per row format
my_stop_words <- tibble( #construct a dataframe
  word = c(
    "https",
    "t.co",
    "rt",
    "amp",
    "rstats",
    "gt"
  ),
  lexicon = "twitter"
)

all_stop_words <- stop_words %>%
  bind_rows(my_stop_words)

no_numbers <- tidy_tweets %>%
  filter(is.na(as.numeric(word)))

no_stop_words <- no_numbers %>%
  anti_join(all_stop_words, by = "word")

nrc <- get_sentiments("nrc")
nrc_words <- no_stop_words %>%
  inner_join(nrc, by="word")

pie_words<- nrc_words %>%
  group_by(sentiment) %>% # group by sentiment type
  tally %>% # counts number of rows
  arrange(desc(n)) 

pie_words_posNeg <- pie_words
pie_words_posNeg <- pie_words_posNeg %>% filter(sentiment=="positive" | sentiment == "negative")

pie_words_Else <- pie_words
pie_words_Else<- pie_words_Else %>% filter(sentiment !="positive")
pie_words_Else<- pie_words_Else %>% filter(sentiment !="negative")

mytime1 <- format(Sys.time(), "%H_%M_%S_%Y_%b_%d")
myfile1 <- file.path(getwd(), paste(mytime1,".png"))
getwd()
png(myfile1, width=6, height=6, units="in", res=300)

ggpubr::ggpie(head(pie_words_posNeg,2), "n", label = "sentiment", 
              lab.font = c(5, "bold", "white"),
              lab.pos = "in",
              palette = c("#FA3429", "#65DFF5" ),
              fill = "sentiment", color = "white"
              )

dev.off()

mytime1 <- format(Sys.time(), "%b_%d_%H_%M_%S_%Y")
myfile1 <- file.path(getwd(), paste(mytime1,".png"))
getwd()
png(myfile1, width=6, height=6, units="in", res=300)
head(pie_words_Else,8)
level_order <- factor(pie_words_Else, levels = c(head(pie_words_Else)))
ggpubr::ggpie(head(pie_words_Else,8), "n", label = "sentiment", 
              lab.font = c(4, "bold", "white"),
              palette = c("#4F4F4F", "#D4D4D4","#C4C4C4","#ABABAB","#9E9E9E","#7D7D7D","#595959","#2E2E2E"),
              lab.pos = "in", 
              fill = "sentiment", color = "white"
)

dev.off()




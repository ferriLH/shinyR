library(textclean)
library(katadasaR)
library(tokenizers)
library(dplyr)
library(mongolite)
library(rtweet)

# CONNECTION
url_path = 'mongodb+srv://ferrilasmihalim:n71mm1EoRhVstrH0@cluster0.vtl2z.mongodb.net/twitter_data?retryWrites=true&w=majority'
mng_connRaw <- mongo(collection = "twitterDataRaw", db = "twitter_data",
                  url = url_path,verbose = TRUE)
mng_connClean <- mongo(collection = "twitterDataTextCleaned", db = "twitter_data",
                      url = url_path,verbose = TRUE)

df_tweets<- read_twitter_csv(file.choose())
mng_connRaw$insert(df_tweets)
keeps <- c("status_id", "created_at","text")
df_tweets <- df_tweets[ , keeps, drop = FALSE]

# CASE FOLDING
df_tweets$text <- casefold(df_tweets$text)

# CLEANSING
df_tweets$text = gsub( "\n"," ",df_tweets$text) # remove enter
df_tweets$text = replace_url(df_tweets$text) # remove url
df_tweets$text = replace_emoji(df_tweets$text) # remove emoji
df_tweets$text = replace_html(df_tweets$text) # remove html text
df_tweets$text = replace_tag(df_tweets$text, pattern = "@([A-Za-z0-9_]+)",replacement="") # remove mentions
df_tweets$text = replace_hash(df_tweets$text, pattern = "#([A-Za-z0-9_]+)",replacement="") # remove hashtag
df_tweets$text = replace_white(df_tweets$text) # remove white space
df_tweets$text = strip(df_tweets$text) # remove non relevant symbol

# SLANGWORD CORRECTION
spell.lex <- read.csv("data/assets/colloquial-indonesian-lexicon.csv")
df_tweets$text = replace_internet_slang(df_tweets$text, slang = paste0("\\b",
                                                                       spell.lex$slang, "\\b"),
                                        replacement = spell.lex$formal, ignore.case = TRUE)

# TOKENIZING & STOPWORD REMOVAL
myStopwords <- readLines("data/assets/stopword_ID.txt")
df_tweets$text <- tokenize_words(df_tweets$text, stopwords = myStopwords)

# STEMMING
stemming <- function(x){
  paste(lapply(x,katadasaR),collapse = " ")
}
df_tweets$text <- lapply(df_tweets$text[], stemming)

# write_as_csv(df_tweets, "data/cleaned", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
mng_connClean$insert(df_tweets)

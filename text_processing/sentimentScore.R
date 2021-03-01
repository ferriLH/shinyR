library(rtweet)
library(plyr)
library(stringr)
library(mongolite)

mng_conn <- mongo(collection = "twitterDataTextCleaned", db = "twitter_data")

df_tweets <- read_twitter_csv(file.choose())

# add positive negative bank data
pos <- readLines("data/assets/positive.txt")
neg <- readLines("data/assets/negative.txt")

score.sentiment = function(tweets, pos.words, neg.words)
{
  require(plyr)
  require(stringr)
  
  scores = laply(tweets, function(tweet, pos.words, neg.words) {
    
    # Memecahkan kata menjadi perkata dan dimasukkan ke dalam list 
    word.list = str_split(tweet, '\\s+')
    
    # Mengubah list ke dalam vektor
    words = unlist(word.list)
    
    #  match () mengembalikan posisi istilah yang cocok atau NA
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # Mengubah kata yang yang cocok dalam bentuk True dan False
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    score = sum(pos.matches) - sum(neg.matches)
    return(score)
  }, pos.words, neg.words)
  
  scores.df = data.frame(score=scores, text=tweets)
  
  return(scores.df)
}

analysis = score.sentiment(df_tweets$text, pos, neg)
allData <- cbind(df_tweets, score = analysis$score)
mng_conn$insert(allData)

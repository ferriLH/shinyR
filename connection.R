#connection csv
#tweets<- read_twitter_csv("D:/R/rtweet/DATA/all.csv")
#df_tweets<-as.data.frame(tweets) 

# LOCAL CONNECTION
# conn_raw <- mongo(collection='twitterDataRaw',db='twitter_data');
# conn_cleaned <- mongo(collection='twitterDataTextCleaned',db='twitter_data');
# df_tweets <- as.data.frame(
#   conn_raw$find(
#     query = '{}',
#     field = '{"_id":0,"status_id":1,"created_at":1,"text":1}')
#   ) 
# df_tweetsCleaned<-as.data.frame(conn_cleaned$find('{}'))

# CLOUD CONNECTION
url_path = 'mongodb+srv://ferrilasmihalim:n71mm1EoRhVstrH0@cluster0.vtl2z.mongodb.net/twitter_data?retryWrites=true&w=majority'
conn_raw <- mongo(collection = "twitterDataRaw", db = "twitter_data",
                 url = url_path,verbose = TRUE)

conn_cleaned <- mongo(collection = "twitterDataTextCleaned", db = "twitter_data",
                     url = url_path,verbose = TRUE)

df_tweets <- as.data.frame(
  conn_raw$find(
    query = '{}',
    field = '{"_id":0,"status_id":1,"created_at":1,"screen_name":1,"text":1}')
  )
df_tweetsCleaned <- as.data.frame(
  conn_cleaned$find(
    query = '{}',
    field = '{"_id":0,"status_id":1,"text":1,"score":1}')
  )

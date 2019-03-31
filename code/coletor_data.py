import os

import tweepy
import pandas as pd

consumer_key = ''
consumer_secret = ''
access_token = ''
access_token_secret = ''
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)


api = tweepy.API(auth)

presidents_users = {'Dilma Rousseff': 'dilmabr', 
                    'Luíz Inácio Lula da Silva':'LulaOficial', 
                    'Michel Temer':'MichelTemer', 
                    'Jair Bolsonaro':'jairbolsonaro',
                    'Fernando Henrique Cardoso':'FHC',
                    'Fernando Collor de Mello' : 'Collor'                    
                    }

os.mkdirs('../data/csv')

for president_user in presidents_users.keys():
    print(president_user)

    all_tweets = []
    user = presidents_users[president_user]
    new_tweets = api.user_timeline(user, tweet_mode='extended', count=20000)
    all_tweets.extend(new_tweets)

    all_tweets = [[tweet.full_text.replace('\n',' '), tweet.retweet_count, tweet.favorite_count] for tweet in all_tweets]

    tweets_df = pd.DataFrame(all_tweets)
    tweets_df.columns = ['tweet','retweet','favoritos']
    tweets_df.to_csv('../data/csv' + president_user + '.csv', sep=';', encoding='utf-8')

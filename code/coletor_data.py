import os
import time

import tweepy
import pandas as pd

consumer_key = "lVblSgT1GVYXZRrUk61XbABvW"
consumer_secret = 'mmC5p4JhpIZh3o5C4ZiLKVYmRtq2tsOHyXMLIXUxSHrGky7HfT'
access_token = '2623510767-hjhrjRyat1RlCcIKpC2WjAWu8dPDUtjwJxmzuHI'
access_token_secret = '7g9e8LznJm3d9sF08CgNDeAemObI8PInQ9V1BKXZ417Iy'

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)


api = tweepy.API(auth)

presidents_users = {'Itamar Franco': 'itamarfranco',
                    'Fernando Collor de Mello' : 'Collor', 
                    'Dilma Rousseff': 'dilmabr', 
                    'Luiz Inacio Lula da Silva':'LulaOficial', 
                    'Michel Temer':'MichelTemer', 
                    'Jair Bolsonaro':'jairbolsonaro',
                    'Fernando Henrique Cardoso':'FHC'}

try:
    os.makedirs('../data/csv')
except FileExistsError:
    pass

for president_user in presidents_users.keys():
    print(president_user)
    all_tweets = []
    last = 0
    
    while True:
        user = presidents_users[president_user]
        temp = last
        
        if last==0:
            new_tweets = api.user_timeline(user, tweet_mode='extended', count=200)
        else:
            new_tweets = api.user_timeline(user, tweet_mode='extended', count=200, max_id=last)

        output = [[tweet.full_text.replace('\n',' '), tweet.retweet_count, tweet.favorite_count, tweet.id, tweet.created_at.strftime("%Y-%m-%d %H:%M:%S")] for tweet in new_tweets]

        last = output[-1][3]
        
        if temp==last:
            break
        
        all_tweets.extend(new_tweets)
        
        time.sleep(1)
        

    all_tweets = [[tweet.full_text.replace('\n',' '), tweet.retweet_count, tweet.favorite_count, tweet.id, tweet.created_at.strftime("%Y-%m-%d %H:%M:%S")] for tweet in all_tweets]
            
    tweets_df = pd.DataFrame(all_tweets)
    tweets_df.columns = ['tweet','retweet','favoritos', 'id', 'data']
    tweets_df.to_csv('../data/csv/' + president_user + '.csv', sep=';', encoding='utf-8')

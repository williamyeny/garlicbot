require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
end

def containsGarlic (str)
  return str.upcase.include? "GARLIC"
end

def followUser(name)
  name = name.tr("@", "")
  puts "Converted name: #{name}"
  begin
    client.follow(name)
  rescue
    puts "Error in attempting to follow user"
  end
end

while true
  client.search("garlic").take(100).each do |tweet|
    screen_name = tweet.user.screen_name
    tweet_words = tweet.text.split(" ")
    hasGarlic = false
    reply_to_garlic = false

    tweet_words.each do |word|
      #checks to see if the tweet is someone replying to some with a screen name of "garlic"
      if word.include?("@") && containsGarlic(word)
        puts "User was replying to #{word}"
        followUser(word)
        reply_to_garlic = true
      #see if it actually has garlic in the tweet
      elsif containsGarlic(word)
        hasGarlic = true
      end
    end

    #check if the user has "garlic" in their name and follows them if so
    if containsGarlic(screen_name)
      puts "Screen name detected: #{screen_name}"
      followUser(screen_name)
      sleep(1)
    end

    #retweets tweets with "garlic" in them and is not a reply
    if !reply_to_garlic && hasGarlic
      begin
        client.retweet tweet
        puts "RT: #{tweet.text}"
      rescue
        puts "Already retweeted or hit max limit of tweets"
        sleep(1) #prevents spam
        next
      end
      sleep(30)
    end
  end
end
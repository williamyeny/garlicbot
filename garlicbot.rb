require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "BBOCstVmaCnt8gjuFHBqgWTzu"
  config.consumer_secret     = "fiHvmHqQO09NmW5BOL532TfN86Ux5qa8saaUpoHV9rZH9346jb"
  config.access_token        = "2941485807-qVq2WrxqXdY9YZm28AEIeArNIJBRoN43f9Q0sqB"
  config.access_token_secret = "I5ZhyTCcw7Czgm0su8p02YLK0IttcKRSMcjH8bUHfEHoA"
end

# DELETE THIS LATER
puts "sleepy"
sleep(7200)

while true
  client.search("garlic").take(100).each do |tweet|
    
    screen_name = tweet.user.screen_name
    if !screen_name.include? "garlic"
      begin
        client.retweet tweet
        puts "RETWEETED"
      rescue
        puts "already retweeted or some other shit happened"
        next
      end
      sleep(30)
    else
      puts "screen name: " + screen_name
      client.follow(screen_name)
    end
  end
end
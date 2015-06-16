# encoding: UTF-8
require 'twitter_ebooks'

SPECIAL_WORDS = [ 'hypothenuse', 'algebra', 'antidisestablishmentarianism' ]
TOKEN_BLACKLIST = ['ebooks', 'bot', 'bots', 'to', 'the', 'a', 'twitter']
TOP_INTERESTING = 100
TOP_COOL = 20

class Content
    
    def initialize(bot = nil)
        ## The key element for our twitter bot is the model, yo
        ## use twitter-ebooks to generate it. Refer to its documentation for now
        @model = Ebooks::Model.load("model/test.model")
    end
    
    def get_tokens()
        ## 'special' , 'interesting' and 'cool' keywords ##
        ## these are keywords that make tweets more likely to get faved, RTed
        ## or replied (some restrictions in botconfig.rb apply)
        ## We simply get the most used keywords from the model.
        inter = @model.keywords.top(TOP_INTERESTING).map{ |s| s.to_s.downcase }
        cool = @model.keywords.top(TOP_COOL).map{ |s| s.to_s.downcase }
        ## Because of the most popular example, ebooks bots have become infamous
        ## for always favoriting tweets containing words like 'bot' and 'ebooks'.
        ## Although this template doesn't use those words in the SPECIAL_WORDS
        ## list. There's strill a risk they could be among the most used words
        ## in model, that's the reason for the BLACKLIST, it ignores those 
        ## words so they cannot become 'interesting' or 'cool'. Also other words
        ## that are very common in the language so you are likely to use them
        ## all the time.
        inter.delete_if { |x| TOKEN_BLACKLIST.include?(x) }
        cool.delete_if { |x| TOKEN_BLACKLIST.include?(x) }
        return SPECIAL_WORDS, inter, cool
    end
    
    def command(text)
        ## advanced , if bot owner sends the bot something starting with ! it is
        ## sent to this method. If nil is returned, the bot does nothing, else
        ## if a string is returned, the bot sends it back.
        return nil
    end
    
    def dm_response(user, text, lim)
        # How to reply to DMs with a text from user. lim is the limit (usually 140)
        # If return is nil , the bot won't reply.
        return @model.make_response(text, lim)
    end
    
    def tweet_response(tweet, text, lim)
        # How to reply to @-mentions.
        # text : Contains the contents of the tweet minus the @-mentions
        # lim  : Is the character limit for the reply. Don't exceed it.
        #        Because the bot needs to include other @-mentions in the reply
        #        this limit is not always 140.
        # tweet: Is an object from the sferik twitter library has 
        #
        return @model.make_response(text, lim)
    end
    
    def hello_world(lim)
        # Return a string to send by DM to the bot owner when the bot starts
        # execution, useful for debug purposes. But very annoying if always on
        # Leave nil so that nothing happens.
        return nil
    end
    
    def make_tweets(lim, special)
        # This just returns a tweet for the bot to make.
        return @model.make_statement(lim)
        
        # In reality there are many additional things we could do.
        # Refer to twitter-bot-template's documentation for more
    end
    
    def special_reply(tweet, meta)
        # This allows you to react to tweets in the time line. If the return
        # is a string, it will reply with that tweet (you need to include the
        # necessary @-s). If the return is nil, do nothing:
        return nil
    end
    
    
end


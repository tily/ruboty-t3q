# coding:utf-8

module Ruboty
  module Handlers
    class T3q < Base
      NAMESPACE = 't3q'

      env :TWITTER_MASTER_USERNAME, "twitter master username to watch"
      env :TUMBLR_CONSUMER_KEY, "tumblr consumer key"
      env :TUMBLR_CONSUMER_SECRET, "tumblr consumer secret"
      env :TUMBLR_ACCESS_TOKEN, "tumblr access token"
      env :TUMBLR_ACCESS_TOKEN_SECRET, "tumblr access token secret"
      env :TUMBLR_BLOG_NAME, "tumblr blog name"

      Tumblr.configure do |config|
        config.consumer_key = ENV['TUMBLR_CONSUMER_KEY']
        config.consumer_secret = ENV['TUMBLR_CONSUMER_SECRET']
        config.oauth_token = ENV['TUMBLR_ACCESS_TOKEN']
        config.oauth_token_secret = ENV['TUMBLR_ACCESS_TOKEN_SECRET']
      end

      on(
        /(?<title>.+)読始/,
        all: true,
        name: 'start_quoting',
        description: 'start quoting'
      )

      on(
        /「(?<text>.+)」/,
        all: true,
        name: 'quote',
        description: 'quote'
      )

      def start_quoting(message)
        title = message[:title]

        if message.original[:from] != twitter_master_username
          return
        end

        if !book(title).empty?
          dm "#{title}はすでにここで読み始めています #{book(title)['title_status_url']}"
        end

        book(title)['title_status_id'] = message.original[:tweet].try(:id)
        book(title)['title_status_url'] = message.original[:tweet].try(:url)
        dm "#{title}を読み始めました #{book(title)['title_status_url']}"
      end

      def quote(message)
        in_reply_to_status_id = message.original[:tweet].try(:in_reply_to_status_id)
        if book = data.find {|k, v| v['title_status_id'] == in_reply_to_status_id }
          response = tumblr.quote(tumblr_blog_name, quote: message[:text], source: book.first)
          dm "tumblr に投稿しました #{response["posts"]["post_url"]}"
	end
      end

      private

      def book(title)
        data[title] ||= {}
      end

      def data
        robot.brain.data[NAMESPACE] ||= {}
      end

      def twitter_master_username
        ENV['TWITTER_MASTER_USERNAME']
      end

      def tumblr_blog_name
        ENV['TUMBLR_BLOG_NAME']
      end

      def dm(text)
	twitter.create_direct_message(twitter_master_username, text)
      end

      def twitter
        robot.send(:adapter).send(:client)
      end

      def tumblr
        Tumblr::Client.new
      end
    end
  end
end

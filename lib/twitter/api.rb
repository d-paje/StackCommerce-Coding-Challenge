# An minimal interface to the Twitter API
# There's a gem that does this already but I figured this would be more fun
module Twitter
  class Api
    BASE_URL = 'https://api.twitter.com/1.1'

    # simple wrapper for twitter results
    class ApiResults
      attr_accessor :data, :error
    end

    # uses the timeline endpoint to return an ApiResult containing Tweet objects
    def self.timeline_for screen_name=nil, params={}
      query_params = {
        screen_name: screen_name,
        count: params[:count] || 25,
      }
      route = "#{BASE_URL}/statuses/user_timeline.json?#{query_params.to_query}"
      response = request(route)

      results = ApiResults.new
      body = JSON.parse(response.body)
      case response.code
      when '200'
        results.data = [].tap do |tweets|
          body.each do |obj|
            # we don't really need all of the data in each hash so pull out what we do need
            tweet = Twitter::Tweet.new(date: Time.zone.parse(obj['created_at']), 
                                       author: screen_name,
                                       id: obj['id'],
                                       content: obj['text'])
            tweets << tweet
          end
        end
      when '404'
        results.error = "#{screen_name} doesn't have a Twitter account :("
      else 
        # surface a friendly sounding error but log the response from twitter for later debugging
        # some api responses return an array of errors with codes
        (body['errors'] || []).each do |error|
          code = error['code']
          msg = error['message']
          Rails.logger.error("TWITTER_ERR: status #{response.code}, code: #{code}, error: #{msg}")
        end
        # others return a simple error message
        if msg = body['error']
          Rails.logger.error("TWITTER_ERR: status #{response.code}, #{msg}")
        end
        results.error = "Something's not quite right. We'll look into it and get back to you."
      end

      results
    end

    private

    # make a request to a specified Twitter API route
    def self.request route
      uri = URI(route)
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{ENV['TWITTER_ACCESS_TOKEN']}"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true # required by Twitter
      res = http.start { |http| http.request(req) }
    end
  end
end

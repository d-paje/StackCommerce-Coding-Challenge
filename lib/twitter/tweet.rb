module Twitter
  BASE_URL = 'https://twitter.com'
  
  class Tweet
    attr_reader :author, :date, :content, :id, :link
    def initialize author:, date:, content:, id:
      @author = author,
      @date = date
      @content = content
      @id = id
      @link = "#{BASE_URL}/#{author}/status/#{id}" 
    end
  end
end

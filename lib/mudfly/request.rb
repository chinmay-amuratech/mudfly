require 'faraday'

require 'mudfly/response/http_exception'

module Mudfly

  class Request

    def self.get(url, query_string = {})

      return perform(:get, url, query_string)   

    end

    def self.post(url, query_string = {})

      return perform(:post, url, query_string)

    end


    private

    def self.connection

      connection = Faraday::Connection.new({

        :url     => Mudfly.endpoint,
        :headers => { 'User-Agent' => Mudfly.user_agent }

      })

      connection.use Mudfly::Response::HttpException

      return connection

    end

    def self.perform(method, url, query_string = {})

      query_string[:prettyprint] = false
      query_string[:locale]      = Mudfly.locale
      query_string[:key]         = Mudfly.api_key


      response = connection.send(method) do |request|

        case method
        when :get
          request.url(url, query_string)
        when :post
          request.path = url
          request.body = query_string
        end

      end
      
      return response.body   

    end

  end # Request

end # Mudfly
# frozen_string_literal: true

require 'net/http'
require 'openssl'

module DeadFinder
  # HTTP client module
  module HttpClient
    def self.create(uri, options)
      begin
        proxy_uri = URI.parse(options['proxy']) if options['proxy'] && !options['proxy'].empty?
      rescue URI::InvalidURIError => e
        DeadFinder::Logger.error "Invalid proxy URI: #{options['proxy']} - #{e.message}"
        proxy_uri = nil # or handle the error as appropriate
      end
      http = if proxy_uri
               Net::HTTP.new(uri.host, uri.port,
                             proxy_uri.host, proxy_uri.port,
                             proxy_uri.user, proxy_uri.password)
             else
               Net::HTTP.new(uri.host, uri.port)
             end
      http.use_ssl = (uri.scheme == 'https')
      http.read_timeout = options['timeout'].to_i if options['timeout']
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?

      if options['proxy_auth'] && proxy_uri
        proxy_user, proxy_pass = options['proxy_auth'].split(':', 2)
        http.proxy_user = proxy_user
        http.proxy_pass = proxy_pass
      end

      http
    end
  end
end

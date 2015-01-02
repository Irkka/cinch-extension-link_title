require 'cinch'
require 'mechanize'
require 'uri'

require "cinch/extension/link_title/version"

module Cinch
  module Extension
    class LinkTitle
      include Cinch::Plugin

      URI_HTTP_REGEXP = URI.regexp(['http', 'https'])

      match /.*http.*/, use_prefix: false

      def execute(m)
        mechanize = Mechanize.new

        urls = URI.extract(m.message).collect { |url| url if URI_HTTP_REGEXP.match url }.compact

        titles = urls.collect do |url|
          page = mechanize.get(url)
          page.title
        end

        m.reply(titles.join(' | '))
      end
    end
  end
end

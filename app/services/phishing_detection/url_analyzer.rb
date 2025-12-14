# frozen_string_literal: true

module PhishingDetection
  class UrlAnalyzer < BaseAnalyzer
    SUSPICIOUS_TLDS = %w[.tk .ml .ga .cf .gq .xyz .top].freeze
    URL_SHORTENERS = %w[bit.ly tinyurl.com goo.gl t.co ow.ly].freeze

    def analyze
      extract_urls.each do |url|
        check_suspicious_tld(url)
        check_url_shortener(url)
        check_ip_address(url)
      end
      @indicators
    end

    private

    def indicator_type
      'url'
    end

    def extract_urls
      uri_regex = URI::DEFAULT_PARSER.make_regexp(%w[http https])
      [@email.body_plain, @email.body_html].compact.flat_map do |text|
        text.scan(uri_regex).flatten.compact
      end.uniq
    end

    def check_suspicious_tld(url)
      return unless SUSPICIOUS_TLDS.any? { |tld| url.downcase.include?(tld) }

      add_indicator('high', "Suspicious top-level domain detected in URL: #{url}", url)
    end

    def check_url_shortener(url)
      return unless URL_SHORTENERS.any? { |shortener| url.downcase.include?(shortener) }

      add_indicator('medium', "URL shortener detected: #{url}", url)
    end

    def check_ip_address(url)
      return unless url.match?(/\d+\.\d+\.\d+\.\d+/)

      add_indicator('high', "IP address-based URL detected: #{url}", url)
    end
  end
end

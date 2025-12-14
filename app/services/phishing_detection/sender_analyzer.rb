# frozen_string_literal: true

module PhishingDetection
  class SenderAnalyzer < BaseAnalyzer
    FREE_EMAIL_PROVIDERS = %w[gmail.com yahoo.com hotmail.com outlook.com aol.com mail.com yandex.com protonmail.com].freeze
    SUSPICIOUS_TLDS = %w[.tk .ml .ga .cf .gq .xyz .top .work .click .link .bid .party .trade .webcam .racing .review].freeze
    COMMON_BRAND_DOMAINS = %w[
      microsoft.com apple.com amazon.com paypal.com bankofamerica.com chase.com wellsfargo.com
      google.com facebook.com twitter.com instagram.com linkedin.com netflix.com adobe.com
    ].freeze

    def analyze
      check_free_email_provider
      check_suspicious_sender_name
      check_suspicious_domain
      check_domain_spoofing
      check_numeric_domain
      @indicators
    end

    private

    def indicator_type
      'sender'
    end

    def sender_domain
      @sender_domain ||= @email.sender_email.split('@').last&.downcase
    end

    def check_free_email_provider
      return unless FREE_EMAIL_PROVIDERS.include?(sender_domain)

      add_indicator('low', "Email from free provider: #{sender_domain}", sender_domain)
    end

    def check_suspicious_sender_name
      suspicious_keywords = %w[admin support noreply no-reply service helpdesk security urgent]
      name = @email.sender_name.downcase

      suspicious_keywords.each do |keyword|
        next unless name.include?(keyword)

        add_indicator('medium', "Generic sender name detected: #{@email.sender_name}", keyword)
        break
      end
    end

    def check_suspicious_domain
      return unless sender_domain

      # Check for suspicious TLDs
      SUSPICIOUS_TLDS.each do |tld|
        next unless sender_domain.end_with?(tld)

        add_indicator('high', "Suspicious sender domain TLD: #{sender_domain}", tld)
        break
      end

      # Check for IP-based domains (rare in legitimate emails)
      if sender_domain =~ /^\d+\.\d+\.\d+\.\d+$/
        add_indicator('critical', "Sender uses IP address instead of domain: #{sender_domain}", 'ip-address')
      end
    end

    def check_domain_spoofing
      return unless sender_domain

      # Check for typosquatting/lookalike domains of major brands
      COMMON_BRAND_DOMAINS.each do |brand|
        brand_name = brand.split('.').first

        # Check if sender name claims to be from a brand but domain doesn't match
        if @email.sender_name.downcase.include?(brand_name) && !sender_domain.include?(brand_name)
          add_indicator('critical', "Sender name claims '#{brand_name}' but domain is #{sender_domain}", 'brand-mismatch')
          break
        end

        # Check for common character substitutions (e.g., micros0ft.com, g00gle.com)
        next unless sender_domain.include?(brand_name.tr('o', '0').tr('i', '1').tr('l', '1')) ||
                    sender_domain.include?(brand_name.tr('o', '0')) ||
                    sender_domain.include?(brand_name.tr('i', '1'))

        add_indicator('critical', "Possible domain spoofing detected: #{sender_domain}", 'lookalike-domain')
        break
      end
    end

    def check_numeric_domain
      return unless sender_domain

      # Count numeric characters in domain (excluding TLD)
      domain_without_tld = sender_domain.split('.').first
      numeric_count = domain_without_tld.scan(/\d/).length

      # If domain has excessive numbers, it might be suspicious
      if numeric_count >= 3
        add_indicator('medium', "Domain contains excessive numbers: #{sender_domain}", 'numeric-domain')
      end
    end
  end
end

# frozen_string_literal: true

module PhishingDetection
  class AttachmentAnalyzer < BaseAnalyzer
    def analyze
      # For demo purposes, we'll check if body mentions attachments
      check_mentioned_attachments
      @indicators
    end

    private

    def indicator_type
      'attachment'
    end

    def check_mentioned_attachments
      attachment_keywords = ['attachment', 'attached', 'download', 'file', 'document', '.exe', '.zip', '.pdf']
      content = [@email.subject, @email.body_plain].join(' ').downcase

      attachment_keywords.each do |keyword|
        next unless content.include?(keyword)

        severity = %w[.exe .scr .bat].any? { |ext| content.include?(ext) } ? 'critical' : 'low'
        add_indicator(severity, "Attachment-related content detected: '#{keyword}'", keyword)
        break
      end
    end
  end
end

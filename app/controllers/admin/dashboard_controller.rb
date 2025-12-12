# frozen_string_literal: true

class Admin::DashboardController < ApplicationController
  def index
    @total_emails = Email.count
    @total_reports = Report.count
    @phishing_emails = Email.phishing.count

    @risk_distribution = ThreatScore.group(:risk_level).count
    @common_indicators = PhishingIndicator.group(:description).count.sort_by { |_k, v| -v }.first(10)
  end
end

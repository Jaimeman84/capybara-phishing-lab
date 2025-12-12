# frozen_string_literal: true

class ReportsController < ApplicationController
  def create
    @email = Email.find(params[:email_id])

    if @email.reported?
      redirect_to email_path(@email), notice: 'This email has already been reported.'
      return
    end

    @report = @email.create_report!
    PhishingDetectionService.new(@email).analyze

    redirect_to email_path(@email), notice: 'Email reported and analyzed successfully.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to email_path(@email), alert: "Error: #{e.message}"
  end
end

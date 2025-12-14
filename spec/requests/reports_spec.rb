# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :request do
  describe 'POST /create' do
    it 'creates a report and redirects' do
      email = Email.create!(
        sender_name: 'Test Sender',
        sender_email: 'test@example.com',
        recipient_email: 'user@company.com',
        subject: 'Test Email',
        body_plain: 'Test body',
        received_at: Time.current
      )

      post '/reports', params: { email_id: email.id }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(email_path(email))
    end
  end
end

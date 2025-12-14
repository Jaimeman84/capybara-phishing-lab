require 'rails_helper'

RSpec.describe "Emails", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/emails"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      email = Email.create!(
        sender_name: "Test Sender",
        sender_email: "test@example.com",
        recipient_email: "user@company.com",
        subject: "Test Email",
        body_plain: "Test body",
        received_at: Time.current
      )
      get "/emails/#{email.id}"
      expect(response).to have_http_status(:success)
    end
  end

end

require 'rails_helper'

RSpec.describe "Waves", type: :request do
  describe "GET #waves" do
    it "returns http success" do
      post "/waves", params: { wave: { csv: "test" } }
      expect(response).to have_http_status(:success)
    end
  end
end

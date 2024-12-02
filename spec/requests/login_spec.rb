require "rails_helper"

RSpec.describe "/login", type: :request do
  describe "GET /login" do
    it "should return 200" do
      get "/login"

      expect(response.status).to eq 200
    end
  end

  describe "POST /session" do
    context "when user is not authenticated" do
      context "when no user data in database" do
        it "should return 401" do
          post "/login", params: {
            email: "activity-pub-relay@example.com",
            password: "activity-pub-relay-pass"
          }

          expect(response.status).to eq 401
        end
      end

      context "when user data in database" do
        before do
          create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
        end

        context "when wrong user email address given" do
          it "should return 401" do
            post "/login", params: {
              email: "wrong@example.com",
              password: "activity-pub-relay-pass"
            }

            expect(response.status).to eq 401
          end
        end

        context "when wrong user password given" do
          it "should return 401" do
            post "/login", params: {
              email_address: "activity-pub-relay@example.com",
              password: "wrong-pass"
            }

            expect(response.status).to eq 401
          end
        end

        context "when correct user email address and password given" do
          it "should redirect to /dashboard" do
            post "/login", params: {
              email: "activity-pub-relay@example.com",
              password: "activity-pub-relay-pass"
            }

            expect(response).to redirect_to dashboard_path
          end
        end
      end
    end

    context "when user is authenticated" do
      before do
        create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
        login("activity-pub-relay@example.com", "activity-pub-relay-pass")
      end

      it "should redirect /dashboard" do
        post "/login", params: {
          email: "activity-pub-relay@example.com",
          password: "activity-pub-relay-pass"
        }

        expect(response).to redirect_to dashboard_path
      end
    end
  end
end

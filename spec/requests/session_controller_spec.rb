require "rails_helper"

RSpec.describe "/session", type: :request do
  describe "GET /session/new" do
    it "should return 200" do
      get "/session/new"

      expect(response.status).to eq 200
    end
  end

  describe "POST /session" do
    context "when user is not authenticated" do
      context "when no user data in database" do
        it "should redirect to /session/new" do
          post "/session", params: {
            email_address: "activity-pub-relay@example.com",
            password: "activity-pub-relay-pass"
          }

          expect(response).to redirect_to new_session_path
        end
      end

      context "when user data in database" do
        before do
          create(:user, email_address: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
        end

        context "when wrong user email address given" do
          it "should redirect to /session/new" do
            post "/session", params: {
              email_address: "wrong@example.com",
              password: "activity-pub-relay-pass"
            }

            expect(response).to redirect_to new_session_path
          end
        end

        context "when wrong user password given" do
          it "should redirect to /session/new" do
            post "/session", params: {
              email_address: "activity-pub-relay@example.com",
              password: "wrong-pass"
            }

            expect(response).to redirect_to new_session_path
          end
        end

        context "when correct user email address and password given" do
          it "should redirect to /dashboard" do
            post "/session", params: {
              email_address: "activity-pub-relay@example.com",
              password: "activity-pub-relay-pass"
            }

            expect(response).to redirect_to dashboard_path
          end
        end
      end
    end

    context "when user is authenticated" do
      let(:user) { create(:user) }

      before do
        login_as(user)
      end

      it "should redirect /dashboard" do
        post "/session", params: {
          email_address: "activity-pub-relay@example.com",
          password: "activity-pub-relay-pass"
        }

        expect(response).to redirect_to dashboard_path
      end
    end
  end
end

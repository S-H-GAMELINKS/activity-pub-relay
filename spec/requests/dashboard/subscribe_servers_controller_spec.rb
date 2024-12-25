require "rails_helper"

RSpec.describe "/dashboard/subscribe_servers", type: :request do
  describe "GET /dashboard/subscribe_servers" do
    context "when user is not authenticated" do
      it "should redirect /login" do
        get "/dashboard/subscribe_servers"

        expect(response.status).to eq 302
        expect(response).to redirect_to "/login"
      end
    end

    context "when user is authenticated" do
      before do
        create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
        login("activity-pub-relay@example.com", "activity-pub-relay-pass")
      end

      it "should return 200" do
        get "/dashboard/subscribe_servers"

        expect(response.status).to eq 200
      end
    end
  end

  describe "GET /dashboard/subscribe_servers/:id" do
    let(:subscribe_server) { create(:subscribe_server) }

    context "when user is not authenticated" do
      it "should redirect /login" do
        get "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response.status).to eq 302
        expect(response).to redirect_to "/login"
      end
    end

    context "when user is authenticated" do
      before do
        create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
        login("activity-pub-relay@example.com", "activity-pub-relay-pass")
      end

      context "when subscribe_server is not exist" do
        let(:not_exist_subscribe_server_id) { subscribe_server.id.succ }

        it "should return 404" do
          get "/dashboard/subscribe_servers/#{not_exist_subscribe_server_id}"

          expect(response.status).to eq 404
        end
      end

      context "when subscribe_server is exist" do
        it "should return 200" do
          get "/dashboard/subscribe_servers/#{subscribe_server.id}"

          expect(response.status).to eq 200
        end
      end
    end
  end

  describe "GET /dashboard/subscribe_servers/:id/edit" do
    let(:subscribe_server) { create(:subscribe_server) }

    context "when user is not authenticated" do
      it "should redirect to /login" do
        get "/dashboard/subscribe_servers/#{subscribe_server.id}/edit"

        expect(response.status).to eq 302
        expect(response).to redirect_to "/login"
      end
    end

    context "when user is authenticated" do
      before do
        create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
        login("activity-pub-relay@example.com", "activity-pub-relay-pass")
      end

      context "when subscribe_server is not exist" do
        let(:not_exist_subscribe_server_id) { subscribe_server.id.succ }

        it "should return 404" do
          get "/dashboard/subscribe_servers/#{not_exist_subscribe_server_id}/edit"

          expect(response.status).to eq 404
        end
      end

      context "when subscribe_server is exist" do
        it "should return 200" do
          get "/dashboard/subscribe_servers/#{subscribe_server.id}/edit"

          expect(response.status).to eq 200
        end
      end
    end
  end

  describe "PUT /dashboard/subscribe_servers/:id" do
    let(:subscribe_server) { create(:subscribe_server) }

    context "when user is not authenticated" do
      it "should redirect /login" do
        put "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response.status).to eq 302
        expect(response).to redirect_to "/login"
      end
    end

    context "when user is authenticated" do
      before do
        create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
        login("activity-pub-relay@example.com", "activity-pub-relay-pass")
      end

      context "when subscribe_server is not exist" do
        let(:not_exist_subscribe_server_id) { subscribe_server.id.succ }

        it "should return 404" do
          put "/dashboard/subscribe_servers/#{not_exist_subscribe_server_id}"

          expect(response.status).to eq 404
        end
      end

      context "when subscribe_server is exist" do
        context "when domain is blank" do
          before do
            put "/dashboard/subscribe_servers/#{subscribe_server.id}", params: {
              subscribe_server: {
                domain: "",
                inbox_url: "https://www.example.com/inbox",
                delivery_suspend: false
              }
            }
          end

          it "should return 422" do
            expect(response.status).to eq 422
          end
        end

        context "when inbox_url is blank" do
          before do
            put "/dashboard/subscribe_servers/#{subscribe_server.id}", params: {
              subscribe_server: {
                domain: "www.example.com",
                inbox_url: "",
                delivery_suspend: false
              }
            }
          end

          it "should return 422" do
            expect(response.status).to eq 422
          end
        end

        context "when domain and inbox_url are present. also correct delivery_suspend is set" do
          before do
            put "/dashboard/subscribe_servers/#{subscribe_server.id}", params: {
              subscribe_server: {
                domain: "www.example.com",
                inbox_url: "https://www.example.com/inbox",
                delivery_suspend: true
              }
            }
          end

          it "should return 302" do
            expect(response.status).to eq 302
          end

          it "should redirect to /dashboard/subscribe_servers/:id" do
            expect(response).to redirect_to dashboard_subscribe_server_path(subscribe_server)
          end
        end
      end

      it "should return 200" do
        get "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response.status).to eq 200
      end
    end
  end

  describe "DELETE /dashboard/subscribe_servers/:id" do
    let(:subscribe_server) { create(:subscribe_server) }

    context "when user is not authenticated" do
      it "should redirect /login" do
        delete "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response.status).to eq 302
        expect(response).to redirect_to "/login"
      end
    end

    context "when user is authenticated" do
      before do
        create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
        login("activity-pub-relay@example.com", "activity-pub-relay-pass")
      end

      it "should redirect to /dashboard/subscribe_servers" do
        delete "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response).to redirect_to dashboard_subscribe_servers_path
      end
    end
  end
end

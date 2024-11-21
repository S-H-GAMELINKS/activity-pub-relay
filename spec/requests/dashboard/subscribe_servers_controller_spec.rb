require "rails_helper"

RSpec.describe "/dashboard/subscribe_servers", type: :request do
  describe "GET /dashboard/subscribe_servers" do
    context "when user is not authenticated" do
      it "should return 404" do
        get "/dashboard/subscribe_servers"

        expect(response.status).to eq 404
      end
    end

    context "when user is authenticated" do
      before do
        allow_any_instance_of(Authentication).to receive(:require_authentication).and_return(true)
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
      it "should return 404" do
        get "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response.status).to eq 404
      end
    end

    context "when user is authenticated" do
      before do
        allow_any_instance_of(Authentication).to receive(:require_authentication).and_return(true)
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
      it "should redirect to /new/session" do
        get "/dashboard/subscribe_servers/#{subscribe_server.id}/edit"

        expect(response.status).to eq 404
      end
    end

    context "when user is authenticated" do
      before do
        allow_any_instance_of(Authentication).to receive(:require_authentication).and_return(true)
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
      it "should return 404" do
        put "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response.status).to eq 404
      end
    end

    context "when user is authenticated" do
      before do
        allow_any_instance_of(Authentication).to receive(:require_authentication).and_return(true)
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
              domain: "",
              inbox_url: "https://www.example.com/inbox"
            }
          end

          it "should return 302" do
            expect(response.status).to eq 302
          end

          it "should redirect to /dashboard/subscribe_servers/:id" do
            expect(response).to redirect_to dashboard_subscribe_server_path(subscribe_server)
          end
        end

        context "when inbox_url is blank" do
          before do
            put "/dashboard/subscribe_servers/#{subscribe_server.id}", params: {
              domain: "www.example.com",
              inbox_url: ""
            }
          end

          it "should return 302" do
            expect(response.status).to eq 302
          end

          it "should redirect to /dashboard/subscribe_servers/:id" do
            expect(response).to redirect_to dashboard_subscribe_server_path(subscribe_server)
          end
        end

        context "when domain and inbox_url are present" do
          before do
            put "/dashboard/subscribe_servers/#{subscribe_server.id}", params: {
              domain: "www.example.com",
              inbox_url: "https://www.example.com/inbox"
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
      it "should return 404" do
        delete "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response.status).to eq 404
      end
    end

    context "when user is authenticated" do
      before do
        allow_any_instance_of(Authentication).to receive(:require_authentication).and_return(true)
      end

      it "should redirect to /dashboard/subscribe_servers" do
        delete "/dashboard/subscribe_servers/#{subscribe_server.id}"

        expect(response).to redirect_to dashboard_subscribe_servers_path
      end
    end
  end
end

class Dashboard::SubscribeServersController < ApplicationController
  before_action :set_subscribe_server, only: %i[ show edit update destroy ]

  layout "dashboard"

  # GET /dashboard/subscribe_servers or /dashboard/subscribe_servers.json
  def index
    @subscribe_servers = SubscribeServer.all
  end

  # GET /dashboard/subscribe_servers/1 or /dashboard/subscribe_servers/1.json
  def show
  end

  # GET /dashboard/subscribe_servers/1/edit
  def edit
  end

  # PATCH/PUT /dashboard/subscribe_servers/1 or /dashboard/subscribe_servers/1.json
  def update
    respond_to do |format|
      if @subscribe_server.update(subscribe_server_params)
        format.html { redirect_to [ :dashboard, @subscribe_server ], notice: "Subscribe server was successfully updated." }
        format.json { render :show, status: :ok, location: @subscribe_server }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subscribe_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboard/subscribe_servers/1 or /dashboard/subscribe_servers/1.json
  def destroy
    @subscribe_server.destroy!

    respond_to do |format|
      format.html { redirect_to dashboard_subscribe_servers_path, status: :see_other, notice: "Subscribe server was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscribe_server
      @subscribe_server = SubscribeServer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def subscribe_server_params
      params.expect(subscribe_server: [ :domain, :inbox_url, :delivery_suspend, :domain_block ])
    end
end

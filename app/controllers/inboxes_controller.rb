class InboxesController < ApplicationController
  def create
    render plain: "OK", status: :accepted
  end
end

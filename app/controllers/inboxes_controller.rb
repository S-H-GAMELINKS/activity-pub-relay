# frozen_string_literal: true

# :nodoc:
class InboxesController < ApplicationController
  def create
    account = SignatureVerification.call(request)
    if !account && blocked_domain?
      render plain: 'not accepted', status: :unauthorized
    else
      render plain: 'accepted', status: :accepted
    end
  end

  private

  def blocked_domain?
    Block.exists?(domain: params[:domain])
  end
end

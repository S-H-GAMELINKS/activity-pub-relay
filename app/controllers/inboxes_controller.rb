class InboxesController < ApplicationController
  def create
    body = Oj.load(request.body.read.force_encoding("UTF-8"), mode: :null)

    account = SignatureVerificater.new(request.method, request.path, request.headers, body, request.raw_post).call

    if account.present?
      InboxProcessJob.perform_later(account, body)
      head :accepted
    else
      head :unauthorized
    end
  end
end

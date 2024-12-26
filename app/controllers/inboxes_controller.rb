class InboxesController < ApiController
  def create
    body = Oj.load(request.body.read.force_encoding("UTF-8"), mode: :null)

    account = SignatureVerificater.new(request.method, request.path, request.headers, body, request.raw_post).call

    if domain_blocked?(account)
      head :unauthorized and return
    end

    if account.present?
      InboxProcessJob.perform_later(account, body)
      head :accepted
    else
      head :unauthorized
    end
  end

  private

  def domain_blocked?(account)
    domain = URI.parse(account["id"]).normalize.host
    SubscribeServer.exists?(domain:, domain_block: true)
  end
end

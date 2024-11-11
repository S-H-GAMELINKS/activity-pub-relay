class ActivityPubTypeHandler
  def initialize(json)
    @json = json
  end

  def call
    if follow?
      :follow
    else
      :none
    end
  end

  private

  def follow?
    @json["type"] == "Follow"
  end
end

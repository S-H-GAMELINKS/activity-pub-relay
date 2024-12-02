module SessionHelpers
  def login(email, password)
    post "/login", params: { email:, password: }
  end
end

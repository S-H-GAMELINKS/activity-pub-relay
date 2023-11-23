# frozen_string_literal: true

require 'rails_helper'

describe '/inbox' do
  before do
    post '/inbox'
  end

  it 'returns http accepted' do
    expect(response).to have_http_status(:accepted)
  end
end

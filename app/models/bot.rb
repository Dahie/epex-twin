# frozen_string_literal: true

require 'mastodon'

class Bot
  def initialize(mastodon_url, access_token)
    @mastodon_client =
      ::Mastodon::REST::Client.new(
        base_url:     mastodon_url,
        bearer_token: access_token,
        timeout:      {
          read: 10,
        },
        )
  end

  private

  def post_message(message)
    @mastodon_client.create_status(message)
  end
end

defmodule OAuth2ExSampleTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    # ExVCR.Config.filter_url_params(true)
    # ExVCR.Config.filter_sensitive_data("oauth_signature=[^\"]+", "<REMOVED>")
    # ExVCR.Config.filter_sensitive_data("guest_id=.+;", "<REMOVED>")

    # ExTwitter.configure(
    #   consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
    #   consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
    #   access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
    #   access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
    # )

    :ok
  end
end
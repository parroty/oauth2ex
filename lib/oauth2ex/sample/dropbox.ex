defmodule OAuth2Ex.Sample.Dropbox do
  @moduledoc """
  Sample setting for Dropbox OAuth 2.0 API.

  API: https://www.dropbox.com/developers/core/docs
  App: https://www.dropbox.com/developers/apps/
  """

  use OAuth2Ex.Client

  @doc """
  Client configuration for specifying required parameters
  for accessing OAuth 2.0 server.
  """
  def config do
    OAuth2Ex.config(
      id:             System.get_env("DROPBOX_API_CLIENT_ID"),
      secret:         System.get_env("DROPBOX_API_CLIENT_SECRET"),
      authorize_url:  "https://www.dropbox.com/1/oauth2/authorize",
      token_url:      "https://api.dropbox.com/1/oauth2/token",
      scope:          [],
      callback_url:   "http://localhost:3000",
      token_store:    %OAuth2Ex.FileStorage{
                       file_path: System.user_home <> "/oauth2ex.dropbox.token"},
      client_options: [receiver_port: 3000, timeout: 60_000]
    )
  end

  @doc """
  List the accounts by calling Dropwbox API.
  API: https://www.dropbox.com/developers/core/docs#account-info
  """
  def get_account do
    response = OAuth2Ex.HTTP.get(token, "https://api.dropbox.com/1/account/info")
    response.body |> JSX.decode!
  end
end

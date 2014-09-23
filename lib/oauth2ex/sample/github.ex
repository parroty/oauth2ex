defmodule OAuth2Ex.Sample.GitHub do
  @moduledoc """
  Sample setting for GitHub OAuth 2.0 API.

  API: https://developer.github.com/v3/oauth/
  App: https://github.com/settings/applications
  """

  use OAuth2Ex.Client

  @doc """
  Client configuration for specifying required parameters
  for accessing OAuth 2.0 server.
  """
  def config do
    OAuth2Ex.config(
      id:            System.get_env("GITHUB_API_CLIENT_ID"),
      secret:        System.get_env("GITHUB_API_CLIENT_SECRET"),
      authorize_url: "https://github.com/login/oauth/authorize",
      token_url:     "https://github.com/login/oauth/access_token",
      scope:         ["public_repo"],
      callback_url:  "http://localhost:4000",
      token_store:   %OAuth2Ex.FileStorage{
                       file_path: System.user_home <> "/oauth2ex.github.token"}
    )
  end

  @doc """
  List the authorizations by calling GitHub API.
  API: https://developer.github.com/v3/oauth_authorizations/
  """
  def get_authorization do
    response = OAuth2Ex.HTTP.get(token, "https://api.github.com/authorizations")
    response.body |> JSEX.decode!
  end
end

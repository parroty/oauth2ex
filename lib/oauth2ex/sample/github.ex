defmodule OAuth2Ex.Sample.GitHub do
  @moduledoc """
  Sample setting for GitHub OAuth2.0 API.

  API: https://developer.github.com/v3/oauth/
  App: https://github.com/settings/applications
  """

  defmodule Client do
    use OAuth2Ex.Client

    def config do
      OAuth2Ex.config(
        id:            System.get_env("GITHUB_API_CLIENT_ID"),
        secret:        System.get_env("GITHUB_API_CLIENT_SECRET"),
        authorize_url: "https://github.com/login/oauth/authorize",
        token_url:     "https://github.com/login/oauth/access_token",
        scope:         ["public_repo"],
        callback_url:  "http://localhost:4000",
        token_store:   System.user_home <> "/oauth2ex.github.token",
        header_prefix: "token" # Authorization: token OAUTH-TOKEN
      )
    end
  end

  def request_token do
    {:ok, message} = Client.request_token(port: 4000)
    IO.puts message
  end

  def get_authorization do
    response = Client.get("https://api.github.com/authorizations")
    response.body |> JSEX.decode!
  end
end

defmodule OAuth2Ex.Sample.Google do
  @moduledoc """
  Sample setting for Google OAuth2.0 API.

  API: https://developers.google.com/accounts/docs/OAuth2
  """

  defmodule Client do
    use OAuth2Ex.Client

    def config do
      OAuth2Ex.config(
        id:            System.get_env("GOOGLE_API_CLIENT_ID"),
        secret:        System.get_env("GOOGLE_API_CLIENT_SECRET"),
        authorize_url: "https://accounts.google.com/o/oauth2/auth",
        token_url:     "https://accounts.google.com/o/oauth2/token",
        scope:         "https://www.googleapis.com/auth/bigquery",
        callback_url:  "http://localhost:4000",
        token_store:   System.user_home <> "/oauth2ex.google.token"
      )
    end
  end

  def request_token do
    {:ok, message} = Client.request_token(port: 4000)
    IO.puts message
  end

  def projects do
    response = Client.get("https://www.googleapis.com/bigquery/v2/projects")
    response.body |> JSEX.decode!
  end
end

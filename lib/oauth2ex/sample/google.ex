defmodule OAuth2Ex.Sample.Google do
  @moduledoc """
  Sample setting for Google OAuth 2.0 API.

  API: https://developers.google.com/accounts/docs/OAuth2
  """

  defmodule Client do
    @moduledoc """
    Client configuration for specifying required parameters
    for accessing OAuth 2.0 server.
    """

    use OAuth2Ex.Client

    def config do
      OAuth2Ex.config(
        id:            System.get_env("GOOGLE_API_CLIENT_ID"),
        secret:        System.get_env("GOOGLE_API_CLIENT_SECRET"),
        authorize_url: "https://accounts.google.com/o/oauth2/auth",
        token_url:     "https://accounts.google.com/o/oauth2/token",
        scope:         "https://www.googleapis.com/auth/bigquery",
        callback_url:  "http://localhost:4000",
        token_store:   %OAuth2Ex.FileStorage{file_name: System.user_home <> "/oauth2ex.google.token"}
      )
    end
  end

  @doc """
  Retrieve the OAuth token from the server, and store to the file
  in the specified token_store, and then return the token.
  """
  def retrieve_token do
    Client.retrieve_token!(receiver_port: 4000)
  end

  @doc """
  Refresh the OAuth access_token from the refresh_token, as
  Google's access token has expiration time.
  """
  def refresh_token, do: Client.refresh_token

  @doc """
  List the projects by calling Google BigQuery API.
  API: https://developers.google.com/bigquery/docs/reference/v2/#Projects
  """
  def projects do
    response = OAuth2Ex.HTTP.get(
                 Client.token, "https://www.googleapis.com/bigquery/v2/projects")
    response.body |> JSEX.decode!
  end
end

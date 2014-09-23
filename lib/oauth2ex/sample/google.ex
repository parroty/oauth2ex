defmodule OAuth2Ex.Sample.Google do
  @moduledoc """
  Sample setting for Google OAuth 2.0 API.

  API: https://developers.google.com/accounts/docs/OAuth2
  """

  use OAuth2Ex.Client

  @doc """
  Client configuration for specifying required parameters
  for accessing OAuth 2.0 server.
  """
  def config do
    OAuth2Ex.config(
      id:            System.get_env("GOOGLE_API_CLIENT_ID"),
      secret:        System.get_env("GOOGLE_API_CLIENT_SECRET"),
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url:     "https://accounts.google.com/o/oauth2/token",
      scope:         "https://www.googleapis.com/auth/bigquery",
      callback_url:  "http://localhost:4000",
      token_store:   %OAuth2Ex.FileStorage{
                       file_path: System.user_home <> "/oauth2ex.google.token"}
    )
  end

  @doc """
  List the projects by calling Google BigQuery API.
  API: https://developers.google.com/bigquery/docs/reference/v2/#Projects
  """
  def projects do
    response = OAuth2Ex.HTTP.get(token, "https://www.googleapis.com/bigquery/v2/projects")
    response.body |> JSEX.decode!
  end
end

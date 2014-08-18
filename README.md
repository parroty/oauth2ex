# OAuth2Ex


A OAuth 2.0 client library for elixir. It provides the following functionalities.
- OAuth token retrieval by communicating with OAuth 2.0 server.
- Caching the acquired token locally, and refreshing the token when the it's expired.
- HTTP client access by specifying OAuth2 access token.


### Usage
#### Web Application

#### Stand-alone Application
The following is an example to call Google's BigQuery API.
- The `retrieve_token` method retrieves the OAuth token and store it locally.
    - This method-call starts up local web server with specified :receiver_port to receive callback from OAuth 2.0 server.
- The `project` method calls Google's BigQuery API using the pre-acquired OAuth token.

```Elixir
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
        token_store:   System.user_home <> "/oauth2ex.google.token"
      )
    end
  end

  @doc """
  Retrieve the OAuth token from the server, and store to the file
  in the specified token_store path.
  """
  def retrieve_token do
    {:ok, message} = Client.retrieve_token(receiver_port: 4000)
    IO.puts message
  end

  @doc """
  List the projects by calling Google BigQuery API - project list.
  API: https://developers.google.com/bigquery/docs/reference/v2/#Projects
  """
  def projects do
    response = Client.get("https://www.googleapis.com/bigquery/v2/projects")
    response.body |> JSEX.decode!
  end
end
```

# OAuth2Ex


An OAuth 2.0 client library for elixir. It provides the following functionalities.
- OAuth token retrieval by communicating with OAuth 2.0 server.
- Caching the acquired token locally, and refreshing the token when the it's expired.
- HTTP client access by specifying OAuth2 access token.

It's pretty much work in progress yet, and APIs will likely to be change.
The `OAuth2Ex.Sample` modules contains example for several API servers, like Google, GitHub and Dropbox.

### Usage
The following is an example to call Google's BigQuery API.

#### Manual token retrieval using browser
An example to uses OAuth2Ex helper methods to retrieve OAuth token.

```Elixir
# Setup config parameters (retrive required parameters from OAuth 2.0 providers).
config = OAuth2Ex.config(
  id:            System.get_env("GOOGLE_API_CLIENT_ID"),
  secret:        System.get_env("GOOGLE_API_CLIENT_SECRET"),
  authorize_url: "https://accounts.google.com/o/oauth2/auth",
  token_url:     "https://accounts.google.com/o/oauth2/token",
  scope:         "https://www.googleapis.com/auth/bigquery",
  callback_url:  "urn:ietf:wg:oauth:2.0:oob",
  token_store:   System.user_home <> "/oauth2ex.google.token"
)
# -> %OAuth2Ex.Config{authorize_url: "https://accounts.google.com/o/oauth2/auth"...

# Get authentication parameters.
IO.puts OAuth2Ex.get_authorize_url(config)
# -> https://accounts.google.com/o/oauth2/auth?client_id=1...
#    Open this url using browser and acquire code string.

# Acquire code from browser and a get access token using the code.
code = "xxx..."
token = OAuth2Ex.get_token(config, code)
# -> %OAuth2Ex.Token{access_token: "xxx.......",
#    expires_at: 1408467022, expires_in: 3600,
#    refresh_token: "yyy....",
#    token_type: "Bearer"}

# Access API server using token.
response = OAuth2Ex.HTTP.get(token, "https://www.googleapis.com/bigquery/v2/projects")
# -> %HTTPoison.Response{body: "{\n \"kind\": \"bigquery#projectList...

# Save token to a file for later use.
token = OAuth2Ex.Token.storage(token, %OAuth2Ex.FileStorage{file_name: "test.token"})
OAuth2Ex.Token.save(token)

# Load previously saved token from the file.
token = OAuth2Ex.Token.load(%OAuth2Ex.FileStorage{file_name: "test.token"})

# Refresh access_token from refresh_token.
token = OAuth2Ex.refresh_token(config, token)
```

#### Automatic token retrieval using local callback server.
An example to uses local server to automates the token retrieval.
- The `retrieve_token` method retrieves the OAuth token and store it locally.
    - This method-call starts up local web server with specified `:receiver_port` to listen callback from OAuth 2.0 server.
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
        token_store:   %OAuth2Ex.FileStorage{file_name: System.user_home <> "/oauth2ex.google.token"}
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

### Config parameters
`OAuth2Ex.config` method requires the following parameters.

Parameter        | Description
---------------- | -------------
id(*)            | Client ID to identify the user to access.
secret(*)        | Client secret to authorize the token retrieval.
authorize_url(*) | Authorization url to retrieve a code to start authentication.
token_url(*)     | Token url to retrieve token.
scope            | Scope to identify the allowed scope within the provider's API. Some providers does not have one.
callback_url     | Callback url for receiving code, which is redirected from authorize_url.
token_store      | File path to store retrieved token.
auth_header      | HTTP Access header for specifying OAuth token. It defaults to "Bearer", which sends `Authorization: Bearer xxxx` header.
response_type    | Response type when accessing authorization url. It defaults to "code".
(*) indicates mandatory parameter.

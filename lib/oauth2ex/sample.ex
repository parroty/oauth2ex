defmodule OAuth2Ex.Sample.Google do
  defmodule Adapter do
    use OAuth2Ex.Adapter

    def config do
      OAuth2Ex.configure(
        id:            System.get_env("GOOGLE_API_CLIENT_ID"),
        secret:        System.get_env("GOOGLE_API_CLIENT_SECRET"),
        authorize_url: OAuth2Ex.Site.Google.authorize_url,
        token_url:     OAuth2Ex.Site.Google.token_url,
        scope:         ["https://www.googleapis.com/auth/bigquery"],
        callback_url:  "http://localhost:4000",
        token_store:   System.user_home <> "/oauth2ex.google.token"
      )
    end
  end

  def request_token do
    {:ok, message} = Adapter.request_token(port: 4000)
    IO.puts message
  end

  def projects do
    response = Adapter.get("https://www.googleapis.com/bigquery/v2/projects")
    response.body |> JSEX.decode!
  end
end

defmodule OAuth2Ex.Sample.GitHub do
  defmodule Adapter do
    use OAuth2Ex.Adapter

    def config do
      OAuth2Ex.configure(
        id:            System.get_env("GITHUB_API_CLIENT_ID"),
        secret:        System.get_env("GITHUB_API_CLIENT_SECRET"),
        authorize_url: OAuth2Ex.Site.GitHub.authorize_url,
        token_url:     OAuth2Ex.Site.GitHub.token_url,
        scope:         ["public_repo"],
        callback_url:  "http://localhost:4000",
        token_store:   System.user_home <> "/oauth2ex.github.token",
        header_prefix: "token" # Authorization: token OAUTH-TOKEN
      )
    end
  end

  def request_token do
    {:ok, message} = Adapter.request_token(port: 4000)
    IO.puts message
  end

  def get_authorization do
    response = Adapter.get("https://api.github.com/authorizations")
    response.body |> JSEX.decode!
  end
end

defmodule OAuth2Ex.Sample.Dropbox do
  defmodule Adapter do
    use OAuth2Ex.Adapter

    def config do
      OAuth2Ex.configure(
        id:            System.get_env("DROPBOX_API_CLIENT_ID"),
        secret:        System.get_env("DROPBOX_API_CLIENT_SECRET"),
        authorize_url: OAuth2Ex.Site.Dropbox.authorize_url,
        token_url:     OAuth2Ex.Site.Dropbox.token_url,
        scope:         [],
        callback_url:  "http://localhost:4000",
        token_store:   System.user_home <> "/oauth2ex.dropbox.token",
      )
    end
  end

  def request_token do
    {:ok, message} = Adapter.request_token(port: 4000)
    IO.puts message
  end

  def get_account do
    response = Adapter.get("https://api.dropbox.com/1/account/info")
    response.body |> JSEX.decode!
  end
end

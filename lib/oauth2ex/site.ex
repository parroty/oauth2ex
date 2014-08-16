defmodule OAuth2Ex.Site do
  defmodule Google do
    @moduledoc """
    An template for Google OAuth2.0 API.

    API: https://developers.google.com/accounts/docs/OAuth2
    """
    def authorize_url, do: "https://accounts.google.com/o/oauth2/auth"
    def token_url, do:     "https://accounts.google.com/o/oauth2/token"
  end

  defmodule GitHub do
    @moduledoc """
    An template for GitHub OAuth2.0 API.

    API: https://developer.github.com/v3/oauth/
    App: https://github.com/settings/applications
    """
    def authorize_url, do: "https://github.com/login/oauth/authorize"
    def token_url, do:     "https://github.com/login/oauth/access_token"
  end

  defmodule Dropbox do
    @moduledoc """
    An template for Dropbox OAuth2.0 API.

    API: https://www.dropbox.com/developers/core/docs
    App: https://www.dropbox.com/developers/apps/
    """
    def authorize_url, do: "https://www.dropbox.com/1/oauth2/authorize"
    def token_url, do:     "https://api.dropbox.com/1/oauth2/token"
  end
end

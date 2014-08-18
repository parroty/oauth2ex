defmodule OAuth2Ex.Config do
  @moduledoc """
  Provides configuration setting for accessing OAuth API server.
  """

  defstruct id: nil,               # Client ID to identify the user to access.
            secret: nil,           # Client secret to authorize the token retrieval.
            authorize_url: nil,    # Authorization url to retrieve a code to start authentication.
            token_url: nil,        # Token url to retrieve token.
            scope: nil,            # Scope to identify the allowed scope within the provider's API. Some providers does not have one.
            callback_url: nil,     # Callback url for receiving code, which is redirected from authorize_url.
            token_store: nil,      # File path to store retrieved token.
            header_prefix: nil,    # HTTP Access header for specifying OAuth token. It defaults to "Bearer", which sends `Authorization: Bearer xxxx`
            response_type: nil     # Response type when accessing authorization url. It defaults to "code".
end

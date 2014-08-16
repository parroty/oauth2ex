defmodule OAuth2Ex.Config do
  defstruct id: nil, secret: nil, authorize_url: nil, token_url: nil, scope: nil,
            callback_url: nil, token_store: nil, header_prefix: nil, response_type: nil
end

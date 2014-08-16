defmodule OAuth2Ex.HTTP do
  def request(adapter, method, url, body, headers, options) do
    header_prefix = adapter.config.header_prefix
    oauth_header = [{"Authorization", "#{header_prefix} #{adapter.token.access_token}"}]
    HTTPoison.request(method, url, body, headers ++ oauth_header, options)
  end
end

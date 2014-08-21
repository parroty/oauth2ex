defmodule OAuth2Ex.HTTP do
  @doc """
  Send HTTP GET request with specified parameters and OAuth token.
  """
  def get(token, url, headers \\ [], options \\ []) do
    request(token, :get, url, "", headers, options)
  end

  @doc """
  Send HTTP PUT request with specified parameters and OAuth token.
  """
  def put(token, url, body, headers \\ [], options \\ []) do
    request(token, :put, url, body, headers, options)
  end

  @doc """
  Send HTTP HEAD request with specified parameters and OAuth token.
  """
  def head(token, url, headers \\ [], options \\ []) do
    request(token, :head, url, "", headers, options)
  end

  @doc """
  Send HTTP POST request with specified parameters and OAuth token.
  """
  def post(token, url, body, headers \\ [], options \\ []) do
    request(token, :post, url, body, headers, options)
  end

  @doc """
  Send HTTP PATCH request with specified parameters and OAuth token.
  """
  def patch(token, url, body, headers \\ [], options \\ []) do
    request(token, :patch, url, body, headers, options)
  end

  @doc """
  Send HTTP DELETE request with specified parameters and OAuth token.
  """
  def delete(token, url, headers \\ [], options \\ []) do
    request(token, :delete, url, "", headers, options)
  end

  @doc """
  Send HTTP OPTIONS request with specified parameters and OAuth token.
  """
  def options(token, url, headers \\ [], options \\ []) do
    request(token, :options, url, "", headers, options)
  end

  @doc """
  Send http requests with specified parameters and OAuth token.
      options[:refresh] indicates whether to refresh token when it's expired. It defaults to true.
  """
  def request(token, method, url, body, headers, options) when is_map(token) do
    oauth_header = [{"Authorization", "#{token.auth_header} #{token.access_token}"}]
    HTTPoison.request(method, url, body, headers ++ oauth_header, options)
  end

  @doc """
  Send http requests with specified parameters and OAuth token.
  """
  def request(adapter, method, url, body, headers, options) do
    request(adapter.token, method, url, body, headers, options)
  end
end

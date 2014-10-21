defmodule OAuth2Ex.HTTP do
  @moduledoc """
  HTTP accessor methods using OAuth2 token.
  Requests and responses are parsed as json. If raw access is required,
  apply request/6 method.
  """

  @doc """
  Send HTTP GET request with specified parameters and OAuth token.
  """
  def get(token, url, params \\ [], headers \\ [], options \\ []) do
    request(token, :get, parse_as_query(url, params), "", headers, options)
  end

  @doc """
  Send HTTP PUT request with specified parameters and OAuth token.
  """
  def put(token, url, params, headers \\ [], options \\ []) do
    request(token, :put, url, parse_as_json(params), headers, options)
  end

  @doc """
  Send HTTP HEAD request with specified parameters and OAuth token.
  """
  def head(token, url, params \\ [], headers \\ [], options \\ []) do
    request(token, :head, url, parse_as_json(params), headers, options)
  end

  @doc """
  Send HTTP POST request with specified parameters and OAuth token.
  """
  def post(token, url, params, headers \\ [], options \\ []) do
    request(token, :post, url, parse_as_json(params), headers, options)
  end

  @doc """
  Send HTTP PATCH request with specified parameters and OAuth token.
  """
  def patch(token, url, params, headers \\ [], options \\ []) do
    request(token, :patch, url, parse_as_json(params), headers, options)
  end

  @doc """
  Send HTTP DELETE request with specified parameters and OAuth token.
  """
  def delete(token, url, params \\ [], headers \\ [], options \\ []) do
    request(token, :delete, url, parse_as_json(params), headers, options)
  end

  @doc """
  Send http requests with specified parameters and OAuth token.
  """
  def request(token, method, url, body, headers, options) when is_map(token) do
    base_header = [
        {"Authorization", "#{token.auth_header} #{token.access_token}"},
        {"Content-Type", "application/json"}
    ]
    response = HTTPoison.request!(method, url, body, headers ++ base_header, options)
    %{response | body: decode_body(response)}
  end

  @doc """
  Send http requests with specified parameters and OAuth token.
  """
  def request(adapter, method, url, body, headers, options) do
    request(adapter.token, method, url, body, headers, options)
  end

  defp decode_body(response) do
    content_type = response.headers["Content-Type"]
    cond do
      content_type != nil and content_type =~ ~r/application\/json/i ->
        response.body |> JSEX.decode!

      true ->
        response.body
    end
  end

  defp parse_as_query(url, params) do
    url <> "?" <> parse_query_params(params)
  end

  defp parse_query_params(params) do
    params |> Enum.map(fn({k,v}) -> "#{k}=#{v}" end)
           |> Enum.join("&")
  end

  defp parse_as_json([]), do: ""
  defp parse_as_json(params) do
    JSEX.encode!(params)
  end
end

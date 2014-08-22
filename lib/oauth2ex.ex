defmodule OAuth2Ex do
  @moduledoc """
  Provides entry points for OAuthEx interfaces.
  """

  @doc """
  Create and return OAuth2Ex.Config struct based on specified parameters.
  For the details of each parameter, refer to the definition of OAuth2Ex.Config struct.
  """
  def config(params) do
    %OAuth2Ex.Config{
      id:            params[:id] || raise_param_error(:id),
      secret:        params[:secret] || raise_param_error(:secret),
      authorize_url: params[:authorize_url] || raise_param_error(:authorize_url),
      token_url:     params[:token_url] || raise_param_error(:token_url),
      scope:         params[:scope],
      callback_url:  params[:callback_url],
      token_store:   params[:token_store],
      auth_header:   params[:auth_header] || "Bearer",
      response_type: params[:response_type] || "code"
    }
  end

  defp raise_param_error(key) do
    raise %OAuth2Ex.Error{message: ":#{key} parameter is missing for the OAuth2Ex.config/1."}
  end

  @doc """
  It returns the url to trigger the OAuth 2.0 authorization.
  """
  def get_authorize_url(config) do
    query_params = [
      client_id:     config.id,
      redirect_uri:  config.callback_url,
      response_type: config.response_type,
      scope:         config.scope
    ] |> join

    config.authorize_url <> "?" <> query_params
  end

  @doc """
  Get access token using the `code` which was retrieved through get_authorize_url method.
  """
  def get_token(config, code) do
    query_params = [
      client_id:     config.id,
      client_secret: config.secret,
      redirect_uri:  config.callback_url,
      code:          code,
      grant_type:    "authorization_code"
    ] |> join

    do_get_token(config, query_params)
  end

  @doc """
  Refresh access token using refresh token for when access token is expired.
  """
  def refresh_token(config, token, options \\ [force: false]) do
    IO.puts expired?(token)
    if expired?(token) || options[:force] do
      query_params = [
        refresh_token: token.refresh_token,
        client_id:     config.id,
        client_secret: config.secret,
        grant_type:    "refresh_token"
      ] |> join

      new_token = do_get_token(config, query_params)
      OAuth2Ex.Token.save(%{new_token | refresh_token: token.refresh_token, storage: token.storage})
    else
      token
    end
  end

  defp expired?(token) do
    if token.expires_at do
      expires_at = Timex.Date.from(token.expires_at, :secs)
      if Timex.Date.diff(Timex.Date.now, expires_at, :secs) <= 0 do
        true
      else
        false
      end
    else
      false
    end
  end

  defp do_get_token(config, query_params) do
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Accept", "application/json"}
    ]

    HTTPoison.post(config.token_url, [query_params], headers).body
      |> JSEX.decode!
      |> parse_token(config)
  end

  defp parse_token(json, config) do
    token = %OAuth2Ex.Token{
      access_token:  json["access_token"],
      expires_in:    json["expires_in"],
      refresh_token: json["refresh_token"],
      token_type:    json["token_type"],
      auth_header:   config.auth_header,
      storage:       config.token_store
    }

    if token.expires_in do
      %{token | expires_at: calc_expires_at(token.expires_in)}
    else
      token
    end
  end

  defp calc_expires_at(expires_in) do
    Timex.Date.now
      |> Timex.Date.shift(secs: expires_in)
      |> Timex.Date.to_secs
  end

  defp join(params) do
    params |> Enum.map(fn({k,v}) -> "#{k}=#{v}" end)
           |> Enum.join("&")
  end
end

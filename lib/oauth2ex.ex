defmodule OAuth2Ex do
  @moduledoc """
  Provides entry points for OAuthEx interfaces.
  """

  @doc """
  Initialize module.
  """
  def start do
    OAuth2Ex.Token.Cache.start
    :ok
  end

  @doc """
  Create and return OAuth2Ex.Config struct based on specified parameters.
  For the details of each parameter, refer to the definition of OAuth2Ex.Config struct.
  """
  def config(params) do
    %OAuth2Ex.Config{
      id:             params[:id] || raise_param_error(:id),
      secret:         params[:secret] || raise_param_error(:secret),
      authorize_url:  params[:authorize_url] || raise_param_error(:authorize_url),
      token_url:      params[:token_url] || raise_param_error(:token_url),
      scope:          params[:scope],
      callback_url:   params[:callback_url],
      token_store:    params[:token_store],
      auth_header:    params[:auth_header] || "Bearer",
      response_type:  params[:response_type] || "code",
      client_options: params[:client_options]
    }
  end

  defp raise_param_error(key) do
    raise OAuth2Ex.Error, message: ":#{key} parameter is missing for the OAuth2Ex.config/1."
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
    ] |> URI.encode_query

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
    ] |> URI.encode_query

    do_get_token(config, query_params)
  end

  @doc """
  It checks the expiration date of the token at first, and then refresh the token if it's expired.
  If token is not expired, it just returns the current token without accessing server.
  """
  def ensure_token(config, token) do
    if token_expired?(token) do
      refresh_token(config, token)
    else
      token
    end
  end

  @doc """
  Refresh access token using refresh token for when access token is expired.
  """
  def refresh_token(config, token) do
    query_params = [
      refresh_token: token.refresh_token,
      client_id:     config.id,
      client_secret: config.secret,
      grant_type:    "refresh_token"
    ] |> URI.encode_query

    new_token = %{do_get_token(config, query_params) | refresh_token: token.refresh_token, storage: token.storage}
    OAuth2Ex.Token.save!(new_token)
  end

  @doc """
  Returns true if the token has refresh expiration date and expired.
  If the expiration date is not available (null), it returns false.
  """
  def token_expired?(token) do
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

    HTTPoison.post!(config.token_url, [query_params], headers).body
    |> JSX.decode!
    |> parse_token(config)
  end

  defp parse_token(json, config) do
    if error = json["error"] do
      raise OAuth2Ex.Error, message: "Error is returned from the server while getting token. Error: #{error}. "
    end

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
end

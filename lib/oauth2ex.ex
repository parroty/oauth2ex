defmodule OAuth2Ex do
  def config(params) do
    %OAuth2Ex.Config{
      id:            params[:id],
      secret:        params[:secret],
      authorize_url: params[:authorize_url],
      token_url:     params[:token_url],
      scope:         params[:scope],
      callback_url:  params[:callback_url],
      token_store:   params[:token_store],
      header_prefix: params[:header_prefix] || "Bearer",
      response_type: params[:response_type] || "code"
    }
  end

  def get_authorize_url(config) do
    query_params = [
      client_id:     config.id,
      redirect_uri:  config.callback_url,
      response_type: config.response_type,
      scope:         config.scope
    ] |> join

    config.authorize_url <> "?" <> query_params
  end

  def get_token(config, code) do
    query_params = [
      client_id:     config.id,
      client_secret: config.secret,
      redirect_uri:  config.callback_url,
      code:          code,
      grant_type:    "authorization_code"
    ] |> join

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Accept", "application/json"}
    ]

    HTTPoison.post(config.token_url, [query_params], headers).body
      |> JSEX.decode!
      |> parse_token
  end

  def refresh_token(config, token) do
    query_params = [
      refresh_token: token.refresh_token,
      client_id:     config.id,
      client_secret: config.secret,
      grant_type:    "refresh_token"
    ] |> join

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Accept", "application/json"}
    ]

    new_token = HTTPoison.post(config.token_url, [query_params], headers).body
                  |> JSEX.decode!
                  |> parse_token

    %{new_token | refresh_token: token.refresh_token}
  end

  defp parse_token(json) do
    token = %OAuth2Ex.Token{
      access_token:  json["access_token"],
      expires_in:    json["expires_in"],
      refresh_token: json["refresh_token"],
      token_type:    json["token_type"]
    }

    if token.expires_in do
      expires_at = Timex.Date.now
                     |> Timex.Date.shift(secs: token.expires_in)
                     |> Timex.Date.to_secs
      %{token | expires_at: expires_at}
    else
      token
    end
  end

  defp join(params) do
    params |> Enum.map(fn({k,v}) -> "#{k}=#{v}" end)
           |> Enum.join("&")
  end
end

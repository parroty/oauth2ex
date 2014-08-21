defmodule OAuth2ExTest do
  use ExUnit.Case

  def config do
    OAuth2Ex.config(
      id:            "sample_client_id",
      secret:        "sample_secret",
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url:     "https://accounts.google.com/o/oauth2/token",
      scope:         "https://www.googleapis.com/auth/bigquery",
      callback_url:  "http://localhost:3000/oauth2callback"
    )
  end

  test "initialization of client for pre-defined site" do
    url = OAuth2Ex.get_authorize_url(config)

    assert String.contains?(url, "accounts.google.com/o/oauth2/auth")
    assert String.contains?(url, "client_id=sample_client_id")
    assert !String.contains?(url, "client_secret=sample_secret")
  end

  # TODO: apply http_server
  # test "authentication with code" do
  #   token = OAuth2Ex.get_token(config, "sample_code")
  #   assert %OAuth2Ex.Token{} == token
  # end

  test "save token to file" do
    token = %OAuth2Ex.Token{
      access_token:  "sample_access_token",
      expires_in:    3600,
      refresh_token: "sample_refresh_token",
      token_type:    "Bearer"
    }

    file_name = "test/fixture/save_token.json"

    File.rm(file_name)
    token = OAuth2Ex.Token.storage(token, %OAuth2Ex.FileStorage{file_name: file_name})
    OAuth2Ex.Token.save(token)
    assert File.exists?(file_name) == true
  end

  test "load token from file" do
    token = OAuth2Ex.Token.load(%OAuth2Ex.FileStorage{file_name: "test/fixture/load_token.json"})

    assert token.access_token == "sample_access_token"
    assert token.expires_in == 3600
    assert token.refresh_token == "sample_refresh_token"
    assert token.token_type ==  "Bearer"
  end
end

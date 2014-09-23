defmodule OAuth2ExSampleTest do
  use ExUnit.Case, async: false

  setup_all do
    System.put_env("GOOGLE_API_CLIENT_ID", "test")
    System.put_env("GOOGLE_API_CLIENT_SECRET", "test")
    System.put_env("DROPBOX_API_CLIENT_ID", "test")
    System.put_env("DROPBOX_API_CLIENT_SECRET", "test")
    System.put_env("GITHUB_API_CLIENT_ID", "test")
    System.put_env("GITHUB_API_CLIENT_SECRET", "test")
  end

  test "google config" do
    assert is_map(OAuth2Ex.Sample.Google.config)
  end

  test "github config" do
    assert is_map(OAuth2Ex.Sample.GitHub.config)
  end

  test "dropbox config" do
    assert is_map(OAuth2Ex.Sample.Dropbox.config)
  end
end
defmodule OAuth2ExSampleTest do
  use ExUnit.Case, async: false

  test "google config" do
    assert is_map(OAuth2Ex.Sample.Google.Client.config)
  end

  test "github config" do
    assert is_map(OAuth2Ex.Sample.GitHub.Client.config)
  end

  test "dropbox config" do
    assert is_map(OAuth2Ex.Sample.Dropbox.Client.config)
  end
end
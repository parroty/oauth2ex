defmodule OAuth2ExClientTest do
  use ExUnit.Case

  defmodule EmptyClient do
    use OAuth2Ex.Client
  end

  defmodule NilParameterClient do
    use OAuth2Ex.Client
    def config, do: OAuth2Ex.config([])
  end

  defmodule InvalidTokenStoreClient do
    use OAuth2Ex.Client
    def config, do: OAuth2Ex.config(token_store: "invalidfilepath")
  end

  test "using empty client throws error" do
    message = "config/0 is not implemented for the OAuth2ExClientTest.EmptyClient."
    assert_raise OAuth2Ex.Error, message, fn ->
      EmptyClient.retrieve_token
    end
  end

  test "using nil parameter client throws error for accessing token" do
    message = ~r/token_store parameter is missing in the specified OAuth2Ex.Config struct: %OAuth2Ex.Config{.+}./
    assert_raise OAuth2Ex.Error, message, fn ->
      NilParameterClient.token
    end
  end

  test "using invalid token_store client throws error for accessing token" do
    assert_raise File.Error, fn ->
      InvalidTokenStoreClient.token
    end
  end
end

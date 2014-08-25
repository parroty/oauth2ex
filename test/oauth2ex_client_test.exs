defmodule OAuth2ExClientTest do
  use ExUnit.Case

  def mandatory_params do
    [ id: "id", secret: "secret",
      authorize_url: "authorize_url", token_url: "token_url" ]
  end

  defmodule EmptyClient do
    use OAuth2Ex.Client
  end

  defmodule NilParameterClient do
    use OAuth2Ex.Client
    def config, do: OAuth2Ex.config([])
  end

  defmodule BasicgParameterClient do
    use OAuth2Ex.Client
    def config, do: OAuth2Ex.config(OAuth2ExClientTest.mandatory_params)
  end

  defmodule InvalidTokenStoreClient do
    use OAuth2Ex.Client
    def config, do: OAuth2Ex.config(OAuth2ExClientTest.mandatory_params ++ [token_store: "invalidfilepath"])
  end

  test "using empty client throws error" do
    message = "config/0 is not implemented for the OAuth2ExClientTest.EmptyClient."
    assert_raise OAuth2Ex.Error, message, fn ->
      EmptyClient.browse_and_retrieve
    end
  end

  test "using nil parameter client throws missing param error" do
    message = ~r/:id parameter is missing/
    assert_raise OAuth2Ex.Error, message, fn ->
      NilParameterClient.browse_and_retrieve
    end
  end

  test "using nil parameter client throws error for accessing token" do
    message = ~r/token_store parameter is missing or invalid for the specified OAuth2Ex.Config struct: %OAuth2Ex.Config{.+}./
    assert_raise OAuth2Ex.Error, message, fn ->
      BasicgParameterClient.token
    end
  end

  test "using invalid token_store client throws error for accessing token" do
    assert_raise OAuth2Ex.Error, fn ->
      InvalidTokenStoreClient.token
    end
  end
end

defmodule OAuth2Ex.Client do
  @moduledoc """
  Provides basic client features for retrieving token and accessing API server.
  """

  defmacro __using__(_opts) do
    quote do
      @doc """
      A method to return OAuth2Ex.Config record by specifying required parameters.
      It should be overriden by the imported module.
      """
      def config, do: raise %OAuth2Ex.Error{message: "config/0 is not implemented for the #{inspect __MODULE__}."}
      defoverridable config: 0

      @doc """
      A method to return pre-retrieved token in the file.
      """
      def token do
        if path = config.token_store do
          OAuth2Ex.Token.Storage.load_from_file(path)
        else
          raise %OAuth2Ex.Error{
            message: "token_store parameter is missing in the specified OAuth2Ex.Config struct: #{inspect config}."}
        end
      end

      @doc """
      Send HTTP GET request with specified parameters and OAuth token.
      """
      def get(url, headers \\ [], options \\ []) do
        request(:get, url, "", headers, options)
      end

      @doc """
      Send HTTP PUT request with specified parameters and OAuth token.
      """
      def put(url, body, headers \\ [], options \\ []) do
        request(:put, url, body, headers, options)
      end

      @doc """
      Send HTTP HEAD request with specified parameters and OAuth token.
      """
      def head(url, headers \\ [], options \\ []) do
        request(:head, url, "", headers, options)
      end

      @doc """
      Send HTTP POST request with specified parameters and OAuth token.
      """
      def post(url, body, headers \\ [], options \\ []) do
        request(:post, url, body, headers, options)
      end

      @doc """
      Send HTTP PATCH request with specified parameters and OAuth token.
      """
      def patch(url, body, headers \\ [], options \\ []) do
        request(:patch, url, body, headers, options)
      end

      @doc """
      Send HTTP DELETE request with specified parameters and OAuth token.
      """
      def delete(url, headers \\ [], options \\ []) do
        request(:delete, url, "", headers, options)
      end

      @doc """
      Send HTTP OPTIONS request with specified parameters and OAuth token.
      """
      def options(url, headers \\ [], options \\ []) do
        request(:options, url, "", headers, options)
      end

      @doc """
      Send http request with specified parameters and OAuth token.
      """
      def request(method, url, body, headers, options) do
        OAuth2Ex.HTTP.request(__MODULE__, method, url, body, headers, options)
      end

      @doc """
      Initiate OAuth 2.0 token retrieval processing.
      """
      def retrieve_token(options \\ []) do
        OAuth2Ex.Token.Requester.run(__MODULE__, options)
      end
    end
  end
end

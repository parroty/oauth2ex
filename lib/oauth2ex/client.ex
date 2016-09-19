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
      def config, do: raise OAuth2Ex.Error, message: "config/0 is not implemented for the #{inspect __MODULE__}."
      defoverridable config: 0

      @doc """
      A method to return pre-retrieved token in the file.
      """
      def token do
        case config.token_store do
          storage when is_map(storage) ->
            token = OAuth2Ex.Token.load(storage)
            OAuth2Ex.ensure_token(config, token)
          _ ->
            raise OAuth2Ex.Error,
              message: "token_store parameter is missing or invalid for the specified OAuth2Ex.Config struct: #{inspect config}."
        end
      end
      defoverridable token: 0

      @doc """
      A method to refresh token.
      """
      def refresh_token do
        OAuth2Ex.refresh_token(config, token)
      end
      defoverridable refresh_token: 0

      @doc """
      Initiate OAuth 2.0 token retrieval processing.
      """
      def browse_and_retrieve(options \\ []) do
        OAuth2Ex.Token.browse_and_retrieve(config, options)
      end
      defoverridable [browse_and_retrieve: 0, browse_and_retrieve: 1]

      @doc """
      Initiate OAuth 2.0 token retrieval processing.
      """
      def browse_and_retrieve!(options \\ []) do
        OAuth2Ex.Token.browse_and_retrieve!(config, options)
      end
      defoverridable [browse_and_retrieve!: 0, browse_and_retrieve!: 1]

      @doc """
      Send HTTP GET request with specified parameters and OAuth token.
      """
      def get(url, params \\ [], headers \\ [], options \\ []) do
        OAuth2Ex.HTTP.get(token, url, params, headers, options)
      end

      @doc """
      Send HTTP PUT request with specified parameters and OAuth token.
      """
      def put(url, params, headers \\ [], options \\ []) do
        OAuth2Ex.HTTP.put(token, url, params, headers, options)
      end

      @doc """
      Send HTTP HEAD request with specified parameters and OAuth token.
      """
      def head(url, params \\ [], headers \\ [], options \\ []) do
        OAuth2Ex.HTTP.head(token, url, params, headers, options)
      end

      @doc """
      Send HTTP POST request with specified parameters and OAuth token.
      """
      def post(url, params, headers \\ [], options \\ []) do
        OAuth2Ex.HTTP.post(token, url, params, headers, options)
      end

      @doc """
      Send HTTP PATCH request with specified parameters and OAuth token.
      """
      def patch(url, params, headers \\ [], options \\ []) do
        OAuth2Ex.HTTP.patch(token, url, params, headers, options)
      end

      @doc """
      Send HTTP DELETE request with specified parameters and OAuth token.
      """
      def delete(url, params \\ [], headers \\ [], options \\ []) do
        OAuth2Ex.HTTP.delete(token, url, params, headers, options)
      end

      @doc """
      Send http requests with specified parameters and OAuth token.
      """
      def request(method, url, body, headers, options) do
        OAuth2Ex.HTTP.request(token, method, url, body, headers, options)
      end
    end
  end
end

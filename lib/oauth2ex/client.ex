defmodule OAuth2Ex.Client do
  defmacro __using__(_opts) do
    quote do
      def config do
        raise "client/0 is not implemented for the token adapter."
      end

      def token do
        if path = config.token_store do
          OAuth2Ex.Token.Storage.load_from_file(path)
        else
          raise ":token_store is not specified for the config of token adapter."
        end
      end

      def get(url, headers \\ [], options \\ []) do
        request(:get, url, "", headers, options)
      end

      def put(url, body, headers \\ [], options \\ []) do
        request(:put, url, body, headers, options)
      end

      def head(url, headers \\ [], options \\ []) do
        request(:head, url, "", headers, options)
      end

      def post(url, body, headers \\ [], options \\ []) do
        request(:post, url, body, headers, options)
      end

      def patch(url, body, headers \\ [], options \\ []) do
        request(:patch, url, body, headers, options)
      end

      def delete(url, headers \\ [], options \\ []) do
        request(:delete, url, "", headers, options)
      end

      def options(url, headers \\ [], options \\ []) do
        request(:options, url, "", headers, options)
      end

      def request(method, url, body, headers, options) do
        OAuth2Ex.HTTP.request(__MODULE__, method, url, body, headers, options)
      end

      def request_token(options) do
        OAuth2Ex.Token.Requester.run(__MODULE__, options)
      end

      defoverridable [config: 0]
    end
  end
end

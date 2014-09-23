defmodule OAuth2Ex.Token.Retriever do
  @moduledoc """
  Token receiver to listen callback from OAuth 2.0 server.
  """

  @doc """
  Start the listen server with specified port. When message is received, navigate user to authenticate using browser.
  """
  def run(config, options) do
    port = options[:receiver_port] || 4000
    timeout = options[:timeout] || 30_000

    Plug.Adapters.Cowboy.http(OAuth2Ex.Token.Listener,
      [caller: self], port: port)

    authorize_url = OAuth2Ex.get_authorize_url(config)
    case open_by_browser(authorize_url) do
      :ok ->
        IO.puts ""
      :error ->
        IO.puts "Open the browser and visit the following link to authenticate."
        IO.puts authorize_url
    end

    receive do
      {:ok, code} ->
        token = get_token(code, config)
        {:ok, token}
    after
      timeout ->
        {:error, "Authorization timed out, please retry the process."}
    end
  end

  @doc """
  Get token from the server and store it into the file.
  """
  def get_token(code, config) do
    token = OAuth2Ex.get_token(config, code)
    OAuth2Ex.Token.save(token)
    Plug.Adapters.Cowboy.shutdown(OAuth2Ex.Token.Listener.HTTP)
    token
  end

  defp open_by_browser(url) do
    try do
      {_output, exit_status} = System.cmd("open", [url])
      if exit_status == 0 do
        :ok
      else
        :error
      end
    rescue
      _ -> :error
    end
  end
end

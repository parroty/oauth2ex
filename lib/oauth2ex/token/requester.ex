defmodule OAuth2Ex.Token.Requester do
  def run(adapter, options) do
    port = options[:port] || 4000
    timeout = options[:timoeut] || 60_000

    Plug.Adapters.Cowboy.http(OAuth2Ex.Token.Receiver,
      [adapter: adapter, caller: self], port: port)

    authorize_url = OAuth2Ex.get_authorize_url(adapter.config)
    case open_by_browser(authorize_url) do
      :ok ->
        IO.puts ""
      :error ->
        IO.puts "Open the browser and visit the following link to authenticate."
        IO.puts authorize_url
    end

    receive do
      {:ok, code} ->
        get_token(code, adapter)
        {:ok, "Successfully authorized and token is stored in the file."}
    after
      timeout ->
        {:error, "Authorization timed out, please retry the process."}
    end
  end

  def get_token(code, adapter) do
    config = adapter.config
    token = OAuth2Ex.get_token(config, code)
    OAuth2Ex.Token.Storage.save_to_file(token, config.token_store)
    Plug.Adapters.Cowboy.shutdown(OAuth2Ex.Token.Receiver.HTTP)
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

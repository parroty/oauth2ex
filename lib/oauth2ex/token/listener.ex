defmodule OAuth2Ex.Token.Listener do
  @moduledoc """
  A plug server to receive callback from OAuth 2.0 server.
  """

  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, options) do
    conn = fetch_query_params(conn)
    case conn.params["code"] do
      "" ->
        send_resp(conn, 500, "Invalid Request")
      code ->
        reply_code_to_caller(options[:caller], code)
        send_resp(conn, 200, "Authorization process completed. Return back to the application to proceed.")
    end
  end

  defp reply_code_to_caller(caller, code) do
    send caller, {:ok, code}
  end
end

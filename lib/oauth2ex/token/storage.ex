defmodule OAuth2Ex.Token.Storage do
  @moduledoc """
  Provides local token file store.
  """

  @doc """
  Load token from the specified file.
    options[:refresh] indicates whether to refresh token when it's expired. It defaults to true.
  """
  def load_from_file(file_name, options \\ [refresh: true]) do
    token = File.read!(file_name) |> JSEX.decode! |> merge_into_struct(%OAuth2Ex.Token{})
    if options[:refresh] do
       verify_expiration(token, file_name)
    end
    token
  end

  @doc """
  Save token into the specified file.
  """
  def save_to_file(token, file_name) do
    json = JSEX.encode!(token) |> JSEX.prettify!
    File.write!(file_name, json)
    token
  end

  defp merge_into_struct(json, struct) do
    keys = Map.keys(struct)
    Enum.reduce(keys, struct, fn(key, acc) ->
      atom_key = Atom.to_string(key)
      if atom_key != "__struct__" and Map.has_key?(json, atom_key) do
        Map.put(acc, key, Map.fetch!(json, atom_key))
      else
        acc
      end
    end)
  end

  defp verify_expiration(token, file_name) do
    if token.expires_at do
      expires_at = Timex.Date.from(token.expires_at, :secs)
      if Timex.Date.diff(Timex.Date.now, expires_at, :secs) <= 0 do
        refresh_token(token, file_name)
      end
    end
  end

  defp refresh_token(token, file_name) do
    IO.puts "Access token is being refreshed."
    OAuth2Ex.refresh_token(token) |> save_to_file(file_name)
  end
end
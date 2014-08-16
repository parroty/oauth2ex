defmodule OAuth2Ex.Token.Storage do
  def load_from_file(file_name) do
    token = File.read!(file_name) |> JSEX.decode! |> merge_map(%OAuth2Ex.Token{})
    verify_expiration(token, file_name)
    token
  end

  def save_to_file(token, file_name) do
    json = JSEX.encode!(token) |> JSEX.prettify!
    File.write!(file_name, json)
    token
  end

  defp merge_map(json, struct) do
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
defmodule OAuth2Ex.Token do
  @moduledoc """
  Provides token stucture and operational methods.
  """

  defstruct access_token: nil, expires_in: nil, refresh_token: nil, token_type: nil, expires_at: nil,
            auth_header: nil, storage: nil, config: nil

  @doc """
  Set storage information to the Token struct.
  """
  def storage(token, storage) do
    %{token | storage: storage}
  end

  @doc """
  Save token to the location specified by the module defined as :storage key.
  """
  def save(token) do
    if storage = token.storage do
      storage.module.save(token, storage)
    else
      token
    end
  end

  @doc """
  Load token from the location specified by the module defined as :storage key.
  """
  def load(storage) do
    storage.module.load(storage)
  end

  def merge_into_struct(json, struct) do
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
end

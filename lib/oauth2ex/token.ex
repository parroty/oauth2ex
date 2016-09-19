defmodule OAuth2Ex.Token do
  @moduledoc """
  Provides token stucture and operational methods.
  """

  defstruct access_token: nil, expires_in: nil, refresh_token: nil, token_type: nil, expires_at: nil,
            auth_header: "Bearer", storage: nil, config: nil

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
      token = storage.module.save(token, storage)
      OAuth2Ex.Token.Cache.set(token)
      {:ok, token}
    else
      {:error, token}
    end
  end

  @doc """
  Save token to the location specified by the module defined as :storage key.
  """
  def save!(token) do
    case save(token) do
      {:ok, token} ->
        token
      {:error, token} ->
        raise OAuth2Ex.Error, message: "Failed to save token. Token.storage = #{inspect token.stoage}"
    end
  end

  @doc """
  Load token from the location specified by the module defined as :storage key.
  """
  def load(storage) do
    if token = OAuth2Ex.Token.Cache.get do
      token
    else
      token = storage.module.load(storage)
      OAuth2Ex.Token.Cache.set(token)
      token
    end
  end

  @doc """
  Initiate OAuth 2.0 token retrieval processing.
  """
  def browse_and_retrieve(config, options \\ []) do
    if config.client_options do
      options = Keyword.merge(config.client_options, options)
    end
    OAuth2Ex.Token.Retriever.run(config, options)
  end

  @doc """
  Initiate OAuth 2.0 token retrieval processing.
  """
  def browse_and_retrieve!(config, options \\ []) do
    case browse_and_retrieve(config, options) do
      {:error, message} ->
        raise OAuth2Ex.Error, message: message
      {:ok, token} ->
        token
    end
  end

  @doc """
  Merge json objects into struct.
  """
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

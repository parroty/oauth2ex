defmodule OAuth2Ex.FileStorage do
  @moduledoc """
  Provides local token file store.
  """

  defstruct module: __MODULE__, file_name: nil

  @doc """
  Load token from the specified file.
  """
  def save(token, storage) do
    map = Map.from_struct(token) |> Map.delete(:storage)
    json = JSEX.encode!(map) |> JSEX.prettify!
    File.write!(storage.file_name, json)
    token
  end

  @doc """
  Save token into the specified file.
  """
  def load(storage) do
    File.read!(storage.file_name)
      |> JSEX.decode!
      |> OAuth2Ex.Token.merge_into_struct(%OAuth2Ex.Token{storage: storage})
  end
end

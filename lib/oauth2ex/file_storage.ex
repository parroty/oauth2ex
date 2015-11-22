defmodule OAuth2Ex.FileStorage do
  @moduledoc """
  Provides local token file store.
  """

  defstruct module: __MODULE__, file_path: nil

  @doc """
  Save token into the specified file.
  """
  def save(token, storage) do
    map = Map.from_struct(token) |> Map.delete(:storage)
    json = JSX.encode!(map) |> JSX.prettify!
    File.write!(storage.file_path, json)
    token
  end

  @doc """
  Load token from the specified file.
  """
  def load(storage) do
    File.read!(storage.file_path)
    |> JSX.decode!
    |> OAuth2Ex.Token.merge_into_struct(%OAuth2Ex.Token{storage: storage})
  end
end

defmodule OAuth2Ex.Token.Cache do
  @moduledoc """
  In memory cache for token, which is stored for each pid.
  """

  @doc """
  Defines table name for ETS.
  """
  def table do
    :"OAuth2Ex.Token.Cache"
  end

  @doc """
  Use pid as cache key.
  """
  def key do
    String.to_atom(inspect self)
  end

  def start do
    if :ets.info(table) == :undefined do
      :ets.new(table, [:set, :public, :named_table])
    end
    :ok
  end

  def get do
    start
    :ets.lookup(table, key)[key]
  end

  def set(value) do
    start
    :ets.insert(table, {key, value})
    value
  end

  def delete do
    start
    :ets.delete(table, key)
  end
end

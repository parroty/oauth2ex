defmodule OAuth2Ex.EncryptedStorage do
  @moduledoc """
  Provides local token file store with encryption.
  """

  defstruct module: __MODULE__, file_path: nil, encryption_key: nil, algorithm: :aes_cfb128, hash_function: :md5, iv_bytes: 16

  @doc """
  Save token into the specified file.
  """
  def save(token, storage) do
    access_token  = encrypt(token.access_token, storage)
    refresh_token = encrypt(token.refresh_token, storage)
    encrypted_token = %{token | access_token: access_token, refresh_token: refresh_token}

    map = Map.from_struct(encrypted_token) |> Map.delete(:storage)

    json = JSX.encode!(map) |> JSX.prettify!
    File.write!(storage.file_path, json)

    token
  end

  @doc """
  Load token from the specified file.
  """
  def load(storage) do
    token = File.read!(storage.file_path) |> JSX.decode!

    access_token  = decrypt(token["access_token"], storage)
    refresh_token = decrypt(token["refresh_token"], storage)

    decrypted_token = %{token | "access_token" => access_token,
                                "refresh_token" => refresh_token}
    OAuth2Ex.Token.merge_into_struct(
      decrypted_token, %OAuth2Ex.Token{storage: storage})
  end

  def encrypt(nil, _storage), do: nil
  def encrypt(token, storage) do
    iv     = :crypto.strong_rand_bytes(storage.iv_bytes)
    cypher = :crypto.block_encrypt(storage.algorithm, hmac(storage), iv, token)

    b64_cypher = :base64.encode(cypher)
    b64_iv     = :base64.encode(iv)

    [b64_cypher, b64_iv]
  end

  def decrypt(nil, _storage), do: nil
  def decrypt([b64_cypher, b64_iv], storage) do
    cypher = :base64.decode(b64_cypher)
    iv     = :base64.decode(b64_iv)

    :crypto.block_decrypt(storage.algorithm, hmac(storage), iv, cypher)
  end

  defp hmac(storage) do
    :crypto.hmac(storage.hash_function, storage.encryption_key, Atom.to_string(__MODULE__))
  end
end

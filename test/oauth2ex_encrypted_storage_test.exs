defmodule OAuth2ExEncryptedStorageTest do
  use ExUnit.Case

  test "encrypt and decrypt should return original token" do
    original_token = "token"
    storage = %OAuth2Ex.EncryptedStorage{encryption_key: "encryption_key"}

    encrypted_token = OAuth2Ex.EncryptedStorage.encrypt(original_token, storage)
    decrypted_token = OAuth2Ex.EncryptedStorage.decrypt(encrypted_token, storage)

    assert original_token == decrypted_token
  end

  test "save and load should return original token" do
    original_token = %OAuth2Ex.Token{access_token: "aaaaa", refresh_token: "bbbbb"}

    storage = %OAuth2Ex.EncryptedStorage{encryption_key: "encryption_key", file_path: "test/tmp/token_file"}

    OAuth2Ex.EncryptedStorage.save(original_token, storage)
    decrypted_token = OAuth2Ex.EncryptedStorage.load(storage)

    assert original_token.access_token == decrypted_token.access_token
    assert original_token.refresh_token == decrypted_token.refresh_token
  end
end

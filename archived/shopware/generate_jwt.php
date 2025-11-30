<?php

if (file_exists(__DIR__ . '/jwt_private.pem')) {
    echo "Private/Public key already exists. Skipping";
    exit(0);
}

$key = openssl_pkey_new([
    'digest_alg' => 'aes256',
    'private_key_type' => OPENSSL_KEYTYPE_RSA,
    'encrypt_key' => 'shopware',
    'encrypt_key_cipher' => OPENSSL_CIPHER_AES_256_CBC
]);

openssl_pkey_export_to_file($key, __DIR__ . '/jwt_private.pem', 'shopware');

$keyData = openssl_pkey_get_details($key);
file_put_contents(__DIR__ . '/jwt_public.pem', $keyData['key']);
Secrets = {}

Secrets.SecretsFile = "design/lua/qobserve/secrets.json"
Secrets.SecretStorage = "SecretStorage"

function Secrets:GetSecrets()
    -- get secrets from secrets file
    print("SECRETS: get secrets")
    local SecretsFileObj = io.open(Secrets.SecretsFile, "r")
    local SecretsContent = SecretsFileObj:read("*a")
    SecretsFileObj:close()
    return json.decode(SecretsContent)
end

function Secrets:Decrypt(cipher)
    -- decrypt secrets with key and iv from SecretStorage component in design
    print("SECRETS: decrypt")
    local SS = Component.New(Secrets.SecretStorage)
    local key = Crypto.Base64Decode(SS["SecretStorage.text.1"].String)
    local iv = Crypto.Base64Decode(SS["SecretStorage.text.2"].String)
    return Crypto.Decrypt(Crypto.Cipher.AES_256_CBC,key,iv,Crypto.Base64Decode(cipher))
end

return Secrets
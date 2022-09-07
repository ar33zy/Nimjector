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

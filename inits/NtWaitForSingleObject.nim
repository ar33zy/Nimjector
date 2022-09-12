proc NtWaitForSingleObject(ObjectHandle: PHANDLE, Alertable: BOOLEAN, TimeOut: PLARGE_INTEGER): NTSTATUS {.stdcall, dynlib: "ntdll", importc, discardable.}

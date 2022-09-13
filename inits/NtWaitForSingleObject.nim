proc NtWaitForSingleObject(ObjectHandle: HANDLE, Alertable: BOOLEAN, TimeOut: PLARGE_INTEGER): NTSTATUS {.stdcall, dynlib: "ntdll", importc, discardable.}

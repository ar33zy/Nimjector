proc NtClose(Handle: HANDLE): NTSTATUS {.stdcall, dynlib: "ntdll", importc, discardable.}

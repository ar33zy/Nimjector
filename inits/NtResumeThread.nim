proc NtResumeThread*(ThreadHandle: HANDLE, PreviousSuspendCount: PULONG): NTSTATUS {.stdcall, dynlib: "ntdll", importc, discardable.}

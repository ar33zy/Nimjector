proc NtQueueApcThread(ThreadHandle: HANDLE, ApcRoutine: PKNORMAL_ROUTINE, ApcArgument1: PVOID, ApcArgument2: PVOID, ApcArgument3: PVOID) NTSTATUS {.stdcall, dynlib: "ntdll", importc, discardable.}

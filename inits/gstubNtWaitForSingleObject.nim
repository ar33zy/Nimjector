type gstubNtWaitForSingleObject = proc(ObjectHandle: HANDLE, Alertable: BOOLEAN, TimeOut: PLARGE_INTEGER): NTSTATUS {.stdcall.}

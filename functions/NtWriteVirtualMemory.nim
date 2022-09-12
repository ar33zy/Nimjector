var bytesWritten: SIZE_T
res = NtWriteVirtualMemory(pHandle, rPtr, unsafeAddr shellcode, sc_size-1, addr bytesWritten)

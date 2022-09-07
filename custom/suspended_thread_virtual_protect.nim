var op: DWORD
VirtualProtect(cast[LPVOID](rPtr), shellcode.len, PAGE_NOACCESS, addr op)

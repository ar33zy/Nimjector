var data: array[0..0x200, byte]
let imageBaseAddress = cast[PVOID](cast[int64](baseAddressBytes))
ReadProcessMemory(pHandle, imageBaseAddress, addr data, len(data), addr bytesWritten)

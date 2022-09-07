var bytesWritten: SIZE_T
var baseAddressBytes: array[0..sizeof(PVOID), byte]
let ptrToImageBase = cast[PVOID](cast[int64](bi.PebBaseAddress) + 0x10)
ReadProcessMemory(pHandle, ptrToImageBase, addr baseAddressBytes, sizeof(PVOID), addr bytesWritten)

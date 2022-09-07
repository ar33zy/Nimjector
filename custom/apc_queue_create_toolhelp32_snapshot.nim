var entry: PROCESSENTRY32
entry.dwSize = cast[DWORD](sizeof(PROCESSENTRY32))
var threadEntry: THREADENTRY32
threadEntry.dwSize = cast[DWORD](sizeof(THREADENTRY32))
var hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS or TH32CS_SNAPTHREAD, 0)
var targetHandle = hSnapshot

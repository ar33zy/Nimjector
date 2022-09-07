let processName: string = r"REPLACE_PROCESS"
let processId = GetProcessbyName(processName)
let pHandle = OpenProcess(PROCESS_ALL_ACCESS, false, cast[DWORD](processId))

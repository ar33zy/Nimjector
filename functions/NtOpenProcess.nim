let processName: string = r"REPLACE_PROCESS"
let processId = GetProcessbyName(processName)

var cid: CLIENT_ID
var oa: OBJECT_ATTRIBUTES
var pHandle: HANDLE
cid.UniqueProcess = processID

res = NtOpenProcess(&pHandle, PROCESS_ALL_ACCESS, &oa, &cid)

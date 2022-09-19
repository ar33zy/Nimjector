let REPLACE_API_CALL = cast[gstubREPLACE_API_CALL](cast[LPVOID](syscallStub_REPLACE_COUNT))
var success: WINBOOL
VirtualProtect(cast[LPVOID](syscallStub_REPLACE_COUNT), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr gstub_op)
success = GetSyscallStub("REPLACE_API_CALL", cast[LPVOID](syscallStub_REPLACE_COUNT))

let processName = r"REPLACE_PROCESS"
var processEntry: PROCESSENTRY32
if Process32First(hSnapshot, addr entry):

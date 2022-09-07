let processName = r"REPLACE_PROCESS"
var 
  si: STARTUPINFOEX
  pi: PROCESS_INFORMATION
  ps: SECURITY_ATTRIBUTES
  ts: SECURITY_ATTRIBUTES

CreateProcess(NULL, newWideCString(processName), ps, ts, TRUE, CREATE_SUSPENDED, NULL, NULL, addr si.StartupInfo, addr pi)

var targetHandle = pi.hThread


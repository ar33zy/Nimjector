var 
  si: STARTUPINFOEX
  pi: PROCESS_INFORMATION
  ps: SECURITY_ATTRIBUTES
  ts: SECURITY_ATTRIBUTES

CreateProcess(NULL, newWideCString(processImage), ps, ts, TRUE, CREATE_SUSPENDED, NULL, NULL, addr si.StartupInfo, addr pi)

var pHandle = pi.hProcess

var pHandle = pi.hProcess
var bi: PROCESS_BASIC_INFORMATION
var tmp: ULONG
discard ZwQueryInformationProcess(pHandle, PROCESSINFOCLASS.ProcessBasicInformation, addr bi, cast[ULONG](sizeof(bi)), addr tmp)

var targetHandle = pi.hThread
res = NtQueueApcThread(targetHandle, cast[PKNORMAL_ROUTINE](rPtr), rPtr, NULL, NULL)

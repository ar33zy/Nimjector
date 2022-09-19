var targetHandle: HANDLE
res = NtCreateThreadEx(&targetHandle, THREAD_ALL_ACCESS, NULL, pHandle, rPtr, NULL, FALSE, 0, 0, 0, NULL)

for threadId in threadIds:
  let tHandle = OpenThread(THREAD_ALL_ACCESS, TRUE, cast[DWORD](threadId))

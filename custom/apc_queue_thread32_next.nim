  while Thread32Next(hSnapshot, addr threadEntry):
    if threadEntry.th32OwnerProcessID == processEntry.th32ProcessID:
      threadIds.add(threadEntry.th32ThreadID)

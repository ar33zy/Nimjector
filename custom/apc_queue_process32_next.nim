  while Process32Next(hSnapshot, addr entry):
    if entry.szExeFile.toString == processName:
      processEntry = entry


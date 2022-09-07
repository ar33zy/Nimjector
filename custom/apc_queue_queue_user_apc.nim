  let apcRoutine = cast[PTHREAD_START_ROUTINE](rPtr)
  QueueUserAPC(cast[PAPCFUNC](apcRoutine), tHandle, cast[ULONG_PTR](NULL))

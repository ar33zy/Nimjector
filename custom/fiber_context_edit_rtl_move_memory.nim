let target = cast[pointer](cast[int64](fiber) + 0xB0)
let source = cast[pointer](rPtr)
RtlMoveMemory(target, unsafeAddr source, cast[SIZE_T](8))

let initonce = INIT_ONCE_STATIC_INIT
var context: LPVOID
InitOnceExecuteOnce(cast[PINIT_ONCE](unsafeAddr initonce), cast[PINIT_ONCE_FN](rPtr), NULL, unsafeAddr context)

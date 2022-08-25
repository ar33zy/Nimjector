{.passC:"-masm=intel".}

# NtQueryInformationProcess -> EjiuPThxCsAfwgTK
# NtReadVirtualMemory -> fXPQkIXjDCQZKuVn
# NtProtectVirtualMemory -> uptxmbrgxZhBKtjx
# NtWriteVirtualMemory -> faLNTeuydmkJYjOG
# NtResumeThread -> bqbwzEiRZiTGYMhk
# NtClose -> KtbKoDwiqwzbwZAK

proc KtbKoDwiqwzbwZAK*(Handle: HANDLE): NTSTATUS {.asmNoStackFrame.} =
    asm """
	mov rax, gs:[0x60]                 
KtbKoDwiqwzbwZAK_Check_X_X_XXXX:               
	cmp dword ptr [rax+0x118], 6
	je  KtbKoDwiqwzbwZAK_Check_6_X_XXXX
	cmp dword ptr [rax+0x118], 10
	je  KtbKoDwiqwzbwZAK_Check_10_0_XXXX
	jmp KtbKoDwiqwzbwZAK_SystemCall_Unknown
KtbKoDwiqwzbwZAK_Check_6_X_XXXX:               
	cmp dword ptr [rax+0x11c], 1
	je  KtbKoDwiqwzbwZAK_Check_6_1_XXXX
	cmp dword ptr [rax+0x11c], 2
	je  KtbKoDwiqwzbwZAK_SystemCall_6_2_XXXX
	cmp dword ptr [rax+0x11c], 3
	je  KtbKoDwiqwzbwZAK_SystemCall_6_3_XXXX
	jmp KtbKoDwiqwzbwZAK_SystemCall_Unknown
KtbKoDwiqwzbwZAK_Check_6_1_XXXX:               
	cmp word ptr [rax+0x120], 7600
	je  KtbKoDwiqwzbwZAK_SystemCall_6_1_7600
	cmp word ptr [rax+0x120], 7601
	je  KtbKoDwiqwzbwZAK_SystemCall_6_1_7601
	jmp KtbKoDwiqwzbwZAK_SystemCall_Unknown
KtbKoDwiqwzbwZAK_Check_10_0_XXXX:              
	cmp word ptr [rax+0x120], 10240
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_10240
	cmp word ptr [rax+0x120], 10586
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_10586
	cmp word ptr [rax+0x120], 14393
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_14393
	cmp word ptr [rax+0x120], 15063
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_15063
	cmp word ptr [rax+0x120], 16299
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_16299
	cmp word ptr [rax+0x120], 17134
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_17134
	cmp word ptr [rax+0x120], 17763
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_17763
	cmp word ptr [rax+0x120], 18362
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_18362
	cmp word ptr [rax+0x120], 18363
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_18363
	cmp word ptr [rax+0x120], 19041
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_19041
	cmp word ptr [rax+0x120], 19042
	je  KtbKoDwiqwzbwZAK_SystemCall_10_0_19042
	jmp KtbKoDwiqwzbwZAK_SystemCall_Unknown
KtbKoDwiqwzbwZAK_SystemCall_6_1_7600:          
	mov eax, 0x000c
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_6_1_7601:          
	mov eax, 0x000c
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_6_2_XXXX:          
	mov eax, 0x000d
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_6_3_XXXX:          
	mov eax, 0x000e
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_10240:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_10586:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_14393:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_15063:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_16299:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_17134:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_17763:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_18362:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_18363:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_19041:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_10_0_19042:        
	mov eax, 0x000f
	jmp KtbKoDwiqwzbwZAK_Epilogue
KtbKoDwiqwzbwZAK_SystemCall_Unknown:           
	ret
KtbKoDwiqwzbwZAK_Epilogue:
	mov r10, rcx
	syscall
	ret
    """

proc uptxmbrgxZhBKtjx*(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.asmNoStackFrame.} =
    asm """
	mov rax, gs:[0x60]                                
uptxmbrgxZhBKtjx_Check_X_X_XXXX:               
	cmp dword ptr [rax+0x118], 6
	je  uptxmbrgxZhBKtjx_Check_6_X_XXXX
	cmp dword ptr [rax+0x118], 10
	je  uptxmbrgxZhBKtjx_Check_10_0_XXXX
	jmp uptxmbrgxZhBKtjx_SystemCall_Unknown
uptxmbrgxZhBKtjx_Check_6_X_XXXX:               
	cmp dword ptr [rax+0x11c], 1
	je  uptxmbrgxZhBKtjx_Check_6_1_XXXX
	cmp dword ptr [rax+0x11c], 2
	je  uptxmbrgxZhBKtjx_SystemCall_6_2_XXXX
	cmp dword ptr [rax+0x11c], 3
	je  uptxmbrgxZhBKtjx_SystemCall_6_3_XXXX
	jmp uptxmbrgxZhBKtjx_SystemCall_Unknown
uptxmbrgxZhBKtjx_Check_6_1_XXXX:               
	cmp word ptr [rax+0x120], 7600
	je  uptxmbrgxZhBKtjx_SystemCall_6_1_7600
	cmp word ptr [rax+0x120], 7601
	je  uptxmbrgxZhBKtjx_SystemCall_6_1_7601
	jmp uptxmbrgxZhBKtjx_SystemCall_Unknown
uptxmbrgxZhBKtjx_Check_10_0_XXXX:              
	cmp word ptr [rax+0x120], 10240
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_10240
	cmp word ptr [rax+0x120], 10586
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_10586
	cmp word ptr [rax+0x120], 14393
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_14393
	cmp word ptr [rax+0x120], 15063
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_15063
	cmp word ptr [rax+0x120], 16299
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_16299
	cmp word ptr [rax+0x120], 17134
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_17134
	cmp word ptr [rax+0x120], 17763
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_17763
	cmp word ptr [rax+0x120], 18362
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_18362
	cmp word ptr [rax+0x120], 18363
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_18363
	cmp word ptr [rax+0x120], 19041
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_19041
	cmp word ptr [rax+0x120], 19042
	je  uptxmbrgxZhBKtjx_SystemCall_10_0_19042
	jmp uptxmbrgxZhBKtjx_SystemCall_Unknown
uptxmbrgxZhBKtjx_SystemCall_6_1_7600:          
	mov eax, 0x004d
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_6_1_7601:          
	mov eax, 0x004d
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_6_2_XXXX:          
	mov eax, 0x004e
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_6_3_XXXX:          
	mov eax, 0x004f
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_10240:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_10586:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_14393:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_15063:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_16299:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_17134:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_17763:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_18362:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_18363:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_19041:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_10_0_19042:        
	mov eax, 0x0050
	jmp uptxmbrgxZhBKtjx_Epilogue
uptxmbrgxZhBKtjx_SystemCall_Unknown:           
	ret
uptxmbrgxZhBKtjx_Epilogue:
	mov r10, rcx
	syscall
	ret
    """

proc EjiuPThxCsAfwgTK*(ProcessHandle: HANDLE, ProcessInformationClass: PROCESSINFOCLASS, ProcessInformation: PVOID, ProcessInformationLength: ULONG, ReturnLength: PULONG): NTSTATUS {.asmNoStackFrame.} =
    asm """
	mov rax, gs:[0x60]                                   
EjiuPThxCsAfwgTK_Check_X_X_XXXX:               
	cmp dword ptr [rax+0x118], 6
	je  EjiuPThxCsAfwgTK_Check_6_X_XXXX
	cmp dword ptr [rax+0x118], 10
	je  EjiuPThxCsAfwgTK_Check_10_0_XXXX
	jmp EjiuPThxCsAfwgTK_SystemCall_Unknown
EjiuPThxCsAfwgTK_Check_6_X_XXXX:               
	cmp dword ptr [rax+0x11c], 1
	je  EjiuPThxCsAfwgTK_Check_6_1_XXXX
	cmp dword ptr [rax+0x11c], 2
	je  EjiuPThxCsAfwgTK_SystemCall_6_2_XXXX
	cmp dword ptr [rax+0x11c], 3
	je  EjiuPThxCsAfwgTK_SystemCall_6_3_XXXX
	jmp EjiuPThxCsAfwgTK_SystemCall_Unknown
EjiuPThxCsAfwgTK_Check_6_1_XXXX:               
	cmp word ptr [rax+0x120], 7600
	je  EjiuPThxCsAfwgTK_SystemCall_6_1_7600
	cmp word ptr [rax+0x120], 7601
	je  EjiuPThxCsAfwgTK_SystemCall_6_1_7601
	jmp EjiuPThxCsAfwgTK_SystemCall_Unknown
EjiuPThxCsAfwgTK_Check_10_0_XXXX:              
	cmp word ptr [rax+0x120], 10240
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_10240
	cmp word ptr [rax+0x120], 10586
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_10586
	cmp word ptr [rax+0x120], 14393
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_14393
	cmp word ptr [rax+0x120], 15063
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_15063
	cmp word ptr [rax+0x120], 16299
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_16299
	cmp word ptr [rax+0x120], 17134
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_17134
	cmp word ptr [rax+0x120], 17763
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_17763
	cmp word ptr [rax+0x120], 18362
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_18362
	cmp word ptr [rax+0x120], 18363
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_18363
	cmp word ptr [rax+0x120], 19041
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_19041
	cmp word ptr [rax+0x120], 19042
	je  EjiuPThxCsAfwgTK_SystemCall_10_0_19042
	jmp EjiuPThxCsAfwgTK_SystemCall_Unknown
EjiuPThxCsAfwgTK_SystemCall_6_1_7600:          
	mov eax, 0x0016
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_6_1_7601:          
	mov eax, 0x0016
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_6_2_XXXX:          
	mov eax, 0x0017
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_6_3_XXXX:          
	mov eax, 0x0018
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_10240:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_10586:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_14393:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_15063:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_16299:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_17134:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_17763:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_18362:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_18363:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_19041:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_10_0_19042:        
	mov eax, 0x0019
	jmp EjiuPThxCsAfwgTK_Epilogue
EjiuPThxCsAfwgTK_SystemCall_Unknown:           
	ret
EjiuPThxCsAfwgTK_Epilogue:
	mov r10, rcx
	syscall
	ret
    """

proc fXPQkIXjDCQZKuVn*(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, BufferSize: SIZE_T, NumberOfBytesRead: PSIZE_T): NTSTATUS {.asmNoStackFrame.} =
    asm """
	mov rax, gs:[0x60]                             
fXPQkIXjDCQZKuVn_Check_X_X_XXXX:               
	cmp dword ptr [rax+0x118], 6
	je  fXPQkIXjDCQZKuVn_Check_6_X_XXXX
	cmp dword ptr [rax+0x118], 10
	je  fXPQkIXjDCQZKuVn_Check_10_0_XXXX
	jmp fXPQkIXjDCQZKuVn_SystemCall_Unknown
fXPQkIXjDCQZKuVn_Check_6_X_XXXX:               
	cmp dword ptr [rax+0x11c], 1
	je  fXPQkIXjDCQZKuVn_Check_6_1_XXXX
	cmp dword ptr [rax+0x11c], 2
	je  fXPQkIXjDCQZKuVn_SystemCall_6_2_XXXX
	cmp dword ptr [rax+0x11c], 3
	je  fXPQkIXjDCQZKuVn_SystemCall_6_3_XXXX
	jmp fXPQkIXjDCQZKuVn_SystemCall_Unknown
fXPQkIXjDCQZKuVn_Check_6_1_XXXX:               
	cmp word ptr [rax+0x120], 7600
	je  fXPQkIXjDCQZKuVn_SystemCall_6_1_7600
	cmp word ptr [rax+0x120], 7601
	je  fXPQkIXjDCQZKuVn_SystemCall_6_1_7601
	jmp fXPQkIXjDCQZKuVn_SystemCall_Unknown
fXPQkIXjDCQZKuVn_Check_10_0_XXXX:              
	cmp word ptr [rax+0x120], 10240
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_10240
	cmp word ptr [rax+0x120], 10586
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_10586
	cmp word ptr [rax+0x120], 14393
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_14393
	cmp word ptr [rax+0x120], 15063
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_15063
	cmp word ptr [rax+0x120], 16299
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_16299
	cmp word ptr [rax+0x120], 17134
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_17134
	cmp word ptr [rax+0x120], 17763
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_17763
	cmp word ptr [rax+0x120], 18362
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_18362
	cmp word ptr [rax+0x120], 18363
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_18363
	cmp word ptr [rax+0x120], 19041
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_19041
	cmp word ptr [rax+0x120], 19042
	je  fXPQkIXjDCQZKuVn_SystemCall_10_0_19042
	jmp fXPQkIXjDCQZKuVn_SystemCall_Unknown
fXPQkIXjDCQZKuVn_SystemCall_6_1_7600:          
	mov eax, 0x003c
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_6_1_7601:          
	mov eax, 0x003c
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_6_2_XXXX:          
	mov eax, 0x003d
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_6_3_XXXX:          
	mov eax, 0x003e
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_10240:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_10586:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_14393:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_15063:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_16299:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_17134:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_17763:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_18362:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_18363:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_19041:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_10_0_19042:        
	mov eax, 0x003f
	jmp fXPQkIXjDCQZKuVn_Epilogue
fXPQkIXjDCQZKuVn_SystemCall_Unknown:           
	ret
fXPQkIXjDCQZKuVn_Epilogue:
	mov r10, rcx
	syscall
	ret
    """

proc bqbwzEiRZiTGYMhk*(ThreadHandle: HANDLE, PreviousSuspendCount: PULONG): NTSTATUS {.asmNoStackFrame.} =
    asm """
	mov rax, gs:[0x60]                        
bqbwzEiRZiTGYMhk_Check_X_X_XXXX:               
	cmp dword ptr [rax+0x118], 6
	je  bqbwzEiRZiTGYMhk_Check_6_X_XXXX
	cmp dword ptr [rax+0x118], 10
	je  bqbwzEiRZiTGYMhk_Check_10_0_XXXX
	jmp bqbwzEiRZiTGYMhk_SystemCall_Unknown
bqbwzEiRZiTGYMhk_Check_6_X_XXXX:               
	cmp dword ptr [rax+0x11c], 1
	je  bqbwzEiRZiTGYMhk_Check_6_1_XXXX
	cmp dword ptr [rax+0x11c], 2
	je  bqbwzEiRZiTGYMhk_SystemCall_6_2_XXXX
	cmp dword ptr [rax+0x11c], 3
	je  bqbwzEiRZiTGYMhk_SystemCall_6_3_XXXX
	jmp bqbwzEiRZiTGYMhk_SystemCall_Unknown
bqbwzEiRZiTGYMhk_Check_6_1_XXXX:               
	cmp word ptr [rax+0x120], 7600
	je  bqbwzEiRZiTGYMhk_SystemCall_6_1_7600
	cmp word ptr [rax+0x120], 7601
	je  bqbwzEiRZiTGYMhk_SystemCall_6_1_7601
	jmp bqbwzEiRZiTGYMhk_SystemCall_Unknown
bqbwzEiRZiTGYMhk_Check_10_0_XXXX:              
	cmp word ptr [rax+0x120], 10240
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_10240
	cmp word ptr [rax+0x120], 10586
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_10586
	cmp word ptr [rax+0x120], 14393
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_14393
	cmp word ptr [rax+0x120], 15063
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_15063
	cmp word ptr [rax+0x120], 16299
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_16299
	cmp word ptr [rax+0x120], 17134
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_17134
	cmp word ptr [rax+0x120], 17763
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_17763
	cmp word ptr [rax+0x120], 18362
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_18362
	cmp word ptr [rax+0x120], 18363
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_18363
	cmp word ptr [rax+0x120], 19041
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_19041
	cmp word ptr [rax+0x120], 19042
	je  bqbwzEiRZiTGYMhk_SystemCall_10_0_19042
	jmp bqbwzEiRZiTGYMhk_SystemCall_Unknown
bqbwzEiRZiTGYMhk_SystemCall_6_1_7600:          
	mov eax, 0x004f
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_6_1_7601:          
	mov eax, 0x004f
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_6_2_XXXX:          
	mov eax, 0x0050
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_6_3_XXXX:          
	mov eax, 0x0051
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_10240:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_10586:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_14393:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_15063:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_16299:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_17134:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_17763:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_18362:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_18363:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_19041:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_10_0_19042:        
	mov eax, 0x0052
	jmp bqbwzEiRZiTGYMhk_Epilogue
bqbwzEiRZiTGYMhk_SystemCall_Unknown:           
	ret
bqbwzEiRZiTGYMhk_Epilogue:
	mov r10, rcx
	syscall
	ret
    """

proc faLNTeuydmkJYjOG*(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.asmNoStackFrame.} =
    asm """
	mov rax, gs:[0x60]                              
faLNTeuydmkJYjOG_Check_X_X_XXXX:               
	cmp dword ptr [rax+0x118], 6
	je  faLNTeuydmkJYjOG_Check_6_X_XXXX
	cmp dword ptr [rax+0x118], 10
	je  faLNTeuydmkJYjOG_Check_10_0_XXXX
	jmp faLNTeuydmkJYjOG_SystemCall_Unknown
faLNTeuydmkJYjOG_Check_6_X_XXXX:               
	cmp dword ptr [rax+0x11c], 1
	je  faLNTeuydmkJYjOG_Check_6_1_XXXX
	cmp dword ptr [rax+0x11c], 2
	je  faLNTeuydmkJYjOG_SystemCall_6_2_XXXX
	cmp dword ptr [rax+0x11c], 3
	je  faLNTeuydmkJYjOG_SystemCall_6_3_XXXX
	jmp faLNTeuydmkJYjOG_SystemCall_Unknown
faLNTeuydmkJYjOG_Check_6_1_XXXX:               
	cmp word ptr [rax+0x120], 7600
	je  faLNTeuydmkJYjOG_SystemCall_6_1_7600
	cmp word ptr [rax+0x120], 7601
	je  faLNTeuydmkJYjOG_SystemCall_6_1_7601
	jmp faLNTeuydmkJYjOG_SystemCall_Unknown
faLNTeuydmkJYjOG_Check_10_0_XXXX:              
	cmp word ptr [rax+0x120], 10240
	je  faLNTeuydmkJYjOG_SystemCall_10_0_10240
	cmp word ptr [rax+0x120], 10586
	je  faLNTeuydmkJYjOG_SystemCall_10_0_10586
	cmp word ptr [rax+0x120], 14393
	je  faLNTeuydmkJYjOG_SystemCall_10_0_14393
	cmp word ptr [rax+0x120], 15063
	je  faLNTeuydmkJYjOG_SystemCall_10_0_15063
	cmp word ptr [rax+0x120], 16299
	je  faLNTeuydmkJYjOG_SystemCall_10_0_16299
	cmp word ptr [rax+0x120], 17134
	je  faLNTeuydmkJYjOG_SystemCall_10_0_17134
	cmp word ptr [rax+0x120], 17763
	je  faLNTeuydmkJYjOG_SystemCall_10_0_17763
	cmp word ptr [rax+0x120], 18362
	je  faLNTeuydmkJYjOG_SystemCall_10_0_18362
	cmp word ptr [rax+0x120], 18363
	je  faLNTeuydmkJYjOG_SystemCall_10_0_18363
	cmp word ptr [rax+0x120], 19041
	je  faLNTeuydmkJYjOG_SystemCall_10_0_19041
	cmp word ptr [rax+0x120], 19042
	je  faLNTeuydmkJYjOG_SystemCall_10_0_19042
	jmp faLNTeuydmkJYjOG_SystemCall_Unknown
faLNTeuydmkJYjOG_SystemCall_6_1_7600:          
	mov eax, 0x0037
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_6_1_7601:          
	mov eax, 0x0037
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_6_2_XXXX:          
	mov eax, 0x0038
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_6_3_XXXX:          
	mov eax, 0x0039
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_10240:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_10586:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_14393:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_15063:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_16299:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_17134:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_17763:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_18362:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_18363:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_19041:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_10_0_19042:        
	mov eax, 0x003a
	jmp faLNTeuydmkJYjOG_Epilogue
faLNTeuydmkJYjOG_SystemCall_Unknown:           
	ret
faLNTeuydmkJYjOG_Epilogue:
	mov r10, rcx
	syscall
	ret
    """

type
  PS_ATTR_UNION* {.pure, union.} = object
    Value*: ULONG
    ValuePtr*: PVOID
  PS_ATTRIBUTE* {.pure.} = object
    Attribute*: ULONG 
    Size*: SIZE_T
    u1*: PS_ATTR_UNION
    ReturnLength*: PSIZE_T
  PPS_ATTRIBUTE* = ptr PS_ATTRIBUTE
  PS_ATTRIBUTE_LIST* {.pure.} = object
    TotalLength*: SIZE_T
    Attributes*: array[2, PS_ATTRIBUTE]
  PPS_ATTRIBUTE_LIST* = ptr PS_ATTRIBUTE_LIST

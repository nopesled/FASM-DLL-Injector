format PE GUI 4.0
entry start

; Created by nopesled
; Contact: aaron.costello@ymail.com
; Tested on MSN

include 'INCLUDE\WIN32A.INC'
include 'INCLUDE\cmd.inc'

section '.data' data readable writeable

hbuff dd ?
hhndl dd ?
fms db '%s',0
krnl db 'kernel32.dll',0
libr db 'LoadLibraryA',0
injd db 'C:\Documents and Settings\x\Desktop\FASM\specialdll.DLL',0
szinjd = $ - injd
procid dd ?
procs  dd ?
pages  dd ?
thrid  dd ?
openings db 'Cant open process',0
virtualz db 'Because of addressing',0
writings db 'Cant write to process',0
getaddresss db 'Couldnt get loadlibrary',0
makethreads db 'Couldnt attach the thread',0

section '.code' code readable executable

        start:
                invoke GetProcessHeap
                mov [hhndl],eax
                invoke HeapAlloc,[hhndl],HEAP_NO_SERIALIZE,1000h
                mov [hbuff],eax
                call GetMainArgs
                mov esi,[_argv]
                add esi,4
                cinvoke wsprintf,[hbuff],fms,[esi]

                invoke  FindWindow,NULL,[hbuff]
                invoke  GetWindowThreadProcessId,eax,procid
                invoke  OpenProcess,PROCESS_ALL_ACCESS,FALSE,[procid]
                cmp eax,NULL
                jz opening
                mov [procs],eax
                invoke  VirtualAllocEx,eax,NULL,szinjd,MEM_COMMIT+MEM_RESERVE,PAGE_EXECUTE_READWRITE
                cmp eax,NULL
                jz virtuals
                mov [pages],eax
                invoke  WriteProcessMemory,[procs],[pages],injd,szinjd,0
                cmp eax,0
                jz writing
                invoke  GetModuleHandle,krnl
                invoke  GetProcAddress,eax,libr
                cmp eax,NULL
                jz getaddress
                invoke  CreateRemoteThread,[procs],0,0,eax,[pages],0,thrid
                cmp eax,NULL
                jz makethread
                invoke  HeapFree,[hhndl],HEAP_NO_SERIALIZE,[hbuff]
                invoke  ExitProcess,0

        opening:
                invoke MessageBox,0,openings,NULL,MB_OK
                invoke  ExitProcess,0
        virtuals:
                invoke MessageBox,0,virtualz,NULL,MB_OK
                invoke  ExitProcess,0

        writing:
                invoke MessageBox,0,writings,NULL,MB_OK
                invoke  ExitProcess,0
        getaddress:
                invoke MessageBox,0,getaddresss,NULL,MB_OK
                invoke  ExitProcess,0
        makethread:
                invoke MessageBox,0,makethreads,NULL,MB_OK
                invoke  ExitProcess,0

section '.idata' import data readable

library kernel32,'kernel32.dll',\
        user32,'user32.dll'

import kernel32,\
       GetCommandLine,'GetCommandLineA',\
       GetProcessHeap,'GetProcessHeap',\
       HeapAlloc,'HeapAlloc',\
       HeapFree,'HeapFree',\
       OpenProcess,'OpenProcess',\
       VirtualAllocEx,'VirtualAllocEx',\
       WriteProcessMemory,'WriteProcessMemory',\
       GetModuleHandle,'GetModuleHandleA',\
       GetProcAddress,'GetProcAddress',\
       CreateRemoteThread,'CreateRemoteThread',\
       ExitProcess,'ExitProcess'

import user32,\
       MessageBox,'MessageBoxA',\
       wsprintf,'wsprintfA',\
       FindWindow,'FindWindowA',\
       GetWindowThreadProcessId,'GetWindowThreadProcessId'

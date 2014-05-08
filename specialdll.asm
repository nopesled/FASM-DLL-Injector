format PE GUI 4.0 DLL
entry DllEntryPoint

include '\INCLUDE\WIN32A.INC'

section '.data' data readable writeable

szText db 'I am inside!',0
szTitle db 'Success',0

section '.code' code readable executable

proc DllEntryPoint hinstDLL,fdwReason,lpvReserved
        mov     eax,TRUE
        invoke MessageBox,NULL,szText,szTitle,MB_OK
        ret
endp

proc DummyProc
     ret
endp


section '.idata' import data readable writeable
library user32,'user32.dll'

  import user32,\
         MessageBox,'MessageBoxA'

section '.edata' export data readable

  export 'specialdll.dll',\
         DummyProc,'DummyProc'

section '.reloc' fixups data discardable

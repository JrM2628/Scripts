;
;Jake McLellen
;Template for Microsoft MASM (CSec 201) 
;

.586
.model flat,stdcall
.stack 4096

includelib libcmt.lib
includelib legacy_stdio_definitions.lib

extern printf:NEAR
extern scanf:NEAR

ExitProcess PROTO, dwExitCode: DWORD

.data 
	;initialize variables
	

.code
	main PROC c
	;instructions
	

	main endp
	invoke ExitProcess, 0
end
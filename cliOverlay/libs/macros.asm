;
;   set of macros used across the main program
;
%include "cliOverlay/libs/linux64.asm"

%macro printString 1
    mov rax, %1
    mov rbx, 0
    %%printLoop:
        mov cl, [rax]
        cmp cl, 0
        je %%endPrintLoop
        inc rbx
        inc rax
        jmp %%printLoop
    %%endPrintLoop:
        mov rax, SYS_WRITE
        mov rdi, STDIN
        mov rsi, %1
        mov rdx, rbx
        syscall
%endmacro

; 1 = command, 2 = argument
%macro runBashCommand 2
    mov rdx, 0 ; no address of environment variable as there are not any
    mov rcx, %2
    mov rbx, %1
    mov rax, 11 ; sys_execve - kernel opcode 11
    int 0x80
%endmacro

; input format goes as follows:
; interface, path_to_script, space_for_joined_interface_command, bash (command /bin/bash)
; macro joins interface and path to script string and then executes it as a bash command
%macro runCommand 4

    mov edi, %3   ; Address of output buffer
    mov esi, %2   ; Address of input buffer
    loop1:
        mov al, [esi]
        inc esi
        mov [edi], al
        inc edi
        cmp al, 0
        jne loop1

    dec edi            ; Removes the zero
    mov esi, %1
    loop2:
        mov al, [esi]
        inc esi
        mov [edi], al
        inc edi
        cmp al, 0
        jne loop2        ; This zero needs to stay

    ;printString %4
    ;printString %3

    runBashCommand %3, %4
%endmacro

%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

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

%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

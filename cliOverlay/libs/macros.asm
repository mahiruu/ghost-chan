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

%macro runCommand 2
    mov rax, 11
    mov rbx, %1
    mov rcx, %2
    xor rdx, rdx
    int 0x80
%endmacro

%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro
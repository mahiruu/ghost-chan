;
; simple command line interface made for ghost-chan scripts
;
; by ma-chan
;
%include "cliOverlay/libs/macros.asm"

section .data
  TITLE db "* __ghost_chan__ *", 10, 0
  WELCOME_MESSAGE db "* This is an overlay for easily running ghost-chan scripts.",10, 0
  MORE_INFO db "* Scripts are located in this apps scripts folder", 10, 0
  MORE_INFO2 db "* or in the downloaded git repo and can be run manually.", 10, 0

  CHOICE0_MESSAGE db "* press 0 to exit the program", 10, 0
  CHOICE1_MESSAGE db "* press 1 to set the working network interface", 10, 0
  CHOICE2_MESSAGE db "* press 2 to change your mac address to a random one", 10, 0
  CHOICE3_MESSAGE db "* press 3 to restore your mac address to the original one", 10, 0
  CHOICE4_MESSAGE db "* press 4 to assign a random IP address which is located in the current network", 10, 0
  CHOICE5_MESSAGE db "* press 5 to enter a ghost mode (assigning random IP address and mac address overtime)", 10, 0
  CHOICE6_MESSAGE db "* press 6 to enter a ghost mode - mac only (assigning random mac address overtime)", 10, 0
  ERROR_MESSAGE   db "* this is not a viable option", 10, 0

  CHOICE_0 db "0",0
  CHOICE_1 db "1",0
  CHOICE_2 db "2",0
  CHOICE_3 db "3",0
  CHOICE_4 db "4",0
  CHOICE_5 db "5",0
  CHOICE_6 db "6",0

  NEWLINE db 10, 0h

  BASH db '/bin/bash', 0

  MACCHANGER_SCRIPT db './scripts/changeMac.sh', 0
  RESTORE_MAC_SCRIPT db './scripts/restoreMac.sh', 0
  RANDOMIP_SCRIPT db './scripts/randomIpAd.sh', 0
  GHOST_MODE_SCRIPT db './scripts/ghostMode.sh', 0
  GHOST_MODE_MACONLY_SCRIPT db './scripts/ghostModeMacOnly.sh', 0

  ; making this code nanoseconds faster by pre-allocating all the pointers
  args1 dd BASH
     dd MACCHANGER_SCRIPT
     dd interface
     dd 0

  args2 dd BASH
      dd RESTORE_MAC_SCRIPT
      dd interface
      dd 0

  args3 dd BASH
      dd RANDOMIP_SCRIPT
      dd interface
      dd 0

  args4 dd BASH
      dd GHOST_MODE_SCRIPT
      dd interface
      dd 0

  args5 dd BASH
      dd GHOST_MODE_MACONLY_SCRIPT
      dd interface
      dd 0

  ; losing the extra time by this mess:
  ; I am only keeping it as a way to show how to change the values in pointer
  timeval:
      tv_sec  dd 0
      tv_nsec dd 0

section .bss
    choice: resb 8
    interface: resb 32
    newlined_interface: resb 32

section .text
    global _start

    _start:
        _menuLoop:
            call _printUserMenu
            call _getUserChoice
            call _checkForOption0

    _printUserMenu:
        printString TITLE
        printString WELCOME_MESSAGE
        printString MORE_INFO
        printString MORE_INFO2
        printString NEWLINE

        printString CHOICE0_MESSAGE
        printString CHOICE1_MESSAGE
        printString CHOICE2_MESSAGE
        printString CHOICE3_MESSAGE
        printString CHOICE4_MESSAGE
        printString CHOICE5_MESSAGE
        printString CHOICE6_MESSAGE

        ret

    _getUserChoice:
        mov rax, 0
        mov rdi, 0
        mov rsi, choice
        mov rdx, 8 ; byte length of choice
        syscall
        ret

    _getInterface:
       mov rax, 0
       mov rdi, 0
       mov rsi, newlined_interface
       mov rdx, 32 ; byte length of interface name
       syscall

       ; removal of newline char
       mov rdi, interface
       mov rsi, newlined_interface
       loopp:
            mov al, [rsi]
            cmp al, 10
            je endd
            inc rsi
            mov [rdi], al
            inc rdi
            cmp al, 0
            jne loopp
       endd:
       ret

    _checkForOption0:
        mov rsi, choice
        mov rdi, CHOICE_0
        mov rcx, 1
        repe cmpsb
        jne _checkForOption1
        exit ; option 0 means exiting the program

    _checkForOption1:
        mov rsi, choice
        mov rdi, CHOICE_1
        mov rcx, 1
        repe cmpsb
        jne _checkForOption2 ; jump to option 2
        call _getInterface
        jmp _menuLoop

    _checkForOption2:
       mov rsi, choice
       mov rdi, CHOICE_2
       mov rcx, 1
       repe cmpsb
       jne _checkForOption3 ; jump to option 3

       ; SYS_FORK
       mov rax, 2
       int 80h

       cmp rax, 0
       jz  script_exec1

       parent1:
           ; not the best solution but it does the job
           mov dword [tv_sec], 1
           mov dword [tv_nsec], 0

           mov rax, 162
           mov rbx, timeval
           mov rcx, 0
           int 0x80
           ;printString NEWLINE
           jmp _menuLoop

       script_exec1:
           runBashCommand BASH, args1
           exit ;redundant as the script calls for exit itself

    _checkForOption3:
       mov rsi, choice
       mov rdi, CHOICE_3
       mov rcx, 1
       repe cmpsb
       jne _checkForOption4

       ; SYS_FORK
       mov rax, 2
       int 80h

       cmp rax, 0
       jz  script_exec2

       parent2:
       ; not the best solution but it does the job
       mov dword [tv_sec], 1
       mov dword [tv_nsec], 0

       mov rax, 162
       mov rbx, timeval
       mov rcx, 0
       int 0x80
       jmp _menuLoop

       script_exec2:
       runBashCommand BASH, args2
       exit ;redundant as the script calls for exit itself


    _checkForOption4:
        mov rsi, choice
        mov rdi, CHOICE_4
        mov rcx, 1
        repe cmpsb
        jne _checkForOption5
        jmp _menuLoop

    _checkForOption5:
        mov rsi, choice
        mov rdi, CHOICE_5
        mov rcx, 1
        repe cmpsb
        jne _checkForOption6
        jmp _menuLoop

    _checkForOption6:
        mov rsi, choice
        mov rdi, CHOICE_6
        mov rcx, 1
        repe cmpsb
        jne _errorMSG
        jmp _menuLoop

    _errorMSG:
        printString ERROR_MESSAGE
        jmp _menuLoop
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


  CHOICE_0 db "0"
  CHOICE_1 db "1"
  CHOICE_2 db "2"
  CHOICE_3 db "3"
  CHOICE_4 db "4"
  CHOICE_5 db "5"
  CHOICE_6 db "6"

  TESTS db "worked", 10, 0
  NEWLINE db "*", 10, 0

  BASH db '/bin/bash',0

  ; interface db 'wlo1',0
  MACCHANGER_SCRIPT db 'scripts/changeMac.sh', 0
  RESTORE_MAC_SCRIPT db 'scripts/restoreMac.sh', 0
  RANDOMIP_SCRIPT db 'scripts/randomIpAd.sh', 0
  GHOST_MODE_SCRIPT db 'scripts/ghostMode.sh', 0
  GHOST_MODE_MACONLY_SCRIPT db 'scripts/ghostModeMacOnly.sh', 0
  ; COMMAND dq interface, script, 0

section .bss
    choice resb 8
    interface resb 32
    script resb 32

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

        syscall
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
       mov rsi, interface
       mov rdx, 32 ; byte length of interface name
       syscall
       ret

    _checkForOption0:
        mov rsi, choice
        mov rdi, CHOICE_0
        mov rcx, 1
        repe cmpsb
        jne _checkForOption1
        exit

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
       jne _checkForOption3: ; jump to option 3
       ; call _setCommand
       ; DOES NOT WORK
       ;  TODO: assign script and the name of the interface to the array
       ; just add the two strings together ffs
;       mov rax, interface
;       mov [COMMAND], rax
;       mov rax, MACCHANGER_SCRIPT
;       mov [COMMAND+32], rax
;       mov qword [script], rax
;       printString COMMAND
       ;runCommand BASH, COMMAND

       exit

    _checkForOption3:
        jmp _menuLoop
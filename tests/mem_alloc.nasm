extern printf
global main

section .bss
    something resb 1
    start resq 1

section .data
    data1 db 'a', 0
    data2 db 'b', 0
    fmt db "current break: %x", 10, 0
    SYS_EXIT equ 60
    SYS_BRK equ 12


section .text
main:
    push rbp
    mov rbp, rsp

    mov byte [something], 'a'

    ; get current break
    mov rax, SYS_BRK
    mov rdi, 0
    syscall

    mov qword [start], rax

    ; allocate two byte
    lea rdi, [rax + 4]
    ; did a lea instead of mov because we want the address
    mov rax, SYS_BRK
    syscall

    ; this actually stores data1 and data2 to rdi because rdi is a quad word and
    ; data1 and data2 come one after another in memory
    ; doing rdi - <some amout> can get me data inside of .bss segment
    mov rdi, [start]
    ;mov rsi, data1
    mov rdi, data1


debug:

    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

    leave
    ret

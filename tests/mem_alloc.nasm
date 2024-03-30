extern printf
global main
section .data
    fmt db "current break: %x", 10, 0
    SYS_EXIT equ 60
    SYS_BRK equ 12
    data1 db "a", 0
    data2 db "b", 0

section .bss
    start resq 1

section .text
main:
    push rbp
    mov rbp, rsp

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

debug:
    mov rdi, [start]
    mov byte [rdi], 'a'
    mov byte [rdi + 1], 0
    mov byte [rdi + 2], 'b'
    mov byte [rdi + 3], 0

    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

    leave
    ret

global main

section .data
    SYS_BRK equ 12
    SYS_EXIT equ 60

section .bss
    start resq 1

section .text

init:
    push rbp
    mov rbp, rsp

    mov rax, SYS_BRK
    mov rdi, 0
    syscall

    mov qword [start], rax

    leave
    ret

func:
section .bss
    .size resq 1
    .data resq 1

section .text
    push rbp
    mov rbp, rsp

    mov qword [.data], rdi
    mov qword [.size], rsi

    ;; allocate memory
    lea rdi, [rax + .size]
    mov rax, SYS_BRK
    syscall

    mov rdi, [start]
    mov rdi, .data

    leave
    ret

main:
    push rbp
    mov rbp, rsp

    call init

    mov rdi, 'a'
    mov rsi, 1
    call func
debug

    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

    leave
    ret

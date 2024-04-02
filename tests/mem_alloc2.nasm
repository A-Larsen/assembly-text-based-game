global main

section .data
    data1 db 'hello', 0
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

    mov rbx, rax
    mov [start], rbx

    leave
    ret

func:
section .bss
    .size resq 1
    .data resq 1

section .text
    push rbp
    mov rbp, rsp

    mov rdi, [rdi]
    mov qword [.data], rdi
    mov qword [.size], rsi

    ;; allocate memory
    mov rax, [start]
    lea rdi, [rax + .size]
    mov rax, SYS_BRK
    syscall

    sub rax, .size
    mov rdi, [.data]
    mov qword [rax], rdi

    leave
    ret

main:
    push rbp
    mov rbp, rsp

    call init

    mov rdi, data1
    mov rsi, 6
    call func

debug:

    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

    leave
    ret

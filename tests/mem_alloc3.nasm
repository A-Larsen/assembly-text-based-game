global main

section .data
    data1 db 'hello', 0
    data2 db 'goodbye', 0
    SYS_EXIT equ 60

section .text

func:
section .data
    .first_call db 0
    .SYS_BRK equ 12

section .bss
    .size resq 1
    .data resq 1
    .program_break resq 1


section .text
    push rbp
    mov rbp, rsp

    mov qword [.data], rdi
    mov qword [.size], rsi

    cmp byte [.first_call], 1
    je .end

    mov rax, .SYS_BRK
    mov rdi, 0
    syscall

    mov [.program_break], rax

    mov byte [.first_call], 1

.end:


    ;; allocate memory
    mov rdi, [.program_break]
    add rdi, [.size]
    mov rax, .SYS_BRK
    syscall

    mov rbx, [.program_break]
    mov rdi, [.data]
    mov qword [rbx], rdi

    mov rdi, [.size]
    add qword [.program_break], rdi

    leave
    ret

main:
    push rbp
    mov rbp, rsp

    mov rdi, [data1]
    mov rsi, 6
    call func

    mov rdi, [data2]
    mov rsi, 8
    call func

debug:

    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

    leave
    ret

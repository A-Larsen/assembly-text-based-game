global main

section .data
    data1 db 'hello', 0
    data2 db 'goodbye', 0
    SYS_EXIT equ 60

section .text

memalloc:
section .data
    .first_call db 0
    .SYS_BRK equ 12

section .bss
    .size resq 1
    .data resq 1
    .alloc_address resq 1

section .text
    push rbp
    mov rbp, rsp

    mov qword [.data], rdi
    mov qword [.size], rsi

    cmp byte [.first_call], 1
    je .end
    
    ; get location of system break
    mov rax, .SYS_BRK
    mov rdi, 0
    syscall

    mov [.alloc_address], rax

    mov byte [.first_call], 1

.end:

    ; allocate memory by moving system break to a new location
    mov rdi, [.alloc_address]
    add rdi, [.size]
    mov rax, .SYS_BRK
    syscall

    mov rbx, [.alloc_address]
    mov rdi, [.data]
    mov qword [rbx], rdi

    mov rdi, [.size]
    mov rax, [.alloc_address] ; return the starting address of the data
    add qword [.alloc_address], rdi

    leave
    ret

main:
    push rbp
    mov rbp, rsp

    mov rdi, [data1]
    mov rsi, 6
    call memalloc

    mov rdi, [data2]
    mov rsi, 8
    call memalloc

debug:

    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

    leave
    ret

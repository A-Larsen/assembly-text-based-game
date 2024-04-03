global memalloc

section .text

memalloc:
section .data
    .first_call db 0

section .bss
    .size resq 1
    .data resq 1
    .alloc_address resq 1

section .text
    push rbp
    mov rbp, rsp

    push rbx
    push rcx

    mov qword [.data], rdi
    mov qword [.size], rsi

    cmp byte [.first_call], 1
    je .end
    
    ; get location of system break
    mov rax, 12 ; 12 is sys_brk
    mov rdi, 0
    syscall

    mov [.alloc_address], rax

    mov byte [.first_call], 1

.end:

    ; allocate memory by moving system break to a new location
    mov rdi, [.alloc_address]
    add rdi, [.size]
    mov rax, 12 ; 12 is sys_brk
    syscall

    mov rbx, [.alloc_address]
    mov rdi, [.data]
    mov qword [rbx], rdi

    mov rdi, [.size]
    mov rax, [.alloc_address] ; return the starting address of the data
    add qword [.alloc_address], rdi

    pop rcx
    pop rbx

    leave
    ret

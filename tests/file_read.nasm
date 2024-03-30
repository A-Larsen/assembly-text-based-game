extern printf
global main

section .data
    filename db 'file', 0
    fmt1 db 'file descriptor %d', 10, 0
    fmt2 db 'string "%s"', 10, 0
    fmt1_len equ $ - fmt1 - 1
    fmt2_len equ $ - fmt2 - 1
    SYS_OPEN equ 2
    SYS_CLOSE equ 3
    SYS_READ equ 0

section .bss
    buffer resb 5

section .text

initialize_string:
    push rbp
    mov rbp, rsp

    push rcx

    mov rcx, 5
.loop:
    mov byte [rdi + rcx], 0
    loop .loop

    pop rcx ; make sure to set variables back to previous state

    leave
    ret

main:
    push rbp
    mov rbp, rsp

    mov rdi, buffer
    call initialize_string

    ; open file and get fd
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, 0 ; read only
    mov rdx, 0755 ; linux permisions
    syscall

    ;print fd
    mov rsi, rax

    push rax
    push rsi ; extra push to align the stack

    mov rdi, fmt1
    mov rax, 0
    call printf

    pop rsi
    pop rax

    ; read file
    mov rdi, rax

    push rax
    push rsi ; extra psuh to align stack

    mov rsi, buffer
    mov rdx, 5
    mov rax, SYS_READ
    syscall

    ; print buffer
    mov rdi, fmt2
    mov rsi, buffer
    mov rax, 0
    call printf

    pop rsi
    pop rax

    ; close fd
    mov rdi, rax
    mov rax, SYS_CLOSE
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

    leave
    ret

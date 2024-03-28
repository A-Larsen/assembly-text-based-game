global main

section .data
    fmt_name db 'What is your name: ', 0
    fmt_name_len equ $ - fmt_name - 1
    SYS_READ equ 0
    SYS_WRITE equ 1
    MAX_NAME_SIZE equ 10

section .bss
    buffer resb MAX_NAME_SIZE

section .text

string_size:
    push rbp
    mov rbp, rsp

    xor rax, rax ; string size
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    leave
    ret

print_string:
    push rbp
    mov rbp, rsp

    ; I'm not using rax so I'm going to restore it
    push rax
    push rbx
    push rcx

    mov rcx, rdi

    call string_size
    mov rbx, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, rbx
    syscall

    pop rcx
    pop rbx
    pop rax

    leave
    ret

initialize_string:
    push rbp
    mov rbp, rsp

    push rcx

    mov rcx, MAX_NAME_SIZE

.loop:
    mov byte [rdi + rcx], 0
    loop .loop

    pop rcx

    leave
    ret

input:
    push rbp
    mov rbp, rsp

    push rbx

    mov rbx, rdx

    ; write prompt
    mov rax, rsi ; temp
    mov rsi, rdi ; string
    mov rdx, rax ; length
    mov rax, SYS_WRITE
    mov rdi, 1
    syscall

    ; Get user input
    mov rax, SYS_READ
    mov rdi, 0 ; file descriptor
    mov rdx, MAX_NAME_SIZE ; size
    mov rsi, rbx ; buffer
    syscall

    pop rbx

    leave
    ret

exit:
    push rbp
    mov rbp, rsp

    mov rax, 60
    xor rdi, rdi
    syscall

    leave
    ret

main:
    mov rdi, buffer
    call initialize_string

    mov rdi, fmt_name
    mov rsi, fmt_name_len
    mov rdx, buffer
    call input

    mov rdi, buffer
    call print_string

    call exit



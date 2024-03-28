global main

section .data
    fmt_name db 'What is your name: ', 0
    fmt_name_len equ $ - fmt_name - 1
    SYS_READ equ 0
    SYS_WRITE equ 1
    MAX_STRING_SIZE equ 50

section .bss
    buffer resb MAX_STRING_SIZE

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

    call string_size
    mov rbx, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rbx
    syscall

    pop rbx
    pop rax

    leave
    ret

initialize_string:
    push rbp
    mov rbp, rsp

    push rcx

    mov rcx, MAX_STRING_SIZE

.loop:
    mov byte [rdi + rcx], 0
    loop .loop

    pop rcx

    leave
    ret

main:

    mov rdi, buffer
    call initialize_string

    ; User input prompt
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, fmt_name
    mov rdx, fmt_name_len
    syscall

    ; Get user input
    mov rax, SYS_READ
    mov rdi, 0 ; file descriptor
    mov rdx, MAX_STRING_SIZE ; size
    mov rsi, buffer ; buffer
    syscall

    mov rdi, buffer
    call print_string

   ; print new line
   mov rax, 1
   mov rdi, 1
   mov rsi, 10
   mov rdx, 1
   syscall

    mov rax, 60
    xor rdi, rdi
    syscall


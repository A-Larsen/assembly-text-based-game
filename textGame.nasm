global main

section .data
    fmt_name db 'What is your name: ', 0
    fmt_name_len equ $ - fmt_name - 1
    SYS_READ equ 0
    SYS_WRITE equ 1

section .bss
    buffer resb 16

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

main:
    mov rcx, 16

; initial string with zeros
.initialize_string:
    mov byte [buffer + rcx], 0
    loop .initialize_string

    ; User input prompt
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, fmt_name
    mov rdx, fmt_name_len
    syscall

    ; Get user input
    mov rax, SYS_READ
    mov rdi, 0 ; file descriptor
    mov rdx, 10 ; size
    mov rsi, buffer ; buffer
    syscall

    ; Get string size
    mov rdi, buffer
    call string_size

    mov rbx, rax
    ; print user input
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rbx
    syscall

   ; print new line
   mov rax, 1
   mov rdi, 1
   mov rsi, 10
   mov rdx, 1
   syscall

    mov rax, 60
    xor rdi, rdi
    syscall


; 
; Copyright (C) 2024  Austin Larsen
; 
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.
; 
; This program is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
; details.
; 
; You should have received a copy of the GNU General Public License along with
; this program; if not, write to the Free Software Foundation, Inc., 51
; Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
;
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
    SYS_WRITE equ 1
    buffer db 'sup', 0
    buffer_len equ $ - buffer - 1



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

    ; open file and get fd
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, 1 ; write only
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
    mov rdx, buffer_len
    mov rax, SYS_WRITE
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

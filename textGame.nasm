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
extern mem_alloc
extern string_size
extern string_print
extern mem_set

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
    mov rsi, 10
    call mem_set

    mov rdi, fmt_name
    mov rsi, fmt_name_len
    mov rdx, buffer
    call input

    mov rdi, buffer
    call string_size

    mov rdi, [buffer]
    mov rsi, rax
    call mem_alloc
debug:

    mov rdi, buffer
    call string_print

    call exit



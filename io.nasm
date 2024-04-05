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
extern string_cmp

global io_input
global io_printf

section .text

io_input:
section .bss
    .size resq 1

section .text

    push rbp
    mov rbp, rsp

    mov qword [.size], rcx

    push rbx

    mov rbx, rdx

    ; write prompt
    mov rax, rsi ; temp
    mov rsi, rdi ; string
    mov rdx, rax ; length
    mov rax, 1 ; sys_write
    mov rdi, 1
    syscall

    ; Get user input
    mov rax, 0 ; sys_read
    mov rdi, 0 ; file descriptor
    mov rdx, [.size] ; size
    mov rsi, rbx ; buffer
    syscall

    pop rbx

    leave
    ret

io_printf:
    push rbp
    mov rbp, rsp
    leave
    ret

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
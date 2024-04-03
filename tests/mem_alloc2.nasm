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
global main

section .data
    data1 db 'hello', 0
    SYS_BRK equ 12
    SYS_EXIT equ 60

section .bss
    memp resq 1

section .text

init:
    push rbp
    mov rbp, rsp

    mov rax, SYS_BRK
    mov rdi, 0
    syscall

    mov [memp], rax

    leave
    ret

func:
section .bss
    .size resq 1
    .data resq 1

section .text
    push rbp
    mov rbp, rsp

    mov rdi, [rdi]
    mov qword [.data], rdi
    mov qword [.size], rsi

    ;; allocate memory
    mov rax, [memp]
    lea rdi, [rax + .size]
    mov rax, SYS_BRK
    syscall

    mov rbx, [memp]
    mov rdi, [.data]
    mov qword [rbx], rdi

    mov rdi, [.size]
    add qword [memp], rdi

    leave
    ret

main:
    push rbp
    mov rbp, rsp

    call init

    mov rdi, data1
    mov rsi, 6
    call func

debug:

    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

    leave
    ret

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
global mem_alloc
global mem_set
global mem_getBreak

section .text

mem_getBreak:
    push rbp
    mov rbp, rsp

    mov rax, 12 ; 12 is sys_brk
    mov rdi, 0
    syscall

    leave
    ret

; Allocates memory in the heap and then places data in that memory. Returns the
; offset of the data in the heap
; @param rdi temp buffer for data
; @param rsi
; @return returns the offset for the data in the heap in rax
mem_alloc:
section .data
    .first_call db 0
    .first_break dq 0

section .bss
    .size resq 1
    .data resq 1
    .alloc_address resq 1

section .text
    push rbp
    mov rbp, rsp

    push rbx
    push rcx

    mov rdi, [rdi]
    mov qword [.data], rdi
    mov qword [.size], rsi

    cmp byte [.first_call], 1
    je .end
    
    ; get location of system break
    mov rax, 12 ; 12 is sys_brk
    mov rdi, 0
    syscall

    mov [.alloc_address], rax
    mov [.first_break], rax

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
    mov rax, [.alloc_address]
    sub rax, [.first_break]

    ;mov rax, .alloc_address ; return the starting address of the data
    add qword [.alloc_address], rdi

    pop rcx
    pop rbx

    leave
    ret

mem_set:
    push rbp
    mov rbp, rsp

    push rcx

    mov rcx, rsi

.loop:
    mov byte [rdi + rcx], 0
    loop .loop

    pop rcx

    leave
    ret

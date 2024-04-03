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
extern string_size
extern string_print

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

string_print:
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


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
global string_size
global string_print
global int_to_string
global string_cmp

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

int_to_string: ; function
section .data
    .codes db '0123456789'
    .temp times 10 db 0
    .buffer times 10 db 0

section .text
    push rbp
    mov rbp, rsp
    xor rcx, rcx
.loop:
    ; modulo
    xor rdx, rdx ; clear rdx to clear junk data
    mov rax, rdi ; dividend (top)
    mov rbx, 10 ; divisor (bottom)
    div rbx ; result in RDX:RAX, modulo of division in rdx

    ; store value 1 btyte of `codes` somewhere in temp
    mov rax, [.codes + rdx]
    mov qword [.temp + rcx], rax
    inc rcx

    ; keep dividing by 10
    xor rdx, rdx
    mov rax, rdi ; dividend (top)
    mov rdi, 10 ; divisor (bottom)
    div rdi 
    mov rdi, rax ; result in rdi

    test rdi, rdi
    jnz .loop

    xor rbx, rbx
    mov rdx, .temp
    dec rcx
    add rdx, rcx
    inc rcx

.reverse:
    mov rsi, [rdx]
    and rsi, 0xFF
    mov [.buffer + rbx], rsi
    dec rdx
    inc rbx
    loop .reverse

    mov rax, .buffer

    leave
    ret

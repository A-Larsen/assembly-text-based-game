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
extern string_size
extern string_find
extern int_to_string

global io_input
global io_printf

section .text

;; 
; Output prompt to stdout and then get input from stdin
; @rdi string for stdout
; @rsi size of string for stdout
; @rdx buffer to store input from stdin
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

;;
; Formats the string to produce a new string
; %s -> get changed to a string in rsi
; @param rdi format string
; @rsi array of strings to place in format string
io_printf:

section .data
    .fmt_str db '%s'
    .fmt_int db '%d'
    .fmt times 10 db 0

section .bss
    .char resb 1

section .text
    push rbp
    mov rbp, rsp
    
    mov [.fmt], rsi

    call string_size
    mov rcx, rax
    
.loop:
    mov rbx, rdi
    push rdi

    mov rdi, rbx
    mov rsi, .fmt_int
    mov rdx, 2
    call string_cmp
    cmp rax, 2
    je .to_int

    mov rdi, rbx
    mov rsi, .fmt_str
    mov rdx, 2
    call string_cmp
    cmp rax, 2
    je .to_string

    pop rdi

    mov rdx, [rdi]
    and rdx, 0xFF
    mov byte [.char], dl

    push rdi
    push rcx

    ; print the byte
    mov rax, 1 ; syscall write
    mov rdi, 1 ; stdout
    mov rsi, .char ; string
    mov rdx, 1 ; length
    syscall

    pop rcx
    pop rdi

    inc rdi
    loop .loop

    jmp .end

.to_int:
    push rdi
    push rcx
    mov rdi, [.fmt]
    call int_to_string
    mov rax, [rax]
    ;and rax, 0xFF
    mov [.fmt], rax
    lea rdi, [.fmt]
    mov rsi, 0
    call string_find

    mov rdx, rax ; length
    mov rax, 1 ; syscall write
    mov rdi, 1 ; stdout
    lea rsi, [.fmt] ; 
    syscall

    pop rcx
    pop rdi
    jmp .loop


.to_string:
    push rdi
    push rcx
    ; need this to find the newline delimeter to determine the size
    mov rdi, [.fmt]
    mov rsi, 10
    call string_find

    mov rdx, rax ; length
    mov rax, 1 ; syscall write
    mov rdi, 1 ; stdout
    mov rsi, [.fmt] ; 
    syscall

    pop rcx
    pop rdi

    jmp .loop

.end:

    leave
    ret

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

section .bss
    something resb 1
    start resq 1

section .data
    data1 db 'hello', 0
    fmt db "current break: %x", 10, 0
    SYS_EXIT equ 60
    SYS_BRK equ 12


section .text
main:
    push rbp
    mov rbp, rsp

    mov byte [something], 'a'

    ; get current break
    mov rax, SYS_BRK
    mov rdi, 0
    syscall

    mov qword [start], rax

    ; allocate two byte
    lea rdi, [rax + 4]
    ; did a lea instead of mov because we want the address
    mov rax, SYS_BRK
    syscall

    ; this actually stores data1 and data2 to rdi because rdi is a quad word and
    ; data1 and data2 come one after another in memory
    ; doing rdi - <some amout> can get me data inside of .bss segment
    mov rdi, [start]
    ;mov rsi, data1
    mov rdi, data1


debug:

    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

    leave
    ret

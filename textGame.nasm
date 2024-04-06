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
extern mem_alloc
extern string_size
extern string_print
extern mem_set
extern io_input
extern int_to_string
extern string_cmp
extern mem_getBreak

global main

section .data
    fmt_name db 'What is your name: ', 0
    fmt_name_len equ $ - fmt_name - 1

    fmt_age db 'What is your age: ', 0
    fmt_age_len equ $ - fmt_age - 1

    fmt_level db 'What is your level: ', 0
    fmt_level_len equ $ - fmt_level - 1

    fmt_gender db 'What is your gender: ', 0
    fmt_gender_len equ $ - fmt_gender - 1

    greeting db 'hello %s', 0, 10
    MAX_BUFFER_SIZE equ 10
    cmp1 db "hello", 0
    cmp2 db "hello", 0

section .bss
    buffer resb MAX_BUFFER_SIZE
    num_buf resb 4
    strarr resq 1 ; address to the collection of strings
    name_id resq 1
    age_id resq 1

section .text

; sets value in strarr
; @param rdi data to save
; @param rsi size of data
setInfo:
section .data
    .data dq 0
    .size dq 0

section .text

    push rbp
    mov rbp, rsp

    ; mov address of rdi to data
    mov qword [.data], rdi 
    mov qword [.size], rsi

    mov rdi, buffer
    mov rsi, MAX_BUFFER_SIZE
    call mem_set

    ; take value of .data (value of the first argument)
    mov rdi, [.data]
    mov rsi, [.size]
    mov rdx, buffer
    mov rcx, MAX_BUFFER_SIZE
    call io_input

    mov rdi, buffer
    call string_size

    mov rdi, buffer
    mov rsi, rax
    call mem_alloc

    leave
    ret

; gets value from strarrr
; @param rdi offset for array
; @return array value
getInfo:
    push rbp
    mov rbp, rsp

    push rbx
    push rcx

    mov rbx, [rdi]

    mov rax, strarr
    mov rax, [rax]

    lea rax, [rax + rbx]

    pop rcx
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
    push rbp
    mov rbp, rsp

    call mem_getBreak
    mov [strarr], rax

; name -------------------------
    mov rdi, fmt_name
    mov rsi, fmt_name_len
    call setInfo
    mov [name_id], rax
; ------------------------------


debug1:

; age --------------------------
    mov rdi, fmt_age
    mov rsi, fmt_age_len
    call setInfo
    mov [age_id], rax
; ------------------------------
debug2:
    
    mov rdi, age_id
    call getInfo

    mov rdi, greeting
    mov rsi,  rax
    mov rax, 0
    call printf

    mov rdi, num_buf
    mov rsi, 4
    call mem_set

    mov rdi, 432
    call int_to_string

    mov rsi, rax
    mov rax, 1
    mov rdi, 1
    mov rdx, 3
    syscall

    mov rdi, cmp1
    mov rsi, cmp2
    mov rdx, 6
    call string_cmp

    call exit

    leave
    ret

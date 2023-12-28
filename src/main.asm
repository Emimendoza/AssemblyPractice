extern malloc, free
global _start
section .text

hello:
mov rax, 1 ; write syscall
mov rdi, 1 ; stdout
mov rsi, msg ; message
mov rdx, msg.len ; length
syscall
ret

; I call this fibo but in reality it does powers of 2 starting from 2^0
fibo_start:
mov r8, rax; max number
mov r9, 1 ; fibo(1) = 1
mov r10, 1 ; fibo(2) = 1
mov r11, 2 ; counter
jmp .fibo_loop
.fibo_end:
mov rax, r9 ; return fibo(n)
ret

.fibo_loop:
add r9, r10 ; fibo(n) = fibo(n-1) + fibo(n-2)
mov r10, r9 ; fibo(n-2) = fibo(n-1)
inc r11 ; counter++
cmp r11, r8 ; compare counter with max number
jne .fibo_loop ; if not equal, jump to fibo_loop
jmp .fibo_end ; if equal, jump to fibo_end

get_digits:
mov r9, rax ; save rax
mov r10, 0 ; counter
.digit_loop:
cmp r9, 0
je .digit_end
mov rax, r9
mov rcx, 10
xor rdx, rdx
div rcx
mov r9, rax
inc r10
jmp .digit_loop
.digit_end:
mov rax, r10
ret

number_to_string:
mov r9, rax; memory of string
mov r10, rbx; number
mov r11, rcx; number of digits
add r9, r11; move pointer to the end
mov byte[r9], 10; add newline
dec r9
mov r12, 0; counter
.loop:
cmp r12, r11
je .end_loop
mov rax, r10
mov rcx, 10
xor rdx, rdx
div rcx
mov r10, rax
add rdx, 0x30
mov byte[r9], dl
dec r9
inc r12
jmp .loop
.end_loop:
ret

print_number:
push rax; save rax
call get_digits ; get number of digits
push rax ; save number of digits
inc rax
mov rdi, rax; size
call malloc ; allocate memory
mov r9, rax ; save pointer
pop rcx ; restore number of digits
pop rbx ; restore number
push rcx ; save number of digits
push rax ; save pointer
call number_to_string ; convert number to string
mov rax, 1 ; write syscall
mov rdi, 1 ; stdout
pop rsi ; restore pointer
pop rdx ; restore size
inc rdx ; add newline
syscall ; print
mov rdi, rsi
call free
ret ; return

_start:
call hello
mov rax, 30 ; max number
call fibo_start
call print_number
call hello
mov rdi, 0 ; exit code
mov rax, 60 ; exit syscall
syscall


section .data
msg: db "Hello, World!", 10
.len: equ $ - msg
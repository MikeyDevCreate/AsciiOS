org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

mov ah, 0x0
mov al, 0x3
int 0x10

start:
    jmp main

puts:
    push si
    push ax

.loop:
    lodsb
    or al, al
    jz .done

    mov ah, 0x0e
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret

main:

    mov ax , 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    mov ah, 0x0e

mov bx, msg_ascii

printbx:
	mov al, [bx]
	cmp al, 0
	je printbxexit
	int 0x10
	inc bx
	jmp printbx

printbxexit:

mov bx, buffer


mov cx, [bx]
cmp cx, 0
jne exit

mov cx, 10

read:;input
	;read one key
	mov ah, 0
	int 0x16

	cmp al, 0xd;compare to enter
	je enter

	cmp al, 8;compare to Backspace
	je backspace

	;check if input can be valid
	cmp cx, 0
	je read

	;display the key
	mov ah, 0x0e
	int 0x10

	;save to buffer
	mov [bx], al
	inc bx

	;set counter and repeat
	dec cx
	jmp read

backspace:
	;nothing to to if there is no previous input
	cmp cx, 10
	je read

	inc cx;add one more available char

	;delete the last char on console  and in buffer
	dec bx
	mov ah, 0x0e
	int 0x10
	mov al, 0
	mov [bx], al
	int 0x10
	mov al, 8
	int 0x10

	jmp read

enter:
	mov ah, 0xe
	mov al, 0xd
	int 0x10
	mov al, 0xa
	int 0x10

	mov bx, buffer
	jmp printbx

exit:

;print new line
mov al, 0xd
int 0x10
mov al, 0xa
int 0x10

jmp $

buffer:
	times 10 db 0
	db 0

    hlt

.halt:
    jmp .halt


msg_ascii db 'Welcome To', 10, 13
          db '                    _ _  ____   _____ _ ', 10, 13
          db '     /\            /_|_\/ __ \ / ____| |', 10, 13
          db '    /  \   ___  ___ _ _| |  | | /___ | |', 10, 13
          db '   / /\ \ / __|/ __| | | |  | |\___ \| |', 10, 13
          db '  / ____ \\__ \ /__| | | |__| |____\ |_|', 10, 13
          db ' /_/    \_\___/\___|_|_|\____/|_____/(_)', 10, 13
          db '                                       Version 1.0.0', 10, 13
          db 'Enter Your Chosen Username : ',0

times 510-($-$$) db 0
dw 0AA55h
.text
	.global main

main:
	movl    $4, %eax
	leal    msg(%rip), %ecx
	movl    $15, %edx
	int     $0x80
	ret

msg:
	.ascii "Hello, world\n"

#init:
#	scasb
#	.byte 214
#	and $45, msg(%rip)
#	add $47, msg(%rip)
#	int $0x80
#	jmp init

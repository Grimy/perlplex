main:
	scasb
	nop
	and $45, %eax
	add $47, %eax
	int $41
	jmp main

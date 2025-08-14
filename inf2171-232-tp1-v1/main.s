#
# INF2171 - UQAM
#
# TP1 - Addition de couleurs

# syscalls
.eqv PrintInt 1
.eqv PrintStr 4
.eqv Sbrk 9
.eqv PrintChar 11
.eqv PrintIntHex 34
.eqv Close 57
.eqv Read 63
.eqv Write 64
.eqv Exit2 93
.eqv Open 1024

.data
testdata:
	# cas 1: simple
	.word 0x010B0C0D # a
	.word 0x01010101 # b 
	.word 0x020C0D0E # add
	.word 0x000A0B0C # sub
	# cas 2: saturation
	.word 0xFF00FF00 # a
	.word 0x01010101 # b
	.word 0xFF01FF01 # add
	.word 0xFE00FE00 # sub
	# cas 3: avec zero 1
	.word 0x00000000 # a
	.word 0xAABBCCDD # b
	.word 0xAABBCCDD # add
	.word 0x00000000 # sub
	# cas 4: avec zero 2
	.word 0xAABBCCDD # a
	.word 0x00000000 # b
	.word 0xAABBCCDD # add
	.word 0xAABBCCDD # sub
nbtests:
	.word 4
MsgPass:
	.asciz "PASS: "
MsgTotal:
	.asciz "TOTAL: "

.text
main:
	lw s0,nbtests
	la s1,testdata
	li s2,0 # compteur de test ok
loop:
	lw a0,0(s1)
	lw a1,4(s1) #on regarde 4 bits plus loin donc le prochain mot
	
	call color_add # test color_add
	mv s3,a0
	
	# showres
	lw a0,0(s1)
	lw a1,4(s1)
	mv a2,s3
	li a3,0x2B
	call showres
		
	lw t0,8(s1)
	sub t0,s3,t0
	seqz t0,t0
	add s2,s2,t0

	lw a0,0(s1)
	lw a1,4(s1)
	call color_sub # test color_sub
	mv s3,a0
	
	# showres
	lw a0,0(s1)
	lw a1,4(s1)
	mv a2,s3
	li a3,0x2D
	call showres
	
	lw t0,12(s1)
	sub t0,s3,t0 # CHECK
	
	seqz t0,t0
	add s2,s2,t0

	addi s1,s1,16 # prochain test
	addi s0,s0,-1
	bnez s0,loop
exit:
	# PASS
	li a7,PrintStr
	la a0,MsgPass
	ecall
	
	li a7,PrintInt
	mv a0,s2
	ecall
	
	li a7,PrintChar
	li a0,0x0A
	ecall

	# TOTAL
	li a7,PrintStr
	la a0,MsgTotal
	ecall
	
	li a7,PrintInt
	lw a0,nbtests
	add a0,a0,a0
	ecall
	
	li a7,PrintChar
	li a0,0x0A
	ecall
	
	# Fin du programme
	li a7,Exit2
	li a0,0
	ecall

showres:
	mv t0,a0
	mv t1,a1
	mv t2,a2
	mv t3,a3

	li a7,PrintIntHex
	mv a0,t0
	ecall

	li a7,PrintChar
	mv a0,t3
	ecall
		
	li a7,PrintIntHex
	mv a0,t1
	ecall

	li a7,PrintChar
	li a0,0x3D
	ecall

	li a7,PrintIntHex
	mv a0,t2
	ecall
	
	li a7,PrintChar
	li a0,0x0A
	ecall
	
	ret

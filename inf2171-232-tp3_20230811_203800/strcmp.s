#
# INF2171 - UQAM
#

.global strcmp

.text
strcmp:
	li a5,0
loop:
	add t0,a0,a5
	lbu t0,0(t0)

	add t1,a1,a5
	lbu t1,0(t1)

	# different
	bne t0,t1,diff
	
	# fin de chaine
	beqz t0,ok
	
	addi a5,a5,1
	j loop

diff:
	li a0,1
	ret

ok:
	li a0,0
	ret
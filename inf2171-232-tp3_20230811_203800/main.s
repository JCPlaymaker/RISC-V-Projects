#
# INF2171 - UQAM
#

.data
msgErr: .asciz "Erreur arguments\n"
msgRes: .asciz "REF: %s\nTRY: %s\nRES: %s\nNUM: %d\n"
buf: .asciz "-----" # tampon de sortie

.text
main:
	# argument 1: mot de référence
	# argument 2: tentative
	# sortie standard: résultat de la vérification
	mv t0, a0
	mv t1, a1

	li t0,2
	beq a0,t0,ok

	li a7,4
	la a0,msgErr
	ecall
	j exit

ok:

	lw s0,0(a1)
	lw s1,4(a1)
	
	mv a0,s0
	mv a1,s1
	la a2,buf
	call lingo
	
	mv s2,a0

	# Afficher resultat
	la a0,msgRes
	mv a1,s0
	mv a2,s1
	la a3,buf
	mv a4,s2
	call printf
	
exit:
	# Fin du programme
	li a7,10
	ecall

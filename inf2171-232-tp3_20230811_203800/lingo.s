#
# INF2171 - UQAM
#

.global lingo

.data
ref: .asciz "ABCDE"
act: .asciz "AAAAA"
res: .asciz "-----"
exp: .asciz "=XX=?"
pass: .asciz "PASS\n"
fail: .asciz "FAIL\n"
.align 2

.data
tableauCible:
	.space 5
				
tableauInput:
	.space 5
	
compteCible:
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	
compteInput:
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
	.byte 0x30
														

# variables du programme

.text
main_test:
	la a0,ref 	#"AGREE"
	la a1,act	#"AIMER"
	la a2,res	#"-----"
	call lingo
	
	mv s2,a0

	# Afficher resultat
	li a7,4
	la a0,res
	ecall

	li a7,11
	li a0,0xa
	ecall

	# Comparaison resultats
	la a0,res
	la a1,exp
	call strcmp
	
	la t0,fail
	bnez a0,disp
	la t0,pass
disp:
	li a7,4
	mv a0,t0
	ecall
	
	# Fin du programme
	li a7,10
	ecall

lingo:
	# arguments:
	#   a0: adresse du mot de référence
	#   a1: adresse du mot d'essai
	#   a2: adresse du résultat
	# retour:
	#   a0: nombre de caracteres incorrects (zero si mot correct)
	mv s9, a2
	la a3, tableauCible
	la a4, tableauInput
	la a5, compteCible
	la a6, compteInput
	
extract_ref_loop:

	lbu t0, 0(a0) 				# extraction d'un caractere de la chaine de ref
	beq t0, zero, extract_inp_loop 	# boucle de verification pour \0

increase_count:
	li t1, 0x41			# t1 = A
	sub t1, t0, t1			# on obtient l'index de compteCible
	add a5, a5, t1			# index + adresse compteCible
	lbu t2, 0(a5)			# on recupere l'adresse modifiee
	li t3, 1			# t3 = 1
	add t2, t2, t3			# compteur + 1
	sb t2, 0(a5)			# on range le compteur de lettre repetee
	sub a5, a5, t1			# on remet l'index a 0
			
store_target_char:			
	sb t0, 0(a3)			# on sauvegarde le caractere dans le tableau
	addi a3, a3, 1			# incrementer l'adresse de 1
	addi a0, a0, 1			# aller chercher le prochain caractere du mot
	j extract_ref_loop
	
extract_inp_loop:
	
	lbu t0, 0(a1)
	beq t0, zero, corr_exacte
	
increase_count2:

	li t1, 0x41			# t1 = A
	sub t1, t0, t1			# on obtient l'index de compteCible
	add a6, a6, t1			# index + adresse compteInput
	lbu t2, 0(a6)			# on recupere l'adresse modifiee
	li t3, 1			# t3 = 1
	add t2, t2, t3			# compteur + 1
	sb t2, 0(a6)			# on range le compteur de lettre repetee
	sub a6, a6, t1			# on remet l'index a 0
				
st_input_char:					
	sb t0, 0(a4)
	addi a4, a4, 1
	addi a1, a1, 1
	j extract_inp_loop
	
corr_exacte:

	# arguments:
	#   a0: adresse du mot de référence
	#   a1: adresse du mot d'essai
	#   a2: adresse du résultat
	#   a3: adresse tableauCible
	#   a4: adresse tableauInput
	#   a5: adresse compteCible
	#   a6: adresse compteInput
	
	la t3, tableauCible	#loader les adresses pour ne pas devoir les remettre a val. orig.
	la t4, tableauInput	
	mv t6, s9
	li s2, 0 		# compteur de boucle
	li t2, 5 		# limite boucle
	
charger_vals:	
	beq s2, t2, corr_part  # boucle while
	lbu t0, 0(t3)   	# t0 = charger une valeur de tableauCible
	lbu t1, 0(t4)   	# t1 = charger une valeur de tableauInput
	beq t0,t1,ajout_char1
next_char1:
	addi t3, t3, 1 		# prochain caractere
	addi t4, t4, 1 		# prochain caractere
	addi s2, s2, 1 		# compteur += 1
	addi t6, t6, 1 		# passer au prochain espace
	j charger_vals

ajout_char1:	
	li t5, 0x3D 		# t5 = '='
	sb t5, 0(t6) 		# storer le =
	
	li t5, 0x41		# t5 = A
	sub t1, t1, t5		# t1 = CHAR - 'A' = indice dans compteCible
	la t5, compteCible	# charger adresse compteCible
	add t5, t5, t1		# aller chercher l'indice dans l'alphabet
	lbu t0, 0(t5)		# chercher le numero a l'indice utilise
	addi t0,t0,-1
	sb t0 0(t5)
	
	j next_char1
#------------------------------------------------	
corr_part:
	mv t0, s9		# chargement adresse
	li s2, 0		# compteur
	li t2, 5		# limite boucle
verif_part:	
	beq s2, t2, corr_nulle	# boucle verif pour 5 iterations
	lbu t1, 0(t0)		# chargement d'un caractere
	li t5, 0x2D		# charger '-'
	beq t1, t5, rech_part	# boucle verif pour voir si loaded char is '-'
	addi t0, t0, 1		# passer au prochain char
	addi s2 ,s2, 1		# compteur += 1
	j verif_part	
	
rech_part:	
	la t3, tableauInput    # chargement adresse
	add t3, t3, s2		# adresse a voir = adresse + compteur/index
	lbu t4, 0(t3)		# charger le caractere
	li t5, 0x41		# t1 = A
	sub t4, t4, t5		# t4 = CHAR - 'A' = indice dans compteCible
	la t5, compteCible	# charger adresse compteCible
	add t5, t5, t4		# aller chercher l'indice dans l'alphabet
	lbu t6, 0(t5)		# chercher le numero a l'indice utilise
	li s3, 0x30		# s1 = 0
	bgt t6, s3, ajout_char2 # si t6 > 0 --> on ajoute un '?'
	addi s2, s2, 1		# compteur += 1
	addi t0, t0, 1		# passer au prochain char
	j verif_part
	
ajout_char2:
	li s4, 0x3F 		# t5 = '?'
	sb s4, 0(t0) 		# storer le ?
	addi t6, t6, -1		# reduire le compteur du mot
	sb t6, 0(t5)
	addi s2, s2, 1		# compteur += 1
	addi t0, t0, 1		# passer au prochain char
	j verif_part
#-----------------------------------------------------------------------------------------		
corr_nulle:
	mv t0, s9	# charger adresse
	li t1, 0		# compteur
	li t2, 5		# limite boucle
	
verif_nulle:	
	beq t1, t2, compte_err # boucle while
	lbu t3, 0(t0)		# charger char
	li t4, 0x2D
	beq t3, t4, ajout_char3# verif si char = \0... si oui, on remplace par 'X'
	addi t1, t1, 1		# compteur += 1
	addi t0, t0, 1		# prochain char
	j verif_nulle
	
	
ajout_char3:
	li t4, 0x58
	sb t4, 0(t0)
	addi t1, t1, 1		# compteur += 1
	addi t0, t0, 1		# prochain char
	j verif_nulle
		
	
compte_err:	
	mv t0, s9		# charger adresse
	li t1, 0		# compteur boucle
	li t2, 5		# limite boucle
	li t3, 0		# compteur erreurs
	li t4, 0x3D		# charger '='
boucle_err:
	beq t1, t2, fin		# boucle while
	lbu t5, 0(t0)		# charger char
	bne t5,t4,ajout_comp   # ajouter au compteur
suite_boucle:	
	addi t1, t1, 1		# compteurBoucle += 1
	add t0, t0, t1		# passer prochain char
	j boucle_err
ajout_comp:
	addi t3, t3, 1		# compteur += 1
	j suite_boucle	 
fin:
	mv a0,t3
	mv t2, s9
	mv a2, t2
	ret

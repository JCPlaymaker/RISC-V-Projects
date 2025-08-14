#
# INF2171 - UQAM
#
# Librairie de manipulation de couleurs
#
# Arguments et valeur de retour:
#
#   a0: couleur a
#   a1: couleur b
#   a0: sortie: a [+-] b
#
# Par simplicité:
#  - Utiliser seulement les registres t0 à t6.
#  - Ne faites pas de sous-routines.
#

.global color_add color_sub

.text
color_add:
	li t0,0
	li t2,0xff	 # t2 = 0x000000ff (variable pour acceder aux groupes)
	li t5,0 	 # t5 = 0 (variable for loop)
	li t6,24
loop_add:	
	sll t2,t2,t5     # t2 =  0x00 00 00 ff / 0x00 00 ff 00 / 0x00 ff 00 00 / 0xff 00 00 00
	and t3,t2,a0     # t3 = t2 & t0
	srl t3,t3,t5     # shift vers la droite de t3
	and t4,t2,a1     # t4 = t2 & t1
	srl t4,t4,t5     # shift vers la droite de t4
	add t3,t3,t4     # t3 = t3 + t4
	srl t2,t2,t5
	# faire une condition au cas ou il y a saturation pour que ca retourne juste ff pour la section
	# comparer 0xff a la valeur dans t3 et si t3 > 0xff alors on branche pour loader 0xff directement
	# dans t3 et revenir dans le flow du programme
	ble t3,t2,saturation_add
	li t3,0xff
saturation_add:
		
	sll t3,t3,t5     #  shift vers la gauche de t3
	add t0,t0,t3
	addi t5,t5,8
	ble t5,t6, loop_add
	li a0,0
	add a0,a0,t0
	ret
	
color_sub:
	li t0,0
	li t2,0xff	 # t2 = 0x000000ff (variable pour acceder aux groupes)
	li t5,0 	 # t5 = 0 (variable for loop)
	li t6,24
loop_sub:	
	sll t2,t2,t5     # t2 =  0x00 00 00 ff / 0x00 00 ff 00 / 0x00 ff 00 00 / 0xff 00 00 00
	and t3,t2,a0     # t3 = t2 & t0
	srl t3,t3,t5     # shift vers la droite de t3
	and t4,t2,a1     # t4 = t2 & t1
	srl t4,t4,t5     # shift vers la droite de t4
	blt t3,t4,ctrl_sat #if t3 < t4, t3 = 0x00 00 00 00
	sub t3,t3,t4     # t3 = t3 - t4
	
sub_controlee:	
	# faire une condition au cas ou il y a saturation pour que ca retourne juste ff pour la section
	srl t2,t2,t5
	sll t3,t3,t5     #  shift vers la gauche de t3
	add t0,t0,t3
	addi t5,t5,8
	ble t5,t6, loop_sub
	li a0,0
	add a0,a0,t0
	ret
	
ctrl_sat:
	li t3,0
	j sub_controlee
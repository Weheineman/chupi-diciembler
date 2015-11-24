.data
	wellmet:.asciiz "Ingrese la altura de la torre: "
	line:	.asciiz "******************\n"
	enter:	.asciiz "\n"
	space:	.asciiz " "
	#representan cada varilla donde puedo colocar discos, que son ints
	e1:	.space 80
	e2:	.space 80
	e3:	.space 80
	#punteros que apuntan al primer lugar libre de cada varilla
	p1:	.space 4
	p2:	.space 4
	p3:	.space 4

.text
	main:	li $v0, 4
		la $a0, wellmet
		syscall
		li $v0, 5
		syscall
		move $s0, $v0 #altura de la torre
		li $v0, 4
		la $a0, line
		syscall

	#init es initTowers
	init:	la $s1, e1
		la $s2, e2
		la $s3, e3
		li $t0, 0
	for1:	beq $t0, $s0, rof1
		sub $t1, $s0, $t0
		sw $t1, 0($s1)
		addi $s1, $s1, 4
		addi $t0, $t0, 1
		j for1
	rof1:	la $t1, p1 #p1 address -> t1
		la $t2, p2 #p2 address -> t2
		la $t3, p3 #p3 address -> t3
		sw $s1, 0($t1)
		sw $s2, 0($t2)
		sw $s3, 0($t3)
		jal show
	
	#inicializa valores antes de llamar a hanoi
	preh:	la $t1, p1 #p1 address -> t1
		la $t2, p2 #p2 address -> t2
		la $t3, p3 #p3 address -> t3
		move $t0, $s0
		jal hanoi

	exit:	li $v0, 10
		syscall
	

	hanoi:	addi $sp, $sp, -20
		sw $t0, 0($sp)#n
		sw $t1, 4($sp)#ori
		sw $t2, 8($sp)#aux
		sw $t3, 12($sp)#des
		sw $ra, 16($sp)
		
		li $t9, 1
		beq $t0, $t9, cbase
		j cgral

	#caso base
	cbase:	#mov(ori, des)
		move $a0, $t1 # ori p address -> a0
		move $a1, $t3 # des p address -> a1
		
		jal mov
		jal show
		j ionah

	#caso general
	cgral:	#hanoi(n-1, ori, des, aux)
		addi $t0, $t0, -1
		move $t9, $t2
		move $t2, $t3
		move $t3, $t9
		jal hanoi

		#recupero los datos
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)

		#mov (ori, des)
		move $a0, $t1 # ori p address -> a0
		move $a1, $t3 # des p address -> a1
		jal mov
		jal show
		
		#hanoi(n-1, aux, ori, des)
		addi $t0, $t0, -1
		move $t9, $t1
		move $t1, $t2
		move $t2, $t9
		jal hanoi
		j ionah
		
	ionah:	
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		jr $ra

	#le paso a0 (direccion del p de donde quitar), a1 (direccion del p de donde agregar)
	mov:	#de aqui debo quitar
		lw $t8, 0($a0) # ori e address -> t8
		addi $t8, $t8, -4 #resto 1 lugar para que apunte al ultimo ocupado

		#aqui debo agregar		
		lw $t9, 0($a1) # des e address -> t9

		#hago el pasaje
		lw $t7, 0($t8)
		sw $t7, 0($t9)
		addi $t9, $t9, 4 #agrego 1 lugar pues hay un nuevo elemento
		
		
		#reacomodo los punteros
		sw $t8, 0($a0) # ori e address -> ori p
		sw $t9, 0($a1) # des e address -> des p
		
		jr $ra

	
	show:	move $t9, $ra
		la $a0, e1
		la $a1, p1
		lw $a1, 0($a1)
		jal show1
		la $a0, e2
		la $a1, p2
		lw $a1, 0($a1)
		jal show1
		la $a0, e3
		la $a1, p3
		lw $a1, 0($a1)
		jal show1
		li $v0, 4
		la $a0, line
		syscall
		jr $t9

	#le paso a0 (dirección del primer elemento de la varilla) y a1 (dirección del primer elemento libre de la varilla)
	show1:	move $t5, $a0
		move $t6, $a1	
	for2:	beq $t5, $t6 wohs
		lw $a0, 0($t5)
		li $v0, 1
		syscall
		la $a0, space
		li $v0, 4
		syscall
		addi $t5, $t5, 4
		j for2
	wohs:	la $a0, enter
		li $v0, 4
		syscall
		jr $ra

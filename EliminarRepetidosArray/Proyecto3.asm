.data
	
	vecCorregir: .asciiz "\nEl vector corregido es: "
	primerMenu: .asciiz "Por favor ingrese el tamaño del vector a generar: "
	vecListo: .asciiz "El vector es: "
	espacio: .ascii " - "
	vector: .word 0

.text
	la $s1,vector						#S1=primera posición del vector
	
	addi $v0,$zero,4					# Se le suma 4 al registro $v0 para que el sistema muestre un mesaje
	la $a0, primerMenu 					# Cargar al registro $a0 el mensaje para mostrar 
	syscall								#llamada al sistema
	
	addi $v0,$zero,5					# Se le suma 5 al registro $v0 para que el sistema se prepare para recibir un dato
	syscall								#llamada al sistema
	
	addi $s0,$v0,0						#Guarda el tamaño del vector a crear en s0
	mul $s0, $s0, 4						#Multiplica s0 x 4 para tener la posición final del vector
	add $s0, $s0, $s1					#Apunta con s0 a la posición final del vector
	jal crear			
	
	
crear:
	addi $t0,$zero,0 					#i=0
	addi $t1,$s1,0 						#Se lleva a t1 la posición inicial del vector
	
	mientras:							#While
		bge $t1,$s0,imprimir			#if((Vector en la posición t1)=(Posición final)) salta a imprimir
		li $a1, 10  					#Establece el rango del random
    		li $v0, 42  				#genera un núemro random
    		syscall						#llamada al sistema
    		
    		sw $a0,vector($t0)			#a0=vector[i]
    		addi $t0,$t0,4 				#i++
    		addi $t1, $t1, 4			#lleva a t1 la siguiente posición en el vector
    		j mientras					#reinicia el ciclo
    					
imprimir:
	la $t0,vector						#Carga en el registro t0 la posición inicial del vector
	
	addi $v0,$zero,4					# Se le suma 4 al registro $v0 para que el sistema muestre un mesaje
	la $a0, vecListo 					# Cargar al registro $a0 el mensaje para mostrar 
	syscall								#llamada al sistema

	loop:
		bge $t0,$s0, corregir			#if((Vector en la posición t0)=(Posición final)) salta a final
		addi $v0, $zero, 1 				# Se le indica al Sistema que se prepar� para imprimir un n�mero en pantalla
		lw $a0, ($t0) 					# Se carga en el registro $a0 el valor a mostrar  
		syscall 						# Llamada al Sistema
		
		addi $v0, $zero, 4 				# Se le suma 4 al registro $v0 para que el sistema muestre un mesaje 
		la $a0, espacio 				# Cargar al registro $a0 el mensaje para mostrar, en este caso para generar un espacio
		syscall 						# Llamada al Sistema
		
		addi $t0,$t0,4					#lleva a t0 la siguiente posición en el vector
		j loop							#Reinicia el ciclo
		
corregir:
	la $t0, vector						#Carga al registro t0 la primera posición del vector(i=0)
	for1:
		bge $t0, $s0, imprimir2			#if((Vector en la posición t0)=(posición final)) salta a imprimir2
		lw $t1, ($t0)					#Carga a t1 el dato del vector en la posición t0
		addi $t3, $t0, 4				#j=i+1
		for2:
			bge $t3, $s0, endFor2		#if((Vector en la posición t3)=(posición final)) salta a enFor2
			lw $t4, ($t3)				#Carga a t4 el dato del vector en la posición t3
			beq $t1, $t4, if			#if((Vector en la posición t1)=(Vector en la posición t4))salta a if
			j endIf						#salta al final de if ignorando esa parte del código
			if:
				addi $t5, $t3, 0		#guarda en t5 la posición de memoria guardada en t3
				subi $s2, $s0, 4		#lleva a s2 la posición anterior a s0
				for3:
					bge $t5,$s2,endFor3 #siempre que y sea menor que s3 y<n-1
					lw $t6,4($t5)		#t6 = y+1
					sw  $t6,0($t5)		# v[3]=y+1
					addi $t5,$t5,4 		#aumenta en 1 el apuntador y , y++
					j for3				#reinicia el ciclo for3
				endFor3:
				sw $zero,($s2)				
				subi $s0, $s0, 4		#mueve a s0 una posición a la izquierda
				subi $t3, $t3, 4		#mueve a t3 una posición a la izquierda
			endIf:
			addi $t3, $t3, 4			#mueve a t3 una posición a la derecha
			j for2						#reinicia el ciclo for2
		endFor2:
		addi $t0, $t0, 4				#mueve a t0 una posición a la derecha
		j for1							#reinicia el ciclo for1
	endFor1:
imprimir2:
	la $t0,vector						#Carga en el registro t0 la posición inicial del vector
	
	addi $v0,$zero,4					# Se le suma 4 al registro $v0 para que el sistema muestre un mesaje
	la $a0, vecCorregir 					# Cargar al registro $a0 el mensaje para mostrar 
	syscall								#llamada al sistema

	loop2:
		bge $t0,$s0, final				#if((Vector en la posición t0)=(Posición final)) salta a final
		addi $v0, $zero, 1 				# Se le indica al Sistema que se prepar� para imprimir un n�mero en pantalla
		lw $a0, ($t0) 					# Se carga en el registro $a0 el valor a mostrar  
		syscall 						# Llamada al Sistema
		
		addi $v0, $zero, 4 				# Se le suma 4 al registro $v0 para que el sistema muestre un mesaje 
		la $a0, espacio 				# Cargar al registro $a0 el mensaje para mostrar, en este caso para generar un espacio
		syscall 						# Llamada al Sistema
		
		addi $t0,$t0,4					#lleva a t0 la siguiente posición en el vector
		j loop2							#reinicia el ciclo loop2
		
final:
# s1 inicio vector
# s0 final vector
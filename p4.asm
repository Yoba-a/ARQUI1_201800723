            
spila segment stack
	DB 32 DUP ('stack___')
spila ends

sdatos segment 
    msgUni db "Universidad de San Carlos de  Guatemala " , "$";DE ACA PARA ABAJO SON VARIABLES USADAS EN EL MENSAGE INICIAL
    msgFacu db "Facultad de Ingenieria " , "$"
    msgEsc db "Escuela de Ciencias y Sistemas ", "$"
    msgClas db "Arquitectura de Compiladores y Ensambladores 1 ", "$"
    msgSecc db "Seccion <A>", "$"
    msgName db "Sergio Giovanni Castro Funes" , "$"
    msgReg db "201800723" , "$"
	msgUno db "1" , "$"
    texto db 50 dup("$");DE ACA PARA ABAJO SON VARIABLES QUE USO PARA EL MENU
	msg1    db      10, 13, 10, 13, "Porfavor seleccione una de las siguientes opciones :",0Dh,0Ah,0Dh,0Ah,09h
			db      "1- Calculadora",0Dh,0Ah,09h
			db      "2- Archivo",0Dh,0Ah,09h     
			db      "3- salir",0Dh,0Ah,09h    
			db      "Ingrese un numero: "
			db      '$'  
    saltoLinea db 10d, 13d, "$"
	ultimoMSG db "Opcion escogida: ", "$"
	division db "---------------------------------------------------------", "$"
	arch db "hola entre al archivo ",0Dh,0Ah,09h ,"$"
	msgBye db "Adios!" , "$"
	entrada db ">" , "$"
	

sdatos ends


scodigo segment 'CODE'
    
	ASSUME SS:spila, DS:sdatos, CS:scodigo

    imprimir macro cadena
		mov dx, offset cadena
		mov ah, 09
		int 21h
	endm

	entrada_num1 proc near
		mov ah, 0ah
		lea dx, datos1
		int 21h
		ret         
	entrada_num1 endp

    LIMPIAR_MEM proc
		mov ax, 40d ;<-- al poner 50 estaba corrompiendo la memoria (El ciclo se salia) como solución rápida le baje a AX.
					;La otra solución esta en el ciclo, en el salto condicional, pero por rapidez y facilidad le baje a AX
		mov cx, 0d
		mov si, offset texto

		cicloMem:
			mov [si], '$'
			inc si
			inc cx
			cmp cx, ax
			jle cicloMem

		ret
	LIMPIAR_MEM endp
	
	main proc far 
	    
	    push ds
		mov si, 0
		push si
		mov ax, sdatos
		mov ds,ax
		mov es,ax 
		
		
		mov si, offset texto
			
		leer:
			
			imprimir msgUni
			imprimir saltoLinea
			imprimir msgFacu
			imprimir saltoLinea
			imprimir msgEsc
			imprimir saltoLinea
			imprimir msgClas
			imprimir saltoLinea
			imprimir msgSecc
			imprimir saltoLinea
			imprimir msgName
			imprimir saltoLinea
			imprimir msgReg
			mov ah, 01
			int 21h
			cmp al, 13d
			mov ah, 00h
			mov al, 03h
			int 10h
			jne leer
			

		mm:
			call LIMPIAR_MEM
			xor ax, ax
			xor dx, dx
			xor si, si
			xor cx, cx
			xor dx, dx
			
			imprimir msg1
			mov si, offset texto		
			ciclo:
				mov ah, 01
				int 21h
				;en "al" esta la letra
				mov [si], al
				inc si
				cmp al , 49 
				je calc
				cmp al , 50 
				je Load
				cmp al , 51
				je Quit
				cmp al, 13 ;salto de linea
				jne ciclo
			
								
			imprimir saltoLinea
			imprimir ultimoMSG
			imprimir texto
			imprimir saltoLinea
			imprimir division
			imprimir saltoLinea
						
		jmp mm
		ret
		calc:
			ciclo2:
				mov ah, 01
				int 21h
				;en "al" esta la letra
				mov [si], al
				inc si
				cmp al , 49 
				je calc
				cmp al , 50 
				je Load
				cmp al , 51
				je Quit
				cmp al, 13 ;salto de linea
				jne ciclo2
		
		
		Load:
			mov ah, 00h
			mov al, 03h
			int 10h 
			imprimir arch
			jmp mm
		Quit:
			imprimir saltoLinea
			imprimir division
			imprimir saltoLinea
			imprimir msgBye
			mov ah,4ch
			int 21h	
    main endp
	
scodigo ends


end main
    
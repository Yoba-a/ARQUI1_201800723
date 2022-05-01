;Autor Alexander H. Quispe Mamani
;URL

;Alexander Hilario Quispe Mamani, Universidad Mayor Real Pontificia de San Francisco Xavier Chuquisaca Bolivia
.model small
.stack 100h
.data
  ms    db         10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,13,'          ---> s para salir',10,13,'          ---> c para borrar',10,10,13,'         ------------CALC-------------$'
  lin1  db      10,13,'         +---------------------------+$'
  lin2  db      10,13,'         | +---+ +---+ +---+   +---+ |$' ;Se define la interfaz grafica
  lin3  db      10,13,'         | | 1 | | 2 | | 3 |   | + | |$'
  lin4  db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin5  db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin6  db      10,13,'         | | 4 | | 5 | | 6 |   | - | |$'
  lin7  db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin8  db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin9  db      10,13,'         | | 7 | | 8 | | 9 |   | c | |$'
  lin10 db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin11 db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin12 db      10,13,'         | | * | | 0 | | / |   | s | |$'       ;Cada uno de los supuestos botones realiza algo
  lin13 db      10,13,'         | +---+ +---+ +---+   +---+ |$'       ;Al presionar 'c' --> "limpia pantalla" y vuelve a iniciar
  lin14 db       10,13,'         +---------------------------+$'        ;Al presionar 's' --> Sale del programa
  lin15 db      10,13,'        Expresion: $'
  msg1  db        10,13,'  Resultado: $'
  resi  db        ' residuo> $'   ;Si hay residuo imprimimos el mensaje
  msg2  db        10,13,'  Resultado en Binario: $'
  msg3  db        10,13,'****ERROR EN LA EXPRESION... LA MANERA CORRECTA: <NUMERO><OPERADOR><NUMERO>',10,13,'Presiona una tecla para continuar...$'
  b     db   ?    ;Variable bandera
  e     db   ?    ;Variable utilizada para error o borrar
  v1    db  ?  ;variable que almacena el primer numero
  v2    db  ?  ;variable que almacena el segundo numero
  op    db  ?  ;variable que almacena el operador

.code
   main proc
        mov ax,@data
        mov ds,ax
menu1:  call menu  ;Mandamos llamar al procedimiento menu

        mov b,0   ;Inicializamos nuestras variables
        mov e,0

        call leecar          ;Mandamos llamar al procedimiento leecar el cual lee un caracter
        cmp al,'s'            ;Comparamos el caracter leido con 's'
        je prefin              ;Si es igual salimos del programa
        cmp e,1   ;Comparamos la variable e con 1
        je menu1                ;Si es igual quiere decir que hay error y saltamos a menu1
        mov v1,al              ;Almacenamos el numero leido en la variable v1

        mov b,1   ;Cambiamos el estado de nuestra bandera
        call leecar          ;Mandamos llamar al procedimiento leecar el cual lee un caracter
        cmp al,'s'            ;Comparamos el caracter leido con 's'
        je prefin              ;Si es igual salimos del programa
        cmp e,1   ;Comparamos la variable e con 1
        je menu1                ;Si es igual quiere decir que hay error y saltamos a menu1
        mov op,al              ;Almacenamos el operador leido en la variable op


        mov b,0   ;Cambiamos el estado de nuestra bandera
        call leecar          ;Mandamos llamar al procedimiento leecar el cual lee un caracter
        cmp al,'s'            ;Comparamos el caracter leido con 's'
        je prefin              ;Si es igual salimos del programa
        cmp e,1   ;Comparamos la variable e con 1
        je menu1                ;Si es igual quiere decir que hay error y saltamos a menu1
        mov v2,al              ;Almacenamos el numero leido en la variable v2


        cmp op,'+'            ;Comparamos el operador con '+'
        je funcsuma          ;Si es igual saltamos a funcsuma
        cmp op,'-'            ;Y asi con las demas comparaciones
        je funcresta
        cmp op,'*'
        je funcmulti
        cmp op,'/'
        je funcdivi
        mov ah,9                ;Si no es igual a ningun operador entonces
        lea dx,msg3
        int 21h   ;Imprimimos el mensaje de error de expresion
        mov ah,8                ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
        int 21h
        jmp menu1

prefin:    ;Esta etiqueta se pone porque las demas lineas de codigo pasan de los 40bytes
        jmp fin   ;Esto se hace para poder llegar a fin

funcsuma:
        call sumaproc      ;Mandamos llamar el procedimiento sumaproc
        mov ah,9                ;Servicio 9 para imprimir cadenas
        lea dx,msg2          ;Seleccionamos la cadena de Resultado en Binario
        int 21h   ;Imprimimos la cadena
        call convbin        ;Mandamos llamar el procedimiento que convierte a binario
        jmp menu1              ;Al finalizar el procedimiento saltamos a menu1 que esta al inicio
funcresta:
        call restaproc    ;Mandamos llamar el procedimiento restaproc
        mov ah,9                ;Servicio 9 para imprimir cadenas
        lea dx,msg2          ;Seleccionamos la cadena de Resultado en Binario
        int 21h   ;Imprimimos la cadena
        call convbin        ;Mandamos llamar el procedimiento que convierte a binario
        jmp menu1              ;Al finalizar el procedimiento saltamos a menu1 que esta al inicio
funcmulti:
        call multiproc    ;Mandamos llamar el procedimiento multiproc
        mov ah,9                ;Servicio 9 para imprimir cadenas
        lea dx,msg2          ;Seleccionamos la cadena de Resultado en Binario
        int 21h   ;Imprimimos la cadena
        call convbin        ;Mandamos llamar el procedimiento que convierte a binario
        jmp menu1              ;Al finalizar el procedimiento saltamos a menu1 que esta al inicio
funcdivi:
        call diviproc      ;Mandamos llamar el procedimiento diviproc
        mov ah,9                ;Servicio 9 para imprimir cadenas
        lea dx,msg2          ;Seleccionamos la cadena de Resultado en Binario
        int 21h   ;Imprimimos la cadena
        call convbin        ;Mandamos llamar el procedimiento que convierte a binario
        jmp menu1              ;Al finalizar el procedimiento saltamos a menu1 que esta al inicio

fin:
        mov ah,4ch
        int 21h
   main endp



;***********************************LEER
   leecar proc near
        mov ah,1                ;Servicio 1 para leer un caracter
        int 21h   ;El caracter leido se almacena en al

        cmp b,0   ;Comparamos nuestra variable bandera
        je numero              ;Si es igual a '0' cero entonces queremos capturar numero
        jmp operador        ;Sino entonces queremos capturar un operador
       
   numero:
        cmp al,'c'            ;Comparamos el caracter leido con 'c'
        je borra                ;Si el caracter leido es igual al caracter 'c' borramos todo y volvemos a iniciar
        cmp al,'+'            ;Comparamos el caracter leido con '+'
        je error                ;Si es igual hay un error en la expresion ya que debe de ser <NUMERO><OPERADOR><NUMERO> == 2+5
        cmp al,'-'            ;E igual para las siguientes lineas
        je error
        cmp al,'*'
        je error
        cmp al,'/'
        je error
        jmp sleecar          ;Si no es igual a las demas saltamos a la salida

   operador:
        cmp al,'c'            ;Comparamos el caracter leido con 'c'
        je borra                ;Si el caracter leido es igual al caracter 'c' borramos todo y volvemos a iniciar
        cmp al,'0'            ;Comparamos el caracter leido con '0'
        je error                ;Si es igual hay un error en la expresion ya que debe de ser <NUMERO><OPERADOR><NUMERO> == 2+5
        cmp al,'1'            ;E igual para las siguientes lineas
        je error
        cmp al,'2'
        je error
        cmp al,'3'
        je error
        cmp al,'4'
        je error
        cmp al,'5'
        je error
        cmp al,'6'
        je error
        cmp al,'7'
        je error
        cmp al,'8'
        je error
        cmp al,'9'
        je error
        jmp sleecar          ;Si no es igual a las demas saltamos a la salida

   borra:
        mov e,1   ;Cambiamos a nuestra variable e a 1 para limpiar pantalla
        jmp sleecar

   error:
        mov ah,9
        lea dx,msg3
        int 21h   ;Imprimimos el mensaje de error de expresion
        mov ah,8                ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
        int 21h
        mov e,1   ;Y hacemos a nuestra variable e a 1 para limpiar pantalla

        sleecar:
     RET
   leecar endp
;***************************************


;***********************************MENU
   menu proc near
        mov ah,9                ;Servicio 9 para imprimir una cadena
        lea dx,ms              ;Seleccionamos la cadena ms
        int 21h   ;la imprimimos
        lea dx,lin1          ;seleccionamos la cadena lin1
        int 21h   ;la imprimimos
        lea dx,lin2          ;y asi para las demas lineas
        int 21h
        lea dx,lin3
        int 21h
        lea dx,lin4
        int 21h
        lea dx,lin5
        int 21h
        lea dx,lin6
        int 21h
        lea dx,lin7
        int 21h
        lea dx,lin8
        int 21h
        lea dx,lin9
        int 21h
        lea dx,lin10
        int 21h
        lea dx,lin11
        int 21h
        lea dx,lin12
        int 21h
        lea dx,lin13
        int 21h
        lea dx,lin14
        int 21h
        lea dx,lin15
        int 21h
     RET
   menu endp
;/***************************************




;/***********************************SUMA
   sumaproc proc near
        mov al,v1              ;Pasamos nuestro primer valor a al
        sub al,30h            ;Le restamos 30h para convertirlo a numero
        mov bl,al              ;Y lo pasamos a bl
        mov al,v2              ;Pasamos nuestro segundo valor a al
        sub al,30h            ;Le restamos 30h para convertirlo a numero
        add bl,al              ;Y lo sumamos con bl que contiene el primer numero

        mov ah,9
        lea dx,msg1
        int 21h   ;Imprimimos el mensaje de resultado
        mov ah,2                ;Servicio 2 imprime un caracter almacenado en dl
        mov dl,bl              ;Pasamos a dl el resultado
        mov v1,dl              ;Respaldamos tambien el resultado en v1
        add dl,30h            ;Sumamos 30h a dl para convertirlo a caracter
        int 21h   ;Imprimimos el resultado
     RET
   sumaproc endp
;/***************************************




;/**********************************RESTA
   restaproc proc near
        mov al,v1              ;Pasamos nuestro primer valor a al
        sub al,30h            ;Le restamos 30h para convertirlo a numero
        mov bl,al              ;Y lo pasamos a bl
        mov al,v2              ;Pasamos nuestro segundo valor a al
        sub al,30h            ;Le restamos 30h para convertirlo a numero
        sub bl,al              ;Restamos bl - al

        mov ah,9
        lea dx,msg1
        int 21h   ;Imprimimos el mensaje de resultado
        mov ah,2                ;Servicio 2 imprime un caracter almacenado en dl
        mov dl,bl              ;Pasamos a dl el resultado
        mov v1,dl              ;Respaldamos tambien el resultado en v1
        add dl,30h            ;Sumamos 30h a dl para convertirlo a caracter
        int 21h   ;Imprimimos el resultado
     RET
   restaproc endp
;/***************************************




;/*************************MULTIPLICACIÓN
   multiproc proc near
        mov al,v1              ;Pasamos nuestro primer valor a al
        sub al,30h            ;Le restamos 30h para convertirlo a numero
        mov bl,al              ;Y lo pasamos a bl
        mov al,v2              ;Pasamos nuestro segundo valor a al
        sub al,30h            ;Le restamos 30h para convertirlo a numero

        and ah,00h            ;Le aplicamos una mascara a la parte superior de AX para que quede con ceros 0000
        and bh,00h            ;Le aplicamos una mascara a la parte superior de BX para que quede con ceros 0000
        mul bx      ;Multiplicamos AX con BX
        mov bl,al              ;El resultado que esta en al lo pasamos a bl

        mov ah,9
        lea dx,msg1
        int 21h   ;Imprimimos el mensaje de resultado

        mov ah,2                ;Servicio 2 imprime un caracter almacenado en dl
        mov dl,bl              ;Pasamos a dl el resultado
        mov v1,dl              ;Respaldamos tambien el resultado en v1
        add dl,30h            ;Sumamos 30h a dl para convertirlo a caracter
        int 21h   ;Imprimimos el resultado
     RET
   multiproc endp
;/***************************************


;/*******************CONVERSION A BINARIO
   convbin proc near
        mov bl,v1              ;Cargamos el resultado en bl
        mov ah,2                ;Servicio 2 para imprimir un caracter
        mov cl,128            ;Ponemos a cl en 128, que es el valor mas alto para un registro de 8 bits

comp:   cmp bl,cl              ;Comparamos bl con cl
        jae restar            ;Si es mayor o igual saltamos a la etiqueta restar
        mov dl,'0'            ;Sino pasamos a dl el caracter 0
        int 21h   ;y lo imprimimos
        jmp ifs   ;saltamos a ifs


restar: sub bl,cl                ;En la etiqueta restar restamos a bl lo que hay en cl, esto para ir quitandole unos supuestamente
        mov dl,'1'            ;Pasamos a dl el caracter 1
        int 21h   ;y lo imprimimos

ifs:    shr cl,1        ;Desplazamos a la derecha a cl una vez, esto hace el efecto de division entre 2
        jz salirr              ;Si la operacion anterior arroja un 0 saltamos a salirr
        jmp comp                ;Sino saltamos a comp, al inicio
salirr:
        mov ah,8                ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
        int 21h
      RET
   convbin endp
;/***************************************


;/*******************************DIVISIÓN
   diviproc proc near
        mov al,v1              ;Pasamos nuestro primer valor a al
        sub al,30h            ;Le restamos 30h para convertirlo a numero
        mov bl,al              ;Y lo pasamos a bl
        mov al,v2              ;Pasamos nuestro segundo valor a al
        sub al,30h            ;Le restamos 30h para convertirlo a numero

        and ah,00h            ;Le aplicamos una mascara a la parte superior de AX para que quede con ceros 0000
        and bh,00h            ;Le aplicamos una mascara a la parte superior de BX para que quede con ceros 0000

        xchg ax,bx            ;Intercambiamos los valores de AX con BX y viceversa
        cwd               ;Cambiamos AX de word a dobleword para que tenga capacidad el programa de dividir
        div bx      ;Dividimos.. Siempre divide AX/BX el resultado lo almacena en AX, el residuo queda en DX
        mov bx,ax              ;Pasamos el resultado a bx
        mov b,dl                ;Pasamos el residuo a b

        mov ah,9
        lea dx,msg1
        int 21h   ;Imprimimos el mensaje de resultado

        mov ah,2
        mov dx,bx              ;Pasamos a dx el resultado
        mov v1,dl              ;Respaldamos tambien el resultado en v1
        add dl,30h            ;Sumamos 30h a dl para convertirlo a caracter
        int 21h   ;Imprimimos el resultado

        cmp b,0   ;Comparamos la variable que contiene el residuo con 0
        jg residuo            ;Si es mayor de 0 quiere decir que hay residuo y saltamos a la etiqueta residuo
        jmp dsal                ;Si es igual a 0 el residuo no hay residuo y saltamos a la etiqueta dsal

residuo:
        mov ah,9                ;Servicio 9 para imprimir cadenas
        lea dx,resi          ;Seleccionamos la cadena contenida en resi
        int 21h   ;Imprimimos

        mov ah,2                ;Servicio 2 para imprimir un caracter contenido en dl
        mov dl,b                ;Pasamos a dl el valor del residuo
        add dl,30h            ;Sumamos 30h a dl para convertirlo a caracter
        int 21h   ;Imprimimos el resultado

dsal:
     RET
   diviproc endp
;/***************************************



end main
Lo más popular
comparacion
Menu
suma,resta,multiplicacion y divide
Binario a Decimal
calculadora basica
Factorial
Lee Cadena y la muestra en una coordenada especifica
Suma dos numeros sin importar el acarreo
Captura Cadena
Los 10 mas visitados
suma,resta,multiplicacion y divide
Menu
Suma dos numeros sin importar el acarreo
Binario a Decimal
Lee Cadena y la muestra en una coordenada especifica
Factorial
ensamblador
comparacion
Ultimos 10 agregados
realizar un margen
Menu
duplicar palabra
crear carpeta
suma,resta,multiplicacion y divide
posiciones del cursor en cualquier momento
comparacion
Captura Cadena
rotabit o kit de 16 bits

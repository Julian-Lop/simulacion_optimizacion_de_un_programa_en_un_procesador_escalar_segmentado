.data
    prompt_num: .asciiz "¿Cuántos números de la serie Fibonacci deseas generar?: "  # Mensaje para solicitar al usuario el número de términos
    result_msg: .asciiz "La serie Fibonacci es: "  # Mensaje que precede a la impresión de la serie Fibonacci
    sum_msg: .asciiz "\nLa suma de los números de la serie es: "  # Mensaje que precede a la impresión de la suma de la serie
    invalid_msg: .asciiz "Entrada no válida. Debes ingresar un número mayor que 0."  # Mensaje de error para entrada inválida

.text
    .globl main

main:
    # Solicitar al usuario cuántos números de la serie Fibonacci desea generar
    li $v0, 4  # Código para imprimir cadena de texto
    la $a0, prompt_num  # Cargar la dirección del mensaje en $a0
    syscall  # Llamada al sistema para ejecutar la impresión

    # Leer el número ingresado por el usuario
    li $v0, 5  # Código para leer un entero desde la consola
    syscall  # Llamada al sistema para ejecutar la lectura
    move $t0, $v0  # Guardar el número ingresado en $t0

    # Verificar si el número de términos es mayor que 0
    li $t1, 1  # Cargar el valor 1 en $t1 para la comparación
    blt $t0, $t1, invalid_input  # Si $t0 es menor que 1, saltar a invalid_input

    # Inicializar variables para la generación de la serie
    li $t2, 0  # $t2 = 0 (primer número de Fibonacci)
    li $t3, 1  # $t3 = 1 (segundo número de Fibonacci)
    li $t4, 0  # Inicializar $t4 con el primer número de Fibonacci (0)
    li $t5, 0  # Inicializar $t5 con 0 para usarlo como acumulador de la suma de la serie
    li $t6, 0  # Inicializar contador de términos generados

    # Imprimir el mensaje que precede a la serie Fibonacci
    li $v0, 4  # Código para imprimir cadena de texto
    la $a0, result_msg  # Cargar la dirección del mensaje en $a0
    syscall  # Llamada al sistema para ejecutar la impresión

fibonacci_loop:
    # Imprimir el número actual de la serie
    li $v0, 1  # Código para imprimir un número entero
    move $a0, $t2  # Mover el valor actual de Fibonacci ($t2) a $a0
    syscall  # Llamada al sistema para ejecutar la impresión

    # Sumar el número actual de la serie a la suma total
    add $t5, $t5, $t2  # $t5 += $t2 (acumular la suma de los números de Fibonacci)

    # Calcular el siguiente número de la serie
    add $t7, $t2, $t3  # $t7 = $t2 + $t3 (siguiente número de Fibonacci)
    move $t2, $t3  # Actualizar $t2 con el valor de $t3 (desplazar los números)
    move $t3, $t7  # Actualizar $t3 con el valor de $t7 (nuevo valor de Fibonacci)

    # Incrementar el contador de términos generados
    addi $t6, $t6, 1  # $t6++

    # Verificar si se han generado todos los términos solicitados
    blt $t6, $t0, fibonacci_loop  # Si $t6 < $t0, continuar en fibonacci_loop

    # Imprimir el mensaje que precede a la suma de la serie
    li $v0, 4  # Código para imprimir cadena de texto
    la $a0, sum_msg  # Cargar la dirección del mensaje en $a0
    syscall  # Llamada al sistema para ejecutar la impresión

    # Imprimir la suma total de la serie Fibonacci
    li $v0, 1  # Código para imprimir un número entero
    move $a0, $t5  # Mover el valor acumulado ($t5) a $a0
    syscall  # Llamada al sistema para ejecutar la impresión

    j end_program  # Saltar a la finalización del programa

invalid_input:
    # Imprimir el mensaje de error para entrada inválida
    li $v0, 4  # Código para imprimir cadena de texto
    la $a0, invalid_msg  # Cargar la dirección del mensaje en $a0
    syscall  # Llamada al sistema para ejecutar la impresión

end_program:
    # Finalizar el programa
    li $v0, 10  # Código para terminar la ejecución del programa
    syscall  # Llamada al sistema para finalizar

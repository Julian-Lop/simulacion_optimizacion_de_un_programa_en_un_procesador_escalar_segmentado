.data
    prompt_num: .asciiz "¿Cuántos números deseas comparar? (mínimo 3, máximo 5): "
    prompt_input: .asciiz "Ingresa un número: "
    result_msg: .asciiz "El número menor es: "
    invalid_msg: .asciiz "Entrada no válida. Debes ingresar un número entre 3 y 5."

.text
    .globl main

main:
    # Pedir al usuario cuántos números quiere comparar
    li $v0, 4
    la $a0, prompt_num
    syscall

    li $v0, 5
    syscall
    move $t0, $v0  # Guardar el número de entradas en $t0

    # Verificar si el número de entradas está dentro del rango permitido (3-5)
    li $t1, 3
    blt $t0, $t1, invalid_input 

    li $t1, 5
    bgt $t0, $t1, invalid_input

    # Pedir los números al usuario
    li $t2, 0
    la $t3, 2147483647  # Inicializar el menor a un valor muy alto (máximo entero positivo)

input_loop:
    li $v0, 4
    la $a0, prompt_input
    syscall

    li $v0, 5
    syscall
    move $t4, $v0  # Guardar el número ingresado en $t4

    # Comparar el número ingresado con el menor actual
    blt $t4, $t3, update_min  # Si el número ingresado es menor, actualizar el menor
    j continue_loop

update_min:
    move $t3, $t4  # Actualizar el menor si el número ingresado es menor

continue_loop:
    addi $t2, $t2, 1  # Incrementar el contador de entradas
    blt $t2, $t0, input_loop  # Repetir si no se han ingresado todos los números

    # Mostrar el número menor
    li $v0, 4
    la $a0, result_msg
    syscall

    li $v0, 1
    move $a0, $t3  # Mueve el número menor ($t3) a $a0 para imprimirlo
    syscall

    j end_program

invalid_input:
    li $v0, 4
    la $a0, invalid_msg
    syscall

end_program:
    li $v0, 10  # Finalizar el programa
    syscall

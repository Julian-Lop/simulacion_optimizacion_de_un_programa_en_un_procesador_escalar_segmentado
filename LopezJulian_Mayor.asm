# Definición de datos donde se almacenan cadenas de texto y otras variables.
.data
    prompt_num: .asciiz "¿Cuántos números deseas comparar? (mínimo 3, máximo 5): "
    prompt_input: .asciiz "Ingresa un número: "
    result_msg: .asciiz "El número mayor es: "
    invalid_msg: .asciiz "Entrada no válida. Debes ingresar un número entre 3 y 5."
# Directiva para indicar el inicio de la sección de código.
.text
    .globl main
# Main marca el inicio del programa.
main:
    # Pedir al usuario cuántos números quiere comparar
    # Registro que indica que vamos a imprimir una cadena de texto en la consola.
    li $v0, 4
    # Carga la dirección de memoria de la cadena promt_num en el registro $a0
    la $a0, prompt_num
    # Se hace la llamada al sistema para ejecutar la operación indicada en $v0
    syscall

    # Registro que indica que vamos a leer un número entero de la consola	
    li $v0, 5
    # Mueve el número leído desde $v0 a $t0. Aquí almacenamos cuántos números el usuario quiere comparar
    syscall
    move $t0, $v0        # Guardar el número de entradas en $t0

    # Verificar si el número de entradas está dentro del rango permitido (3-5)
    li $t1, 3 # Carga 3 en $t1 para usarlo en la comparación.
    # Compara si $t0 (número de entradas) es menor que 3. Si lo es, salta a la etiqueta invalid_input, lo que significa que la entrada no es válida.
    blt $t0, $t1, invalid_input 

    li $t1, 5 # Carga 5 en $t1 para la siguiente comparación.
    # Compara si $t0 es mayor que 5. Si lo es, también salta a invalid_input.
    bgt $t0, $t1, invalid_input

    # Pedir los números al usuario
    li $t2, 0  # Inicializar el contador de entradas
    la $t3, -1  # Inicializar el mayor a un valor muy bajo (-1 en este caso)
# Marca el inicio de un bucle para leer y comparar los números.
input_loop:
    # Configuran la impresión del mensaje prompt_input que solicita al usuario ingresar un número. 
    li $v0, 4
    la $a0, prompt_input
    syscall

    li $v0, 5 # Configura la lectura de un número desde la consola.
    syscall
    move $t4, $v0  # Guardar el número ingresado en $t4

    # Comparar el número ingresado con el mayor actual
    # Compara si el número recién ingresado ($t4) es mayor que el mayor actual ($t3). Si es mayor, salta a la etiqueta update_max.
    bgt $t4, $t3, update_max
    j continue_loop # Si no es mayor, salta a continue_loop para seguir con el siguiente número.
# Si el número es mayor, actualiza $t3 con el valor de $t4.
update_max:
    move $t3, $t4 # Actualizar el mayor si el número ingresado es mayor

continue_loop:
    addi $t2, $t2, 1 # Incrementar el contador de entradas
    blt $t2, $t0, input_loop # Repetir si no se han ingresado todos los números

    # Mostrar el número mayor
    # Configuran la impresión del mensaje result_msg que indica que se va a mostrar el número mayor.
    li $v0, 4
    la $a0, result_msg
    syscall

    # Configura la impresión de un número entero.
    li $v0, 1
    move $a0, $t3 # Mueve el número mayor ($t3) a $a0 para imprimirlo.
    syscall

    j end_program
# Se maneja la entrada inválida (fuera de 3-5).
invalid_input:
    li $v0, 4
    la $a0, invalid_msg
    syscall

end_program:
    li $v0, 10 # Finalizar el programa
    syscall

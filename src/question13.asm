; class Grupo():
;   aluno1 = Icaro Baliza Albuquerque 222115784
;   aluno2 = João Paulo Gomes Bernardino 222115792
;   aluno3 = Yuri Freitas Hughes 220115570 

section .data

    half dq 0.5
    pi dq 3.14159265359

    input db "Escolha a entrada (0 - Raio, 1 - Diâmetro): ",0
    radius_msg db "Digite o raio: ", 0
    diameter_msg db 10,"Digite o diâmetro: ", 0
    result_msg db 10,"A area do circulo é %.2f u.m. ", 10, 0

    int_format db  "%d", 0
    float_format dq "%lf", 10, 0

section .bss
    choice resb 1
    radius resq 1
    diameter resq 1

section .text
    global main
    extern printf, scanf

main:
    push rbp
    mov rbp, rsp
    
    ; Imprime a mensagem de escolha
    mov rdi, input
    mov rax, 0
    call printf

    ; Lê a escolha do usuário
    mov rdi, int_format
    mov rsi, choice
    mov rax, 0
    call scanf

    
    ; Verificar a escolha do usuário
    and byte [choice], 1
    je calculateRadius
    jne calculateDiameter

    leave
    ret

calculateRadius:
    ;Imprime a mensagem de entrada
    mov rdi, radius_msg
    mov rax, 0
    call printf

    ;Recebe os valores das alturas
	mov rdi, float_format
	mov rsi, radius
	mov rax, 1
	call scanf

	
   ; Calcula a área r² * pi
    movq xmm0, [pi]
    movq xmm1, [radius]
    mulsd xmm0, xmm1
    mulsd xmm0, xmm1
    jmp showResult

    leave
    ret

calculateDiameter:
    ;Imprime a mensagem de entrada
    mov rdi, diameter_msg
    mov rax, 0
    call printf

    ;Recebe os valores das alturas
    mov rdi, float_format
    mov rsi, diameter
    mov rax, 1
    call scanf

    ; Formula: (d/2)² * pi
    ; Divide o diâmetro por 2
    movq xmm0, [half]
    mulsd xmm0, [diameter]
    ; Calcula a área
    mulsd xmm0, xmm0
    mulsd xmm0, [pi]

    jmp showResult

    leave
    ret

showResult:
    ; Imprime o resultado
    mov rdi, result_msg
    call printf

    leave
    ret

section .data

	calculadora_msg db "----CALCULADORA----", 10, 0
  operation_msg db "Digite a operacao correspondente: ( + | - | * | / | s-sair )",10, 0
	exit_msg db "Encerrando calculadora...", 10, 0

  primeiroNumero_msg db "Digite o primeiro numero: ", 0
  segundoNumero_msg db "Digite o segundo numero: ", 0

  soma_msg db "O resultado da soma é %.1f ", 10, 0
	sub_msg db "O resultado da subtracao é %.1f ", 10, 0
	multi_msg db "O resultado da multiplicacao é %.1f ", 10, 0
	divi_msg db "O resultado da divisao é %.1f ", 10, 0

  somar db "+", 0
  subtrair db "-", 0
  multiplicar db "*", 0
  dividir db "/", 0
	saida db "s", 0
    

  float_format dq "%lf", 10, 0
  str_format db "%s", 0
    
section .bss
  flag resb 1
  n1 resq 1
  n2 resq 1

section .text
  global main
  extern printf, scanf, strcmp

main:
	push rbp
	mov rbp, rsp

	;imprime msg CALCULADORA
	mov rdi, calculadora_msg
	mov rax, 0
	call printf
	
	;imprime msg referente as operacoes disponiveis
	mov rdi, operation_msg
	mov rax, 0
	call printf

	;guardar o valor de input da operacao correspondente
	mov rdi, str_format
	mov rsi, flag
	mov rax, 1
	call scanf

	;abaixo comparamos as operacoes possiveis com a operacao de input e com base no valor contido no registrador rax
	;fazemos um jump pra instrucao corespondente
	mov rdi, saida
	mov rsi, flag
	call strcmp

	test rax, rax
	je exitAll
	
	mov rdi, somar
	mov rsi, flag
	call strcmp
	
	test rax, rax
	je soma
	
	mov rdi, subtrair
	mov rsi, flag
	call strcmp
	
	test rax, rax
	je sub
	
	mov rdi, multiplicar
	mov rsi, flag
	call strcmp
	
	test rax, rax
	je multi
	
	mov rdi, dividir
	mov rsi, flag
	call strcmp
	
	test rax, rax
	je divi

	;soma os dois numeros
	soma:
	
	mov rdi, primeiroNumero_msg
	mov rax, 0
	call printf
	
	;captura primeiro numero digitado
	mov rdi, float_format
	mov rsi, n1
	mov rax, 1
	call scanf
	
	mov rdi, segundoNumero_msg
	mov rax, 0
	call printf

	;captura segundo numero digitado
	mov rdi, float_format
	mov rsi, n2
	mov rax, 1
	call scanf

	;faz a operacao correspondente, nesse caso, a soma
	movq xmm0, [n1]
	movq xmm1, [n2]	
	addsd xmm0, xmm1
	jmp answerSoma

	;as operacoes abaixo funcionam da mesma forma que a soma, a diferenca esta na operacao feita com os registradores xmm0 e xmm1
	
	;subtrai os dois numeros
	sub:
	mov rdi, primeiroNumero_msg
	mov rax, 0
	call printf

	mov rdi, float_format
	mov rsi, n1
	mov rax, 1
	call scanf
	
	mov rdi, segundoNumero_msg
	mov rax, 0
	call printf

	mov rdi, float_format
	mov rsi, n2
	mov rax, 1
	call scanf

	movq xmm0, [n1]
	movq xmm1, [n2]	
	subsd xmm0, xmm1
	jmp answerSub
	
	;multimplica os dois numeros
	multi:
	mov rdi, primeiroNumero_msg
	mov rax, 0
	call printf

	mov rdi, float_format
	mov rsi, n1
	mov rax, 1
	call scanf
	
	mov rdi, segundoNumero_msg
	mov rax, 0
	call printf

	mov rdi, float_format
	mov rsi, n2
	mov rax, 1
	call scanf

	movq xmm0, [n1]
	movq xmm1, [n2]	
	mulsd xmm0, xmm1
	jmp answerMult
	
	;divide os dois numeros
	divi:
	mov rdi, primeiroNumero_msg
	mov rax, 0
	call printf

	mov rdi, float_format
	mov rsi, n1
	mov rax, 1
	call scanf
	
	mov rdi, segundoNumero_msg
	mov rax, 0
	call printf

	mov rdi, float_format
	mov rsi, n2
	mov rax, 1
	call scanf

	movq xmm0, [n1]
	movq xmm1, [n2]	
	divsd xmm0, xmm1
	jmp answerDiv
	
	leave
	ret

;essas funcoes servem pra imprimir o resultado respectivo a uma operacao especifica
answerSoma:
	mov rdi, soma_msg
	call printf
	leave
	ret
answerSub:
	mov rdi, sub_msg
	call printf
	leave
	ret
answerMult:
	mov rdi, multi_msg
	call printf
	leave
	ret
answerDiv:
	mov rdi, divi_msg
	call printf
	leave
	ret

;funcao que forca a parada do programa
exitAll:
	mov rdi, exit_msg
	mov rax, 0
	call printf
	leave
	ret

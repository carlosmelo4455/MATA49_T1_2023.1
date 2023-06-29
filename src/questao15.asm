; GRUPO 15: Jonas Oliveira Pereira e Thales
section .bss
	;variaveis nao-iniciadas, recebidas por entrada
	qtdTanque	 	resq 1
	volumeTanque 	resq 1
	alturaTanque 	resq 1
	
section .data
	litrosPorLata 	dq 7.0
	areaPorLitro 	dq 5.0
	;areaPorLata	dq 35.0 ;litrosPorLata vezes areaPorLitro, valor calculado durante a execucao, embora pudesse ser uma constante, conforme esta linha comentada
	precoTinta		dq 101.35
	pi 				dq 3.141592 ;constante utilizada para calculo da area
	dois			dq 2.0		;constante utilizada para calculo da area

	digiteQtd db "Digite a quantidade de tanques a serem pintados:", 10, 0
	digiteVolume db "Digite o volume dos tanques:", 10, 0
	digiteAltura db "Digite a altura dos tanques em metros:", 10, 0

	precoLatasOutput db "O valor total das latas é %.2lf reais", 10, 0
	qtdLatasOutput db "e serão necessárias %ld latas para pintar os tanques", 10, 0

	fmt db "%lf", 0


section .text
	global main
	extern printf, scanf

;recebe dois valores, multiplica e os guarda em xmm2
%macro multiplicar_var 2
	movsd xmm1, [%1]
	movsd xmm2, [%2]
	mulsd xmm2, xmm1
%endmacro

;arg1: volumeTanque, arg2:alturaTanque guarda o valor do raio em xmm1; raio = sqrt(Volume/(pi * altura))
%macro calcula_raio 2

	multiplicar_var pi, %2 ;pi*altura -> xmm2

	movsd xmm1, [%1] ;volume
	divsd xmm1, xmm2 ;volume/(pi*altura)

	sqrtsd xmm1, xmm1 ;sqrt(volume/(pi*altura)) = raio

%endmacro

;arg: alturaTanque, area = (2*pi*altura*raio) + (2*pi*(raio²)) = 2*pi*raio*(raio + altura)
%macro calcula_area_tanque 1
	
	movsd xmm0, [pi]
	mulsd xmm0, [dois] ; 2*pi
	mulsd xmm0, xmm1 ; 2*pi*raio

	addsd xmm1, [%1] ; (raio + altura) 
	mulsd xmm0, xmm1 ; 2*pi*raio*(raio + altura)

%endmacro

;arg: qtdTanques
%macro calcula_area_total 1
	mulsd xmm0, [%1]
%endmacro

;armazena o resultado em xmm0
%macro calcula_latas_necessarias 0
	multiplicar_var areaPorLitro, litrosPorLata ; -> xmm2
	divsd xmm0, xmm2 ; dividindo a area dos cilindros pela area total que uma lata eh capaz de pintar, obtemos a qtd de latas necessarias para pintar a area dos cilindros em xmm0
%endmacro

;arredonda para cima o numero de latas de tinta
%macro arredonda_latas 0
	roundsd xmm0, xmm0, 2
%endmacro

;arg: precoTinta; multiplica o preco da tinta pela qtd necessaria de tintas em xmm0
%macro calcula_preco_total 1
	mulsd xmm0, [%1] 
%endmacro

%macro ler 1
	mov rdi, fmt
	mov rsi, %1
	; xor rax, rax
	mov rax, 1
	call scanf
%endmacro

%macro imprimir_msg 1
	mov rdi, %1
	mov rax, 0
	call printf
%endmacro

%macro imprimir_float 2
	mov rdi, %1			; primeiro arg do printf, a format string
	movq xmm0, %2		; no modo floating point, o reg xmm0 recebe o segundo arg de printf
	mov rax, 1			; modo floating point
	call printf
%endmacro

main:
	push rbp
	mov rbp, rsp

	imprimir_msg digiteQtd
	ler qtdTanque

	imprimir_msg digiteVolume
	ler volumeTanque

	imprimir_msg digiteAltura
	ler alturaTanque

	calcula_raio volumeTanque, alturaTanque
	calcula_area_tanque alturaTanque
	calcula_area_total qtdTanque
	calcula_latas_necessarias
	arredonda_latas

	movsd xmm6, xmm0 ;guarda o valor total de latas em xmm6
	cvttsd2si rbx, xmm6 ;converte o total de latas para um inteiro

	calcula_preco_total precoTinta

	imprimir_float precoLatasOutput, xmm0
	
	mov rsi, rbx ;prepara o total de latas para impressao
	imprimir_msg qtdLatasOutput

    leave
    ret
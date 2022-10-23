	.intel_syntax noprefix
	.text
	.data
	.align 4
	.type	MAX_SIZE, @object
	.size	MAX_SIZE, 4
MAX_SIZE:						# максимальная длина массива
	.long	1000					# значение этой длины
	.local	ARRAY_A					# массив считывания
	.comm	ARRAY_A,4000,32				# память под этот массив
	.local	ARRAY_B					# преобразованный массив
	.comm	ARRAY_B,4000,32				# память под этот массив
	.text
	.globl	compare	
	.type	compare, @function	
compare:
	endbr64
	push	rbp
	mov	rbp, rsp
	mov	DWORD PTR -20[rbp], edi     		# записываем переменную, которую передали в функцию
	mov	DWORD PTR -4[rbp], 0
	jmp	.L2
.L6:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]				#этри три строчки реализуют переход к j элементу в массиве
	lea	rax, ARRAY_A[rip]			#
	mov	eax, DWORD PTR [rdx+rax]		#
	test	eax, eax                		# сравнение элемента массива с нулем
	jle	.L3
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_B[rip]
	mov	DWORD PTR [rdx+rax], 1     		# элемент массива приравнивает к единице
	jmp	.L4
.L3:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_A[rip]
	mov	eax, DWORD PTR [rdx+rax]
	test	eax, eax                		# сравнивает с нулем
	jns	.L5
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_B[rip]
	mov	DWORD PTR [rdx+rax], -1     		# элемент массива приравнивается к -1
	jmp	.L4
.L5:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_B[rip]
	mov	DWORD PTR [rdx+rax], 0      		# элемент приравнивается к 0
.L4:
	add	DWORD PTR -4[rbp], 1
.L2:
	mov	eax, DWORD PTR -4[rbp]			#запись значения j  в eax
	cmp	eax, DWORD PTR -20[rbp]            	# проверка в цикле for на то что не провосходит заданной длины
	jl	.L6
	nop
	nop
	pop	rbp
	ret
	.size	compare, .-compare
	.section	.rodata
.LC0:
	.string	"%d"					# строка для ввода.
.LC1:
	.string	"enter size is too big"		
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	DWORD PTR -20[rbp], edi
	mov	QWORD PTR -32[rbp], rsi
	lea	rax, -12[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT                  	#считывание значения n
	mov	edx, DWORD PTR -12[rbp]                 # запись в edx значения n
	mov	eax, DWORD PTR MAX_SIZE[rip]            # запись в eax значение максимальной длины
	cmp	edx, eax                                #сравнение n и MAX_SIZE
	jle	.L8                                     #переход к циклу for
	lea	rax, .LC1[rip]                          # запись в rax строки "enter size is too big"
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 0                                  #эти две строчки реализуют return 0
	jmp	.L14                                    #
.L8:
	mov	DWORD PTR -4[rbp], 0                    # в цикле for определеяет значения j. Оно равно 0
	jmp	.L10                                    # переход к самому циклу.
.L11:
	lea	rax, -16[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT                  	#вызывает функция считывания.
	mov	eax, DWORD PTR -16[rbp]                 # запись в eax введенного значения.
	mov	edx, DWORD PTR -4[rbp]                  #эти строки реализуют свдиг в массиве к j элементу.
	movsx	rdx, edx                            	#
	lea	rcx, 0[0+rdx*4]                         #
	lea	rdx, ARRAY_A[rip]                       #
	mov	DWORD PTR [rcx+rdx], eax                # приравнивает значение в массиве к введеному числу
	add	DWORD PTR -4[rbp], 1
.L10:
	mov	eax, DWORD PTR -12[rbp]                 # запись в eax значения n
	cmp	DWORD PTR -4[rbp], eax                  # сравнение j и n
	jl	.L11
	mov	eax, DWORD PTR -12[rbp]			
	mov	edi, eax				# запись значения n  в edi
	call	compare                             	# вызов функции compare
	mov	DWORD PTR -8[rbp], 0
	jmp	.L12
.L13:
	mov	eax, DWORD PTR -8[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_B[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	esi, eax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT                          #вывод элемент массива
	mov	edi, 10
	call	putchar@PLT                         #выводит char \n
	add	DWORD PTR -8[rbp], 1
.L12:
	mov	eax, DWORD PTR -12[rbp]
	cmp	DWORD PTR -8[rbp], eax              #проверяет, не вышел ли цикл за границы массива
	jl	.L13
	mov	eax, 0
.L14:
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:

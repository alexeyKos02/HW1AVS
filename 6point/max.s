	.intel_syntax noprefix
	.text
	.data
	.align 4
	.type	MAX_SIZE, @object
	.size	MAX_SIZE, 4
MAX_SIZE:				# максимальная длина массива
	.long	1000			# значение этой длины
	.local	ARRAY_A			# массив считывания
	.comm	ARRAY_A,4000,32		# память под этот массив
	.local	ARRAY_B			# преобразованный массив
	.comm	ARRAY_B,4000,32		# память под этот массив
	.text
	.globl	compare			#
	.type	compare, @function	
compare:
	endbr64
	push	rbp

	push r13
	push	r14
	mov	rbp, rsp
	mov	r14d, edi           # в r14d кладем переменную, переданную в функцию
	mov	r13d, 0             # в r13d кладется 0. В данном случае это переменная j  в цикле for
	jmp	.L2
.L6:
	mov	eax, r13d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_A[rip]
	mov	eax, DWORD PTR [rdx+rax]
	test	eax, eax                # сравнение элемента массива с нулем
	jle	.L3
	mov	eax, r13d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_B[rip]
	mov	DWORD PTR [rdx+rax], 1      # элемент массива приравнивает к единице
	jmp	.L4
.L3:
	mov	eax, r13d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_A[rip]
	mov	eax, DWORD PTR [rdx+rax]
	test	eax, eax                # сравнивает с нулем
	jns	.L5
	mov	eax, r13d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_B[rip]
	mov	DWORD PTR [rdx+rax], -1     # элемент массива приравнивается к -1
	jmp	.L4
.L5:
	mov	eax, r13d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, ARRAY_B[rip]
	mov	DWORD PTR [rdx+rax], 0      # элемент приравнивается к 0
.L4:
	add	r13d, 1                     #увеличение j на единицу
.L2:
	mov	eax, r13d           # в eax кладем значение j
	cmp	eax, r14d           # проверка в цикле for на то что не провосходит заданной длины
	jl	.L6
	nop
	nop
	pop r13
	pop	r14
	pop	rbp
	ret




.LC0:
	.string	"%d"				# строка для ввода.
.LC1:
	.string	"enter size is too big"		
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp

	push 	r13
	push	r14

	mov	r14d, edi
	mov	QWORD PTR -32[rbp], rsi
	lea	rax, -12[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT                  #считывание значения n
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
	mov	r13d, 0                                 # в r13d кладется 0. В данном случае это переменная j  в цикле for
	jmp	.L10                                    # переход к самому циклу.
.L11:
	lea	rax, -16[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT                  #вызывает функция считывания.
	mov	eax, DWORD PTR -16[rbp]                 # запись в eax введенного значения.
	mov	edx, r13d                               #эти строки реализуют свдиг в массиве к j элементу.
	movsx	rdx, edx                            #
	lea	rcx, 0[0+rdx*4]                         #
	lea	rdx, ARRAY_A[rip]                       #
	mov	DWORD PTR [rcx+rdx], eax                # приравнивает значение в массиве к введеному числу
	add	r13d, 1
.L10:
	mov	eax, DWORD PTR -12[rbp]                 # запись в eax значения n
	cmp	r13d, eax                  # сравнение j и n
	jl	.L11
	mov	eax, DWORD PTR -12[rbp]
	mov	edi, eax
	call	compare                             # вызов функции compare
	mov	r13d, 0
	jmp	.L12
.L13:
	mov	eax, r13d
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
	add	r13d, 1
.L12:
	mov	eax, DWORD PTR -12[rbp]
	cmp	r13d, eax              #проверяет, не вышел ли цикл за границы массива
	jl	.L13
	mov	eax, 0
.L14:
	pop r13
	pop	r14
	leave
	ret

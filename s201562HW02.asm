TITLE s201562_HW02

comment @
	작성자	: 20201562 김서인
	기능	: 수식 계산
	입력	: CSE3030_PHW02.inc를 통해 변수 x1,x2,x3가 주어짐
	출력	: F=90x1-30x2+19x3 계산한 값
@
INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW02.inc

.code
main PROC
	mov	 eax, x1	;	eax = x1
	add	 eax, eax	; 	eax = 2*x1
	add	 eax, x1	; 	eax = 3*x1
	add	 eax, eax	; 	eax = 6*x1
	mov	 ebx, eax	; 	ebx = 6*x1
	mov	 ecx, x2	; 	ecx = x2
	add	 ecx, ecx	; 	ecx = 2*x2
	sub	 eax, ecx	; 	eax = 6*x1 - 2*x2
	add	 eax, x3	; 	eax = 6*x1 - 2*x2 + x3
	mov	 edx, x3	; 	edx = x3
	add	 edx, edx	; 	edx = 2*x3
	add	 edx, x3	; 	edx = 3*x3
	add	 eax, eax	; 	eax = 12*x1 - 4*x2 + 2*x3
	add	 eax, eax	; 	eax = 24*x1 - 8*x2 + 4*x3
	add	 eax, eax	; 	eax = 48*x1 - 16*x2 + 8*x3
	add	 eax, eax	; 	eax = 96*x1 - 32*x2 + 16*x3
	sub	 eax, ebx	; 	eax = 90*x1 - 32*x2 + 16*x3
	add	 eax, ecx	; 	eax = 90*x1 - 30*x2 + 16*x3
	add	 eax, edx	; 	eax = 90*x1 - 30*x2 + 19*x3
	call WriteInt
exit
main ENDP
END main
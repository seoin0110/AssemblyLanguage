TITLE s201562_HW05
comment @
	작성자	: 20201562 김서인
	기능	: 정수를 입력받아 그 합을 출력하는 기능
	입력	: 정수와 공백으로 이뤄진 문자열을 입력받음
	출력	: 정수들의 합이 출력됨
@

INCLUDE Irvine32.inc

.data
ENT_NUM		BYTE "Enter numbers(<ent> to exit) : ", 0Dh, 0Ah, 0
BYE			BYTE "Bye!", 0Dh, 0Ah, 0
BUF_SIZE	EQU 256
inBuffer	BYTE BUF_SIZE DUP(?)		;input string buffer(EOS is 0)
inBufferN	DWORD ?						;string size(excludint EOS)
intArray	SDWORD BUF_SIZE/2 DUP(?)	;integer array

.code
main PROC
START:
	mov		edx, OFFSET ENT_NUM
	call	WriteString ;"Enter numbers(<ent> to exit) : "출력
	mov		edx, OFFSET inBuffer
	mov		ecx, BUF_SIZE
	CALL	ReadString	;문자를 입력받고 입력한 문자수 EAX에 반환(Call args: edx, ecx)
	cmp		eax, 0
	je		FIN			;입력한 문자가 없으면 끝
	mov		ecx, eax	;문자수 ecx에 넣기
	mov		edx, OfFSET inBuffer
	mov		edi, OFFSET intArray
	call	Func		;Func 함수 호출(ecx: 문자의 갯수,edx: 문자의 offset,edi:정수배열의 offset)
	cmp		eax, 0		
	je		START		;추출된 정수가 없으면 START로 돌아감
	mov		ecx, eax	;정수의 갯수만큼 반복
	mov		eax, 0		;eax 0으로 초기화
	mov		edi, OFFSET intArray
SU:
	add		eax, [edi]	;추출된 정수를 eax에 더함
	add		edi, 4		;edi에 4를 더함
	Loop SU
	cmp		eax, 0		;정수들의 합이 0보다 작으면 WriteInt 호출
	jl		MINUS
	call	WriteDec	;0보다 같거나 크면 WriteDec 호출
	jmp		EN
MINUS:
	call	WriteInt
EN:
	call	Crlf		;개행문자 출력
	jmp		START		;START로 되돌아감
FIN:
	mov		edx, OFFSET BYE	;"Bye!" 출력
	call	WriteString
exit
main ENDP

;------------------------------------------------------------------------------------------------------
Func PROC 

;문자의 갯수,inBuffer의 offset과 intArray의 offset을 각각 ecx, edx, edi로 받아 문자열에 있는 정수들의 갯수 리턴
;Receives: edx는 offset inBuffer, edi는 OFFSET intArray, ecx는 문자의 갯수
;Returns: eax는 정수의 갯수, edi 정수의 배열
;Calls: ParseInteger32
;------------------------------------------------------------------------------------------------------
	mov		eax, 0		;eax 0으로 초기화
L1:
	cmp		BYTE PTR [edx], 2Dh ;'-'이면 L3로 넘어감
	je		L3
	cmp		BYTE PTR [edx], 2Bh	;'+'이면 L3로 넘어감
	je		L3
	cmp		BYTE PTR [edx], 30h ;'0'보다 작으면 L2로 넘어감
	jb		L2
	cmp		BYTE PTR [edx], 39h	;'9'보다 작거나 같으면(정수이므로) L3로 넘어감
	jbe		L3
L2:						;정수가 아닌 경우
	inc		edx			;다음 index 가리킴
	jmp		L6
L3:						;정수인 경우
	push	eax
	mov		eax, 0		;eax 0으로 초기화
L4:
	inc		eax			;정수가 나오는 동안 반복
	dec		ecx
	cmp		ecx, 0		;ecx가 0보다 같거나 작으면 L5로 넘어감
	jle		L5
	cmp		BYTE PTR [edx+eax], 30h	;30h('0')보다 작으면 L5로 넘어감
	jb		L5
	cmp		BYTE PTR [edx+eax], 39h	;39h('9')보다 작으면 반복(정수이므로)
	jbe		L4
L5:
	push	ecx
	mov		ecx, eax	;ecx: 정수의 길이
	call	ParseInteger32	;ecx의 길이만큼 문자열을 정수로 변환해 eax에 저장
	mov		[edi], eax		;정수를 intArray에 저장
	add		edx, ecx		;정수의 길이만큼 ecx를 더함 edx가 공백을 가리키게
	pop		ecx
	pop		eax
	inc		eax				;정수의 갯수 더함
	add		edi, 4			;edi가 다음 index를 가리키게 4를 더함
	inc		ecx
	cmp		ecx, 0			;ecx가 0보다 같거나 작으면 넘어감
	jle		L7
L6:
	loop L1
L7:
	ret
Func ENDP
END main

INCLUDE Irvine32.inc
INCLUDE Q34_in.inc

.data

BYE			BYTE "Bye!",0
BUF_SIZE = 250
NumArray	DWORD BUF_SIZE DUP(?)
intNum		DWORD ?
NumSize		DWORD ?
StringSize	DWORD ?

.code
main PROC
	mov edx, OFFSET StartInput
L1:
	mov edi, OFFSET NumArray
	mov ecx, DWORD PTR [edx]
	mov StringSize, ecx
	cmp ecx, 0
	je	FIN
	add edx, 4
	push edx
	call Func
	pop edx
	cmp eax, 1
	je LLLL1
	mov NumSize, eax
	dec eax
	mov ecx, eax
	mov edi, OFFSET NumArray
	mov esi, OFFSET NumArray
	add esi,4
LLL1:
	push ecx
	mov ecx, eax
	mov edi, OFFSET NumArray
	mov esi, OFFSET NumArray
	add esi,4
LLL2:
	mov ebx, DWORD PTR [edi]
	cmp ebx, DWORD PTR [esi]
	jle LLL3
	push eax
	mov eax, DWORD PTR [esi]
	mov DWORD PTR [esi], ebx
	mov DWORD PTR [edi], eax
	pop eax
LLL3:
	add edi,4
	add esi,4
	Loop LLL2
	pop ecx
	Loop LLL1

	push edx
	mov ebx, 2
	mov eax, NumSize
	CDQ
	idiv ebx
	mov ebx, 4
	mov edi, OFFSET NumArray
	imul ebx
	mov ebx, DWORD PTR [edi+eax]
	pop edx
	mov eax, ebx
	jmp L5
LLLL1:
	mov ebx, OFFSET NumArray
	mov eax, DWORD PTR [ebx]
L5:
	cmp eax, 0
	jge LL2
	call WriteInt
	call Crlf
	add edx, StringSize
	jmp LL3
LL2:
	call WriteDec
	call Crlf
	add edx, StringSize
LL3:
	jmp L1

FIN:
	mov edx, OFFSET BYE
	call WriteString

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

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

;������ ����,inBuffer�� offset�� intArray�� offset�� ���� ecx, edx, edi�� �޾� ���ڿ��� �ִ� �������� ���� ����
;Receives: edx�� offset inBuffer, edi�� OFFSET intArray, ecx�� ������ ����
;Returns: eax�� ������ ����, edi ������ �迭
;Calls: ParseInteger32
;------------------------------------------------------------------------------------------------------
	mov		eax, 0		;eax 0���� �ʱ�ȭ
L1:
	cmp		BYTE PTR [edx], 2Dh ;'-'�̸� L3�� �Ѿ
	je		L3
	cmp		BYTE PTR [edx], 2Bh	;'+'�̸� L3�� �Ѿ
	je		L3
	cmp		BYTE PTR [edx], 30h ;'0'���� ������ L2�� �Ѿ
	jb		L2
	cmp		BYTE PTR [edx], 39h	;'9'���� �۰ų� ������(�����̹Ƿ�) L3�� �Ѿ
	jbe		L3
L2:						;������ �ƴ� ���
	inc		edx			;���� index ����Ŵ
	jmp		L6
L3:						;������ ���
	push	eax
	mov		eax, 0		;eax 0���� �ʱ�ȭ
L4:
	inc		eax			;������ ������ ���� �ݺ�
	dec		ecx
	cmp		ecx, 0		;ecx�� 0���� ���ų� ������ L5�� �Ѿ
	jle		L5
	cmp		BYTE PTR [edx+eax], 30h	;30h('0')���� ������ L5�� �Ѿ
	jb		L5
	cmp		BYTE PTR [edx+eax], 39h	;39h('9')���� ������ �ݺ�(�����̹Ƿ�)
	jbe		L4
L5:
	push	ecx
	mov		ecx, eax	;ecx: ������ ����
	call	ParseInteger32	;ecx�� ���̸�ŭ ���ڿ��� ������ ��ȯ�� eax�� ����
	mov		[edi], eax		;������ intArray�� ����
	add		edx, ecx		;������ ���̸�ŭ ecx�� ���� edx�� ������ ����Ű��
	pop		ecx
	pop		eax
	inc		eax				;������ ���� ����
	add		edi, 4			;edi�� ���� index�� ����Ű�� 4�� ����
	inc		ecx
	cmp		ecx, 0			;ecx�� 0���� ���ų� ������ �Ѿ
	jle		L7
L6:
	loop L1
L7:
	ret
Func ENDP
END main
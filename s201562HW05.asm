TITLE s201562_HW05
comment @
	�ۼ���	: 20201562 �輭��
	���	: ������ �Է¹޾� �� ���� ����ϴ� ���
	�Է�	: ������ �������� �̷��� ���ڿ��� �Է¹���
	���	: �������� ���� ��µ�
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
	call	WriteString ;"Enter numbers(<ent> to exit) : "���
	mov		edx, OFFSET inBuffer
	mov		ecx, BUF_SIZE
	CALL	ReadString	;���ڸ� �Է¹ް� �Է��� ���ڼ� EAX�� ��ȯ(Call args: edx, ecx)
	cmp		eax, 0
	je		FIN			;�Է��� ���ڰ� ������ ��
	mov		ecx, eax	;���ڼ� ecx�� �ֱ�
	mov		edx, OfFSET inBuffer
	mov		edi, OFFSET intArray
	call	Func		;Func �Լ� ȣ��(ecx: ������ ����,edx: ������ offset,edi:�����迭�� offset)
	cmp		eax, 0		
	je		START		;����� ������ ������ START�� ���ư�
	mov		ecx, eax	;������ ������ŭ �ݺ�
	mov		eax, 0		;eax 0���� �ʱ�ȭ
	mov		edi, OFFSET intArray
SU:
	add		eax, [edi]	;����� ������ eax�� ����
	add		edi, 4		;edi�� 4�� ����
	Loop SU
	cmp		eax, 0		;�������� ���� 0���� ������ WriteInt ȣ��
	jl		MINUS
	call	WriteDec	;0���� ���ų� ũ�� WriteDec ȣ��
	jmp		EN
MINUS:
	call	WriteInt
EN:
	call	Crlf		;���๮�� ���
	jmp		START		;START�� �ǵ��ư�
FIN:
	mov		edx, OFFSET BYE	;"Bye!" ���
	call	WriteString
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
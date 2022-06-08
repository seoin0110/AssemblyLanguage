
INCLUDE Irvine32.inc

.data
prin		BYTE "Enter a string : ", 0
BYE			BYTE "Bye!",0
BUF_SIZE = 30
inBuffer	BYTE BUF_SIZE DUP(?)		;input string buffer(EOS is 0)
inBuffert	BYTE BUF_SIZE DUP(?)						;string size(excludint EOS)

.code
main PROC
START:
	mov		edx, OFFSET prin
	call	WriteString ;"Enter numbers(<ent> to exit) : "���
	mov		edx, OFFSET inBuffer
	mov		ecx, BUF_SIZE
	CALL	ReadString	;���ڸ� �Է¹ް� �Է��� ���ڼ� EAX�� ��ȯ(Call args: edx, ecx)
	cmp		eax, 0
	je		FIN			;�Է��� ���ڰ� ������ ��
	mov		ecx, eax	;���ڼ� ecx�� �ֱ�
	cmp		eax, 2
	ja		L1
	mov		edx, OFFSET inBuffer
	call	WriteString
	call	Crlf
	call	Crlf
	jmp		START
L1:
	mov		edx, OFFSET inBuffer
	mov		edi, OFFSET inBuffert
	mov		ecx, eax
LL:
	mov		bl, BYTE PTR [edx]
	mov		BYTE PTR [edi], bl
	inc		edx
	inc		edi
	loop LL		;inBuffer�� inBuffert�� ����
	dec		eax
	mov		ebx, eax
	mov		eax, 0
	mov		edx, OFFSET inBuffer
	mov		edi, OFFSET inBuffert

L2:		;���� �������� �κ� ���
	cmp		eax, ebx
	ja		L3			;���� Ŀ����
	mov		edx, OFFSET inBuffer
	call	WriteString
	call	Crlf
	mov		cl, ' '			;�պκ��� ' '���� �ٲ���
	mov		BYTE PTR [edx+eax], cl
	mov		BYTE PTR [edx+ebx], 0		;�޺κ��� 0���� �ٲ���
	dec		ebx
	inc		eax
	jmp		L2
L3:							;ebx�� eax ����
	inc		ebx
	dec		eax
	mov		cl ,BYTE PTR [edi+ebx]
	mov		BYTE PTR[edx+ebx], cl
	mov		cl, BYTE PTR [edi+eax]
	mov		BYTE PTR[edx+eax], cl
L5:		;���� Ŀ���� �κ� ���
	inc		ebx
	dec		eax
	mov		cl ,BYTE PTR [edi+ebx]
	mov		BYTE PTR[edx+ebx], cl
	mov		cl, BYTE PTR [edi+eax]
	mov		BYTE PTR[edx+eax], cl
	call	WriteString
	call	Crlf
	cmp		eax, 0
	je		L6
	jmp		L5
L6:
	call	CRLF
	jmp		START
FIN:
	mov		edx, OFFSET BYE	;"Bye!" ���
	call	WriteString
exit
main ENDP

END main
TITLE s201562_HW04
comment @
	�ۼ���	: 20201562 �輭��
	���	: Uphills ���� �������� ���� ū ���� ���ϱ�
	�Է�	: CSE3030_PHW04.inc�� ���� ���� TN, CASE, HEIGHT�� ����
	���	: �� �׽�Ʈ ���̽����� �������� ���� ū ���̰� ��µ�
@

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW04.inc


.data
CHANGEL	BYTE 0Ah,0Dh,0			;�ٹٲ� ����

.code
main PROC
	mov esi, OFFSET TN
	mov ecx, [esi]
L1:	push ecx					;��ø loop�� �ϱ� ���� ecx stack�� ����
	add esi, 4
	mov eax, 0					;������ �ִ� �ʱ�ȭ
	mov ebx, 0					;������ ���� �ʱ�ȭ
	mov ecx, [esi]				;CASE ������ ecx�� ����
	cmp ecx, 1
	je L5						;CASE�� 1�� ��� �������� �ִ� ���̴� 0
	dec ecx						;CASE ���� - 1 �� ���캽
L2: add esi, 4
	mov edx, [esi]
	cmp	edx, DWORD PTR [esi+4]	;���� ���� ��
	jae L3						;if(edx>=[esi+4]) jmp L3
	add ebx, DWORD PTR [esi+4]	;ebx = ebx+[esi+4]
	sub ebx, edx				;ebx = ebx-[esi]
	cmp eax, ebx
	jae L5						;if(eax>=ebx) jmp L5
	mov eax, ebx				;max = sum
	jmp L5
L3:	cmp eax, ebx				;���� ���̿� ������ �ִ� ��
	jae L4						;if(eax>=ebx) jmp L4
	mov eax, ebx				;�ִ� ����
L4:	mov ebx, 0
L5:	
Loop L2
	call WriteDec				;�ִ� ���
	add esi, 4
	mov edx, OFFSET CHANGEL		;�ٹٲ� ���� ���
	call WriteString
	inc edx
	call WriteString
	pop ecx
Loop L1

exit
main ENDP
END main
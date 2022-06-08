TITLE s201562_HW03
comment @
	�ۼ���	: 20201562 �輭��
	���	: ī�̻縣 ��ȣ
	�Է�	: CSE3030_PHW03.inc�� ���� ���� Num_Str, Cipher_Str�� �־���
	���	: 0s201562_out.txt���Ͽ� de-cipher�� ����� �����
@

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW03.inc


.data
LF = 0Ah
CR = 0Dh
filename	BYTE	"0s201562_out.txt",	0
filehandle	DWORD	?
Alphabet	BYTE	"ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ",0	;���ǹ��� �����ʰ� ���������� ���ڿ��� de-cipher�ϱ� ���� ���ĺ��� �ι� ��
buffer		BYTE	CR,LF,0				;���๮��

.code
main PROC
	mov		esi,		OFFSET Cipher_Str
	mov		edx,		OFFSET filename
	call	CreateOutputFile			;esi,edx ���� �� ���� ����
	mov		filehandle,	eax				;eax�� ���� �Է��� ���� �� file handle�� ����
	mov		ecx,		Num_Str			;ecx�� Num_str�� ������ ���ڿ��� ������ŭ �ݺ�
L1:		push	ecx						;Nested Loop�� ���� ecx stack�� push
		mov		ecx,	10
L2:		push ecx						;���� �Է½� ecx�� ����ؾ��ϹǷ� ecx stack�� push
		mov edi,	OFFSET Alphabet		;edi�� Alphabet�� OFFSET ����
		mov		bl,	[esi]
		movzx		ebx,	bl			;de-cipher�� ���ڸ� ebx�� ����
		sub		ebx,	"A"				;ebx���� "A"�� �� ���ĺ� index�� ����
		add		ebx,	16				;de-cipher�ϱ� ���� 10�� ���� �Ͱ� 16�� ���ϴ� ���� ����
		add		edi,	ebx				;edi�� ���Ͽ� �Է��� ������ index��ŭ ����
		mov		eax,	filehandle
		mov		edx,	edi
		mov		ecx,	1				;���Ͽ� �Է��� byte
		call	WriteToFile				;eax, edx, ecx ���� �� ���Ͽ� ���� 1�� �Է�
		inc		esi						;esi(OFFSET Cipher_Str)�� 1������
		pop		ecx						;loop ������ ���� ecx�� pop
	loop L2								;10�� ������ ������ �ݺ�
		mov		eax,	filehandle
		mov		edx,	OFFSET buffer	;���๮���� offset
		mov		ecx,	2				;���๮�� 2byte
		call	WriteToFile				;eax, edx, ecx ���� �� ���Ͽ� ���๮�� �Է�
		inc		esi						;esi(OFFSET Cipher_Str)�� 1������
		pop		ecx						;loop ������ ���� ecx�� pop
	loop L1
	mov		eax,		filehandle
	call	CloseFile					;eax ���� �� ���� �ݱ�
exit
main ENDP
END main
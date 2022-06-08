TITLE s201562_HW06
comment @
	�ۼ���	: 20201562 �輭��
	���	: ����������� ���� ���ڸ� �Է¹޾� ���ڸ�ŭ �ݺ��� ���ڸ� ���
	�Է�	: ���ڿ� ���ڵ�� �̷��� ����(in.txt)�Է¹���
	���	: out.txt�� ���ڸ��� ���ڸ�ŭ �ݺ��� �ؽ�Ʈ ����
@

INCLUDE Irvine32.inc

.data
	next_line BYTE 0Dh, 0Ah, 0
	BUF_SIZE = 24							;BUF_SIZE�� 24�� ����
	stdinHandle HANDLE ?					;HANDLE�� C���� FILE�� 
	stdoutHandle HANDLE ?					;���� ������ data type
	inBuf BYTE BUF_SIZE DUP(?)				;input buf
	bytesREAD DWORD ?						;������ ���� byte ���� ����
	outBuf BYTE BUF_SIZE DUP(?)				;output buf
	bytesWRITE DWORD ?						;������ ������ byte ���� ����

.code

main PROC
	INVOKE GetStdHandle, STD_INPUT_HANDLE	;eax�� handle ��ȯ
	mov stdinHandle, eax
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE	;eax�� handle ��ȯ
	mov stdoutHandle, eax
L1:
	mov eax, stdinHandle
	mov edx, OFFSET inBuf
	call Read_a_Line						;�����б�
	cmp ecx, 2								;����ó�� ecx�� 2���� ���ų� ������ ������
	jbe EN
	push ecx
	mov ecx, 1
	mov edx, OFFSET inBuf
	cmp BYTE PTR [edx], 30h					;���� ó�� 1~9���̰� �ƴϸ� ������
	jbe EN
	cmp BYTE PTR [edx], 39h
	ja EN
	call ParseDecimal32						;EAX�� ���� ����
	pop ecx
	inc edx									;�������� Ȯ��
	cmp BYTE PTR [edx], ' '					;����ó�� �ι�° ���ڰ� ' '�� �ƴϸ� ������
	jne EN
	mov edx, OFFSET inBuf
	add edx, 2								;���ڿ����� Ȯ���ϱ� ���� edx <= edx + 2
	sub ecx, 2								;edx�� 2 �������Ƿ� loop counter�� ecx�� -2
L2:
	cmp BYTE PTR [edx], 0					;[edx]�� 0�̸� L4�� jmp
	je L4
	push ecx
	mov ecx, eax							;�ݺ��� Ƚ���� ecx�� mov
	push eax
L3:
	push edx
	push ecx
	INVOKE WriteFile,						;�ѱ��ھ� ���
		stdoutHandle,						;input handle
		edx,								;�Է� ���� �ּ�
		1,									;�а��� �ϴ� �ִ� ũ��
		OFFSET bytesWrite, 0				;������ ���� byte ��, 0
	pop ecx
	pop edx
Loop L3
	inc edx									;���� ���� ����Ŵ
	pop eax
	pop ecx
Loop L2
L4:
	mov edx, OFFSET next_line				;�ٹٲ� ���
	INVOKE WriteFile,
		stdoutHandle,						;output handle
		edx,								;��� ���� �ּ�
		2,									;������ �ϴ� ���� ��
		OFFSET bytesWrite, 0				;������ �� byte ��, 0
	jmp L1
EN:
exit
main ENDP

Read_a_Line PROC
	;; Input EAX : File Handle
	;; EDX : Buffer offset to store the string
	;; Output ECX : # of chars read(0 if none(i.e. EOF)
	;; Function
	;; Read a line from a ~.txt file until CR, LF.
	;; CR, LF are ignored and 0 is appended at the end.
	;; ECX only counts valid chars just before CR.
	.data
		CR = 0Ah
		LF = 0Dh
		Single_Buf__ BYTE ? ; two underscores(__)
		Byte_Read__ DWORD ? ; "
	.code
		xor ecx, ecx ; reset counter
	Read_Loop :
		;; Note: Win32 API functions do not preserve 
		;; EAX, EBX, ECX, and EDX.
		push eax ; save registers
		push ecx
		push edx
		; read a single char
		INVOKE ReadFile, EAX, OFFSET Single_Buf__, 
		1, OFFSET Byte_Read__, 0
		pop edx ; restore registers
		pop ecx
		pop eax
		cmp DWORD PTR Byte_Read__, 0 ; check # of chars read
		je Read_End ; if read nothing, return
		;; Each end of line consists of CR and then LF
		mov bl, Single_Buf__ ; load the char
		cmp bl, CR
		je Read_Loop ; if CR, read once more
		cmp bl, LF
		je Read_End ; End of line detected, return
		mov [edx], bl ; move the char to input buf
		inc edx ; ++1 buf pointer
		inc ecx ; ++1 char counter
		jmp Read_Loop ; go to start to read the next line
	Read_End:
		mov BYTE PTR [edx], 0 ; append 0 at the end
	ret
Read_a_Line ENDP

END main

TITLE s201562_HW06
comment @
	작성자	: 20201562 김서인
	기능	: 파일입출력을 통해 문자를 입력받아 숫자만큼 반복된 문자를 출력
	입력	: 숫자와 문자들로 이뤄진 파일(in.txt)입력받음
	출력	: out.txt에 문자마다 숫자만큼 반복된 텍스트 파일
@

INCLUDE Irvine32.inc

.data
	next_line BYTE 0Dh, 0Ah, 0
	BUF_SIZE = 24							;BUF_SIZE는 24로 설정
	stdinHandle HANDLE ?					;HANDLE은 C언어에서 FILE과 
	stdoutHandle HANDLE ?					;같은 형태의 data type
	inBuf BYTE BUF_SIZE DUP(?)				;input buf
	bytesREAD DWORD ?						;실제로 읽은 byte 개수 저장
	outBuf BYTE BUF_SIZE DUP(?)				;output buf
	bytesWRITE DWORD ?						;실제로 쓰여진 byte 개수 저장

.code

main PROC
	INVOKE GetStdHandle, STD_INPUT_HANDLE	;eax로 handle 반환
	mov stdinHandle, eax
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE	;eax로 handle 반환
	mov stdoutHandle, eax
L1:
	mov eax, stdinHandle
	mov edx, OFFSET inBuf
	call Read_a_Line						;한줄읽기
	cmp ecx, 2								;예외처리 ecx가 2보다 같거나 작으면 끝내기
	jbe EN
	push ecx
	mov ecx, 1
	mov edx, OFFSET inBuf
	cmp BYTE PTR [edx], 30h					;예외 처리 1~9사이가 아니면 끝내기
	jbe EN
	cmp BYTE PTR [edx], 39h
	ja EN
	call ParseDecimal32						;EAX에 숫자 저장
	pop ecx
	inc edx									;다음글자 확인
	cmp BYTE PTR [edx], ' '					;예외처리 두번째 글자가 ' '이 아니면 끝내기
	jne EN
	mov edx, OFFSET inBuf
	add edx, 2								;문자열부터 확인하기 위해 edx <= edx + 2
	sub ecx, 2								;edx를 2 더했으므로 loop counter인 ecx는 -2
L2:
	cmp BYTE PTR [edx], 0					;[edx]가 0이면 L4로 jmp
	je L4
	push ecx
	mov ecx, eax							;반복할 횟수를 ecx로 mov
	push eax
L3:
	push edx
	push ecx
	INVOKE WriteFile,						;한글자씩 출력
		stdoutHandle,						;input handle
		edx,								;입력 버퍼 주소
		1,									;읽고자 하는 최대 크기
		OFFSET bytesWrite, 0				;실제로 읽은 byte 수, 0
	pop ecx
	pop edx
Loop L3
	inc edx									;다음 글자 가리킴
	pop eax
	pop ecx
Loop L2
L4:
	mov edx, OFFSET next_line				;줄바꿈 출력
	INVOKE WriteFile,
		stdoutHandle,						;output handle
		edx,								;출력 버퍼 주소
		2,									;쓰고자 하는 문자 수
		OFFSET bytesWrite, 0				;실제로 쓴 byte 수, 0
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

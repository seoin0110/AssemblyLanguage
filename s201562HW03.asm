TITLE s201562_HW03
comment @
	작성자	: 20201562 김서인
	기능	: 카이사르 암호
	입력	: CSE3030_PHW03.inc를 통해 변수 Num_Str, Cipher_Str가 주어짐
	출력	: 0s201562_out.txt파일에 de-cipher한 결과가 저장됨
@

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW03.inc


.data
LF = 0Ah
CR = 0Dh
filename	BYTE	"0s201562_out.txt",	0
filehandle	DWORD	?
Alphabet	BYTE	"ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ",0	;조건문을 쓰지않고 덧셈만으로 문자열을 de-cipher하기 위해 알파벳을 두번 씀
buffer		BYTE	CR,LF,0				;개행문자

.code
main PROC
	mov		esi,		OFFSET Cipher_Str
	mov		edx,		OFFSET filename
	call	CreateOutputFile			;esi,edx 설정 후 파일 열기
	mov		filehandle,	eax				;eax에 파일 입력을 위해 열 file handle을 저장
	mov		ecx,		Num_Str			;ecx에 Num_str를 저장해 문자열의 갯수만큼 반복
L1:		push	ecx						;Nested Loop를 위해 ecx stack에 push
		mov		ecx,	10
L2:		push ecx						;파일 입력시 ecx를 사용해야하므로 ecx stack에 push
		mov edi,	OFFSET Alphabet		;edi에 Alphabet의 OFFSET 저장
		mov		bl,	[esi]
		movzx		ebx,	bl			;de-cipher할 문자를 ebx에 저장
		sub		ebx,	"A"				;ebx에서 "A"를 빼 알파벳 index를 저장
		add		ebx,	16				;de-cipher하기 위해 10을 빼는 것과 16을 더하는 것은 같음
		add		edi,	ebx				;edi에 파일에 입력할 문자의 index만큼 더함
		mov		eax,	filehandle
		mov		edx,	edi
		mov		ecx,	1				;파일에 입력할 byte
		call	WriteToFile				;eax, edx, ecx 설정 후 파일에 문자 1개 입력
		inc		esi						;esi(OFFSET Cipher_Str)을 1증가함
		pop		ecx						;loop 진행을 위해 ecx에 pop
	loop L2								;10번 시행할 때까지 반복
		mov		eax,	filehandle
		mov		edx,	OFFSET buffer	;개행문자의 offset
		mov		ecx,	2				;개행문자 2byte
		call	WriteToFile				;eax, edx, ecx 설정 후 파일에 개행문자 입력
		inc		esi						;esi(OFFSET Cipher_Str)을 1증가함
		pop		ecx						;loop 진행을 위해 ecx에 pop
	loop L1
	mov		eax,		filehandle
	call	CloseFile					;eax 설정 후 파일 닫기
exit
main ENDP
END main
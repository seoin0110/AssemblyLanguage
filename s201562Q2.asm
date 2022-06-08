
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
	call	WriteString ;"Enter numbers(<ent> to exit) : "출력
	mov		edx, OFFSET inBuffer
	mov		ecx, BUF_SIZE
	CALL	ReadString	;문자를 입력받고 입력한 문자수 EAX에 반환(Call args: edx, ecx)
	cmp		eax, 0
	je		FIN			;입력한 문자가 없으면 끝
	mov		ecx, eax	;문자수 ecx에 넣기
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
	loop LL		;inBuffer을 inBuffert에 복제
	dec		eax
	mov		ebx, eax
	mov		eax, 0
	mov		edx, OFFSET inBuffer
	mov		edi, OFFSET inBuffert

L2:		;점점 좁아지는 부분 출력
	cmp		eax, ebx
	ja		L3			;점점 커지기
	mov		edx, OFFSET inBuffer
	call	WriteString
	call	Crlf
	mov		cl, ' '			;앞부분을 ' '으로 바꿔줌
	mov		BYTE PTR [edx+eax], cl
	mov		BYTE PTR [edx+ebx], 0		;뒷부분은 0으로 바꿔줌
	dec		ebx
	inc		eax
	jmp		L2
L3:							;ebx와 eax 보정
	inc		ebx
	dec		eax
	mov		cl ,BYTE PTR [edi+ebx]
	mov		BYTE PTR[edx+ebx], cl
	mov		cl, BYTE PTR [edi+eax]
	mov		BYTE PTR[edx+eax], cl
L5:		;점점 커지는 부분 출력
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
	mov		edx, OFFSET BYE	;"Bye!" 출력
	call	WriteString
exit
main ENDP

END main
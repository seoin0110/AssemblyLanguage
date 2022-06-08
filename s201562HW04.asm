TITLE s201562_HW04
comment @
	작성자	: 20201562 김서인
	기능	: Uphills 등산로 오르막의 가장 큰 높이 구하기
	입력	: CSE3030_PHW04.inc를 통해 변수 TN, CASE, HEIGHT를 받음
	출력	: 각 테스트 케이스에서 오르막의 가장 큰 높이가 출력됨
@

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW04.inc


.data
CHANGEL	BYTE 0Ah,0Dh,0			;줄바꿈 문자

.code
main PROC
	mov esi, OFFSET TN
	mov ecx, [esi]
L1:	push ecx					;중첩 loop을 하기 위해 ecx stack에 저장
	add esi, 4
	mov eax, 0					;높이의 최댓값 초기화
	mov ebx, 0					;현재의 높이 초기화
	mov ecx, [esi]				;CASE 갯수를 ecx에 저장
	cmp ecx, 1
	je L5						;CASE가 1인 경우 오르막의 최대 높이는 0
	dec ecx						;CASE 갯수 - 1 번 살펴봄
L2: add esi, 4
	mov edx, [esi]
	cmp	edx, DWORD PTR [esi+4]	;다음 고도와 비교
	jae L3						;if(edx>=[esi+4]) jmp L3
	add ebx, DWORD PTR [esi+4]	;ebx = ebx+[esi+4]
	sub ebx, edx				;ebx = ebx-[esi]
	cmp eax, ebx
	jae L5						;if(eax>=ebx) jmp L5
	mov eax, ebx				;max = sum
	jmp L5
L3:	cmp eax, ebx				;현재 높이와 높이의 최댓값 비교
	jae L4						;if(eax>=ebx) jmp L4
	mov eax, ebx				;최댓값 갱신
L4:	mov ebx, 0
L5:	
Loop L2
	call WriteDec				;최댓값 출력
	add esi, 4
	mov edx, OFFSET CHANGEL		;줄바꿈 문자 출력
	call WriteString
	inc edx
	call WriteString
	pop ecx
Loop L1

exit
main ENDP
END main
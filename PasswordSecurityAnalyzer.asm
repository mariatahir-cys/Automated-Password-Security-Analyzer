INCLUDE Irvine32.inc

.data
inputMsg    BYTE "Enter Password: ",0

weakMsg     BYTE "Result: WEAK",0
medMsg      BYTE "Result: MEDIUM",0
strongMsg   BYTE "Result: STRONG",0

msgU        BYTE "Missing uppercase",0
msgL        BYTE "Missing lowercase",0
msgD        BYTE "Missing digit",0
msgS        BYTE "Missing special character",0
msgLen      BYTE "Too short password",0

msgWeakBF   BYTE "Brute Force Risk: Can be cracked quickly",0
msgMedBF    BYTE "Brute Force Risk: May take time to crack",0
msgStrBF    BYTE "Brute Force Risk: Very hard to crack",0

password BYTE 50 DUP(0)
len DWORD ?

upperFlag BYTE 0
lowerFlag BYTE 0
digitFlag BYTE 0
specialFlag BYTE 0

.code
main PROC

    ; Input
    mov edx, OFFSET inputMsg
    call WriteString

    mov edx, OFFSET password
    mov ecx, 50
    call ReadString
    mov len, eax

    ; reset flags
    mov upperFlag, 0
    mov lowerFlag, 0
    mov digitFlag, 0
    mov specialFlag, 0

    mov esi, OFFSET password
    mov ecx, len

checkLoop:
    mov al, [esi]

    ; uppercase
    cmp al, 'A'
    jb checkLower
    cmp al, 'Z'
    ja checkLower
    mov upperFlag, 1
    jmp next

checkLower:
    cmp al, 'a'
    jb checkDigit
    cmp al, 'z'
    ja checkDigit
    mov lowerFlag, 1
    jmp next

checkDigit:
    cmp al, '0'
    jb checkSpecial
    cmp al, '9'
    ja checkSpecial
    mov digitFlag, 1
    jmp next

checkSpecial:
    mov specialFlag, 1

next:
    inc esi
    loop checkLoop

    ; -------------------------
    ; SCORING SYSTEM
    ; -------------------------
    mov al, upperFlag
    add al, lowerFlag
    add al, digitFlag
    add al, specialFlag
    mov bl, al        ; score 0–4

    ; length rule
    mov eax, len
    cmp eax, 8
    jae len_ok
    dec bl

len_ok:

    call Crlf

    ; -------------------------
    ; REASONS (why weak)
    ; -------------------------
    cmp upperFlag, 1
    je skip1
    mov edx, OFFSET msgU
    call WriteString
    call Crlf
skip1:

    cmp lowerFlag, 1
    je skip2
    mov edx, OFFSET msgL
    call WriteString
    call Crlf
skip2:

    cmp digitFlag, 1
    je skip3
    mov edx, OFFSET msgD
    call WriteString
    call Crlf
skip3:

    cmp specialFlag, 1
    je skip4
    mov edx, OFFSET msgS
    call WriteString
    call Crlf
skip4:

    mov eax, len
    cmp eax, 8
    ja skip5
    mov edx, OFFSET msgLen
    call WriteString
    call Crlf
skip5:

    call Crlf

    ; -------------------------
    ; FINAL RESULT
    ; -------------------------
    cmp bl, 2
    jbe WEAK

    cmp bl, 3
    je MEDIUM

    jmp STRONG

WEAK:
    mov edx, OFFSET weakMsg
    call WriteString
    call Crlf
    mov edx, OFFSET msgWeakBF
    call WriteString
    jmp done

MEDIUM:
    mov edx, OFFSET medMsg
    call WriteString
    call Crlf
    mov edx, OFFSET msgMedBF
    call WriteString
    jmp done

STRONG:
    mov edx, OFFSET strongMsg
    call WriteString
    call Crlf

    mov edx, OFFSET msgStrBF
    call WriteString

    jmp done

done:
    call Crlf
    exit

main ENDP
END main
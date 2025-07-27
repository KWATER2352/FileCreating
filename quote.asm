section .data
    filename db "quotes.txt", 0
    contents db "To be, or not to be, that is the question.", 10, 10, \
               "A fool thinks himself to be wise, but a wise man knows himself to be a fool.", 10
    contents_len equ $ - contents

    new_contents db "Better three hours too soon than a minute too late.", 10, 10, \
                   "No legacy is so rich as honesty.", 10
    new_contents_len equ $ - new_contents

section .bss
    fd_out resd 1

section .text
    global _start

_start:
    ; sys_open (create/truncate file with read/write)
    mov eax, 5              ; sys_open
    mov ebx, filename
    mov ecx, 2 | 64 | 512   ; O_RDWR | O_CREAT | O_TRUNC
    mov edx, 0666           ; permissions
    int 0x80
    mov [fd_out], eax

    ; sys_write
    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, contents
    mov edx, contents_len
    int 0x80

    ; move file pointer to the end for appending
    mov eax, 19             ; sys_lseek
    mov ebx, [fd_out]       ; file descriptor
    xor ecx, ecx            ; offset = 0
    mov edx, 2              ; SEEK_END
    int 0x80

    ; write new content
    mov eax, 4              ; sys_write
    mov ebx, [fd_out]
    mov ecx, new_contents
    mov edx, new_contents_len
    int 0x80

    ; sys_close
    mov eax, 6
    mov ebx, [fd_out]
    int 0x80

    ; sys_exit
    mov eax, 1
    xor ebx, ebx
    int 0x80


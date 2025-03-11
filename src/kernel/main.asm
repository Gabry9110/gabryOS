org 0x7C00
bits 16


%define ENDL 0x0D, 0x0A


start: 
    jmp main


;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb  ; loads character in al
    or al, al  ; verify if next character is null using bitwise OR, change zero flag if it is
    jz .done

    mov ah, 0x0e  ; call BIOS interrupt, using a built in function that write text to screen in TTY mode
    mov bh, 0
    int 0x10  ; actually call the BIOS

    jmp .loop

.done:
    pop ax
    pop si
    ret


main:
    ; setup data segments
    mov ax, 0  ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00  ; stack grows downwards from where we are loaded in memory, we don't want it to overwrite anything

    ; print message
    mov si, msg_hello
    call puts

    hlt

msg_hello: db 'Hello, world!', ENDL, 0

.halt:
    jmp .halt


times 510-($-$$) db 0
dw 0AA55h

; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
include emu8086.inc

NEWLINE    MACRO
    mov ah, 2
    ;newline and cret
	mov dl, 0ah
	int 21h
	mov dl, 0dh
	int 21h        
ENDM

org 100h

; first user input
;storing first number
;mov si,1010
mov si, 00
mov bp, 00

start:
    mov dx, offset start_msg
    mov ah, 9
    int 21h
    inc si
    mov ah, 1
    mov cx, 03

    mov di, 1000h                     

input:
    int 21h
    sub al, '0'
    mov [di], al
    inc di
    loop input
    NEWLINE
    

;converting input to decimal and storing it
mov di, 1000h
mov al, [di]
mov cl, 100
mul cl
mov dl, al
jo error

inc di
mov al, [di]
mov cl, 10
mul cl

inc di
add al, [di]
add al, dl
mov [si], al
;checks if al==0
cmp al, 00
je error    

     
jnc cont

error:
    mov dx, offset err_msg
    mov ah, 9
    int 21h
    NEWLINE
    INT 20h  
                

cont:
    ; getting nxt user input
    cmp si, 01
    je start
    
    ; primeFact of second number
    mov al, [si]
    mov ah, 0
    mov cx, ax
    mov bl, 1        
    
    incDiv2:
        mov ax, cx
        inc bl
    startPrime2:
        mov cx, ax
        div bl
        cmp ah, 0
        jne incDiv2
        
        mov prime2[bp], bl
        inc bp
        cmp al, 01
        jne startPrime2
            
        
    ;primeFact of first number
    mov bp, 0
    dec si    
    mov al, [si]
    mov ah, 0
    mov cx, ax
    mov bl, 1
    
    
    incDiv:
        mov ax, cx
        inc bl
    startPrime:
        mov cx, ax
        div bl
        cmp ah, 0
        jne incDiv
        
        mov prime1[bp], bl
        inc bp
        cmp al, 01
        jne startPrime
                  
           
           
        ;printing prime factors of 1st number
        PRINT 'Prime factors of 1st number: '
        mov bp, 0
        mov ah, 0
        mov al, byte prime1[bp]
    printP1:
        call print_num_uns
        NEWLINE
	    mov ax, 0
	    inc bp 
        mov al, prime1[bp]
        cmp al, 0
        jne printP1
        NEWLINE
        
        
        ;printing prime factors of 2nd number
        PRINT 'Prime factors of 2nd number: '
        mov bp, 0
        mov ah, 0
        mov al, byte prime2[bp]
    printP2:
        call print_num_uns
        NEWLINE
	    mov ax, 0
	    inc bp 
        mov al, prime2[bp]
        cmp al, 0
        jne printP2
        NEWLINE
    
    ;press enter to continue (debugging)
    mov ah, 1
	int 21h 

    mov ah, 00
    mov al, [si]
    mov bl, [si+1] 
    
    gcd:
        cmp al, 00
        je finish
        xchg bl, al
        div bl
        mov al, ah
        mov ah, 0       
        jmp gcd
        
        finish:
        mov ax,bx
        mov cx,bx ;moves GCD in cx for use in LCM
        mov bh, 0
        
        PRINT 'GCD: '
        call print_num_uns
        NEWLINE
        
    lcm:
        mov ah, 00
        mov al, [si]
        mov bl, [si+1]
        mul bl
        mov bl, cl
        mov dx, 0
        div bx
        
        PRINT 'LCM: '
        call print_num_uns
        NEWLINE
                 
        
    


        

INT 20h

DEFINE_PRINT_NUM_UNS

start_msg db "Enter a number (between 001 and 255): $"
err_msg db "Enter a valid number...Exiting the program !! $"

prime1 db 0,0,0,0,0,0,0,0
prime2 db 0,0,0,0,0,0,0,0

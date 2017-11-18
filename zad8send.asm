.model small
.386
.stack 200h

.data
; starting point can be set and then
; all other points can be calculated
; in relation to it, eg.
; third_rectangle_left_x = center_x + 100
; but it makes calculations more complicated

; first rectangle
    l_one dw 10
    r_one dw 20
    u_one dw 10
    d_one dw 70
    color_one db 02h

; second
    l_two dw 20
    r_two dw 40
    u_two dw 40
    d_two dw 50
    color_two db 06h

; third
    l_three dw 40
    r_three dw 50
    u_three dw 30
    d_three dw 90
    color_three db 04h

    x_dir dw 1
    y_dir dw 1
    counter dw ?

.code
start:
    mov eax, @data
    mov ds, eax
    call move

animate:
    mov ah,00h
    mov al,13h
    int 10h
    call figure
    ret

figure:
    mov cx, l_one
    mov dx, u_one
    mov ah, 0ch
    mov al, color_one
    call draw_one

    mov cx, l_two
    mov dx, u_two
    mov ah, 0ch
    mov al, color_two
    call draw_two

    mov cx, l_three
    mov dx, u_three
    mov ah, 0ch
    mov al, color_three
    call draw_three

    dec counter;
    cmp counter, 0
    jge figure
    ret

draw_one:
    inc cx
    int 10h
    cmp cx, r_one
    jne draw_one

    mov cx, l_one
    inc dx
    cmp dx, d_one
    jne draw_one
    ret

draw_two:
    inc cx
    int 10h
    cmp cx, r_two
    jne draw_two

    mov cx, l_two
    inc dx
    cmp dx, d_two
    jne draw_two
    ret

draw_three:
    inc cx
    int 10h
    cmp cx, r_three
    jne draw_three

    mov cx, l_three
    inc dx
    cmp dx, d_three
    jne draw_three
    ret

move:
    mov counter, 10
    call checkDir
    call animate

    mov ax, x_dir
    add l_one, ax
    add r_one, ax
    add l_two, ax
    add r_two, ax
    add l_three, ax
    add r_three, ax

    mov ax, y_dir
    add u_one, ax
    add d_one, ax
    add u_two, ax
    add d_two, ax
    add u_three, ax
    add d_three, ax

    cmp d_one, 200
    jl move
    ret

checkDir:
    cmp r_three, 320
    jge negateX
    cmp l_one, 0
    jle negateX
    cmp u_one, 0
    jle negateY
    cmp d_three, 200
    jge negateY
    ret

negateX:
    neg x_dir
    ret

negateY:
    neg y_dir
    ret

    mov ah, 00h
    int 16h
    mov ah, 00h
    mov al, 03h
    int 10h
    mov ah,00h
    mov ah,4ch
    int 21h
end start

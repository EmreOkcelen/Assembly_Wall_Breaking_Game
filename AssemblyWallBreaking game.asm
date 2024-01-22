
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

Include 'emu8086.inc'
.model large
.data 

msg Dw ' Wall Breaking Game                                              [Esc] $'                                      
exit db 0           ;For quitting the game

Rocpos Dw 3910d     ;Rocket's position
Bulpos Dw 0d        ;Bullet's position
uppos  Dw 0d        ;Bullet's Upper positions

recind Db 10        ;Index for deleting the rectangle
recpost1 Dw 0d      ;rectangle positions

row1 Dw 484d,504d,524d,544d,564d,584d,604d,624d          ;
row2 Dw 1284d,1304d,1324d,1344d,1364d,1384d,1404d,1424d  ;Position of all Rectangles
row3 Dw 2084d,2104d,2124d,2144d,2164d,2184d,2204d,2224d  ;

say Db 1            ;
sec db 0            ;counter      
kontrol dw 0        ;
sayac db 6          ;

az dw 0             ;
azz dw 0            ;
temp1 db 0          ;
temp2 db 0          ;
temp3 db 0          ;temps
temp4 db 0          ;
temp5 db 0          ;
temp6 db 0          ;
temp7 db 0
          
x db 2              ;
y db 2              ;
uzunluk db 8        ;Variables  for  creating the rectangle
boy db 3            ;
corft db 0Fh        ;



 


game_start_str dw '  ',0ah,0dh

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '            ====================================================',0ah,0dh
dw '           ||                                                * ||',0ah,0dh                                        
dw '           ||           /\                       /\            ||',0ah,0dh
dw '           ||           --  -Wall Breaking Game- --            ||',0ah,0dh
dw '           ||*          \/                       \/            ||',0ah,0dh
dw '           ||--------------------------------------------------||',0ah,0dh
dw '           ||                                                  ||',0ah,0dh
dw '           || *                                                ||',0ah,0dh
dw '           ||                                                  ||',0ah,0dh          
dw '           ||     Use -> and <- to arrange the position of     ||',0ah,0dh
dw '           ||          the rocket and break the bricks         ||',0ah,0dh
dw '           ||    *     with the Right click of mouse           ||',0ah,0dh
dw '           ||                                                  ||',0ah,0dh 
dw '           ||               Press Enter to start!              ||',0ah,0dh
dw '           ||                                                * ||',0ah,0dh
dw '            ====================================================',0ah,0dh
dw '                                                                 ',0ah,0dh
dw '$',0ah,0dh
dw '$',0ah,0dh
dw '$',0ah,0dh









.code
main proc

mov ax,@data
mov ds,ax

mov ax, 0B800h
mov es,ax 



jmp game_menu                              ;display the main menu



jmp start


game_menu:
    
    mov     ah, 1
    mov     ch, 2bh
    mov     cl, 0bh
    int     10h 
                                           ;game menu screen
    mov ah,09h
    mov dh,0
    mov dx, offset game_start_str          ;Display the main menu string
    int 21h
                                           ;wait for input
    input2:
        mov ah,1
        int 21h                            ;preparig the screen for game 
        cmp al,13d
        jne input2
        mov ax, 3
        int 10h

        
        jmp start                          ;jumping the game screen






Start:
mov ah, 09h
lea DX,msg                                 ;Display game screen title and exit button
int 21h

int 10h 
mov corft, 54h 
call draw_rectangle                        ;Creating the rectangles

                                           

Mov sayac,6
loop1:


add y, 10
mov corft, 54h                             ;1st row
call draw_rectangle
dec sayac
cmp sayac,0
jnz loop1

add x,5
Mov y,2
Mov boy,8
Mov uzunluk,8
call draw_rectangle

Mov sayac,6
loop2:


add y, 10
mov corft, 54h 
call draw_rectangle
dec sayac
cmp sayac,0                                ;2nd row
jnz loop2



add x,5
Mov y,2
Mov boy,13  
Mov uzunluk,8
call draw_rectangle

Mov sayac,6
loop3:

                                           ;3rd row
add y, 10
mov corft, 54h 
call draw_rectangle
dec sayac
cmp sayac,0
jnz loop3





jmp Movement

ret

draw_rectangle:
push ax ; save registers
push bx
push cx
push dx

mov bh, corft ; set color
mov ch, x
mov cl, y
mov dh, x
mov dh, boy
mov dl, y
add dl, uzunluk
mov ah,07h
int 10h

pop dx
pop cx
pop bx
pop ax
ret

Click DW ? ;Mouse Click

Movement:

 mov cl, 33d            
 mov ch, 1001b            ;creating the rocket at 3910d location
 mov bx,Rocpos 
 mov es:[bx], cx
 
 
 
                ;removing the crosur:
 mov     ah, 1
 mov     ch, 2bh
 mov     cl, 0bh
 int     10h           

 cmp [Click],2
 je mouse          ;if rihgt button pressed on mouse  je mouse fonction
 mov ax,3
 int 33h
 
 mov  [Click], bx
 int 16h           ;
 cmp ah,4Bh        ;moving right and left
 je left           ;
 cmp ah,4Dh        ;
 je right          ;

 ret
                                                        

mouse:
    
    
  mov dx,Rocpos                       
  Sub Dx,160d                 
  Mov Bulpos,Dx  
                                                
  Mov sayac,0
  
  
  Bulfire:
  
  mov cl, ' '       ;Delete(Cl[design] = " ")            
  mov ch, 1111b                                     
  mov bx,Bulpos 
  mov es:[bx], cx
                
  sub Bulpos,160d              
  mov cl, 250d        ;create with new pos. and Choosing the design(by ASCII codes,Cl) with colour(Ch)
  mov ch, 1110b      
  mov bx,Bulpos 
  mov es:[bx], cx
  inc sayac
  jz Break            ;bullfire function for moving!
  cmp sayac,10
  jne Bulfire
  jmp Recsec             
               
  mov [Click],0
  jmp Movement

Break:
 mov cl, ' '       ;Delete(Cl[design] = " ")            
 mov ch, 1111b                                     
 mov bx,Bulpos 
 mov es:[bx], cx   
 mov [Click],0   
 jmp reset


right:
   cmp Rocpos,3998d
   je Movement
   mov cl, ' '
   mov ch, 1001b
        
   mov bx,Rocpos 
   mov es:[bx], cx
    
   Add Rocpos, 2d             
       

   jmp Movement    

left:
   cmp Rocpos,3840d
   je Movement
   mov cl, ' '
   mov ch, 1001b
        
   mov bx,Rocpos 
   mov es:[bx], cx
    
   sub Rocpos, 2d 
          
   jmp Movement


exit_game:                                  
mov exit,10d






Recsec:
Mov BP,row3[SI]
Mov az,BP                        ;chosing which rectangle to delete
Mov AX,Bulpos                    

mov recpost1,BP
inc sec
cmp AX ,az
JGE kont2
cmp sec,8
jnz Recsec
cmp sec,8
jmp break

kont2:
Add SI,2
Mov bp,0
Mov Bp,row3[SI]

cmp Bulpos,bp
JGE kont2
                                 ;Controlling for the blank spaces
Mov BP,row3[SI-2]
Mov kontrol,0
Mov kontrol,Bp
Add kontrol,16d
cmp AX,kontrol
JG break
mov recpost1,Bp


jmp chsrow 


chsrow:
cmp Row3[0],BP
je t1
cmp Row3[2],BP
je t2                            ;find the X position of the rectangle 
cmp Row3[4],BP
je t3
cmp Row3[6],BP
je t4
cmp Row3[8],BP
je t5
cmp Row3[10],BP
je t6
cmp Row3[12],BP
je t7

Chng1:
 Mov sayac,0
 
 Bulf2:
 mov cl, ' '                   
 mov ch, 1111b                                     
 mov bx,Bulpos 
 mov es:[bx], cx
                
 sub Bulpos,160d              
 mov cl, 250d        
 mov ch, 1110b      
 mov bx,Bulpos 
 mov es:[bx], cx
 inc sayac
 jz Break
 cmp sayac,5
 jne Bulf2

 Mov Bulpos,0
 Mov BP,row2[SI-2]
 mov recpost1,Bp
 jmp Del

Chng2:
 Mov sayac,0
 
 Bulf3:
 mov cl, ' '                  
 mov ch, 1111b                                     
 mov bx,Bulpos 
 mov es:[bx], cx
                
 sub Bulpos,160d              
 mov cl, 250d        
 mov ch, 1110b      
 mov bx,Bulpos 
 mov es:[bx], cx
 inc sayac
 jz Break
 cmp sayac,10
 jne Bulf3

 Mov Bulpos,0
 Mov BP,row1[SI-2]
 mov recpost1,Bp
 jmp Del


t1:
Inc temp1
cmp temp1,1
Je Del                             ;Finding the Y position of the rectangle
cmp temp1,2                        
je chng1
cmp temp1,3
je chng2 


t2:
Inc temp2
cmp temp2,1
Je Del
cmp temp2,2
je chng1
cmp temp2,3
je chng2

t3:
Inc temp3
cmp temp3,1
Je Del
cmp temp3,2
je chng1
cmp temp3,3
je chng2

t4:
Inc temp4
cmp temp4,1
Je Del
cmp temp4,2
je chng1
cmp temp4,3
je chng2
t5:
Inc temp5
cmp temp5,1
Je Del
cmp temp5,2
je chng1
cmp temp5,3
je chng2
  
t6:
Inc temp6
cmp temp6,1
Je Del
cmp temp6,2
je chng1
cmp temp6,3
je chng2
  
t7:
Inc temp7
cmp temp7,1
Je Del
cmp temp7,2
je chng1
cmp temp7,3
je chng2




Mov recind,10
Del:
Mov Bulpos,0
mov cl, 31d                        ;Deleting the first row of the rectangle by replacig the index with " "
mov ch, 1001b
mov bx,recpost1 
mov es:[bx], cx
    
add recpost1,2d
dec recind
cmp recind,0
jnz Del
cmp say,0
jnz Delup
jmp break


Delup:
dec say                           ;upper row of the rectangle
Mov recind,10
Mov recpost1,BP
sub recpost1,160d
jmp Del



reset:
Mov SI,0
Mov Bulpos,0d                    ;resetig the variables for the next action
Mov uppos,0d
Mov recind, 10
Mov recpost1, 0d 
Mov say , 1
Mov sec , 0
Mov kontrol, 0
Mov az, 0
Mov azz, 0
jmp Movement

    
 

end main









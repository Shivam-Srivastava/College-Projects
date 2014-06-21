;Authors:   Shivam Srivastava (CS10B051)
			Vikas Neelam (CS10B016)
			Sudheer Sana (CS10B050)




.model small
.stack 100h

NL equ 10d	                             ;formfeed character	

.data
	prompt db  0dh,'?', '$'
	blank_line db 20 dup (' '),'$'
	arr db 20 dup('$'),'$'
	car_row db 0							;Rows 0-199
	car_col dw 2 dup(0)					;Columns 0-319
	car_row2 db 0							;Rows 0-199
	car_col2 dw 2 dup(0)					;Columns 0-319
	car_row3 db 0							;Rows 0-199
	car_col3 dw 2 dup(0)					;Columns 0-319
	temp db 0
	count db 0
	car_step db 3
	game_counter dw 0
	car_step2 db 4
	car_step3 db 3
	step db 8
	flag db 0
	a db 0
	b db 0
	c db 0
	mode db 0
	RES1 db 0,'$'
	str_score db 10,0,10 dup(0),'$'
	str_score1 db 10,0,10 dup(0),'$'
	bike_row dw 170
	bike_col dw 140
	track_col dw 30
	pixel_row db 0
	RESULT1 DB 0,'$'
	pixel_col dw 2 dup(0)

	display db 'score','$'

	line1 db NL,NL,'                           Welcome to..................!! $'
	line2 db ';;;;;;;;; ;;     ;;  ;;;;;;      ;;;;;;;        ;;;     ;;;;;;   ;;;;;;$'
	line3 db '   ;;;    ;;     ;;  ;;          ;;     ;      ;; ;;    ;;       ;;     $'
	line4 db '   ;;;    ;;;;;;;;;  ;;;;        ;;;;;;;;     ;;;;;;;   ;;       ;;;;  $'
	line5 db '   ;;;    ;;     ;;  ;;          ;;     ;;   ;;     ;;  ;;       ;;     $'
	line6 db '   ;;;    ;;     ;;  ;;;;;;      ;;      ;  ;;       ;; ;;;;;;   ;;;;;;$'
	line7 db '                                                           $'
	line8 db '-------->>           Bike against cars         >>----------$'
	line9 db 'Press -->> N <<-- For NEW GAME $'
	line10 db 'Press -->> H <<-- For HELP $'
	line11 db 'Press -->> Q <<-- For Quit$'
	line12 db 'You can select the game modes after entering to the new game $'
	line13 db '______________________________________________________________$'
	oline1 db 'Game Over$'
	oline2 db 'Your Score is $'
	oline3 db 'Press ->m<- to go back to the main menu $'
	hline1 db   'The game is designed based on a famous game called "MotoRacer" on Android.','$'
	hline2 db   'In this game the user is on a bike which can be navigated by the Keys:','$'
	hline3 db   '-> .::a::. for left','$'
	hline4 db   '-> .::d::. for right','$'
	hline5 db   '-> .::w::. for increasing the speed','$'
	
	hline6 db   'There are three levels in the game:','$'
	hline7 db   '-> Easy','$'
	hline8 db   '-> Medium','$'
	hline9 db   '-> Hard','$'
	hline10 db  'Easy mode: The cars come at a slow speed and can be used for getting used to the game.','$'
	hline11 db  'The Medium Mode: The speed of the game keeps on increasing with time.','$'
	hline12 db  'Hard Mode: Not only does the speed increase, the cars even move on the track.','$'
	hline13 db  'The Score is displayed in the top right corner. The score corresponds to the number of cars that you have dodged till then.','$'
	hline14 db  'Enjoy the game!','$'
	hline15 db  'Press b or B to go to the START page','$'
	hline16 db   '-> .::s::. for breaks','$'
	
    mline1 db '--> Press 1 for EASY','$'
    mline2 db '--> Press 2 for MEDIUM','$'
    mline3 db '--> Press 3 for HARD','$'

	score dw 259
	temp2 dw 1
	temp3 db ?
	input db 10,?,10 dup('$')

.code
clear_sc PROC
push ax
push bx
push cx
push dx
	mov al, 03h
	mov ah, 0
	int 10h
	mov ax,0600h					;   06h for clearing the screen, 00h for full screen
	mov bh,07h						;	0h for black background, 7h for white foreground
	mov cx,0000h					; 	top left coordinates
	mov dx,184fh					;	bottom right coordinates
	int 10h							;	"	"	"	"
pop dx
pop cx
pop bx
pop ax
	ret
clear_sc endp
;===================================

;;TheBike is here!













hor_line proc
	mov al,al
	mov cx,si
	mov dx,di
	mov ah,0ch
hor:
	int 10h
	inc cx
	cmp cx,bp
jbe hor
ret
hor_line endp

ver_line  proc
	mov al,al
	mov cx,si
	mov dx,di
	mov ah,0ch
b1:
	int 10h
	inc dx
	cmp dx,bp
	jbe b1
ret
ver_line endp








thebike proc
push ax
push bx
push cx
push dx
	    
		mov di,bike_row
	    mov bp,di
	    add bp,6
	    mov si,bike_col
	    sub si,4
	    mov bx,bike_col
	    add bx,4
	    mov al,1001b

;Handle of the Bike
	    loop2:
	    	call ver_line
	    	inc si
	    	cmp si,bx
	    	jbe loop2
	    
	    
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    mov bx,cx
	    add bx,3
	    sub si,3
	    add di,6
	    mov bp,di
	  	add bp,19
	    loop1:
	    	mov al,1110b
	    	call  ver_line
	    	inc si
	    	cmp si,bx
	    	jbe loop1
	    
	    
;The front part of the bike 
	   
	    
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    add di,2
	    sub si,4
	    mov bp,si
	    sub si,6
	    mov al,1100b
	    call hor_line
	    add di,1
	    mov cx,bike_col
	    mov si,cx
	    sub si,4
	    mov bp,si
	    sub si,6
	    mov al,1100b
	    call hor_line
	    
	    
	    
	    
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    add di,2
	    add si,4
	    mov bp,si
	    add bp,6
	    mov al,1100b
	    call hor_line
	    add di,1
	    mov cx,bike_col
	    mov si,cx
	    add si,4
	    mov bp,si
	    add bp,6
	    mov al,1100b
	    call hor_line
	    
	    
;Back part of the bike
	    
	    
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    mov bx,cx
	    add bx,2
	    add di,25
	    sub si,2
	    mov bp,di
	    add bp,3
	    loop4:
	    	mov al,0111b
	    	call ver_line
	    	inc si
	    	cmp si,bx
	    	jbe loop4
	    

	   
	   
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    mov bx,cx
	    add bx,2
	    sub si,2
	    mov bp,di
	    sub di,2
	    a2:
	    	mov al,0111b
	    	call ver_line
	    	inc si
	    	cmp si,bx
	    	jbe a2




pop dx
pop cx
pop bx
pop ax

ret
thebike endp
;;;;;;;;;;;;;;;;;;;;;;;;;


clearthebike proc
push ax
push bx
push cx
push dx
	    
		mov di,bike_row
	    mov bp,di
	    add bp,6
	    mov si,bike_col
	    sub si,4
	    mov bx,bike_col
	    add bx,4
	    mov al,1000b


	    loop20:
		    call ver_line
		    inc si
	    	cmp si,bx
	   	 	jbe loop20
	    	
	    
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    mov bx,cx
	    add bx,3
	    sub si,3
	    add di,6
	    mov bp,di
	  	add bp,19
	    loop10:
	    	mov al,1000b
	    	call  ver_line
	    	inc si
	    	cmp si,bx
	    	jbe loop10
	    
	    
	    
	   
	    
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    add di,2
	    sub si,4
	    mov bp,si
	    sub si,6
	    mov al,1000b
	    call hor_line
	    add di,1
	    mov cx,bike_col
	    mov si,cx
	    sub si,4
	    mov bp,si
	    sub si,6
	    mov al,1000b
	    call hor_line
	    
	    
	    
	    
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    add di,2
	    add si,4
	    mov bp,si
	    add bp,6
	    mov al,1000b
	    call hor_line
	    add di,1
	    mov cx,bike_col
	    mov si,cx
	    add si,4
	    mov bp,si
	    add bp,6
	    mov al,1000b
	    call hor_line
	    
	    
	    
	    
	    
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    mov bx,cx
	    add bx,2
	    add di,25
	    sub si,2
	    mov bp,di
	    add bp,3
   	    mov al,1000b
	    loop8:
		    call ver_line
		    inc si
		    cmp si,bx
		    jbe loop8
	    

	   
	   
	    mov cx,bike_col
	    mov dx,bike_row
	    mov si,cx
	    mov di,dx
	    mov bx,cx
	    add bx,2
	    sub si,2
	    mov bp,di
	    sub di,2
   	    mov al,1000b
	    a4:

		    call ver_line
		    inc si
		    cmp si,bx
		    jbe a4




pop dx
pop cx
pop bx
pop ax

ret
clearthebike endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;TheBike ends
;the part below has been taken from track.asm file
;========================
track proc
push ax
push cx
push dx
push bx
	mov dh,0
	mov al,1111b
	mov bl,10
	mov bh,3																; how many times should the single line of length "bl" be made
	mov cx,track_col
	mov dl,temp	
	mov ah,0ch																;temp stores the initial value of dx... temp ranges from 1 to 20
outer_loop:
	mov bl,70
		inner_loop:
			int 10h
			inc cl
			int 10h
			inc cl 
			int 10h
			dec cl
			dec cl
			inc dl
			dec bl
			jnz inner_loop
			add dl,13
			dec bh
			jnz outer_loop
pop bx
pop dx
pop cx
pop ax
ret
track endp
;================
track_clean proc
push ax
push cx
push dx
push bx
	mov dh,0
	mov al,1000b
	mov bl,10
	mov bh,3
	mov cx,track_col
	mov dl,temp	
	mov ah,0ch																;temp stores the initial value of dx... temp ranges from 1 to 20
outer_loop1:
	mov bl,70
		inner_loop1:
			int 10h
			inc cl
			int 10h
			inc cl 
			int 10h
			dec cl
			dec cl
			inc dl
			dec bl
			jnz inner_loop1
		add dl,13
		dec bh
		jnz outer_loop1
pop bx
pop dx
pop cx
pop ax
ret
track_clean endp
;================
;===============road begins
road proc
push ax
push bx
push cx
push dx
mov al,1000b
mov ah,0ch
mov cx,90
mov dx,0
mov bl,140
next_line1:
	mov bl,140
	mov cx,80
	the_line:
		int 10h
		inc cx
		dec bl
		jnz the_line
	inc dx
	cmp dx,200
	jne next_line1
pop dx
pop cx
pop bx
pop ax
ret
road endp
;===============road ends
;the above part has been taken from the track.asm file



;=========================



;===================================car1_cleaning procedure starts here=================

car_clear proc
push ax
push bx
push cx
push dx
mov al,1000b
; =================front paddle of the car begins=====
	mov dl,car_row	;the row of the front car plate									
	mov dh,00h	;dh and dl together make the row
	mov bl,21 	;length of the bat
	mov cx,car_col   ;cx is the column of the car
	add cl,a
next_pixl:
	
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	dec dl
	add dl,30
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	sub dl,31
	
	
	inc cx
	dec bl
	jnz next_pixl
;=================front paddle of the car ends========


;=================the side wheels of the car begins=========
mov al,1000b
mov cx,car_col	
add cl,a																	; have to be changed = car_col
mov dl,car_row
add dl,3																		; have to be changed = car_row + 3
;=================wheels of the car begins =====
	mov bl,5 ;;row-wise span of the wheels
	mov bh,3;;column wise width of the wheels
	next_pi:
		one_line_1_tyre:	
			mov ah,0ch
			int 10h
			add dl,21
			
			int 10h
			add cx,18
			
			int 10h
			sub dl,21
			
			int 10h
			sub cx,18
			
			int 10h
			inc cx
			dec bh
			jnz one_line_1_tyre
		mov bh,3
		sub cl,bh
		inc dl
		dec bl
		jnz next_pi
	
;================= wheels of the car ends=========



;================= mainframe of the car begins====
mov cx,car_col	
add cl,a																	;have to be changed = car_col + 9
add cx,9
mov dl,car_row																		;have to be changed = car_row + 1
add dl,1
mov bl,29
	main_fram:
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		sub cx,2
		
		inc dx
		dec bl
		jnz main_fram
	
mov cx,car_col	
add cl,a																;have to be changed = car_col + 5
add cx,5
mov dl,car_row																		;have to be changed = car_row + 15
add dl,15
mov bl,11		;;column steps
mov bh,15		;;row steps
	bloc:
		inside:
			int 10h
			inc cx
			dec bl
			jnz inside
		mov bl,11
		sub cl,bl
		inc dx
		dec bh
		jnz bloc
			
;=================mainframe of the car ends=======

pop dx
pop cx
pop bx
pop ax
ret
car_clear endp


;===================================car1_cleaning procedure ends here  =================




;=============================================car1 procedure begins here=================
car proc
push ax
push bx
push cx
push dx

mov al,1110b
; =================front paddle of the car begins=====
	mov dl,car_row	;the row of the front car plate									;have to be changed = car_row
	mov dh,00h	;dh and dl together make the row
	mov bl,21 	;length of the bat
	mov cx,car_col   ;cx is the column of the car									;have to be changed = car_column
	add cl,a
next_pixel:
	
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	dec dl
	add dl,30
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	sub dl,31
	
	
	inc cx
	dec bl
	jnz next_pixel
;=================front paddle of the car ends========


;=================the side wheels of the car begins=========
mov al,1011b
mov cx,car_col
add cl,a																		; have to be changed = car_col
mov dl,car_row
add dl,3																		; have to be changed = car_row + 3
;=================wheels of the car begins =====
	mov bl,5 ;;row-wise span of the wheels
	mov bh,3;;column wise width of the wheels
	next_p:
		one_line_one_tyre:	
			mov ah,0ch
			int 10h
			add dl,21
			int 10h
			add cx,18
			
			int 10h
			sub dl,21
			
			int 10h
			sub cx,18
			
			int 10h
			inc cx
			dec bh
		jnz one_line_one_tyre
		mov bh,3
		sub cl,bh
		inc dl
		dec bl
	jnz next_p
	
;================= wheels of the car ends=========



;================= mainframe of the car begins====
mov cx,car_col																		;have to be changed = car_col + 9
add cx,9
add cl,a
mov dl,car_row																		;have to be changed = car_row + 1
add dl,1
mov bl,29
mov al,1011b
	main_frame:
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		sub cx,2
		
		inc dx
		dec bl
		jnz main_frame
mov al,1100b
mov cx,car_col																	;have to be changed = car_col + 5
add cx,5
add cl,a
mov dl,car_row																		;have to be changed = car_row + 15
add dl,15
mov bl,11		;;column steps
mov bh,15		;;row steps
	block:
		inn:
			int 10h
			inc cx
			dec bl
			jnz inn
		mov bl,11
		sub cl,bl
		inc dx
		dec bh
		jnz block
			
;=================mainframe of the car ends=======

pop dx
pop cx
pop bx
pop ax
ret
car endp
;===================================car1 procedure ends here==================


;car 2 procedure begins here

car2 proc
push ax
push bx
push cx
push dx
dont_change3:
mov al,1110b
; =================front paddle of the car begins=====
	mov dl,car_row2	;the row of the front car plate									
	mov dh,00h	;dh and dl together make the row
	mov bl,21 	;length of the bat
	mov cx,car_col2   ;cx is the column of the car
	add cl,b
	
	next_pixel1:
	
		mov ah,0ch
		int 10h
		inc dl
		mov ah,0ch
		int 10h
		dec dl
		add dl,30
		mov ah,0ch
		int 10h
		inc dl
		mov ah,0ch
		int 10h
		sub dl,31
	
	
	inc cx
	dec bl
	jnz next_pixel1
;=================front paddle of the car ends========


;=================the side wheels of the car begins=========
mov al,1011b
mov cx,car_col2
add cl,b																; have to be changed = car_col
mov dl,car_row2
add dl,3																		; have to be changed = car_row + 3
;=================wheels of the car begins =====
	mov bl,5 ;;row-wise span of the wheels
	mov bh,3;;column wise width of the wheels
	next_p1:
		one_line_one_tyre1:	
			mov ah,0ch
			int 10h
			add dl,21
			
			int 10h
			add cx,18
			
			int 10h
			sub dl,21
			
			int 10h
			sub cx,18
			
			int 10h
			inc cx
			dec bh
		jnz one_line_one_tyre1
		mov bh,3
		sub cl,bh
		inc dl
		dec bl
	jnz next_p1
	
;================= wheels of the car ends=========



;================= mainframe of the car begins====
mov cx,car_col2					;change here													;have to be changed = car_col + 9
add cx,9
add cl,b
mov dl,car_row2			;change here																		;have to be changed = car_row + 1
add dl,1
mov bl,29
mov al,1011b
	main_frame1:
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		sub cx,2
		
		inc dx
		dec bl
		jnz main_frame1
mov al,1100b
mov cx,car_col2  	;change here																	;have to be changed = car_col + 5
add cx,5
add cl,b
mov dl,car_row2		;change here														;have to be changed = car_row + 15
add dl,15
mov bl,11		;;column steps
mov bh,15		;;row steps
	block1:
		inn1:
			int 10h
			inc cx
			dec bl
			jnz inn1
		mov bl,11
		sub cl,bl
		inc dx
		dec bh
		jnz block1
			
;=================mainframe of the car ends=======

pop dx
pop cx
pop bx
pop ax
ret
car2 endp





;car 2 procedure ends here
;car2 clear begins here!!!




car_clear2 proc
push ax
push bx
push cx
push dx
mov al,1000b
; =================front paddle of the car begins=====
	mov dl,car_row2	;the row of the front car plate									;have to be changed = car_row
	mov dh,00h	;dh and dl together make the row
	mov bl,21 	;length of the bat
	mov cx,car_col2   ;cx is the column of the car									;have to be changed = car_column
	add cl,b
next_pixel2:
	
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	dec dl
	add dl,30
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	sub dl,31
	
	
	inc cx
	dec bl
	jnz next_pixel2
;=================front paddle of the car ends========


;=================the side wheels of the car begins=========
mov al,1000b
mov cx,car_col2		
add cl,b														
mov dl,car_row2
add dl,3		
;=================wheels of the car begins =====
	mov bl,5 ;;row-wise span of the wheels
	mov bh,3;;column wise width of the wheels
	next_p2:
		one_line_one_tyre2:	
			mov ah,0ch
			int 10h
			add dl,21
			
			int 10h
			add cx,18
			
			int 10h
			sub dl,21
			
			int 10h
			sub cx,18
			
			int 10h
			inc cx
			dec bh
		jnz one_line_one_tyre2
		mov bh,3
		sub cl,bh
		inc dl
		dec bl
	jnz next_p2
	
;================= wheels of the car ends=========



;================= mainframe of the car begins====
mov cx,car_col2					;change here													;have to be changed = car_col + 9
add cx,9
add cl,b
mov dl,car_row2			;change here																		;have to be changed = car_row + 1
add dl,1
mov bl,29
mov al,1000b
	main_frame2:
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		sub cx,2
		
		inc dx
		dec bl
		jnz main_frame2
mov al,1000b
mov cx,car_col2  	;change here																	;have to be changed = car_col + 5
add cx,5
add cl,b
mov dl,car_row2		;change here														;have to be changed = car_row + 15
add dl,15
mov bl,11		;;column steps
mov bh,15		;;row steps
	block2:
		inn2:
			int 10h
			inc cx
			dec bl
			jnz inn2
		mov bl,11
		sub cl,bl
		inc dx
		dec bh
		jnz block2
			
;=================mainframe of the car ends=======

pop dx
pop cx
pop bx
pop ax
ret
car_clear2 endp







;car2 clear ends here!!!



;;;;;car3 begins here










car3 proc
push ax
push bx
push cx
push dx
mov al,1110b
; =================front paddle of the car begins=====
	mov dl,car_row3	;the row of the front car plate									;have to be changed = car_row
	mov dh,00h	;dh and dl together make the row
	mov bl,21 	;length of the bat
	mov cx,car_col3   ;cx is the column of the car									;have to be changed = car_column
	add cl,c
next_pixel3:
	
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	dec dl
	add dl,30
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	sub dl,31
	
	
	inc cx
	dec bl
	jnz next_pixel3
;=================front paddle of the car ends========


;=================the side wheels of the car begins=========
mov al,1011b
mov cx,car_col3			
add cl,c															; have to be changed = car_col
mov dl,car_row3
add dl,3																		; have to be changed = car_row + 3
;=================wheels of the car begins =====
	mov bl,5 ;;row-wise span of the wheels
	mov bh,3;;column wise width of the wheels
	next_p3:
		one_line_one_tyre3:	
			mov ah,0ch
			int 10h
			add dl,21
		
			int 10h
			add cx,18
		
			int 10h
			sub dl,21
		
			int 10h
			sub cx,18
		
			int 10h
			inc cx
			dec bh
		jnz one_line_one_tyre3
		mov bh,3
		sub cl,bh
		inc dl
		dec bl
	jnz next_p3
	
;================= wheels of the car ends=========



;================= mainframe of the car begins====
mov cx,car_col3					;change here													;have to be changed = car_col + 9
add cx,9
add cl,c
mov dl,car_row3			;change here																		;have to be changed = car_row + 1
add dl,1
mov bl,29
mov al,1011b
	main_frame3:
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		sub cx,2
		
		inc dx
		dec bl
		jnz main_frame3
mov al,1100b
mov cx,car_col3  	;change here																	;have to be changed = car_col + 5
add cx,5
add cl,c
mov dl,car_row3		;change here														;have to be changed = car_row + 15
add dl,15
mov bl,11		;;column steps
mov bh,15		;;row steps
	block3:
		inn3:
			int 10h
			inc cx
			dec bl
			jnz inn3
		mov bl,11
		sub cl,bl
		inc dx
		dec bh
		jnz block3
			
;=================mainframe of the car ends=======

pop dx
pop cx
pop bx
pop ax
ret
car3 endp



;car 2 procedure ends here
;car2 clear begins here!!!




car_clear3 proc
push ax
push bx
push cx
push dx	
mov al,1000b

; =================front paddle of the car begins=====
	mov dl,car_row3	;the row of the front car plate									;have to be changed = car_row
	mov dh,00h	;dh and dl together make the row
	mov bl,21 	;length of the bat
	mov cx,car_col3   ;cx is the column of the car									;have to be changed = car_column
	add cl,c
next_pixel4:
	
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	dec dl
	add dl,30
	mov ah,0ch
	int 10h
	inc dl
	mov ah,0ch
	int 10h
	sub dl,31
	
	
	inc cx
	dec bl
	jnz next_pixel4
;=================front paddle of the car ends========


;=================the side wheels of the car begins=========
mov al,1000b
mov cx,car_col3	
add cl,c															; have to be changed = car_col
mov dl,car_row3
add dl,3																		; have to be changed = car_row + 3
;=================wheels of the car begins =====
	mov bl,5 ;;row-wise span of the wheels
	mov bh,3;;column wise width of the wheels
	next_p4:
		one_line_one_tyre4:	
			mov ah,0ch
			int 10h
			add dl,21
		
			int 10h
			add cx,18
		
			int 10h
			sub dl,21
		
			int 10h
			sub cx,18
		
			int 10h
			inc cx
			dec bh
		jnz one_line_one_tyre4
		mov bh,3
		sub cl,bh
		inc dl
		dec bl
	jnz next_p4
	
;================= wheels of the car ends=========



;================= mainframe of the car begins====
mov cx,car_col3					;change here													;have to be changed = car_col + 9
add cx,9
add cl,c
mov dl,car_row3			;change here																		;have to be changed = car_row + 1
add dl,1
mov bl,29
mov al,1000b
	main_frame4:
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		sub cx,2
		
		inc dx
		dec bl
		jnz main_frame4
mov al,1000b
mov cx,car_col3  	;change here																	;have to be changed = car_col + 5
add cx,5
add cl,c
mov dl,car_row3		;change here														;have to be changed = car_row + 15
add dl,15
mov bl,11		;;column steps
mov bh,15		;;row steps
	block4:
		inn4:
			int 10h
			inc cx
			dec bl
			jnz inn4
		mov bl,11
		sub cl,bl
		inc dx
		dec bh
		jnz block4
			
;=================mainframe of the car ends=======

pop dx
pop cx
pop bx
pop ax
ret
car_clear3 endp


;car3 ends here!!!


bat proc
	push ax
	push bx
	push cx
	push dx
	;Head pixel
	mov al,1111b
	mov dx,bike_row
	mov dh,00h
	mov bl,20 ;;length of the bat
	mov cx,bike_col
next_pix:
	
	mov ah,0ch
	int 10h
	inc cx
	dec bl
	jnz next_pix
	pop dx
	pop cx
	pop bx
	pop ax
ret
bat endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;


clear_bat proc
	push ax
	push bx
	push cx
	push dx
	;Head pixel
	mov al,1000b
	mov dx,bike_row
	mov dh,00h
	mov bl,20 ;;length of the bat
	mov cx,bike_col
next_:
	
	mov ah,0ch
	int 10h
	inc cx
	dec bl
	jnz next_
	pop dx
	pop cx
	pop bx
	pop ax
ret
clear_bat endp






;;;Making a Bat procedure here

;;;;;;;;;;moving car1 automatically procedure








;;;;;;;;;;moving car1 automatically procedure ends


make_bike proc
push dx
push ax
loop_here1:
		mov dl,0dh
		call thebike
		mov ah,1
		int 16h
		jz go_back_to_main1
		mov ah,0
		int 16h
		
		
		call clearthebike
		cmp al,119
		jne cmp_s
		add step,3
		
		cmp_s:
			cmp al,115
			jne cmp_d
			cmp step,7
			jl cmp_d
			sub step,2
		cmp_d:
			cmp al,100 ;'d'
			jne cmp_a1
		
			add bike_col,5
			jmp loop_here1
		cmp_a1:
			cmp al,97 ; 'a'
			jne cmp_esc1
		
			sub bike_col,5
			jmp loop_here1
	cmp_esc1:
		cmp al,27
		jne loop_here1

go_back_to_main1:
pop ax
pop dx
ret
make_bike endp










;;;;;;;;;;;;;;ending bat procedure



pauseInTheEnd proc
push ax
push cx
mov ax,64000
mov cx,65000
outer4:
	mov cx,65000
inner4:
	dec cx
	NOP
	jnz inner4
	dec ax
	jnz outer4
add count,1
pop cx
pop ax
ret
pauseInTheEnd endp




;;;;;;;;;;;;;;;;;;;;;



waste_time_track proc
push ax
push cx
mov ax,64000
mov cx,65000
outer1:
	mov cx,2000
inner1:
	dec cx
	NOP
	jnz inner1
	dec ax
	jnz outer1
add count,1
pop cx
pop ax
ret
waste_time_track endp

checkCollisionCar1 proc
push bx
push cx
mov cx, car_col3
add cl,c
mov bl, car_row3 
add bl,33
mov bh,0
add cx,27
cmp bike_row,bx
  ja no_prob1
  ;sub cx,25
  cmp bike_col,cx
    ja no_prob
    sub cx,32
    cmp bike_col,cx
    jb no_prob
    mov flag,1
no_prob:
pop cx
pop bx
ret
checkCollisionCar1 endp
;;;;;;;;checks collision for left car till here
;;;;;;;;now checks for collision with middle car 
checkCollisionCar2 proc
push bx
push cx
mov cx, car_col
mov bl, car_row 
add bl,30
mov bh,0
add cx,27
add cl,a
cmp bike_row,bx
  ja no_prob1
  cmp bike_col,cx
    ja no_prob1
    sub cx,32
    cmp bike_col,cx
    jb no_prob1
    mov flag,1
no_prob1:
pop cx
pop bx
ret
checkCollisionCar2 endp
;;;;;;;;checks for collision with the middle car till here
checkCollisionCar3 proc
push bx
push cx
mov cx, car_col2
add cl,b
mov bh,0
mov bl, car_row2 
add bl,30
add cx,27
cmp bike_row,bx
  ja no_prob2
  ;sub cx,25
  cmp bike_col,cx
    ja no_prob2
    sub cx,32
    cmp bike_col,cx
    jb no_prob2
    mov flag,1
no_prob2:
pop cx
pop bx
ret
checkCollisionCar3 endp


checkWallCollision proc
cmp bike_col,88
ja checkRightSide
  mov flag,1
checkRightSide:
  cmp bike_col,214
  jb notCollided
  mov flag,1

notCollided:
ret
checkWallCollision endp



;runs the track
track_run proc
push bx
		mov bh,step
		add temp,bh
		mov track_col,125
		call track
		mov track_col,170
		call track
pop bx
ret
track_run endp


bothTrackClean proc
		call track_clean
		mov track_col,125
		call track_clean
ret
bothTrackClean endp



;;;the checkCollisions procedure can check for collisions and adds the appropriate value to each car row
checkCollisions proc
push ax
push bx
push cx
push dx
		call checkWallCollision
		call checkCollisionCar1
		call checkCollisionCar2
		call checkCollisionCar3


		cmp a,35
		ja car1WasNotCalled
		mov bh,step
		add car_row,bh
		mov bl,car_step
		sub car_row,bl
	
	
	car1WasNotCalled:
			cmp car_row,0
			je here1
			cmp car_row,200
			jb check_next
			inc game_counter
	here1:
			mov ah,00h
			int 1ah
			and dx,100
			mov a,dl
			mov car_row,0
	
	
	check_next:
			cmp b,35
			ja car2WasNotCalled
	
			mov bh,step
			add car_row2,bh
			mov bl,car_step2
			sub car_row2,bl
			
	car2WasNotCalled:
			cmp car_row2,0
			je here2
			cmp car_row2,200
			jb check_next2
			inc game_counter
	here2:
			mov ah,00h
			int 1ah
			and dx,277	
			mov b,dl
	
			mov car_row2,0
	check_next2:
			cmp c,35
			ja car3WasNotCalled
			;add car_row3,3
			mov bh,step
			add car_row3,bh
			mov bl,car_step3
			sub car_row3,bl
	
	 car3WasNotCalled:
			cmp car_row3,0
			je here3
			cmp car_row3,200
			jb check_next3
			inc game_counter
	here3:
			mov ah,00h
			int 1ah
			and dx,532
			mov c,dl
			mov car_row3,0
		
	check_next3:		

pop dx
pop cx
pop bx
pop ax
ret
checkCollisions endp
generateCars proc
		cmp a,35
		ja goCar2
		call car
goCar2:
		cmp b,35
		ja goCar3			
		call car2
goCar3:
		cmp c,35
		ja nothing2
		call car3
nothing2:
;============wasting time begins
		call waste_time_track
;============wasting time ends	
		cmp a,35
		ja goCar21
		call car_clear
goCar21:
		cmp b,35
		ja goCar22
		call car_clear2
goCar22:
		cmp c,35
		ja nothing1
		call car_clear3
nothing1:
ret
generateCars endp
;;;;;;;;;;;;;;;;;;;;;;;;

randomMovement proc
cmp c,17
ja checkElse
cmp a,15
jle checkElse
inc c
dec a



checkElse:
cmp c,17
jb checkElse2
cmp a,15
jge checkElse2
dec c
inc a




checkElse2:
cmp a,17
jl checkElse3
cmp b,17
ja checkElse3
dec a
inc b


checkElse3:


checkElse4:

noMore:
ret
randomMovement endp

generateStep proc
push ax
push bx
	cmp mode,1
	jne not_easy
	mov step,5
	jmp stepGenerated
not_easy:
	cmp game_counter,25
	ja check100
	mov step,5
	jmp stepGenerated
check100:
	cmp game_counter,50
	ja check500
	mov step,7
	jmp stepGenerated
check500:
	cmp game_counter,75
	ja check700
	mov step,10
	jmp stepGenerated
check700:
	cmp game_counter,100
	ja check800
	mov step,13
	jmp stepGenerated
check800:
	cmp game_counter,125
	ja check900
	mov step,15
	jmp stepGenerated
check900:
	cmp game_counter,150
	mov step,17
stepGenerated:
pop bx
pop ax
ret
generateStep endp
;;;;;;car making procedure ends here...

;;;;;;;;;; login page code starts here;;;;;;;;;;;;;;
;;;;;;;;;; set cursor position ;;;;;;;;;;;;
setCursor macro row,col 
	push ax    
	push bx
	push cx
	push dx
	mov dh, row 	
    mov dl, col 	
    mov bh, 0 		
    mov ah, 2
    int 10h
    pop dx    
	pop cx
	pop bx
	pop ax
endm
;;;;;;;;; set cursor position ends here ;;;;;;;;;;;

;;;;;;;;; set background colour starts here ;;;;;;;;;;;;;;;;;;;;
background macro col,x,y

	push ax
	push bx
	push cx
	push dx
    mov ax,0600h    								; Moving 600h into ax for background 
    mov bh,col    									; In col first four bits for background colour and next four bits are for text colour
    mov cx,x       									; x is the X coordinate
    mov dx,y        								; y is the Y coordinate
    int 10h 
ENDM

;;;;;;;;; set background colour ends herer ;;;;;;;;;;;;;;;;

;;;;;;;;;;; draw pixel starts here ;;;;;;;;;;;;;;;;;;
DrawPixel macro color
	push ax
    push cx
    push dx
    mov al,color
    mov dx,pixel_row
    mov cx,pixel_col
    mov ah,0ch
    int 10h     ; Set the Pixel
    pop dx
    pop cx
    pop ax
    ENDM

;;;;;;;;;;; draw pixel ends here ;;;;;;;;;;;;;;;;;


;;;;;;;;;;;; prints the line ;;;;;;;;;;;;;;


printline macro str
	push ax
	push dx

	lea dx,str
	mov ah,09h
	int 21h
	
	pop dx
	pop ax
endm


;;;;;;;;;; prints line ends here ;;;;;;;;;;



roadBackground proc
push ax
push bx
push cx
push dx
mov al,1010b
mov ah,0ch
mov cx,70
mov dx,0
mov bl,160
next_line10:
	mov bl,160
	mov cx,70
	the_line2:
		int 10h
		inc cx
		dec bl
		jnz the_line2
	inc dx
	cmp dx,200
	jne next_line10
pop dx
pop cx
pop bx
pop ax
ret
roadBackground endp





;;;;;;;;;;; game starts screen starts here ;;;;
gamestartscreen proc
	push ax
	push bx
	push cx
	push dx
	
	mov al, 03h
    mov ah, 0
    int 10h
	
	mov ax, 0600h
	mov bh, 0010b                             	  ;set-colour
	mov cx, 0000h                                 ;topleft
	mov dx, 184fh                                 ;bottom right
	int 10h
   
	setcursor 0,10
	printline line1
	setcursor 8,5
	printline line2
	setcursor 9,5
	printline line3
	setcursor 10,5
	printline line4
	setcursor 11,5
	printline line5
	setcursor 12,5
	printline line6
	setcursor 13,5
	printline line7
	setcursor 14,10
	printline line8
	setcursor 18,25
	printline line9
	setcursor 19,25
	printline line10
	setcursor 20,25
	printline line11

	setcursor 24,1
	
	pop dx
	pop cx
	pop bx
	pop ax
ret
gamestartscreen endp
;;;;;;;;;;;;;;; loginpage ends here ;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;; game overpage starts here ;;;;;;;;;;;
gameoverscreen proc
	push ax
	push bx
	push cx
	push dx

	mov al, 03h
    mov ah, 0
    int 10h	

	mov ax, 0600h
	mov bh, 0010b                             	  ;set-colour
	mov cx, 0000h                                 ;topleft
	mov dx, 184fh                                 ;bottom right
	int 10h
 
	setcursor 5,36
	printline oline1
	setcursor 10,33
	printline oline2
	 mov temp2 ,10                                   ;we will divide with 10 because the remainder we obtain
                mov ax,0                                      ;is simply the last digit of the number
                lea bx,str_score1[9]
                mov cx,game_counter
                mov dx,0


        change_to_decimal1:
                mov dx, 0
                mov ax,cx
                div temp2
                add dx,'0'
                mov byte ptr [bx], dl                          ; dx stores remainder of divison
                dec bx
                mov cx,ax                                      ;ax stores quotient of divison
                cmp cx,10
                jb extra1
                jmp change_to_decimal1
                
                extra1:
                add cx,'0'                                     ;adding the most significant digit  into the 'str'
                mov byte ptr [bx], cl
                lea dx,str_score1[2]
                mov ah,09h
                int 21h
	setcursor 15,22
	printline oline3

	

  
;    MOV Cx,score
;    MOV BX, OFFSET RES1
;    MOV temp3, 10
;    CHANGETOSTRING1:;
;	MOV AH, 0
;	MOV Ax, Cx
;	DIV temp3
;	ADD AH, '0'
;	MOV BYTE PTR [BX], AH                        ; ah stores remainder of divison
;	DEC BX
;	MOV Cx, Ax                                       ; al stores quotient of divison
;	CMP Cx , 0
;	JNZ CHANGETOSTRING1
;	INC BX
	
;	MOV AH, 09H
;	mov DX, BX
;	INT 21H


    
	
	setcursor 24,0
	pop dx
	pop cx
	pop bx
	pop ax

ret
gameoverscreen endp

help_screen proc near
push ax
push bx
push cx
push dx
    mov al, 03h
    mov ah, 0
    int 10h
	
	mov ax, 0600h
	mov bh, 0010b                             	  ;set-colour
	mov cx, 0000h                                 ;topleft
	mov dx, 184fh                                 ;bottom right
	int 10h
   
	setcursor 0,1
	printline hline1
	setcursor 1,1
	printline hline2
	setcursor 4,1
	printline hline3
	setcursor 5,1
	printline hline4
	setcursor 6,1
	printline hline5
	setcursor 7,1
	printline hline16
	setcursor 9,1
	printline hline6
	setcursor 10,10
	printline hline7
	setcursor 12,10
	printline hline8
	setcursor 14,10
	printline hline9
	setcursor 16,1
	printline hline10
	setcursor 18,1
	printline hline11
    setcursor 19,1
    printline hline12
    setcursor 20,1
    printline hline13
    setcursor 22,1
    printline hline14
    setcursor 23,1
    printline hline15
    
	setcursor 24,1
	




pop dx
pop cx
pop bx
pop ax

ret 
help_screen endp
;;;;;;;;;;;;;;; game over screen ends here ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;; game mode screen starts here ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

gamemodescreen proc near
push ax
push bx
push cx
push dx
    mov al, 03h
    mov ah, 0
    int 10h
	
	mov ax, 0600h
	mov bh, 0010b                             	  ;set-colour
	mov cx, 0000h                                 ;topleft
	mov dx, 184fh                                 ;bottom right
	int 10h
   
	setcursor 10,10
	printline mline1
	setcursor 13,10
	printline mline2
	setcursor 16,10
	printline mline3
	setcursor 24,1
	mode_again:
	mov ah,1h
	int 21h
	cmp al,'n'
	je mode_again
	sub al,48
	mov mode,al
pop dx
pop cx
pop bx
pop ax

ret 
gamemodescreen endp



;;;;;;;;;;;;;;; game mode screen ends here ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
















get_cursor    proc near
	push ax
	push bx
	mov bh,00h
    mov ah,03h
    int 10h
	pop bx
	pop ax
    ret
get_cursor endp
DecimalToString PROC 		; start of the procedure
    push ax
    push bx
    push cx
    push dx
	xor cx, cx 				; data to be displayed should be in the ax register
	mov bx, 10d 
	loop11: 
	xor dx, dx 
	div bx 					; 
	push dx 				; save the remainder in the stack 
	inc cx 					; count the number of remainders saved in the stack. 
	cmp ax, 0 				; 
	jnz loop11 				; 
	mov ah, 02 				; 
	loop21: 					; 
	pop dx 					; 
	add dl, 48 				; add to that 48 because 48 is the ASCII code of 0 (zero).
	int 21h 				; call of the interruption 21 to display the character which code ASCII is in dx!
	dec cx 					; 
	jnz loop21 				; the instruction that lets us jump or not to the loop2 label. 
	pop dx 					; 
	pop dx
	pop cx
	pop bx
	pop ax
	ret 					; 
DecimalToString ENDP 		; end of the procedure

;;;;;;;;;;;;;;; score board ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scoreboard proc
	push ax
	push bx
	push cx
	push dx
	

setcursor 00h,20h
mov ah,09h
lea dx,display
int 21h
setcursor 02h,20h



                mov temp2 ,10                                   ;we will divide with 10 because the remainder we obtain
                mov ax,0                                      ;is simply the last digit of the number
                lea bx,str_score[9]
                mov cx,game_counter
                mov dx,0


        change_to_decimal:
                mov dx, 0
                mov ax,cx
                div temp2
                add dx,'0'
                mov byte ptr [bx], dl                          ; dx stores remainder of divison
                dec bx
                mov cx,ax                                      ;ax stores quotient of divison
                cmp cx,10
                jb extra
                jmp change_to_decimal
                
                extra:
                add cx,'0'                                     ;adding the most significant digit  into the 'str'
                mov byte ptr [bx], cl
                lea dx,str_score[2]
                mov ah,09h
                int 21h






	
    
    

	pop dx
	pop cx
	pop bx
	pop ax
ret
scoreboard endp




InputStr macro str1
	push ax
    push dx
    mov ah,0ah
    lea dx,str1
    int 21h
    pop dx
    pop ax
endm
welcome_screen proc
push ax




scr:	

	call gamestartscreen
	
	mov ah,1h
    int 21h
	cmp al,'n'
	je game
	cmp al,'N'
	je game
	cmp al,'h'
	je h
	cmp al,'H'
	je h
	cmp al,'q'
	je r
	cmp al,'Q'
	je r
	jmp scr	
	
	r:
	mov ax,4c00h
	int 21h
	
	
	h:
	call help_screen
	mov ah,1h
	int 21h
	cmp al,'n'
	je game
	cmp al,'N'
	je game
	cmp al,'b'
	je scr
	cmp al,'B'
	je scr
	jmp h
	
	

	
game:
	
	call gamemodescreen
	



pop ax
ret
welcome_screen endp
initialize_variables proc
	mov bike_row, 170
	mov bike_col, 140
	mov car_row, 0							;Rows 0-199
	mov temp, 0
	mov count, 0
	mov car_step, 2
	mov game_counter, 0
	mov car_step2, 4
	mov car_step3, 3
	mov step, 5
	mov flag, 0
	mov score,0
	mov a, 0
	mov b, 0
	mov c, 0
	mov car_row,50
	mov car_col,130
	mov car_row2,50
	mov car_col2,175
	mov car_row3,50
	mov car_col3,85
ret
initialize_variables endp
START:
	mov ax,@data
	mov ds,ax					;;;; data segment 

wel:
    call welcome_screen
    call initialize_variables
    mov al,13h					;;; graphic mode
    mov ah,0
    int 10h
	
	
track1:
	mov temp,0
	mov bl,80
	call roadBackground
	call road
	next_l:
		call track_run
		cmp mode,3
		jne not_hard
		call randomMovement
		not_hard:
		call thebike
		call generateCars			;it calls car proc and car_clean procedure for each car if it is allowed
		call bothTrackClean
		call scoreboard
		call checkCollisions			;it
		call generateStep
		cmp flag,1
		je game_ends
		mov flag,0
		take_input:
			mov ah,1
			int 16h
			jz next_l
;track loop ends here!!!!
		;mov step, 8
		call make_bike
		cmp al,27
		jne take_input

		
game_ends:
call car
call car2
call car3
call pauseInTheEnd
over:
call gameoverscreen 		;in this screen include displaying the final score!
; ending the code from the "start" part of the file track.asm	

mov ah,1h
int 21h
cmp al,'m'
je wel
jmp over

Return_control:
	call clear_sc
	mov ax,4c00h
	int 21h
END START

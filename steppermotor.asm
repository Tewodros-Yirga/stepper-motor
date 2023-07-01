;Question:8 full rotation reversing stepper motor control program ?
#start=stepper_motor.exe#
name "stepper"
             ;^directives,meta data
             
#make_bin#;custom emu8086 directive to generate binary excutable file
          ;from the code if we leave them the code will successfully run  
        
steps_before_direction_change = 64 ; 8 for one rotation

jmp start
; ========= data ===============
; bin data for clock-wise
datcw  db 1, 3, 6, 4   
                      
; bin data for counter-clock-wise
datccw db 4, 6, 3, 1

start:
mov bx, offset datcw ; retrieves the memory offset of the 
                        ;datcw sequence,which was defined earlier. 
mov si, 0 ;setting si to 0 is often used to indicate the beginning 
          ;of a data structure or an array when iterating or
          ;processing data sequentially.  
mov cx, 0 ; step counter

next_step:;motor sets top bit when it's ready to accept new command
group1:
in al, 7; the value from port 7 into the al register.
        ;Port 7 is the port designated for communication with the motor.     
test al, 10000000b;
jz group1 ;If the top bit is not set (i.e., the motor is not ready),
        ;the program enters a loop labeled as group1 to group1 until the motor becomes ready. 
        ;This loop ensures that the program remains in the loop until
        ;the top bit is set, indicating that the motor is ready for the next command.

mov al, [bx][si]
out 7, al;it writes values to virtual i/o port

inc si
cmp si, 4;since we have only 4 data in bx
jb next_step

mov si, 0
inc cx
cmp cx, steps_before_direction_change ;when cx is 8 one full rotation
jb next_step

mov cx, 0
add bx, 4 ; next bin data

cmp bx, offset datccw
jbe next_step

mov bx, offset datcw ; return to clock-wise. this makes the motor to not stop
jmp next_step

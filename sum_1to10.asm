setup:
       mov     R0, #0
       mov     R1, #0
loop:
       add     R0, R0, #1
       add     R1, R1, R0
	subs r5, r0, #10
       blt     loop
 
	mov R1, R1

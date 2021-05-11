mov r0, #0
mov r1, #1
mov r2, #2
str r1, [r0]
str r2, [r0, #4]
ldr r3, [r0]
ldr r4, [r0, #4]

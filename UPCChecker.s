                         AREA assignment5, CODE, READONLY
                         ENTRY
asciiToHexadecimalOffset EQU  0x480                              ;Offset when converting from ascii to hexadecimal which is (30 x 6 x 3) + (30 x 6) = 480 hexadecimal
zero                     EQU  0                                  ;Constant 0 for initialization purposes
one                      EQU  1                                  ;Constant 1 for ++/-- purposes and to be returned if UPC is valid
two                      EQU  2                                  ;Constant 2 to be return if UPC is not valid
six                      EQU  6                                  ;Constant 6 for loop to go through each digit 
ten                      EQU  0xA                                ;Constant 10/A for division
                         LDR  r1, =UPC                           ;Pointer to UPC
                         MOV  r0, #one                           ;Store 1 in r0 to indicate valid UPC
                         MOV  r2, #zero                          ;Initialize sum of odd digits to 0	
                         MOV  r3, #zero                          ;Initialize sum of even digits to 0
                         MOV  r4, #zero                          ;Initialize index for pointing to each digit to 0 
                         MOV  r6, #six                           ;Initialize counter for loop
addition                 LDRB r7, [r1, r4]                       ;Load odd digit
                         ADD  r4, r4, #one                       ;Increase index (on first iteration it goes from 0 to 1)
                         LDRB r8, [r1, r4]                       ;Load even digit
                         ADD  r2, r2, r7                         ;Add odd digit to odd sum 
                         ADD  r3, r3, r8                         ;Add even digit to even sum (including check digit)
                         ADD  r4, r4, #one                       ;Increase index
                         SUBS r6, r6, #one                       ;Decrease loop counter
                         BNE  addition                           ;Loop 6 times
                         ADD  r2, r2, r2, LSL #one               ;Multiply odd sum by 3
                         ADD  r2, r2, r3                         ;Add odd sum * 3 to even sum
                         SUBS  r2, r2, #asciiToHexadecimalOffset ;Remove the extra 0x30s when going from ascii to hexidecimal and sets the Z flag to check for UPC "000000000000"
division                 BEQ  Loop                               ;If sum is a multiple of 10 jump to end as 1 is already stored in r0
                         SUBS r2, r2, #ten                       ;Subtract 10 from sum of odd sum * 3 + even sum
                         BPL  division                           ;Continue loop if no branching occurs
invalidUPC               MOV  r0, #two                           ;Move 2 to r0 to indicate invalid UPC
Loop                     B    Loop                               ;Trap to stop program from going further
UPC                      DCB  "013800150738"                     ;correct UPC string
UPC2                     DCB  "060383755577"                     ;correct UPC string
UPC3                     DCB  "065633454712"                     ;correct UPC string
UPC4                     DCB  "065633754712"                     ;incorrect UPC string
UPC5                     DCB  "018800150738"                     ;incorrect UPC string
UPC6                     DCB  "060383775577"                     ;incorrect UPC string
UPC7                     DCB  "000000000000"                     ;correct UPC string
                         END
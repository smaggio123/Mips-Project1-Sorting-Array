
        .data
prompt1:.asciiz "Enter 0 to sort in descending order.\n"
prompt2:.asciiz "Any number different than 0 will sort in ascending order.\n"
prompt3:.asciiz "Before sort:\n"
prompt4:.asciiz "\n\nafter Sort:\n"
printNewLine:.asciiz "\n"
arr: .word 7, 9, 4, 3, 8, 1, 6, 2, 5




    .globl main
    .text
main:

    #assigning registers:
    #$s0=j
    #s1=k
    #s2=temp
    #$s3=min
    #$s4=direction
    #$s5=length

    
    li $s5,9            #int length=9

    #printing part
    li	$v0,4				
    la	$a0,prompt1		# printf("\nEnter 0 to sort in descending order.\n")
    syscall

    li	$v0,4
    la	$a0,prompt2     #printf("Any number different than 0 will sort in ascending order.\n")
    syscall

    li	$v0,5           #scanf(%d,&direction)
    syscall

    move $s4,$v0        #store input number (direction)

    li	$v0,4
    la	$a0,prompt3     #printf("Before sort:\n")
    syscall
    jal printData       #printData(list,length)

    li $s1,0           #k=0



initialConditionForKLoop: #if k>length-1 to start,skips loops
    addi,$t1,$s5,-1     #$t1=length-1
    bgt $s1,$t1,endPrint

loopWithVarK:           #for(k=0;k<length-1;++k)
    move $s3,$s1        #min=k
    addi $s0,$s1,1        #j=k+1

initialConditionForJLoop: #if j>length to start, skips loops
    addi $t0,$s0,1      #$t0=k+1
    bgt $t0,$s5,endOfLoopK
loopWithVarJ:           #for(j=k+1;j<length;++j)
    jal check           #$s6=check(direction,list[j],list[min])
    #beq $s6,$0,secondPart #if($s6)
    bgt	$s6, $0, conditionOfJLoop	# if $s6 > $0 then conditionJLoop
    move $s3,$s0        #min=j

conditionOfJLoop:
    addi $s0,$s0,1      #++j
    blt $s0,$s5,loopWithVarJ	#if 0, loop again
#end of loop j
#back in loop k
    beq $s3,$s1,endOfLoopK
    #swap
    la $s7,arr      #$s7=list
    move $t1,$s3    #edit min
    mul $t1,$t1,4   #$t1=min*4
    add $s7,$s7,$t1 #$s7=min position in array
    lw $s2,0($s7)   #$s2<-list[min]


    la $t5,arr      #$t5=list
    move $t2,$s1    #edit k
    mul $t2,$t2,4   #$t2=k*4
    add $t5,$t5,$t2 #t5=k position in array
    lw $t3,0($t5)   #$t3<-list[k]
    #list[min]=list[k]
    sw $s2,0($t5)   #$s2->list[k]

    #list[k]=temp
    sw $t3,0($s7)   #t3->list[min]

endOfLoopK:
    addi,$t1,$s5,-1     #$t1=length-1
    addi $s1,$s1,1      #++k
    blt $s1,$t1, loopWithVarK	    #get k<length-1
#end of loop k

#Does final prints and exits program
endPrint:
    li	$v0,4
    la	$a0,prompt4 #printf("\n\nafter Sort:\n")
    syscall

    jal printData #printData()

    li	$v0,4
    la	$a0,printNewLine #printf("\n")
    syscall

    li	$v0,10  #end program
    syscall
    
#Prints the array
printData:
    li $t0,0	#$t0=k
    add $t1,$0,$s5  #$t1=length
    addi $t1,$t1,-1 #subtract one since condition is evaluated after
    la $s7,arr
    loop:
        #Getting element in array
        lw $s6,0($s7)
        add $s7,$s7,4
        #Printing element in array
        li $v0,1
        move $a0,$s6
        syscall
        #incrementing index in array
        addi $t0,$t0,1

        sgt $t2,$t0,$t1	#for $t0>$t1 still false 0
        beq $t2,$0,loop	#if not 0, exit loop

    jr $ra


#sets $s6 equal to j>min or j<min depending on the value of direction
check:  #check()
    la $s7,arr      #$s7=list
    mul $t0,$s0,4
    add $t0,$t0,$s7
    lw $t1,0($t0) #$t1=j
    mul $t0,$s3,4
    add $t0,$t0,$s7
    lw $t2,0($t0) #$t2=min
    beq $s4,$0,checkGreaterThan #if(direction==0)
    j else
#determines if j>min
checkGreaterThan:

    sgt $s6,$t2,$t1 #return j>min
    j exitCheck
#determines if j<min
else:
    slt $s6,$t2,$t1 #return j<min
    j exitCheck

exitCheck:
    jr $ra

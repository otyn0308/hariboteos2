TOOLS	=../hariboteos2/tools/
INCPATH	=../hariboteos2/tools/haribote/

NASK	=$(TOOLS)nask
EDIMG	=$(TOOLS)edimg
CC1		=$(TOOLS)gocc1 -I$(INCPATH) -Os -Wall -quiet
GAS2NASK=$(TOOLS)gas2nask -a
MAKEFONT=$(TOOLS)makefont
BIN2OBJ =$(TOOLS)bin2obj
OBJ2BIM =$(TOOLS)obj2bim
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

graphic.gas : graphic.c Makefile
	$(CC1) -o graphic.gas graphic.c

graphic.nas : graphic.gas Makefile
	$(GAS2NASK) graphic.gas graphic.nas

graphic.obj : graphic.nas Makefile
	$(NASK) graphic.nas graphic.obj graphic.lst

dsctbl.gas : dsctbl.c Makefile
	$(CC1) -o dsctbl.gas dsctbl.c

dsctbl.nas : dsctbl.gas Makefile
	$(GAS2NASK) dsctbl.gas dsctbl.nas

dsctbl.obj : dsctbl.nas Makefile
	$(NASK) dsctbl.nas dsctbl.obj dsctbl.lst

naskfunc.obj : naskfunc.nas Makefile
	$(NASK) naskfunc.nas naskfunc.obj naskfunc.lst

hankaku.bin : hankaku.txt Makefile
	$(MAKEFONT) hankaku.txt hankaku.bin

hankaku.obj : hankaku.bin Makefile
	$(BIN2OBJ) hankaku.bin hankaku.obj _hankaku

bootpack.bim : bootpack.obj graphic.obj dsctbl.obj naskfunc.obj hankaku.obj Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
	  bootpack.obj graphic.obj dsctbl.obj naskfunc.obj hankaku.obj 

bootpack.hrb : bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

haribote.sys : asmhead.bin bootpack.hrb Makefile
	$(HARITOL) concat haribote.sys asmhead.bin bootpack.hrb

haribote.img : ipl.bin haribote.sys Makefile
	$(EDIMG) imgin:$(TOOLS)fdimg0at.tek \
	  wbinimg src:ipl.bin len:512 from:0 to:0 \
	  copy from:haribote.sys to:@: \
	  imgout:haribote.img


img :
	make -r haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img

clean :
	rm *.bin
	rm *.lst
	rm *.gas
	rm *.obj
	rm *.sys
	rm bootpack.hrb
	rm bootpack.map
	rm bootpack.bim
	rm bootpack.nas
	rm graphic.nas
	rm dsctbl.nas

src_only :
	make clean
	rm haribote.img


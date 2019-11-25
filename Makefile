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

%.bin : %.nas Makefile
	$(NASK) $*.nas $*.bin $*.lst

%.gas : %.c Makefile
	$(CC1) -o $*.gas $*.c

%.nas : %.gas Makefile
	$(GAS2NASK) $*.gas $*.nas
	
%.obj : %.nas Makefile
	$(NASK) $*.nas $*.obj $*.lst

hankaku.bin : hankaku.txt Makefile
	$(MAKEFONT) hankaku.txt hankaku.bin

hankaku.obj : hankaku.bin Makefile
	$(BIN2OBJ) hankaku.bin hankaku.obj _hankaku

bootpack.bim : bootpack.obj graphic.obj dsctbl.obj int.obj fifo.obj keyboard.obj mouse.obj memory.obj sheet.obj timer.obj naskfunc.obj hankaku.obj Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
	  bootpack.obj graphic.obj dsctbl.obj int.obj fifo.obj \
	  keyboard.obj mouse.obj memory.obj sheet.obj timer.obj \
	  naskfunc.obj hankaku.obj 

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
	rm *.obj
	rm *.sys
	rm bootpack.hrb
	rm bootpack.map
	rm bootpack.bim

src_only :
	make clean
	rm haribote.img


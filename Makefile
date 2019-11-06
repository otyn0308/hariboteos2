tools		=../hariboteos2/tools/
make		=$(tools)make -r
nask		=$(tools)nask
edimg		=$(tools)edimg


default :
	make img

ipl.bin : ipl.nas Makefile
	$(nask) ipl.nas ipl.bin ipl.lst

haribote.img : ipl.bin Makefile
	$(edimg) imgin:$(tools)fdimg0at.tek \
	  wbinimg src:ipl.bin len:512 from:0 to:0 imgout:haribote.img


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

src_only :
	make crean
	rm hatibote.img


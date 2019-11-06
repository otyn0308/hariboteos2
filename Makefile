tools		=../hariboteos2/tools/
nask		=$(tools)nask
edimg		=$(tools)edimg


default :
	make img

ipl.bin : ipl.nas Makefile
	$(nask) ipl.nas ipl.bin ipl.lst

haribote.sys : haribote.nas Makefile
	$(nask) haribote.nas haribote.sys haribote.lst

haribote.img : ipl.bin haribote.sys Makefile
	$(edimg) imgin:../hariboteos2/tools/fdimg0at.tek \
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
	rm haribote.sys
	rm haribote.lst

src_only :
	make crean
	rm hatibote.img


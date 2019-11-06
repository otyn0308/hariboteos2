;hariboteos
;TAB=4

        ORG     0xc200          ;このプログラムがどこに読み込まれるのか

        MOV     AL,0x13         ;VGAグラフィックス，320*320*8bitカラー
        MOV     AH,0x00
        INT     0x10
fin:
        HLT
        JMP     fin

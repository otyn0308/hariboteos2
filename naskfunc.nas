;naskfunc
;TAB=4

[FORMAT "WCOFF"]            ;オブジェクトファイルを作るモード
[INSTRSET "i486p"]
[BITS 32]                   ;32ビットモード用の機械語を作らせる
[FILE "naskfunc.nas"]       ;ソースファイル名情報

        GLOBAL _io_hlt,_write_mem8

[SECTION .text]

_io_hlt:
        HLT
        RET

_write_mem8:
        MOV     ECX,[ESP+4] ;[ESP+4]にaddrが入っているのでそれをECXに読み込む
        MOV     AL,[ESP+8]  ;[ESP+8]にdataが入っているのでそれをALに読み込む
        MOV     [ECX],AL
        RET

;naskfunc
;TAB=4

[FORMAT "WCOFF"]            ;オブジェクトファイルを作るモード
[INSTRSET "i486p"]
[BITS 32]                   ;32ビットモード用の機械語を作らせる
[FILE "naskfunc.nas"]       ;ソースファイル名情報

        GLOBAL _io_hlt

[SECTION .text]

_io_hlt:
        HLT
        RET


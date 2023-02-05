if { $modelsim == 1 } {
    if { [info exists enodeb_path ] } {
        set here $enodeb_path
    } else {
        set here ""
    }
} else {
    set here $::quartus(qip_path)
}

set enodeb_synthesis_tx [list \
                             [file normalize [ file join $here ../vhdl/enodeb_crc.vhd] ]             \
                             [file normalize [ file join $here ../vhdl/crc8.vhd] ]                   \
                             [file normalize [ file join $here ../vhdl/crc16.vhd] ]                  \
                             [file normalize [ file join $here ../vhdl/crc24A.vhd] ]                 \
                             [file normalize [ file join $here ../vhdl/crc24B.vhd] ]                 \
] ;

set enodeb_synthesis_top [list \
                             [file normalize [ file join $here ../vhdl/enodeb_top.vhd] ]             \
                             ] ;

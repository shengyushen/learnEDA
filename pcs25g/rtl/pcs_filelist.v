
`include "../pcssrc/rtl/pcs8x_define.v"

`include "../pcssrc/rtl/graydecoder_16_long.v"
`include "../pcssrc/rtl/graycounter_16_long.v"
`include "../pcssrc/rtl/graydecoder_32_long.v"
`include "../pcssrc/rtl/graycounter_32_long.v"
`include "../pcssrc/rtl/graydecoder_12.v"
`include "../pcssrc/rtl/graycounter_12.v"

//tx
`include "../pcssrc/rtl/tx_escaper.v"
`include "../pcssrc/rtl/scrambler_48.v"
`include "../pcssrc/rtl/tx_gearbox.v"
`include "../pcssrc/rtl/tx_fifo_2x.v"
`include "../pcssrc/rtl/tx_fifo_stage.v"
`include "../pcssrc/rtl/tx_fifo_stage_idle.v"

//rx
`include "../pcssrc/rtl/XFIPCS_LOCK_FSM.v"
`include "../pcssrc/rtl/rx_block_sync.v"
`include "../pcssrc/rtl/descrambler_48.v"
`include "../pcssrc/rtl/rx_deescaper.v"
`include "../pcssrc/rtl/rx_fifo_2x_32.v"
`include "../pcssrc/rtl/rx_fifo_stage.v"

//one lane
`include "../pcssrc/rtl/pcs1x.v"
`include "../pcssrc/rtl/pcs1x_empty.v"

//top
`include "../pcssrc/rtl/tx_flusher.v"
`include "../pcssrc/rtl/tx_swizzler.v"
`include "../pcssrc/rtl/distributor.v"
`include "../pcssrc/rtl/collector.v"
`include "../pcssrc/rtl/rx_lane_sorter.v"
`include "../pcssrc/rtl/rx_swizzler.v"
`include "../pcssrc/rtl/rx_stage.v"
`include "../pcssrc/rtl/rx_deflusher.v"
`include "../pcssrc/rtl/pcs4x_nocsr.v"

../rtl/pcs8x_define.v

../rtl/clock_counter.v
../rtl/clock_div16.v
../rtl/collector.v
../rtl/descrambler_48.v
../rtl/descrambler_64.v
../rtl/distributor.v
../rtl/gearbox_192_256.v
../rtl/gearbox_256_192.v
../rtl/gearbox_48_64.v
../rtl/gearbox_64_48.v
../rtl/graycounter_12.v
../rtl/graycounter_16_long.v
../rtl/graycounter_32_long.v
../rtl/graycounter_8_long.v
../rtl/graydecoder_12.v
../rtl/graydecoder_16_long.v
../rtl/graydecoder_32_long.v
../rtl/grayencoder_16_long.v
../rtl/grayencoder_16.v
../rtl/grayencoder_6.v
../rtl/pcs1x_empty.v
../rtl/pcs1x.v
../rtl/pcs4x_nocsr.v
../rtl/pcsfec.v
../rtl/perlane_descrambler.v
../rtl/perlane_scrambler.v
../rtl/reset_delay.v
../rtl/rx_block_sync.v
../rtl/rx_deescaper.v
../rtl/rx_deflusher.v
../rtl/rx_fifo_2x_32.v
../rtl/rx_fifo_2x.v
../rtl/rx_fifo_stage.v
../rtl/rx_lane_sorter.v
../rtl/rx_stage.v
../rtl/rx_swizzler.v
../rtl/scrambler_48.v
../rtl/scrambler_64.v
../rtl/ssyfifo.v
../rtl/sync_2xdff.v
../rtl/tx_escaper.v
../rtl/tx_fifo_2x.v
../rtl/tx_fifo_stage_idle.v
../rtl/tx_fifo_stage.v
../rtl/tx_flusher.v
../rtl/tx_gearbox.v
../rtl/tx_swizzler.v
../rtl/XFIPCS_LOCK_FSM.v

../tb/amdetector.v
../tb/chip_sendESC.v
../tb/chip.v
../tb/chk192_sendtime_sendESC.v
../tb/chk192_sendtime.v
../tb/chk_dec.v
../tb/chk_rx_fifo.v
../tb/chk_tx_fifo.v
../tb/errorInjecting.v

../tb/fake_hss/test_define.v
../tb/fake_hss/gen_rdy_lock.v
#../tb/fake_hss/HSSLane_20.v
../tb/fake_hss/HSSLane.v
../tb/fake_hss/Interfere_PCS_HSS.v
../tb/fake_hss/WRAP2_T09_HS28GBLPF04_test.v

../tb/gen192_sendtime_sendESC.v
../tb/gen192_sendtime.v
../tb/hss.v
../tb/inplace_dec6466.v
../tb/lane_shower.v
../tb/random_error.v
../tb/ssycdr.v
../tb/sync2stage.v
../tb/tb28g.v
../tb/tb_deskew.v
../tb/tb.v



-propfile_vlog ../rtl/perlane_scrambler.psl
-propfile_vlog ../rtl/gearbox_192_256.psl
-propfile_vlog ../rtl/distributor.psl
-propfile_vlog ../rtl/gearbox_48_64.psl
-propfile_vlog ../rtl/gearbox_64_48.psl
-propfile_vlog ../rtl/gearbox_256_192.psl
-propfile_vlog ../rtl/graycounter_32_long.psl
-propfile_vlog ../rtl/tx_swizzler.psl
-propfile_vlog ../rtl/tx_flusher.psl
-propfile_vlog ../rtl/rx_fifo_stage.psl
-propfile_vlog ../rtl/grayencoder_6.psl
-propfile_vlog ../rtl/perlane_descrambler.psl
-propfile_vlog ../rtl/tx_gearbox.psl
-propfile_vlog ../rtl/ssyfifo.psl
-propfile_vlog ../rtl/rx_block_sync.psl
-propfile_vlog ../rtl/rx_fifo_2x_32.psl
-propfile_vlog ../rtl/graycounter_16_long.psl
-propfile_vlog ../rtl/tx_fifo_2x.psl
-propfile_vlog ../rtl/grayencoder_16_long.psl
-propfile_vlog ../rtl/graycounter_12.psl
-propfile_vlog ../rtl/graycounter_8_long.psl
-propfile_vlog ../rtl/tx_escaper.psl
-propfile_vlog ../rtl/rx_fifo_2x.psl

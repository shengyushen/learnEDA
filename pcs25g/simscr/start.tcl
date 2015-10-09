database -open  waves -into waves.shm -default

probe -create tb.inst_tb28g.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g.inst_chip_slow -depth all -all -database waves

probe -create tb.inst_tb28g_manual_blocklock.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_manual_blocklock.inst_chip_slow -depth all -all -database waves

probe -create tb.inst_tb28g_manual_polar.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_manual_polar.inst_chip_slow -depth all -all -database waves

probe -create tb.inst_tb28g_fec_corrected.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_fec_corrected.inst_chip_slow -depth all -all -database waves
probe -create tb.inst_tb28g_fec_corrected.inst_random_error0 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_corrected.inst_random_error1 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_corrected.inst_random_error2 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_corrected.inst_random_error3 -depth all -all -database waves

probe -create tb.inst_tb28g_fec_located.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_fec_located.inst_chip_slow -depth all -all -database waves
probe -create tb.inst_tb28g_fec_located.inst_random_error0 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_located.inst_random_error1 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_located.inst_random_error2 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_located.inst_random_error3 -depth all -all -database waves

probe -create tb.inst_tb28g_fec_detected.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_fec_detected.inst_chip_slow -depth all -all -database waves
probe -create tb.inst_tb28g_fec_detected.inst_random_error0 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_detected.inst_random_error1 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_detected.inst_random_error2 -depth all -all -database waves
probe -create tb.inst_tb28g_fec_detected.inst_random_error3 -depth all -all -database waves

probe -create tb.inst_tb28g_fec_manual_polar.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_fec_manual_polar.inst_chip_slow -depth all -all -database waves

probe -create tb.inst_tb28g_fec_noECC.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_fec_noECC.inst_chip_slow -depth all -all -database waves

probe -create tb.inst_tb28g_fpga.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_fpga.inst_chip_slow -depth all -all -database waves

probe -create tb.inst_tb28g_40g.inst_chip_fast -depth all -all -database waves
probe -create tb.inst_tb28g_40g.inst_chip_slow -depth all -all -database waves

probe -create tb -depth 4 -all -database waves

run 200000



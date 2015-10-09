database -open  waves -into waves.shm -default
probe -create tb_deskew -depth all -all -database waves

run 200000



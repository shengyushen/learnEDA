# l3cache is not used
#gem5.opt ~/EDA_tools/gem5-stable/configs/example/fs.py --kernel=~/EDA_tools/gem5-stable/binaries/vmlinux.aarch64.20140821 --disk-image=~/EDA_tools/gem5-stable/disks/aarch64-ubuntu-trusty-headless.img --dtb-filename=~/EDA_tools/gem5-stable/binaries/vexpress.aarch64.20140821.dtb --machine-type=VExpress_EMM64 --caches --l2cache --l3cache --l1d_size=32kB --l1i_size=32kB --l2_size=256kB --l3_size=16MB -n 8
#gem5.opt ~/EDA_tools/gem5-stable/configs/example/fs.py --kernel=/home/syshen/EDA_tools/gem5-stable/binaries/vmlinux.aarch64.20140821 --disk-image=/home/syshen/EDA_tools/gem5-stable/disks/aarch64-ubuntu-trusty-headless.img --dtb-filename=/home/syshen/EDA_tools/gem5-stable/binaries/vexpress.aarch64.20140821.dtb --machine-type=VExpress_EMM64 --caches --l2cache --l1d_size=32kB --l1i_size=32kB --l2_size=256kB --l3_size=16MB -n 4 --arm-iset=aarch64
gem5.opt ~/EDA_tools/gem5-stable/configs/example/fs.py --kernel=/home/syshen/EDA_tools/gem5-stable/binaries/vmlinux.aarch64.20140821 --disk-image=/home/syshen/EDA_tools/gem5-stable/disks/aarch64-ubuntu-trusty-headless.img --dtb-filename=/home/syshen/EDA_tools/gem5-stable/binaries/vexpress.aarch64.20140821.dtb --machine-type=VExpress_EMM64 --caches --l2cache --l1d_size=32kB --l1i_size=32kB --l2_size=256kB  -n 8 --arm-iset=aarch64

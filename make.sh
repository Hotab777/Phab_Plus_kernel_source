set -x
TOP=`pwd`
OUT='out/target/product/kernel_build/obj/KERNEL_OBJ'
CONFIG='kernel/arch/arm64/configs/defconfig'
PATH+=$TOP/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:
PATH+=$TOP/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.8/bin:
PATH+=$TOP/prebuilts/devtools/tools:
PATH+=$TOP/prebuilts/android-emulator/linux-x86_64:
OBJCOPY=$TOP'/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android/bin/objcopy'
cd ${TOP}/kernel
make clean
make mrproper
cd ../
mkdir -p $TOP/$OUT 
cp    $TOP/$CONFIG $TOP/$OUT/.config
make  -C kernel O=$TOP/$OUT ARCH=arm64 CROSS_COMPILE=aarch64-linux-android- KCFLAGS=-mno-android  
$OBJCOPY -O binary -S $OUT/vmlinux $OUT/boot -R .comment -R .note
./mkbootimg  --kernel $OUT/boot --ramdisk ramdisk.img --cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk'  --dt dt.img -o $OUT/boot.img
set +x

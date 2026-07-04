# Linux kernel for Raspberry Pi Zero 2W 

Based on source from original Raspberry Pi repo.

Install dependencies:
```bash
sudo ./install-dependencies.sh
```

Build kernel, modules and dtb:
```bash
./build.sh
```
You can also build everything in docker:
```bash
./build.sh -d
```

Copy files from `./build/output/boot` to `bootfs`

Copy files from `./build/output/lib` to `rootfs/lib`

Add line `kernel=Image.gz` to bootfs/config.txt 

Enjoy :)

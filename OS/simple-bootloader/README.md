Hello World BootLoader
=======

`Simpllest form of bootloader`

##### Compile

----

first install nasm qemu:

    $sudo apt install nasm qemu 

then Compile the code with:

    $nasm boot.asm -f bin -o boot.bin


##### Boot

Then we create a iso file with an UltraISO. its important for boot with our code.

Then we can boot our system with this file. but we prefer a virtual machine like Vmware.

I boot this ISO file on Oracle VM VirtualBox.

![example image](https://raw.githubusercontent.com/erfanbahrami/a-simple-bootloader/master/pic.png)

---

##### **Source**

[https://www.viralpatel.net/taj/tutorial/hello_world_bootloader.php](https://www.viralpatel.net/taj/tutorial/hello_world_bootloader.php)
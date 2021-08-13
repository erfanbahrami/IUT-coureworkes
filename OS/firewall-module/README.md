


 >you can set your restrictions fpr ip addresses in config file
 >first yoy should determine you want blacklist or whitelist
 >and after that you can set ip and port in every line

  
---

---

 

## **Building & Cleaning Module**

-   To build this module, type:

		$ make

-   To clean up the module, type:

		$ make clean
	 
## **Loading & Unloading Module**

-   To install the module, type:

		$ sudo insmod firewall.ko

-   To remove the module, type:

		$ sudo rmmod  firewall.ko

-   To run this

		 $ sudo tail -f /var/log/kern.log



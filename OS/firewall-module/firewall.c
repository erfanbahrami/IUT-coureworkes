#include <linux/device.h>
#include <linux/uaccess.h>
#include <linux/time.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/skbuff.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <linux/icmp.h>
#include <linux/ip.h>
#include <linux/inet.h>
#include <linux/if.h>
#include <linux/fs.h>
#include <linux/string.h>
#define  DEVICE_NAME "Mfirewall"              ///< The device will appear at /dev/Mfirewall using this value
#define  CLASS_NAME  "fire"                   ///< The device class -- this is a character device driver

MODULE_LICENSE("GPL");                        ///< The license type -- this affects runtime behavior
MODULE_AUTHOR("Erfan Bahrami");               ///< The author -- visible when you use modinfo
MODULE_DESCRIPTION("Filter packet module");    ///< The description -- see modinfo
MODULE_VERSION("1.0");                        ///< The version of the module

static char *name = "ٌWorld";                  ///< An example LKM argument -- default value is "world"
module_param(name, charp, S_IRUGO);           ///< Param desc. charp = char ptr, S_IRUGO can be read/not changed
MODULE_PARM_DESC(name, "The name to display in 'journalctl -f'");  ///< parameter description

static int    majorNumber;                    ///< Stores the device number -- determined automatically
static char   message[256] = {0};             ///< Memory for the string that is received from userspace
static struct class*  MfirewallClass  = NULL; ///< The device-driver class struct pointer
static struct device* MfirewallDevice = NULL; ///< The device-driver device struct pointer


static int  dev_Open(struct inode *, struct file *);
static int  dev_release(struct inode *, struct file *);
static ssize_t dev_write(struct file *, const char *, size_t, loff_t *);

/** @brief Devices are represented as file structure in the kernel. The file_operations structure from
 *  /linux/fs.h lists the callback functions that you wish to associated with your file operations
 *  using a C99 syntax structure. char devices usually implement open, read, write and release calls
 */
static struct file_operations fops ={
   .open = dev_Open,
   .write = dev_write,
   .release = dev_release,
};


unsigned int icmp_hook(	unsigned int hooknum,
			struct sk_buff *skb,
			const struct net_device *in,
			const struct net_device *out,
			int(*okfn)(struct sk_buff *));

static struct nf_hook_ops icmp_drop __read_mostly = {
        .pf = NFPROTO_IPV4,
        .priority = NF_IP_PRI_FIRST,
        .hooknum =NF_INET_LOCAL_IN,
        .hook = (nf_hookfn *) icmp_hook
};

int No; // 0 for whitelist & 1 for blacklist
int list_num; // number of list
char list[100][25];


/** @brief The LKM initialization function
 *  The static keyword restricts the visibility of the function to within this C file. The __init
 *  macro means that for a built-in driver (not a LKM) the function is only used at initialization
 *  time and that it can be discarded and its memory freed up after that point.
 *  @return returns 0 if successful
 */
static int __init icmp_drop_init(void){
   int ret;

   printk(KERN_INFO "packet dropper loaded\n");

   majorNumber = register_chrdev(0, DEVICE_NAME, &fops);
   if (majorNumber<0)
   {
      printk(KERN_ALERT "Mfirewall failed to register a major number\n");
      return majorNumber;
   }
   printk(KERN_INFO "registered correctly with major number %d\n", majorNumber);


   MfirewallClass = class_create(THIS_MODULE, CLASS_NAME);
   if (IS_ERR(MfirewallClass)){
      unregister_chrdev(majorNumber, DEVICE_NAME);
      printk(KERN_ALERT "Failed to register device class\n");
      return PTR_ERR(MfirewallClass);
   }
   printk(KERN_INFO "Mfirewall: device class registered correctly\n");


   MfirewallDevice = device_create(MfirewallClass, NULL, MKDEV(majorNumber, 0), NULL, DEVICE_NAME);
   if (IS_ERR(MfirewallDevice))
   {
      class_destroy(MfirewallClass);
      unregister_chrdev(majorNumber, DEVICE_NAME);
      printk(KERN_ALERT "Failed to create the device\n");
      return PTR_ERR(MfirewallDevice);
   }
   printk(KERN_INFO "Mfirewall: device class created correctly\n");
   ret = nf_register_net_hook(&init_net,&icmp_drop);
   if(ret)
   {
      printk(KERN_INFO "FAILED");
   }
   No = 1;
   list_num = 0;
   return  ret;
}

/** @brief The LKM cleanup function
 *  Similar to the initialization function, it is static. The __exit macro notifies that if this
 *  code is used for a built-in driver (not a LKM) that this function is not required.
 */
static void __exit  icmp_drop_exit(void){
   device_destroy(MfirewallClass, MKDEV(majorNumber, 0));
   class_unregister(MfirewallClass);
   class_destroy(MfirewallClass);
   unregister_chrdev(majorNumber, DEVICE_NAME);
   printk(KERN_INFO "Mfirewall: Goodbye from the LKM!\n");
   nf_unregister_net_hook(&init_net,&icmp_drop);
}

/** @brief The device open function that is called each time the device is opened
 *  This will only increment the numberOpens counter in this case.
 *  @param inodep A pointer to an inode object (defined in linux/fs.h)
 *  @param filep A pointer to a file object (defined in linux/fs.h)
 */
static int dev_Open(struct inode *inodep, struct file *filep){
   printk(KERN_INFO "Mfirewall: Device has been opened \n");
   return 0;
}

/** @brief This function is called whenever the device is being written to from user space i.e.
 *  data is sent to the device from the user. The data is copied to the message[] array in this
 *  LKM using the sprintf() function along with the length of the string.
 *  @param filep A pointer to a file object
 *  @param buffer The buffer to that contains the string to write to the device
 *  @param len The length of the array of data that is being passed in the const char buffer
 *  @param offset The offset if required
 */
static ssize_t dev_write(struct file *filep, const char *buffer, size_t len, loff_t *offset){
   int error_count = 0;
   // unsigned long copy_from_user( void *to, const void __user *from,unsigned long n);
   error_count = copy_from_user(message, buffer, len);
   if(message[0]=='b'){
      if(!No){
         list_num=0;
         printk(KERN_INFO "Mfirewall: policy changed to blacklist\n");
      }
      No = 1;
   }
   else if(message[0]=='w'){
      if(No){
         list_num=0;
         printk(KERN_INFO "Mfirewall: policy changed to whitelist\n");
      }
      No = 0;
   }
   else{
      strncpy(list[list_num++],message,len);
      if(No){
         printk(KERN_INFO "Mfirewall: add %s to %s\n",message , "blacklist");
      }
      else{
         printk(KERN_INFO "Mfirewall: add %s to %s\n",message , "whitelist");
      }
   }
   return len;
}

static int dev_release(struct inode *inodep, struct file *filep){
   printk(KERN_INFO "Mfirewall: Device successfully closed\n");
   return 0;
}


unsigned int icmp_hook(unsigned int hooknum, struct sk_buff *skb,const struct net_device *in, const struct net_device *out,int(*okfn)(struct sk_buff *)){

   struct iphdr *ip_header = (struct iphdr *)skb_network_header(skb);
   struct udphdr *udp_header;
   struct tcphdr *tcp_header;

   unsigned int src_ip = (unsigned int)ip_header->saddr;
   unsigned int dest_ip = (unsigned int)ip_header->daddr;
   unsigned int src_port = 0;
   unsigned int dest_port = 0;

   int i;
   char SOurce[25];
   if(!skb)
   {
     printk("droped");
      return NF_DROP;
    }
   if (ip_header->protocol==17)
   {
      udp_header = (struct udphdr *)skb_transport_header(skb);
      src_port = (unsigned int)ntohs(udp_header->source);
      printk(KERN_DEBUG "(UDP)IP addres = %pI4(%u)  DEST = %pI4\n", &src_ip, src_port , &dest_ip);

   }
   else if (ip_header->protocol == 6)
   {
      tcp_header = (struct tcphdr *)skb_transport_header(skb);
      src_port = (unsigned int)ntohs(tcp_header->source);
      dest_port = (unsigned int)ntohs(tcp_header->dest);
      printk(KERN_DEBUG "(TCP)IP addres = %pI4(%u)  DEST = %pI4\n", &src_ip, src_port , &dest_ip);
   }

   snprintf(SOurce, 25, "%pI4:%u", &ip_header->saddr, src_port); // Mind the &!

   if(No)
   {
      for(i=0;i<list_num ;i++){


         if( !strncmp(SOurce ,list[i] , strlen(list[i])-1))
         {
            printk(KERN_DEBUG "(TCP)IP addres = %pI4(%u)  DEST = %pI4\n", &src_ip, src_port , &dest_ip);
            printk(KERN_DEBUG "packet drop - %s is in black list", SOurce);
            return NF_DROP;
         }

    }return NF_ACCEPT;
   }
   else
   {
      for(i=0;i<list_num ;i++)
         if( !strncmp(SOurce ,list[i] , strlen(list[i])-1))
         {
            printk(KERN_DEBUG "packet accept - %s is in white list", SOurce);
            return NF_ACCEPT;
         }

      return NF_DROP;
   }
   return NF_ACCEPT;

}


/** @brief A module must use the module_init() module_exit() macros from linux/init.h, which
 *  identify the initialization function at insertion time and the cleanup function (as
 *  listed above)
 */
module_init(icmp_drop_init);
module_exit(icmp_drop_exit);

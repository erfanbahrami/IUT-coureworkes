using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using DataModelLayer;
using System.Windows.Shapes;
using Common;

namespace Spadana_Music
{
    /// <summary>
    /// Interaction logic for Win_login.xaml
    /// </summary>
    public partial class Win_about : Window
    {
        private Settings mSettings = new Settings(@"MainWindow");
        public Common.Settings Settings
        {
            get
            {
                return mSettings;
            }
        }

        string userName;
        Music_Academy_ManagementEntities db = new Music_Academy_ManagementEntities();
        public Win_about()
        {
            InitializeComponent();
            about.Text = @"هدف از این پروژه راه اندازی یک اپلیکیشن دسکتاپ مدیریت کامل یک آموزشگاه موسیقی به هر حدی از امکانات و وسعت است. در راستای این پروژه دوست داشتنی ، از هیچ تلاشی دریغ نشده است و انجام آن در 3 فاز صورت گرفته است.
نام و نام خانوادگی : عرفان بهرامی
شماره دانشجویی : 9624513
ایمیل : erfanbahrami1999@gmail.com";
        }

        private void cancell_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}

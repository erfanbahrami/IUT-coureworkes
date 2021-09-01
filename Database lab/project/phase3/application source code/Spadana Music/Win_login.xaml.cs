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
    public partial class Win_login : Window
    {
        private Settings mSettings = new Settings(@"MainWindow");
        public Common.Settings Settings
        {
            get
            {
                return mSettings;
            }
        }
        public Win_login()
        {
            InitializeComponent();
        }


        private void login_Click(object sender, RoutedEventArgs e)
        {
            var db = new Music_Academy_ManagementEntities();
            var qLog = db.USERS.Find(username.Text);

            if (qLog !=null && qLog.password==pass.Text)
            {
                new MainWindow(qLog.manager.Value,username.Text).Show();
                this.Close();
            }
            else
            {
                MessageBox.Show("رمز وارد شده یا نام کاربری نامعتبر است!");
            }
        }

        private void cancell_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

    }
}

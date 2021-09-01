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
    public partial class Win_changePass : Window
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
        public Win_changePass(string user)
        {
            InitializeComponent();
            userName = user;
        }


        private void login_Click(object sender, RoutedEventArgs e)
        {
            var db = new Music_Academy_ManagementEntities();
            var qLog = db.USERS.Find(userName);

            if (qLog.password==oldPass.Text)
            {
                db.update_username(userName, newPass.Text);
                db.SaveChanges();
                MessageBox.Show("رمز با موفقیت تغییر کرد");
                this.Close();
            }
            else
            {
                MessageBox.Show("رمز وارد شده نامعتبر است!");
            }
        }

        private void cancell_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

    }
}

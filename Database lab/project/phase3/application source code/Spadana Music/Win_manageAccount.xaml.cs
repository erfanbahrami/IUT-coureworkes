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
    public partial class Win_manageAccount : Window
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
        public Win_manageAccount(string user)
        {
            InitializeComponent();
            userName = user;
            accounts.ItemsSource = (from u in db.USERS where u.username != userName select u).ToList();
        }

        private void cancell_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void delAccnt_Click(object sender, RoutedEventArgs e)
        {
            var uName = accounts.SelectedItem as USER;
            if (uName == null) return;
            db.USERS.Remove(uName);
            db.SaveChanges();
            accounts.ItemsSource = (from u in db.USERS where u.username != userName select u).ToList();
        }

        private void addAccnt_Click(object sender, RoutedEventArgs e)
        {
            if (db.USERS.Find(newUser.Text) == null)
            {
                var nu = new USER();
                nu.username = newUser.Text;
                nu.password = "123456";
                nu.manager = isAdmin.IsChecked.Value;
                db.USERS.Add(nu);
                db.SaveChanges();
                newUser.Text = "";
                accounts.ItemsSource = (from u in db.USERS where u.username != userName select u).ToList();
                MessageBox.Show("کاربر جدید با رمز پیش فرض جدید ۱ تا۶ ثبت شد");
            }
            else MessageBox.Show("نام کاربری از قبل وجود دارد");
        }
    }
}

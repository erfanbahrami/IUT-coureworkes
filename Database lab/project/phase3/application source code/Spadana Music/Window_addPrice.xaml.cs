using System;
using System.Collections.Generic;
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
using System.Windows.Shapes;
using Common;
using DataModelLayer;

namespace Spadana_Music
{
    /// <summary>
    /// Interaction logic for Window_addPrice.xaml
    /// </summary>
    public partial class Window_addPrice : Window
    {
        private Settings mSettings = new Settings(@"MainWindow");
        public Common.Settings Settings
        {
            get
            {
                return mSettings;
            }
        }
        bool isEm;
        public Window_addPrice(bool isEm)
        {
            InitializeComponent();
            percent.Text = "0";
            this.isEm = isEm;
        }

        private void ok_Click(object sender, RoutedEventArgs e)
        {
            var db = new Music_Academy_ManagementEntities();
            if (isEm)
            {
                db.add_base_salary(short.Parse(percent.Text));
            }
            else db.add_price_percentage(int.Parse(percent.Text));
            this.Close();
        }
    }
}

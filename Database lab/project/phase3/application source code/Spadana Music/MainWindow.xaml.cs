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
using System.Windows.Navigation;
using System.Windows.Shapes;
using DataModelLayer;
using System.IO;
using System.Net;
using System.Net.Cache;
using System.Text.RegularExpressions;
using System.Threading;
using Microsoft.SqlServer.Management;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Common;
using System.Data.SqlClient;
using Microsoft.Win32;
using System.Data;

namespace Spadana_Music
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private Common.Settings mSettings = new Common.Settings(@"MainWindow");
        public Common.Settings Settings
        {
            get
            {
                return mSettings;
            }
        }
        string username;
        public MainWindow(bool isAdmin, string user)
        {
            InitializeComponent();
            username = user;
            if (!isAdmin)
            {
                btnAddEmployee.Visibility = Visibility.Hidden;
                btnAddStudent.Visibility = Visibility.Hidden;
                btnAddTerm.Visibility = Visibility.Hidden;
                finance.Visibility = Visibility.Collapsed;
                manageAccount.Visibility = Visibility.Collapsed;
                delSt.Visibility = editSt.Visibility = Visibility.Collapsed;
                cmTch.Visibility = cmEm.Visibility = cmTr.Visibility = Visibility.Collapsed;

            }

            Thread t = new Thread(new ParameterizedThreadStart(GetFastestNISTDate));
            t.Start("1");
        }

        private void MenuItem_Click_Exite(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void onlineTime_MouseDown(object sender, MouseButtonEventArgs e)
        {
            Thread t = new Thread(new ParameterizedThreadStart(GetFastestNISTDate));
            t.Start("1");
        }

        public void GetFastestNISTDate(object s)
        {
            try
            {
                DateTime dateTime;
                System.Net.HttpWebRequest request = (System.Net.HttpWebRequest)System.Net.WebRequest.Create("http://www.microsoft.com");
                request.Method = "GET";
                request.Accept = "text/html, application/xhtml+xml, */*";
                request.UserAgent = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)";
                request.ContentType = "application/x-www-form-urlencoded";
                request.CachePolicy = new System.Net.Cache.RequestCachePolicy(System.Net.Cache.RequestCacheLevel.NoCacheNoStore);
                System.Net.HttpWebResponse response = (System.Net.HttpWebResponse)request.GetResponse();
                if (response.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    string todaysDates = response.Headers["date"];

                    dateTime = DateTime.ParseExact(todaysDates, "ddd, dd MMM yyyy HH:mm:ss 'GMT'",
                        System.Globalization.CultureInfo.InvariantCulture.DateTimeFormat, System.Globalization.DateTimeStyles.AssumeUniversal);
                    Dispatcher.Invoke(() =>
                    {
                        onlineTime.Text = dateTime.ToString();
                    });
                }
            }
            catch
            {
                Dispatcher.Invoke(() =>
                {
                    onlineTime.Text = "دسترسی به اینترنت نا موفق است";
                });
            }
        }

        private void Window_Activated(object sender, EventArgs e)
        {
            FillTblStudent();
            FillTblTeacher();
            FillTblEmployee();
            fillTblTerm();
            fillTblWeeklyClass();
        }


        private void fillTblWeeklyClass()
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            var qTch = from em in database.Employees
                       where em.Job == "teacher"
                       join t in database.Employee_Pv on em.EID equals t.EID
                       select t;
            cbTchClasses.ItemsSource = qTch.ToList();

            lbCTSat.ItemsSource = (from cr in database.Classes
                                   where cr.day == "شنبه"
                                   join t in database.Employee_Pv on cr.EID equals t.EID
                                   select new { cr.Instr_Name, t.First_Name, t.Last_Name, cr.hour }).ToList();
            lbCTSun.ItemsSource = (from cr in database.Classes
                                   where cr.day == "یک شنبه"
                                   join t in database.Employee_Pv on cr.EID equals t.EID
                                   select new { cr.Instr_Name, t.Last_Name, t.First_Name, cr.hour }).ToList();
            lbCTMon.ItemsSource = (from cr in database.Classes
                                   where cr.day == "دو شنبه"
                                   join t in database.Employee_Pv on cr.EID equals t.EID
                                   select new { cr.Instr_Name, t.Last_Name, t.First_Name, cr.hour }).ToList();
            lbCTues.ItemsSource = (from cr in database.Classes
                                   where cr.day == "سه شنبه"
                                   join t in database.Employee_Pv on cr.EID equals t.EID
                                   select new { cr.Instr_Name, t.Last_Name, t.First_Name, cr.hour }).ToList();
            lbCWed.ItemsSource = (from cr in database.Classes
                                  where cr.day == "چهارشنبه"
                                  join t in database.Employee_Pv on cr.EID equals t.EID
                                  select new { cr.Instr_Name, t.Last_Name, t.First_Name, cr.hour }).ToList();
            lbCTThurs.ItemsSource = (from cr in database.Classes
                                     where cr.day == "پنج شنبه"
                                     join t in database.Employee_Pv on cr.EID equals t.EID
                                     select new { cr.Instr_Name, t.Last_Name, t.First_Name, cr.hour }).ToList();
        }

        private void btnAllDayClasses_Click(object sender, RoutedEventArgs e)
        {
            fillTblWeeklyClass();
        }

        private void cbTchClasses_DropDownClosed(object sender, EventArgs e)
        {
            var db = new Music_Academy_ManagementEntities();
            var t = cbTchClasses.SelectedItem as Employee_Pv;

            var satCl = db.class_info(t.EID, "شنبه").ToList();
            lbCTSat.ItemsSource = (from cl in satCl
                                   join em in db.Employee_Pv on cl.EID equals em.EID
                                   select new { cl.Instr_Name, t.Last_Name, t.First_Name, cl.hour }).ToList();
            var sunCl = db.class_info(t.EID, "یک شنبه").ToList();
            lbCTSun.ItemsSource = (from cl in sunCl
                                   join em in db.Employee_Pv on cl.EID equals em.EID
                                   select new { cl.Instr_Name, t.Last_Name, t.First_Name, cl.hour }).ToList();
            var monCl = db.class_info(t.EID, "دو شنبه").ToList();
            lbCTMon.ItemsSource = (from cl in monCl
                                   join em in db.Employee_Pv on cl.EID equals em.EID
                                   select new { cl.Instr_Name, t.Last_Name, t.First_Name, cl.hour }).ToList();
            var tuesCl = db.class_info(t.EID, "سه شنبه").ToList();
            lbCTues.ItemsSource = (from cl in tuesCl
                                   join em in db.Employee_Pv on cl.EID equals em.EID
                                   select new { cl.Instr_Name, t.Last_Name, t.First_Name, cl.hour }).ToList();
            var wedCl = db.class_info(t.EID, "چهارشنبه").ToList();
            lbCWed.ItemsSource = (from cl in wedCl
                                  join em in db.Employee_Pv on cl.EID equals em.EID
                                  select new { cl.Instr_Name, t.Last_Name, t.First_Name, cl.hour }).ToList();
            var thursCl = db.class_info(t.EID, "پنج شنبه").ToList();
            lbCTThurs.ItemsSource = (from cl in thursCl
                                     join em in db.Employee_Pv on cl.EID equals em.EID
                                     select new { cl.Instr_Name, t.Last_Name, t.First_Name, cl.hour }).ToList();
        }

        //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        void FillTblStudent()
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            var queryS = from st in database.Students select st;
            lbStudent.ItemsSource = queryS.ToList();
        }

        private void MenuItem_Click_EditSt(object sender, RoutedEventArgs e)
        {
            new Win_addStudent(lbStudent.SelectedItem as Student).Show();
            fillTblWeeklyClass();
        }

        private void MenuItem_Click_RemoveSt(object sender, RoutedEventArgs e)
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            Student st = lbStudent.SelectedItem as Student;
            var qSt = (from s in database.Students where s.SID == st.SID select s).First();
            database.Students.Remove(qSt);

            var qClasses = from cl in database.Classes
                           where cl.SID == st.SID
                           select cl;
            database.Classes.RemoveRange(qClasses.ToList());
            database.SaveChanges();
            FillTblStudent();
            fillTblWeeklyClass();
        }

        private void tbSearchStudent_TextChanged(object sender, TextChangedEventArgs e)
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            var qs = from st in database.Students
                     where st.First_Name.Contains(tbSearchStudent.Text) || st.Last_Name.Contains(tbSearchStudent.Text) || st.SID.Contains(tbSearchStudent.Text) || tbSearchStudent.Text == ""
                     select st;
            lbStudent.ItemsSource = qs.ToList();
        }


        private void MenuItem_Click_numAttn(object sender, RoutedEventArgs e)
        {
            var database = new Music_Academy_ManagementEntities();
            Student st = lbStudent.SelectedItem as Student;
            int numAttn = 0;
            var qStr = from stt in database.Student_Term where stt.SID == st.SID select stt.Term_ID;
            foreach (var tr in qStr.ToArray())
                numAttn += database.attendance_state_ById(st.SID, tr).First().Value;
            MessageBox.Show($"تعداد حضوری های کل :{numAttn}");
        }

        ////////////////////////////////////////

        void FillTblTeacher()
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            var qt = from t in database.Employee_Pv
                     join ins in database.Teacher_Instr on t.EID equals ins.EID
                     select new { t.First_Name, t.Last_Name, t.National_Code, t.Phone, ins.Instr_Name, t.EID };
            lbTeacher.ItemsSource = qt.ToList();
        }

        private void tbSearchTeacher_TextChanged(object sender, TextChangedEventArgs e)
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            var qt = from t in database.Employee_Pv
                     join ins in database.Teacher_Instr on t.EID equals ins.EID
                     where (t.First_Name.Contains(tbSearchTeacher.Text) || t.Last_Name.Contains(tbSearchTeacher.Text) || t.EID.Contains(tbSearchTeacher.Text) || tbSearchTeacher.Text == "")
                     select new { t.First_Name, t.Last_Name, t.National_Code, t.Phone, ins.Instr_Name, t.EID };
            lbTeacher.ItemsSource = qt.ToList();
        }

        private void MenuItem_Click_RemoveTCh(object sender, RoutedEventArgs e)
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            TextBlock tEid = new TextBlock();
            Binding b = new Binding();
            b.Source = lbTeacher.SelectedItem;
            b.Path = new PropertyPath("EID");
            b.Mode = BindingMode.OneWay;
            tEid.SetBinding(TextBlock.TextProperty, b);

            var tEmp = (from t in database.Employees where t.EID == tEid.Text select t).First();
            database.Employees.Remove(tEmp);

            var tPv = (from t in database.Employee_Pv where t.EID == tEid.Text select t).First();
            database.Employee_Pv.Remove(tPv);

            var tIns = (from t in database.Teacher_Instr where t.EID == tEid.Text select t).First();
            database.Teacher_Instr.Remove(tIns);

            var tCl = from cl in database.Classes where cl.EID == tEid.Text select cl;
            var sId = from s in tCl select s.SID;
            database.Classes.RemoveRange(tCl);

            var term = from t in database.Terms where t.EID == tEid.Text select t;
            database.Terms.RemoveRange(term);

            var st = from s in database.Students where sId.Contains(s.SID) select s;
            database.Students.RemoveRange(st);

            database.SaveChanges();

            FillTblStudent();
            FillTblTeacher();
            fillTblTerm();
            fillTblWeeklyClass();
        }


        private void MenuItem_Click_editEmp(object sender, RoutedEventArgs e)
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            if ((sender as MenuItem) == miTch)
            {
                TextBlock emId = new TextBlock();
                Binding b = new Binding();
                b.Source = lbTeacher.SelectedItem;
                b.Mode = BindingMode.OneWay;
                b.Path = new PropertyPath("EID");
                emId.SetBinding(TextBlock.TextProperty, b);

                var qEm = (from emp in database.Employees where emp.EID == emId.Text select emp).First();
                var qEmp = (from emp in database.Employee_Pv where emp.EID == emId.Text select emp).First();
                new Win_addEmployee(qEmp, qEm).Show();
            }
            else
            {
                TextBlock emId = new TextBlock();
                Binding b = new Binding();
                b.Source = lbEmployee.SelectedItem;
                b.Mode = BindingMode.OneWay;
                b.Path = new PropertyPath("EID");
                emId.SetBinding(TextBlock.TextProperty, b);

                var qEm = (from emp in database.Employees where emp.EID == emId.Text select emp).First();
                var qEmp = (from emp in database.Employee_Pv where emp.EID == emId.Text select emp).First();
                new Win_addEmployee(qEmp, qEm).Show();
            }
        }
        //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        void FillTblEmployee()
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            var qt = from t in database.Employee_Pv
                     join em in database.Employees on t.EID equals em.EID
                     where em.Job == "employee"
                     select new { t.First_Name, t.Last_Name, t.National_Code, t.Phone, t.EID };
            lbEmployee.ItemsSource = qt.ToList();
        }

        private void tbSearchEmployee_TextChanged(object sender, TextChangedEventArgs e)
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            var qt = from t in database.Employee_Pv
                     where (t.First_Name.Contains(tbSearchEmployee.Text) || t.Last_Name.Contains(tbSearchEmployee.Text) || t.EID.Contains(tbSearchEmployee.Text) || tbSearchEmployee.Text == "")
                     join em in database.Employees on t.EID equals em.EID
                     where em.Job == "employee"
                     select new { t.First_Name, t.Last_Name, t.National_Code, t.Phone, t.EID };
            lbEmployee.ItemsSource = qt.ToList();
        }

        private void MenuItem_Click_RemoveEm(object sender, RoutedEventArgs e)
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            TextBlock tEid = new TextBlock();
            Binding b = new Binding();
            b.Source = lbEmployee.SelectedItem;
            b.Path = new PropertyPath("EID");
            b.Mode = BindingMode.OneWay;
            tEid.SetBinding(TextBlock.TextProperty, b);

            var tEmp = (from t in database.Employees where t.EID == tEid.Text select t).First();
            database.Employees.Remove(tEmp);

            var tPv = (from t in database.Employee_Pv where t.EID == tEid.Text select t).First();
            database.Employee_Pv.Remove(tPv);
            database.SaveChanges();
            FillTblEmployee();
        }

        //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        void fillTblTerm()
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            var qTerm = from tr in database.Terms
                        join pv in database.Employee_Pv on tr.EID equals pv.EID
                        select new { tr.Instr_Name, pv.First_Name, pv.Last_Name, tr.Session_Count, tr.Session_Time, tr.Session_Price, tr.Term_ID };
            lbTerm.ItemsSource = qTerm.ToList();
        }

        private void MenuItem_Click_editTr(object sender, RoutedEventArgs e)
        {
            Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();
            TextBlock tid = new TextBlock();
            Binding b = new Binding();
            b.Source = lbTerm.SelectedItem;
            b.Path = new PropertyPath("Term_ID");
            b.Mode = BindingMode.OneWay;
            tid.SetBinding(TextBlock.TextProperty, b);
            byte id = byte.Parse(tid.Text);
            var qT = (from t in database.Terms where t.Term_ID == id select t).First();
            new Win_addTerm(qT).Show();
        }

        private void MenuItem_Click_RemoveTr(object sender, RoutedEventArgs e)
        {
            var database = new Music_Academy_ManagementEntities();
            TextBlock tid = new TextBlock();
            Binding b = new Binding();
            b.Source = lbTerm.SelectedItem;
            b.Path = new PropertyPath("Term_ID");
            b.Mode = BindingMode.OneWay;
            tid.SetBinding(TextBlock.TextProperty, b);
            byte id = byte.Parse(tid.Text);
            var qT = (from t in database.Terms where t.Term_ID == id select t).First();
            database.Terms.Remove(qT);
            database.SaveChanges();
            fillTblTerm();
        }

        //////////////////////////////////////
        private void btnAddTerm_Click(object sender, RoutedEventArgs e)
        {
            new Win_addTerm().Show();
        }

        private void btnAttendance_Click(object sender, RoutedEventArgs e)
        {
            new Win_attendance().Show();
        }

        private void btnAddEmployee_Click(object sender, RoutedEventArgs e)
        {
            new Win_addEmployee().Show();
        }

        private void btnAddStudent_Click(object sender, RoutedEventArgs e)
        {
            new Win_addStudent().Show();
        }

        private void MenuItem_Click_AboutUs(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("گروه نواوران فناور پیشه اسپادانا\nاعضای گروه:\nعلیرضا غفوری\nمحسن جوادیان\nسید محمدامید دادگر\nسپهر صناعی");
        }

        string BackUpConString = @"data source=.;initial catalog=Music_Academy_Management;integrated security=True;MultipleActiveResultSets=True;";
        private void MenuItem_Click_backup(object sender, RoutedEventArgs e)
        {
            SqlConnection con = new SqlConnection(BackUpConString);
            SaveFileDialog savefd = new SaveFileDialog();
            savefd.Filter = "Backup File (*.Bak)|*.Bak";
            savefd.FileName = DateTime.Now.ToString("ddMMyyyy_HHmmss");
            Nullable<bool> result = savefd.ShowDialog();
            if (result == true)
            {
                string cmd = $@"BACKUP DATABASE [Music_Academy_Management] TO DISK='{savefd.FileName}'";
                using (SqlCommand command = new SqlCommand(cmd, con))
                {
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    command.ExecuteNonQuery();
                    con.Close();
                    MessageBox.Show("ذخیره فایل پشتیبان موفقیت امیز بود");
                }
            }
            try
            {
            }
            catch (Exception ep)
            {
                MessageBox.Show(ep.Message);
            }
        }

        string RestoreConString = @"data source=.;initial catalog=Music_Academy_Management;integrated security=True;MultipleActiveResultSets=True;";

        private void MenuItem_Click_restore(object sender, RoutedEventArgs e)
        {
            using (SqlConnection con = new SqlConnection(RestoreConString))
            {
                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    OpenFileDialog openfd = new OpenFileDialog();
                    openfd.Filter = "Backup File (*.Bak)|*.Bak";

                    Nullable<bool> result = openfd.ShowDialog();
                    if (result == true)
                    {
                        string sqlStmt2 = $@"ALTER DATABASE [Music_Academy_Management] SET SINGLE_USER WITH ROLLBACK IMMEDIATE";
                        SqlCommand bu2 = new SqlCommand(sqlStmt2, con);
                        bu2.ExecuteNonQuery();

                        string sqlStmt3 = $@"USE MASTER RESTORE DATABASE [Music_Academy_Management] FROM DISK='{openfd.FileName}' WITH REPLACE;";
                        SqlCommand bu3 = new SqlCommand(sqlStmt3, con);
                        bu3.ExecuteNonQuery();

                        string sqlStmt4 = @"ALTER DATABASE [Music_Academy_Management] SET MULTI_USER";
                        SqlCommand bu4 = new SqlCommand(sqlStmt4, con);
                        bu4.ExecuteNonQuery();

                        MessageBox.Show("بازگردانی فایل پشتیبان موفقیت امیز بود");
                        con.Close();
                    }
                }
                catch (Exception ep)
                {
                    MessageBox.Show(ep.Message);
                }
            }
        }

        private void Prom_Click(object sender, RoutedEventArgs e)
        {
            if (sender == emProm)
            {
                new Window_addPrice(true).Show();
            }
            else new Window_addPrice(false).Show();

        }

        private void MenuItem_Click_changePass(object sender, RoutedEventArgs e)
        {
            new Win_changePass(username).Show();
        }

        private void MenuItem_Click_manageAccount(object sender, RoutedEventArgs e)
        {
            new Win_manageAccount(username).Show();
        }
    }
}

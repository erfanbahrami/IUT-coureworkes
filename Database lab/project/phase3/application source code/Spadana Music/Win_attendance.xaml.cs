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
    /// Interaction logic for Win_addStudent.xaml
    /// </summary>
    public partial class Win_attendance : Window
    {
        private Settings mSettings = new Settings(@"MainWindow");
        public Common.Settings Settings
        {
            get
            {
                return mSettings;
            }
        }

        Music_Academy_ManagementEntities database;

        public Win_attendance()
        {
            InitializeComponent();
            database = new Music_Academy_ManagementEntities();
            var Att = (from at in database.Attendances group at by new { at.Date_Time.Year, at.Date_Time.Month, at.Date_Time.Day }).ToArray();
            List<DateTime> cbDate = new List<DateTime>();
            for (int i = 0; i < Att.Length; i++)
            {
                var item = Att[i];
                cbDate.Add(new DateTime(item.Key.Year, item.Key.Month, item.Key.Day));
            }
            date.ItemsSource = cbDate;
            string dWeek = "جمعه";
            switch (DateTime.Now.DayOfWeek.ToString())
            {
                case "Saturday":
                    dWeek = "شنبه";
                    break;
                case "Sunday":
                    dWeek = "یک شنبه";
                    break;
                case "Monday":
                    dWeek = "دو شنبه";
                    break;
                case "Tuesday":
                    dWeek = "سه شنبه";
                    break;
                case "Wednesday":
                    dWeek = "چهارشنبه";
                    break;
                case "Thursday":
                    dWeek = "پنج شنبه";
                    break;
            }
            var atThisDay = (from at in database.Attendances where at.Date_Time.Year == DateTime.Now.Year && at.Date_Time.Month == DateTime.Now.Month && at.Date_Time.Day == DateTime.Now.Day select at.SID).ToList();
            var qSTCL = from cl in database.Classes where cl.day == dWeek && !atThisDay.Contains(cl.SID) join st in database.Students on cl.SID equals st.SID select new { st.First_Name, st.Last_Name, cl.Instr_Name, st.SID, Date_Time = DateTime.Now, dayWeek = dWeek, attn = "ثبت نشده" };
            lbAttendance.ItemsSource = qSTCL.ToList();
        }

        private void cancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void addItem_Click(object sender, RoutedEventArgs e)
        {

        }

        void present_click(object sender, RoutedEventArgs e)
        {
            setAttendance(true);
        }


        void absent_click(object sender, RoutedEventArgs e)
        {
            setAttendance(false);
        }

        void allowed_click(object sender, RoutedEventArgs e)
        {
            setAttendance(false, true);
        }

        void setAttendance(bool isPresent, bool allowed = false)
        {
            Label l = new Label();
            Binding b = new Binding();
            b.Source = lbAttendance.SelectedItem;
            b.Path = new PropertyPath("SID");
            b.Mode = BindingMode.OneWay;
            l.SetBinding(Label.ContentProperty, b);
            string sid = l.Content.ToString();
            Binding b2 = new Binding();
            b2.Source = lbAttendance.SelectedItem;
            b2.Path = new PropertyPath("dayWeek");
            b2.Mode = BindingMode.OneWay;
            l.SetBinding(Label.ContentProperty, b2);
            string week = l.Content.ToString();

            var qNewAttn = from stt in database.Student_Term
                           where stt.SID == sid
                           select stt;
            Attendance at = new Attendance();
            at.SID = sid;
            at.Date_Time = DateTime.Now;

            if (isPresent)
                at.Attendance1 = true;
            else
            {
                at.Attendance1 = false;
                if (allowed) at.Allowed = true;
            }

            at.Term_ID = qNewAttn.ToList().First().Term_ID;
            database.Attendances.Add(at);
            database.SaveChanges();

            var atThisDay = (from atp in database.Attendances
                             where atp.Date_Time.Year == DateTime.Now.Year && atp.Date_Time.Month == DateTime.Now.Month && atp.Date_Time.Day == DateTime.Now.Day
                             select atp.SID).ToList();
            var qNewEntireList = from cl in database.Classes
                                 where cl.day == week
                                 join st in database.Students on cl.SID equals st.SID
                                 where !atThisDay.Contains(st.SID)
                                 select new { st.First_Name, st.Last_Name, cl.Instr_Name, st.SID, Date_Time = DateTime.Now, dayWeek = week, attn = "ثبت نشده" };

            lbAttendance.ItemsSource = qNewEntireList.ToList();
            date.ItemsSource = (from atp in database.Attendances select atp).ToList();

            var Att = from atpp in database.Attendances
                      group atpp by new { atpp.Date_Time.Year, atpp.Date_Time.Month, atpp.Date_Time.Day };
            List<DateTime> cbDate = new List<DateTime>();
            foreach (var item in Att)
            {
                cbDate.Add(new DateTime(item.Key.Year, item.Key.Month, item.Key.Day));
            }
            date.ItemsSource = cbDate;
        }

        private void nowDay_Click(object sender, RoutedEventArgs e)
        {
            cntxMenu.IsEnabled = true;
            date.SelectedIndex = -1;

            string dWeek = "جمعه";
            switch (DateTime.Now.DayOfWeek.ToString())
            {
                case "Saturday":
                    dWeek = "شنبه";
                    break;
                case "Sunday":
                    dWeek = "یک شنبه";
                    break;
                case "Monday":
                    dWeek = "دو شنبه";
                    break;
                case "Tuesday":
                    dWeek = "سه شنبه";
                    break;
                case "Wednesday":
                    dWeek = "چهارشنبه";
                    break;
                case "Thursday":
                    dWeek = "پنج شنبه";
                    break;
            }

            var atThisDay = (from at in database.Attendances
                             where at.Date_Time.Year == DateTime.Now.Year && at.Date_Time.Month == DateTime.Now.Month && at.Date_Time.Day == DateTime.Now.Day
                             select at.SID).ToList();
            var qSTCL = from cl in database.Classes
                        where cl.day == dWeek && !atThisDay.Contains(cl.SID)
                        join st in database.Students on cl.SID equals st.SID
                        select new { st.First_Name, st.Last_Name, cl.Instr_Name, st.SID, Date_Time = DateTime.Now, dayWeek = dWeek, attn = "ثبت نشده" };
            lbAttendance.ItemsSource = qSTCL.ToList();

        }

        private void date_DropDownClosed(object sender, EventArgs e)
        {
            if (date.SelectedItem != null)
            {

                DateTime timeSelected = (DateTime)date.SelectedItem;
                var qAttn = from at in database.Attendances
                            where at.Date_Time.Year == timeSelected.Year && at.Date_Time.Month == timeSelected.Month && at.Date_Time.Day == timeSelected.Day
                            join st in database.Students on at.SID equals st.SID
                            join cl in database.Classes on st.SID equals cl.SID
                            select new { st.First_Name, st.Last_Name, cl.Instr_Name, st.SID, Date_Time = DateTime.Now, dayWeek = cl.day, attn = (at.Attendance1 ? "حاضر" : (at.Allowed.Value ? "غیبت موجه" : "غایب")) };
                lbAttendance.ItemsSource = qAttn.ToList();
                cntxMenu.IsEnabled = false;
            }
        }
    }
}

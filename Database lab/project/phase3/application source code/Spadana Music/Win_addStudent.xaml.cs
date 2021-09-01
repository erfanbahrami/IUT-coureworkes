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
using DataModelLayer;
using Common;
using System.Data.Entity.Validation;
using DataGridViewPrinter;
using System.Drawing;
using Color = System.Drawing.Color;

namespace Spadana_Music
{
    /// <summary>
    /// Interaction logic for Win_addStudent.xaml
    /// </summary>
    public partial class Win_addStudent : Window
    {
        private Settings mSettings = new Settings(@"MainWindow");
        public Common.Settings Settings
        {
            get
            {
                return mSettings;
            }
        }
        bool isEdit = false;
        Music_Academy_ManagementEntities database;
        public Win_addStudent()
        {
            InitializeComponent();
            database = new Music_Academy_ManagementEntities();
            var qTerm = from t in database.Terms
                        join ep in database.Employee_Pv on t.EID equals ep.EID
                        select new { t.Instr_Name, t.Session_Price, ep.First_Name, ep.Last_Name, t.Term_ID };
            StudentTerm.ItemsSource = qTerm.ToList();
        }

        string editSid;
        public Win_addStudent(Student st)
        {
            InitializeComponent();
            database = new Music_Academy_ManagementEntities();
            winSt.Title = "ویرایش هنرجو";
            StudentTerm.IsEnabled = false;

            editSid = st.SID;
            studentName.Text = st.First_Name;
            studentLastName.Text = st.Last_Name;
            studentAddress.Text = st.Address;
            studentBirthDate.Text = st.Birth_Date.ToString();
            studentNationalCode.Text = st.National_Code;
            studentPhone.Text = st.Phone;
            studentTel.Text = st.Tel;

            var qCl = from cl in database.Classes
                      where cl.SID == st.SID
                      select cl;
            Class stCl = qCl.ToList().First();
            switch (stCl.day)
            {
                case "شنبه":
                    termDay.SelectedIndex = 0;
                    break;
                case "یک شنبه":
                    termDay.SelectedIndex = 1;
                    break;
                case "دو شنبه":
                    termDay.SelectedIndex = 2;
                    break;
                case "سه شنبه":
                    termDay.SelectedIndex = 3;
                    break;
                case "چهارشنبه":
                    termDay.SelectedIndex = 4;
                    break;
                case "پنج شنبه":
                    termDay.SelectedIndex = 5;
                    break;
                default:
                    break;
            }
            termHour.Text = stCl.hour;
            classNumber.Text = stCl.Number;
            var qStTerm = from stt in database.Student_Term
                          where stt.SID == st.SID
                          join t in database.Terms on stt.Term_ID equals t.Term_ID
                          join ep in database.Employee_Pv on t.EID equals ep.EID
                          select new { t.Instr_Name, t.Session_Price, ep.First_Name, ep.Last_Name, t.Term_ID };
            var qTerm = from t in database.Terms
                        join ep in database.Employee_Pv on t.EID equals ep.EID
                        select new { t.Instr_Name, t.Session_Price, ep.First_Name, ep.Last_Name, t.Term_ID };
            StudentTerm.ItemsSource = qTerm.ToList();
            StudentTerm.SelectedItem = qStTerm.ToList().First();

            var qStTermNum = from stt in database.Student_Term
                             where stt.SID == st.SID
                             select stt;
            termNumber.Text = qStTermNum.ToList().First().Term_Num.ToString();
            isEdit = true;
        }

        private void cancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void addItem_Click(object sender, RoutedEventArgs e)
        {
            if (isEdit) editStudent();
            else addNewStudent();

        }

        void editStudent()
        {
            try
            {
                Student st = new Student();
                st.First_Name = studentName.Text;
                st.Last_Name = studentLastName.Text;
                st.National_Code = studentNationalCode.Text;
                st.Phone = studentPhone.Text;
                st.Tel = studentTel.Text;
                st.SID = editSid;
                st.Address = studentAddress.Text;
                st.Birth_Date = DateTime.Parse(studentBirthDate.Text);

                var term2 = (from clt in database.Classes where clt.SID == st.SID select clt).ToList().First();
                Class cl = new Class();
                cl.Number = classNumber.Text;
                cl.day = (termDay.SelectedItem as ComboBoxItem).Content as string;
                cl.hour = termHour.Text;
                cl.SID = st.SID;
                cl.EID = term2.EID;
                cl.Instr_Name = term2.Instr_Name;

                database.update_student(st.SID, st.First_Name, st.Last_Name, st.Birth_Date, st.National_Code, st.Phone, st.Tel, st.Address);
                database.update_Class(cl.Number, cl.day, cl.hour, cl.EID, cl.Instr_Name, cl.SID);

                database.SaveChanges();
                this.Close();
            }
            catch (DbEntityValidationException ex)
            {
                foreach (var eve in ex.EntityValidationErrors)
                {
                    foreach (var ve in eve.ValidationErrors)
                    {
                        MessageBox.Show($"موارد وارد شده را تصحیح کنید!\n- Property: \"{ve.PropertyName}\", Error: \"{ve.ErrorMessage}\"");
                    }
                }
            }
            catch
            {
                MessageBox.Show("داده ها را کامل وارد کنید!");
            }
        }

        void addNewStudent()
        {
            try
            {
                Student st = new Student();
                st.First_Name = studentName.Text;
                st.Last_Name = studentLastName.Text;
                st.National_Code = studentNationalCode.Text;
                st.Phone = studentPhone.Text;
                st.Tel = studentTel.Text;
                st.SID = ((DateTime.Now.ToFileTime() / 100000000) % 100000000).ToString();
                st.Address = studentAddress.Text;
                st.Birth_Date = DateTime.Parse(studentBirthDate.Text);
                database.Students.Add(st);

                Payment p = new Payment();
                p.Pay_ID = ((DateTime.Now.ToFileTime() / 100000000) % 10000000000).ToString();
                p.Time = DateTime.Now;
                database.Payments.Add(p);

                Student_Term stt = new Student_Term();
                Binding b = new Binding();
                b.Source = StudentTerm.SelectedItem;
                b.Path = new PropertyPath("Term_ID");
                b.Mode = BindingMode.OneWay;
                TextBlock t = new TextBlock();
                t.SetBinding(TextBlock.TextProperty, b);
                stt.Term_ID = byte.Parse(t.Text);
                stt.Register_Date = DateTime.Now;
                var term2 = database.Terms.Find(stt.Term_ID);
                stt.End_Date = DateTime.Now.AddDays(((double)term2.Session_Count - 1) * 7);
                stt.Term_Num = byte.Parse(termNumber.Text);
                stt.SID = st.SID;
                stt.Pay_ID = p.Pay_ID;
                database.Student_Term.Add(stt);


                Class cl = new Class();
                cl.Number = classNumber.Text;
                cl.day = (termDay.SelectedItem as ComboBoxItem).Content as string;
                cl.hour = termHour.Text;
                cl.SID = st.SID;
                cl.EID = term2.EID;
                cl.Instr_Name = term2.Instr_Name;
                database.Classes.Add(cl);

                database.SaveChanges();
                if (MessageBox.Show("آیا میخواهید رسید چاپ شود؟", "چاپ رسید", MessageBoxButton.YesNo) == MessageBoxResult.Yes)
                {
                    using (var dg = new System.Windows.Forms.DataGridView())
                    {

                        dg.Columns.Add("column1","نام");
                        dg.Columns.Add("column1", "نام خوانوادگی");
                        dg.Columns.Add("column1", "ترم ثبت نام شده");
                        dg.Columns.Add("column1", "مبلغ قابل پرداخت");
                        dg.Columns.Add("column1", "تاریخ");

                        dg.Columns[0].Width = 100;
                        dg.Columns[1].Width = 100;
                        dg.Columns[2].Width = 100;
                        dg.Columns[3].Width = 100;
                        dg.Columns[4].Width = 100;

                        var price = from tr in database.Terms where tr.Term_ID == stt.Term_ID select tr.Session_Price;
                        dg.Rows.Add(st.First_Name, st.Last_Name, cl.Instr_Name,price.First().ToString(), p.Time);
                        DGVPrinter printer = new DGVPrinter();
                        printer.CellAlignment = StringAlignment.Center;
                        printer.CellFormatFlags = StringFormatFlags.DirectionRightToLeft;

                        printer.PageNumbers = true;
                        printer.PageNumberAlignment = StringAlignment.Center;

                        printer.HeaderCellAlignment = StringAlignment.Center;
                        printer.HeaderCellFormatFlags = StringFormatFlags.DirectionRightToLeft;

                        printer.PorportionalColumns = true;

                        printer.Title = "رسید چاپ";
                        printer.TitleAlignment = StringAlignment.Center;
                        printer.TitleColor = Color.Red;
                        printer.TitleFormatFlags = StringFormatFlags.DirectionRightToLeft;

                        printer.PrintPreviewDataGridView(dg);
                    }
                }
                this.Close();
            }
            catch (DbEntityValidationException ex)
            {
                foreach (var eve in ex.EntityValidationErrors)
                {
                    foreach (var ve in eve.ValidationErrors)
                    {
                        MessageBox.Show($"موارد وارد شده را تصحیح کنید!\n- Property: \"{ve.PropertyName}\", Error: \"{ve.ErrorMessage}\"");
                    }
                }
            }
            catch
            {
                MessageBox.Show("داده ها را کامل وارد کنید!");
            }
        }
    }
}

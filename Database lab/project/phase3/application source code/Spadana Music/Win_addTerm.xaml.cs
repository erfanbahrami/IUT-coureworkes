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
using System.Data.Entity.Validation;
using Common;

namespace Spadana_Music
{
    /// <summary>
    /// Interaction logic for Win_addStudent.xaml
    /// </summary>
    public partial class Win_addTerm : Window
    {
        private Settings mSettings = new Settings(@"MainWindow");
        public Common.Settings Settings
        {
            get
            {
                return mSettings;
            }
        }
        public Win_addTerm()
        {
            InitializeComponent();
            var qTch = from t in database.Employees
                       where t.Job == "teacher"
                       join pv in database.Employee_Pv on t.EID equals pv.EID
                       select pv;
            teacher.ItemsSource = qTch.ToList();
        }
        bool isEdit = false;
        Term editTr;
        Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();

        public Win_addTerm(Term tr)
        {
            InitializeComponent();
            isEdit = true;
            editTr = tr;
            winTerm.Title = "ویرایش ترم";
            instrName.Text = tr.Instr_Name;
            sessionCount.Text = tr.Session_Count.ToString();
            sessionPrice.Text = tr.Session_Price.ToString();
            sessionTime.Text = tr.Session_Time.ToString();
            var qTch = from t in database.Employee_Pv where t.EID == tr.EID select t;
            teacher.ItemsSource = qTch.ToList();
            teacher.SelectedItem = qTch.First();
            teacher.IsEnabled = false;
        }

        private void cancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        void addNewTerm()
        {
            try
            {
                Term tr = new Term();
                tr.Term_ID = (byte)((DateTime.Now.ToFileTime() / 100000000000) % 100000000000);
                tr.EID = (teacher.SelectedItem as Employee_Pv).EID;
                tr.Instr_Name = instrName.Text;
                tr.Session_Count = byte.Parse(sessionCount.Text);
                tr.Session_Price = int.Parse(sessionPrice.Text);
                tr.Session_Time = byte.Parse(sessionTime.Text);
                database.Terms.Add(tr);
                Teacher_Instr ti = new Teacher_Instr();
                ti.EID = tr.EID;
                ti.Instr_Name = tr.Instr_Name;
                database.Teacher_Instr.Add(ti);
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

        void editTerm()
        {
            try
            {
                database.update_Term(editTr.Term_ID, editTr.EID, instrName.Text, byte.Parse(sessionCount.Text), int.Parse(sessionPrice.Text), byte.Parse(sessionTime.Text));
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

        private void addItem_Click(object sender, RoutedEventArgs e)
        {
            if (isEdit) editTerm();
            else addNewTerm();
        }
    }
}

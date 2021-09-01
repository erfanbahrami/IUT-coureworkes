using Common;
using DataModelLayer;
using System;
using System.Data.Entity.Validation;
using System.Linq;
using System.Windows;

namespace Spadana_Music
{
    /// <summary>
    /// Interaction logic for Win_addStudent.xaml
    /// </summary>
    public partial class Win_addEmployee : Window
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
        Music_Academy_ManagementEntities database = new Music_Academy_ManagementEntities();

        public Win_addEmployee()
        {
            InitializeComponent();
            promote.Text = "0";
        }

        bool editMarital;
        Employee editEm;
        public Win_addEmployee(Employee_Pv emPv, Employee em)
        {
            InitializeComponent();
            isEdit = true;
            addEmployee.Title = "ویرایش اطلاعات";
            promote.Text = "0";
            editEm = em;
            emName.Text = emPv.First_Name;
            emLastName.Text = emPv.Last_Name;
            emBirthDate.Text = emPv.Birth_Date.ToString();
            emAddress.Text = emPv.Address;
            rbIsMarital.IsChecked = emPv.Marital;
            emNationalCode.Text = emPv.National_Code;
            emPhone.Text = emPv.Phone;
            emTel.Text = emPv.Tel;
            emInsNum.Text = em.Insurance_Num.ToString();
            emSalary.Text = em.Base_Salary.ToString();
            rbIsTch.IsChecked = true;

            if (emPv.Marital)
            {
                editMarital = true;
                rbIsMarital.IsChecked = true;
                rbIsAlone.IsEnabled = false;
            }
            else
            {
                editMarital = false;
                rbIsAlone.IsChecked = true;
                rbIsMarital.IsEnabled = false;
            }
            if (em.Job == "teacher")
            {
                rbIsTch.IsChecked = true;
                rbIsEm.IsEnabled = false;
            }
            else
            {
                rbIsEm.IsChecked = true;
                rbIsTch.IsEnabled = false;
            }

        }

        void addNewEmployee()
        {
            try
            {
                Employee_Pv emPv = new Employee_Pv();
                emPv.First_Name = emName.Text;
                emPv.Last_Name = emLastName.Text;
                emPv.Birth_Date = DateTime.Parse(emBirthDate.Text);
                emPv.Address = emAddress.Text;
                emPv.EID = ((DateTime.Now.ToFileTime() / 100000000) % 100000000).ToString();
                emPv.Marital = rbIsMarital.IsChecked.Value;
                emPv.National_Code = emNationalCode.Text;
                emPv.Phone = emPhone.Text;
                emPv.Tel = emTel.Text;
                database.Employee_Pv.Add(emPv);

                Employee em = new Employee();
                em.EID = emPv.EID;
                em.Base_Salary = int.Parse(emSalary.Text);
                em.Entrance_Date = DateTime.Now;
                em.Insurance_Num = int.Parse(emInsNum.Text);
                em.Job = rbIsTch.IsChecked.Value ? "teacher" : "employee";
                database.Employees.Add(em);
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

        void editEmployee()
        {
            try
            {
                database.update_Employee_Pv(editEm.EID, emName.Text, emLastName.Text, DateTime.Parse(emBirthDate.Text), emNationalCode.Text, emPhone.Text, emTel.Text, emAddress.Text, editMarital);
                database.update_Employee(editEm.EID, int.Parse(emSalary.Text), editEm.Entrance_Date, editEm.Exit_Date, editEm.Job, editEm.Overtime, int.Parse(emInsNum.Text));
                utility.promotionSalary(editEm.EID, int.Parse(promote.Text));
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

        private void cancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void addItem_Click(object sender, RoutedEventArgs e)
        {
            if (isEdit) editEmployee();
            else addNewEmployee();
        }


    }
    public static class utility
    {
        static utility() { }
        public static Nullable<int> promotionSalary(string eId, int percent)
        {
            using (var db = new DataModelLayer.Music_Academy_ManagementEntities())
            {
                if (-50 < percent && percent < 100)
                {
                    db.promotion2(eId, (byte)percent);
                    int qS = (from em in db.Employees where em.EID == eId select em.Base_Salary).First().Value;
                    return qS;
                }
                return null;
            }
        }
    }
}

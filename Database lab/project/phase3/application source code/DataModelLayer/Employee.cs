//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DataModelLayer
{
    using System;
    using System.Collections.Generic;
    
    public partial class Employee
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Employee()
        {
            this.Teacher_Instr = new HashSet<Teacher_Instr>();
        }
    
        public string EID { get; set; }
        public Nullable<int> Base_Salary { get; set; }
        public System.DateTime Entrance_Date { get; set; }
        public Nullable<System.DateTime> Exit_Date { get; set; }
        public string Job { get; set; }
        public Nullable<byte> Overtime { get; set; }
        public int Insurance_Num { get; set; }
    
        public virtual Employee_Pv Employee_Pv { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Teacher_Instr> Teacher_Instr { get; set; }
    }
}
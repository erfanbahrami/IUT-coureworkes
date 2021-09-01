using Microsoft.VisualStudio.TestTools.UnitTesting;
using DataModelLayer;
using System;
using System.Linq;
using System.Windows;

namespace UnitTestProject
{
    [TestClass]
    public class UnitTest1
    {
        public Music_Academy_ManagementEntities dataBase=new Music_Academy_ManagementEntities();
        [TestMethod]
        public void TestMethod1()
        {
            Nullable<int> actualSlr = Spadana_Music.utility.promotionSalary("24058656",-100);
            Assert.AreEqual(expected: null, actual: actualSlr);
        }
        [TestMethod]
        public void TestMethod2()
        {
            Nullable<int> actualSlr = Spadana_Music.utility.promotionSalary("24058656", -50);
            Assert.AreEqual(expected: null, actual: actualSlr);
        }
        [TestMethod]
        public void TestMethod3()
        {
            var qSl = (from em in dataBase.Employees where em.EID == "24058656" select em.Base_Salary).First().Value;
            qSl -= (int)(qSl / .25);
            Nullable<int> actualSlr = Spadana_Music.utility.promotionSalary("24058656", -25);
            Assert.AreEqual(expected: null, actual: actualSlr);
        }
        [TestMethod]
        public void TestMethod4()
        {
            var qSl = (from em in dataBase.Employees where em.EID == "24058656" select em.Base_Salary).First().Value;
            qSl += (int)(qSl / .5);
            Nullable<int> actualSlr = Spadana_Music.utility.promotionSalary("24058656", 50);
            Assert.AreEqual(expected: qSl, actual: actualSlr);
        }
        [TestMethod]
        public void TestMethod5()
        {
            Nullable<int> actualSlr = Spadana_Music.utility.promotionSalary("24058656", 100);
            Assert.AreEqual(expected: null, actual: actualSlr);
        }
        [TestMethod]
        public void TestMethod6()
        {
            Nullable<int> actualSlr = Spadana_Music.utility.promotionSalary("24058656", 150);
            Assert.AreEqual(expected: null, actual: actualSlr);
        }
    }
}

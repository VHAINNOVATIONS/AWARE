using System;
using System.Diagnostics;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using AWARE_SQL_Transporter;
using System.IO;

namespace AWARE_SQL_TransporterTests
{
    /// <summary>
    /// Summary description for SQLTransporterTests
    /// </summary>
    [TestClass]
    public class SQLTransporterTests
    {
        public SQLTransporterTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        /// <summary>
        /// This test validates the creation of the log file when one does not exist, to do this we have to delete
        /// any previously created log file from a result of this test.
        /// </summary>
        [TestMethod]
        public void ManageLogFile_NoLogFileExistCreate()
        {
            string logFileName = "AWARE_SQL_Transporter.log";
            string theCurrentLogFile = Directory.GetCurrentDirectory() + "\\" + logFileName;
            if (true == File.Exists(logFileName))
            {
                File.Delete(logFileName);
            }

            SQLTransporter sqlTrns = new SQLTransporter("MyTestServer");
            sqlTrns.ManageLogFiles();
            Assert.IsTrue(File.Exists(logFileName));
        }

        /// <summary>
        /// This test gets the amount of disk space free and compares it to a known value
        /// Because disk space can change during execution we're really just ensuring it 
        /// returns a value greater than the known
        /// </summary>
        [TestMethod]
        public void GetFreeDiskSpace()
        {
            long knownFreeSpace = 136883;
            long fetchedFreeSpace = 0;
            SQLTransporter sqlTrns = new SQLTransporter("MyTestServer");
            fetchedFreeSpace = sqlTrns.GetFreeDiskSpace();

            Assert.IsTrue(knownFreeSpace < fetchedFreeSpace);
        }

        /// <summary>
        /// This validates that a string passed is of a valid date time string
        /// </summary>
        [TestMethod]
        public void ValidateDateTimeStringValue()
        {
            DateTime timeNow = DateTime.Now;
            SQLTransporter sqlTrns = new SQLTransporter("MyTestServer");
            DateTime retDT;
            DateTime.TryParse(sqlTrns.ValidateDateTimeStringValue(timeNow.ToString("o")), out retDT);

            Assert.AreEqual(timeNow, retDT);
        }

        /// <summary>
        /// This test validates that a string with a single quote occurance is modified to prevent
        /// sql injection hits
        /// </summary>
        [TestMethod]
        public void FormatSqlValue()
        {
            string inputString = "I'left'my'secret'decoder'ring'at'home";
            string expectedString = "I''left''my''secret''decoder''ring''at''home";

            SQLTransporter sqlTrns = new SQLTransporter("MyTestServer");
            Assert.AreEqual(expectedString, sqlTrns.FormatSqlValue(inputString));
        }

        /// <summary>
        /// This test validates the getting version string from the app.config
        /// </summary>
        [TestMethod]
        public void GetBuildVersion()
        {
            AppSettings appstgs = new AppSettings();
            string directVersion = appstgs.ApplicationVersion;

            SQLTransporter sqlTrns = new SQLTransporter("MyTestServer");
            Assert.AreEqual(directVersion, sqlTrns.GetBuildVersion());
        }
    }
}

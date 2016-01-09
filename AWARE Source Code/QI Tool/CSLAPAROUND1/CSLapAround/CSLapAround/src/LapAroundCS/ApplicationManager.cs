using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace LapAroundCS.Application
{
    static class ApplicationManager
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        private static void Main(string[] args)
        {
            System.Windows.Forms.Application.EnableVisualStyles();
            System.Windows.Forms.Application.SetCompatibleTextRenderingDefault(false);

            MessageBox.Show("Starting LapAround CS Application" + System.Environment.NewLine +
                "in the Main procedure of Application Manager.", "Main");

            if (args.Length == 0)
            {
                MessageBox.Show("No arguments", "Program Arguments");
            }
            else
            {
                try
                {
                    for (int i = 0; i < args.Length; i++)
                    {
                        if (i == 0)
                        {
                            // expected input is "ecptest.houston.med.va.gov:19019;DUZ;station#508"
                            string[] input1 = args[i].Split(';');
                            //string ipAddress = "23.21.114.197:9300" ;// input1[0];
                            string ipAddress = "75.101.135.12:9300" ;// input1[0];
                            //string ipAddress = "184.73.210.13:9200" ;// input1[0];
                            string duz = "10000000210"; // input1[1];
                            string station = "500"; // input1[2];

                            MessageBox.Show("Input Arguments: " + args[i].ToString() + System.Environment.NewLine + System.Environment.NewLine +
                                    "Input Arguments parsed:" + System.Environment.NewLine + System.Environment.NewLine +
                                    " IPAddress: " + ipAddress + System.Environment.NewLine +
                                    " duz: " + duz + System.Environment.NewLine +
                                    " station: " + station + ".", "Program Arguments");
                        }
                    }
                }
                catch
                {
                    // TODO still need error handling
                }
            }

            System.Windows.Forms.Application.Run(new Form1());
        }
    }
}

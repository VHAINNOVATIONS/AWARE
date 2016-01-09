using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LapAroundCS.Application
{
    class DataSetUse
    {
        static void Start()
        {
            string connectionString = GetConnectionString();
            ConnectToData(connectionString);
        }

        public static void ConnectToData(string connectionString)
        {
            //Create a SqlConnection to the AWARE database. 
            using (SqlConnection connection =
                       new SqlConnection(connectionString))
            {
                //Create a SqlDataAdapter for the Suppliers table.
                SqlDataAdapter adapter = new SqlDataAdapter();

                // A table mapping names the DataTable.
                adapter.TableMappings.Add("Table", "Suppliers");

                // Open the connection.
                connection.Open();
                Console.WriteLine("The SqlConnection is open.");

                // Create a SqlCommand to retrieve Suppliers data.
                SqlCommand command = new SqlCommand(
                    "SELECT SupplierID, CompanyName FROM dbo.Suppliers;",
                    connection);
                command.CommandType = CommandType.Text;

                // Set the SqlDataAdapter's SelectCommand.
                adapter.SelectCommand = command;

                // Fill the DataSet.
                DataSet dataSet = new DataSet("Suppliers");
                adapter.Fill(dataSet);

                // Create a second Adapter and Command to get 
                // the Products table, a child table of Suppliers. 
                SqlDataAdapter productsAdapter = new SqlDataAdapter();
                productsAdapter.TableMappings.Add("Table", "Products");

                SqlCommand productsCommand = new SqlCommand(
                    "SELECT ProductID, SupplierID FROM dbo.Products;",
                    connection);
                productsAdapter.SelectCommand = productsCommand;

                // Fill the DataSet.
                productsAdapter.Fill(dataSet);

                // Close the connection.
                connection.Close();
                Console.WriteLine("The SqlConnection is closed.");

                // Create a DataRelation to link the two tables 
                // based on the SupplierID.
                DataColumn parentColumn =
                    dataSet.Tables["Suppliers"].Columns["SupplierID"];
                DataColumn childColumn =
                    dataSet.Tables["Products"].Columns["SupplierID"];
                DataRelation relation =
                    new System.Data.DataRelation("SuppliersProducts",
                    parentColumn, childColumn);
                dataSet.Relations.Add(relation);
                Console.WriteLine(
                    "The {0} DataRelation has been created.",
                    relation.RelationName);
            }
        }

        static private string GetConnectionString()
        {
            // To avoid storing the connection string in your code,  
            // you can retrieve it from a configuration file. 
            return "Data Source=(local);Initial Catalog=AWARE;"
                + "Integrated Security=SSPI";
        }
    }   
}

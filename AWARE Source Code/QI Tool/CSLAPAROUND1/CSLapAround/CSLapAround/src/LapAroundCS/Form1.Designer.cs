namespace LapAroundCS.Application
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.Button joinStringsButton;
            this.vsATextBox = new System.Windows.Forms.TextBox();
            this.vsBTextBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.treeView1 = new System.Windows.Forms.TreeView();
            this.vsResultTextbox = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.clearButton = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            joinStringsButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // joinStringsButton
            // 
            joinStringsButton.Location = new System.Drawing.Point(64, 185);
            joinStringsButton.Name = "joinStringsButton";
            joinStringsButton.Size = new System.Drawing.Size(100, 23);
            joinStringsButton.TabIndex = 8;
            joinStringsButton.Text = "Start RPC";
            joinStringsButton.UseVisualStyleBackColor = true;
            joinStringsButton.Click += new System.EventHandler(this.joinStringsButton_Click);
            // 
            // vsATextBox
            // 
            this.vsATextBox.Location = new System.Drawing.Point(64, 80);
            this.vsATextBox.Name = "vsATextBox";
            this.vsATextBox.Size = new System.Drawing.Size(191, 20);
            this.vsATextBox.TabIndex = 0;
            // 
            // vsBTextBox
            // 
            this.vsBTextBox.Location = new System.Drawing.Point(64, 132);
            this.vsBTextBox.Name = "vsBTextBox";
            this.vsBTextBox.Size = new System.Drawing.Size(191, 20);
            this.vsBTextBox.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(64, 65);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(30, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "DUZ";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(67, 117);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(60, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Other Input";
            // 
            // comboBox1
            // 
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(267, 78);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(270, 21);
            this.comboBox1.TabIndex = 4;
            // 
            // treeView1
            // 
            this.treeView1.Location = new System.Drawing.Point(13, 324);
            this.treeView1.Name = "treeView1";
            this.treeView1.Size = new System.Drawing.Size(585, 205);
            this.treeView1.TabIndex = 5;
            // 
            // vsResultTextbox
            // 
            this.vsResultTextbox.Location = new System.Drawing.Point(64, 271);
            this.vsResultTextbox.Name = "vsResultTextbox";
            this.vsResultTextbox.ReadOnly = true;
            this.vsResultTextbox.Size = new System.Drawing.Size(191, 20);
            this.vsResultTextbox.TabIndex = 6;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(64, 256);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(80, 13);
            this.label3.TabIndex = 7;
            this.label3.Text = "RPC Parameter";
            // 
            // clearButton
            // 
            this.clearButton.Location = new System.Drawing.Point(462, 268);
            this.clearButton.Name = "clearButton";
            this.clearButton.Size = new System.Drawing.Size(75, 23);
            this.clearButton.TabIndex = 9;
            this.clearButton.Text = "Clear";
            this.clearButton.UseVisualStyleBackColor = true;
            this.clearButton.Click += new System.EventHandler(this.clearButton_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(269, 65);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(68, 13);
            this.label4.TabIndex = 10;
            this.label4.Text = "RPC Options";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(610, 541);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.clearButton);
            this.Controls.Add(joinStringsButton);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.vsResultTextbox);
            this.Controls.Add(this.treeView1);
            this.Controls.Add(this.comboBox1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.vsBTextBox);
            this.Controls.Add(this.vsATextBox);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox vsATextBox;
        private System.Windows.Forms.TextBox vsBTextBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.TreeView treeView1;
        private System.Windows.Forms.TextBox vsResultTextbox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button clearButton;
        private System.Windows.Forms.Label label4;

    }
}
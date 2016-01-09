namespace AwareDbUtility
{
    partial class Dlg_Main
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Dlg_Main));
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnBegin = new System.Windows.Forms.Button();
            this.rbtnUpdateDb = new System.Windows.Forms.RadioButton();
            this.rbtnCreateDb = new System.Windows.Forms.RadioButton();
            this.btnDbScriptsBrowse = new System.Windows.Forms.Button();
            this.tbxDbScriptFiles = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.btnDbLogBrowse = new System.Windows.Forms.Button();
            this.btnDbFileBrowse = new System.Windows.Forms.Button();
            this.tbxDbLogFilePath = new System.Windows.Forms.TextBox();
            this.tbxDbDataFilePath = new System.Windows.Forms.TextBox();
            this.tbxDbName = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.rtbxDbStatus = new System.Windows.Forms.RichTextBox();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnCancel);
            this.groupBox1.Controls.Add(this.btnBegin);
            this.groupBox1.Controls.Add(this.rbtnUpdateDb);
            this.groupBox1.Controls.Add(this.rbtnCreateDb);
            this.groupBox1.Controls.Add(this.btnDbScriptsBrowse);
            this.groupBox1.Controls.Add(this.tbxDbScriptFiles);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.btnDbLogBrowse);
            this.groupBox1.Controls.Add(this.btnDbFileBrowse);
            this.groupBox1.Controls.Add(this.tbxDbLogFilePath);
            this.groupBox1.Controls.Add(this.tbxDbDataFilePath);
            this.groupBox1.Controls.Add(this.tbxDbName);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(7, 8);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(479, 179);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "AWARE database options";
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(250, 147);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 23);
            this.btnCancel.TabIndex = 8;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnBegin
            // 
            this.btnBegin.Location = new System.Drawing.Point(153, 147);
            this.btnBegin.Name = "btnBegin";
            this.btnBegin.Size = new System.Drawing.Size(75, 23);
            this.btnBegin.TabIndex = 7;
            this.btnBegin.Text = "Begin";
            this.btnBegin.UseVisualStyleBackColor = true;
            this.btnBegin.Click += new System.EventHandler(this.btnBegin_Click);
            // 
            // rbtnUpdateDb
            // 
            this.rbtnUpdateDb.AutoSize = true;
            this.rbtnUpdateDb.Location = new System.Drawing.Point(283, 122);
            this.rbtnUpdateDb.Name = "rbtnUpdateDb";
            this.rbtnUpdateDb.Size = new System.Drawing.Size(109, 17);
            this.rbtnUpdateDb.TabIndex = 12;
            this.rbtnUpdateDb.TabStop = true;
            this.rbtnUpdateDb.Text = "Update Database";
            this.rbtnUpdateDb.UseVisualStyleBackColor = true;
            // 
            // rbtnCreateDb
            // 
            this.rbtnCreateDb.AutoSize = true;
            this.rbtnCreateDb.Location = new System.Drawing.Point(117, 122);
            this.rbtnCreateDb.Name = "rbtnCreateDb";
            this.rbtnCreateDb.Size = new System.Drawing.Size(105, 17);
            this.rbtnCreateDb.TabIndex = 11;
            this.rbtnCreateDb.TabStop = true;
            this.rbtnCreateDb.Text = "Create Database";
            this.rbtnCreateDb.UseVisualStyleBackColor = true;
            // 
            // btnDbScriptsBrowse
            // 
            this.btnDbScriptsBrowse.Location = new System.Drawing.Point(398, 94);
            this.btnDbScriptsBrowse.Name = "btnDbScriptsBrowse";
            this.btnDbScriptsBrowse.Size = new System.Drawing.Size(75, 23);
            this.btnDbScriptsBrowse.TabIndex = 6;
            this.btnDbScriptsBrowse.Text = "Browse";
            this.btnDbScriptsBrowse.UseVisualStyleBackColor = true;
            this.btnDbScriptsBrowse.Click += new System.EventHandler(this.BrowseForFolder);
            // 
            // tbxDbScriptFiles
            // 
            this.tbxDbScriptFiles.Location = new System.Drawing.Point(117, 96);
            this.tbxDbScriptFiles.Name = "tbxDbScriptFiles";
            this.tbxDbScriptFiles.Size = new System.Drawing.Size(275, 20);
            this.tbxDbScriptFiles.TabIndex = 5;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(27, 99);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(91, 13);
            this.label4.TabIndex = 8;
            this.label4.Text = "Database Scripts:";
            // 
            // btnDbLogBrowse
            // 
            this.btnDbLogBrowse.Location = new System.Drawing.Point(398, 69);
            this.btnDbLogBrowse.Name = "btnDbLogBrowse";
            this.btnDbLogBrowse.Size = new System.Drawing.Size(75, 23);
            this.btnDbLogBrowse.TabIndex = 4;
            this.btnDbLogBrowse.Text = "Browse";
            this.btnDbLogBrowse.UseVisualStyleBackColor = true;
            this.btnDbLogBrowse.Click += new System.EventHandler(this.BrowseForFolder);
            // 
            // btnDbFileBrowse
            // 
            this.btnDbFileBrowse.Location = new System.Drawing.Point(398, 44);
            this.btnDbFileBrowse.Name = "btnDbFileBrowse";
            this.btnDbFileBrowse.Size = new System.Drawing.Size(75, 23);
            this.btnDbFileBrowse.TabIndex = 2;
            this.btnDbFileBrowse.Text = "Browse";
            this.btnDbFileBrowse.UseVisualStyleBackColor = true;
            this.btnDbFileBrowse.Click += new System.EventHandler(this.BrowseForFolder);
            // 
            // tbxDbLogFilePath
            // 
            this.tbxDbLogFilePath.Location = new System.Drawing.Point(117, 71);
            this.tbxDbLogFilePath.Name = "tbxDbLogFilePath";
            this.tbxDbLogFilePath.Size = new System.Drawing.Size(275, 20);
            this.tbxDbLogFilePath.TabIndex = 3;
            // 
            // tbxDbDataFilePath
            // 
            this.tbxDbDataFilePath.Location = new System.Drawing.Point(117, 46);
            this.tbxDbDataFilePath.Name = "tbxDbDataFilePath";
            this.tbxDbDataFilePath.Size = new System.Drawing.Size(275, 20);
            this.tbxDbDataFilePath.TabIndex = 1;
            // 
            // tbxDbName
            // 
            this.tbxDbName.Location = new System.Drawing.Point(117, 22);
            this.tbxDbName.Name = "tbxDbName";
            this.tbxDbName.Size = new System.Drawing.Size(74, 20);
            this.tbxDbName.TabIndex = 0;
            this.tbxDbName.Text = "AWARE";
            this.tbxDbName.Leave += new System.EventHandler(this.tbxDbName_Leave);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(71, 74);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(47, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "Log File:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(66, 49);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(52, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Data File:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(31, 25);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(87, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Database Name:";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.rtbxDbStatus);
            this.groupBox2.Location = new System.Drawing.Point(7, 193);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(479, 256);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Status";
            // 
            // rtbxDbStatus
            // 
            this.rtbxDbStatus.Location = new System.Drawing.Point(6, 16);
            this.rtbxDbStatus.Name = "rtbxDbStatus";
            this.rtbxDbStatus.Size = new System.Drawing.Size(466, 234);
            this.rtbxDbStatus.TabIndex = 0;
            this.rtbxDbStatus.Text = "";
            // 
            // Dlg_Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(493, 457);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Dlg_Main";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "AWARE Database Utility";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox tbxDbLogFilePath;
        private System.Windows.Forms.TextBox tbxDbDataFilePath;
        private System.Windows.Forms.TextBox tbxDbName;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btnDbScriptsBrowse;
        private System.Windows.Forms.TextBox tbxDbScriptFiles;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnDbLogBrowse;
        private System.Windows.Forms.Button btnDbFileBrowse;
        private System.Windows.Forms.RadioButton rbtnUpdateDb;
        private System.Windows.Forms.RadioButton rbtnCreateDb;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnBegin;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.RichTextBox rtbxDbStatus;

    }
}


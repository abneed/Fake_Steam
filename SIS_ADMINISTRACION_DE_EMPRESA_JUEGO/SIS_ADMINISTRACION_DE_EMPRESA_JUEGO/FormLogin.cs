﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace SIS_ADMINISTRACION_DE_EMPRESA_JUEGO
{
    public partial class FormLogin : Form
    {

        public string SERVIDOR = "ANGEL-PC\\SQLEXPRESS";
        public FormLogin()
        {
            InitializeComponent();
        }
        

        ~ FormLogin()
        {
            this.Dispose();
        }

        private void btnSALIR_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void btnINGRESAR_Click(object sender, EventArgs e)
        {
            try
            {

               
            CONEXIONBD.Servidor = SERVIDOR; //ANGEL - PC\SQLEXPRESS
            CONEXIONBD.Base_Datos = "FAKE_STEAM";
                CONEXIONBD.Usuario = txtUsuario.Text.ToUpper();
            CONEXIONBD.Contraseña = txtContra.Text;
                CONEXIONBD DB = new CONEXIONBD();
                DB.Conectar();
                
           
            frmPrincipal frmPrin = new frmPrincipal();
                // frmPrin.dgvJuegos.DataSource = DB.EjecutarConsulta(new SqlCommand("SELECT * FROM ESTADO"));
                //  frmPrin.dataGridView2.DataSource = DB.EjecutarConsulta(new SqlCommand("SELECT * FROM USUARIOS"));
                string cadena = " select NOMBRE from JUEGOS";
                frmPrin.cmbJuegos.DisplayMember = "NOMBRE";
                frmPrin.cmbJuegos.DataSource = DB.EjecutarConsulta(new SqlCommand(cadena));

                string cadenausuarios = " select NOMBREPERFIL from USUARIOS";
                frmPrin.cmbUsuarios.DisplayMember = "NOMBREPERFIL";
                frmPrin.cmbUsuarios.DataSource = DB.EjecutarConsulta(new SqlCommand(cadenausuarios));

                string cadenaDESCRIPCION = " SELECT DESCRIPCION FROM METODOPAGO";
                frmPrin.cmbMETODODEPAGO.DisplayMember = "DESCRIPCION";
                frmPrin.cmbMETODODEPAGO.DataSource = DB.EjecutarConsulta(new SqlCommand(cadenaDESCRIPCION));


                frmPrin.USUARIO = txtUsuario.Text;
                frmPrin.CONTRA = txtContra.Text;
                frmPrin.BASE = this.SERVIDOR;
            frmPrin.Show();
            this.Visible = false;
                DB.CerrarConexion();
            }
            catch (Exception EX)
            {
                MessageBox.Show(EX.Message);
                
                return;
            }
        }
    }
}

unit Dialogo2;


interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, StrUtils;


type
  TDialogoDatos = class(TForm)
    Panel1: TPanel;
    LabelNacion: TLabel;
    LabelProvincia: TLabel;
    LabelCP: TLabel;
    LabelGenero: TLabel;
    LabelEdadInicial: TLabel;
    LabelCursoInicio: TLabel;
    LabelAcceso: TLabel;
    LabelCalificacion: TLabel;
    Panel2: TPanel;
    ButtonSiguiente: TButton;
    ComboBoxNacion: TComboBox;
    ComboBoxProvincia: TComboBox;
    ComboBoxGenero: TComboBox;
    ComboBoxAcceso: TComboBox;
    EditCP: TEdit;
    EditEdad: TEdit;
    EditCurso: TEdit;
    EditCalificacion: TEdit;
    procedure ButtonSiguienteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComprobarDatos(Sender: TObject);
    procedure CargarTuplaAlumno;
    procedure ExtraerCodigo (texto : string; var valor : integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  DialogoDatos: TDialogoDatos;


implementation


{$R *.dfm}


uses
   Main, Dialogo1, UEjecucion, UDatos, UClaseAtributo, UPrueba;




procedure TDialogoDatos.ComprobarDatos(Sender: TObject);

begin
   if (ComboBoxAcceso.ItemIndex >= 0) and
      (ComboBoxGenero.ItemIndex >= 0) and
      (ComboBoxNacion.ItemIndex >= 0) and
      (ComboBoxProvincia.ItemIndex >= 0) and
      (StrToIntDef (EditCP.Text, 0) > 0) and
      (StrToIntDef (EditCurso.Text, 0) > 0) and
      (StrToIntDef (EditEdad.Text, 0) > 0) then
      ButtonSiguiente.Enabled := true
   else
      ButtonSiguiente.Enabled := false;
end;





procedure TDialogoDatos.ExtraerCodigo (texto : string; var valor : integer);

var
   pos_ini, pos_fin : integer;
   codigo_str : string;

begin
   pos_ini := Pos('[',texto) + 1;
   pos_fin := Pos(']',texto);
   codigo_str := MidStr (texto, pos_ini, pos_fin - pos_ini);
   valor := StrToIntDef (codigo_str, 0);
end;





procedure TDialogoDatos.CargarTuplaAlumno;

var
   codigo : integer;
   cadena : string;

begin
   ExtraerCodigo (ComboBoxAcceso.Items.Strings[ComboBoxAcceso.ItemIndex], codigo);
   EscribirDatosAlumno (tupla_alumno, atr_acceso, codigo);

   ExtraerCodigo (ComboBoxGenero.Items.Strings[ComboBoxGenero.ItemIndex], codigo);
   EscribirDatosAlumno (tupla_alumno, atr_genero, codigo);

   ExtraerCodigo (ComboBoxNacion.Items.Strings[ComboBoxNacion.ItemIndex], codigo);
   EscribirDatosAlumno (tupla_alumno, atr_nacionalidad, codigo);

   ExtraerCodigo (ComboBoxProvincia.Items.Strings[ComboBoxProvincia.ItemIndex], codigo);
   EscribirDatosAlumno (tupla_alumno, atr_provincia, codigo);

   codigo := Pos ('.', EditCalificacion.Text);
   if codigo > 0 then begin
      cadena := LeftStr (EditCalificacion.Text, codigo - 1) + MidStr (EditCalificacion.Text, codigo + 1, 2);
      if Length (MidStr (EditCalificacion.Text, codigo +1, 2)) = 1 then
         cadena := cadena + '0'
      else if Length (MidStr (EditCalificacion.Text, codigo +1, 2)) = 0 then
         cadena := cadena + '00';
      end
   else
      cadena := EditCalificacion.Text + '00';
   codigo := StrToIntDef (cadena, 0);
   EscribirDatosAlumno (tupla_alumno, atr_calificacion, codigo);

   codigo := StrToIntDef (EditCP.Text, 0);
   EscribirDatosAlumno (tupla_alumno, atr_codigo_postal, codigo);

   codigo := StrToIntDef (EditCurso.Text, 0);
   EscribirDatosAlumno (tupla_alumno, atr_expediente, codigo);

   codigo := StrToIntDef (EditEdad.Text, 0);
   EscribirDatosAlumno (tupla_alumno, atr_edad_inicio, codigo);

end;





procedure TDialogoDatos.ButtonSiguienteClick(Sender: TObject);

begin
   ButtonSiguiente.Enabled := false;
   CargarTuplaAlumno;
   Calcular (arbol, tupla_alumno);
   DialogoDatos.Visible := false;
   FormGecUMA.Visible := true;
end;





procedure TDialogoDatos.FormClose(Sender: TObject; var Action: TCloseAction);

begin
   DialogoTitulacion.Close;
end;





end.

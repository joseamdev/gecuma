unit Dialogo1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, StrUtils;

type
  TDialogoTitulacion = class(TForm)
    ListBox1 : TListBox;
    Panel1   : TPanel;
    ButtonSiguiente: TButton;
    procedure ButtonSiguienteClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  DialogoTitulacion   : TDialogoTitulacion;



implementation



{$R *.dfm}



uses
   Dialogo2, UDatos, UClaseAtributo, ULectura, Main;



const
   EXTENSION = '.ARB';





procedure TDialogoTitulacion.ButtonSiguienteClick (Sender: TObject);

var
   nombre, titulacion : string;
   codigo : integer;

begin
   ButtonSiguiente.Enabled := false;
   nombre := ListBox1.Items.Strings[ListBox1.ItemIndex];
   titulacion := LeftStr (nombre, 3) + MidStr (nombre, 5, 2);
   codigo := StrToIntDef (titulacion, 0);
   EscribirDatosAlumno (tupla_alumno, atr_titulacion, codigo);
   LecturaArbol (titulacion+EXTENSION, arbol);
   if arbol = nil then
      DialogoTitulacion.Close;
   DialogoTitulacion.Visible := false;
   DialogoDatos.Visible := true;
end;





procedure TDialogoTitulacion.ListBox1Click(Sender: TObject);

begin
   ButtonSiguiente.Enabled := true;
end;





procedure TDialogoTitulacion.FormShow(Sender: TObject);

begin
   ListBox1.ClearSelection;
end;





end.

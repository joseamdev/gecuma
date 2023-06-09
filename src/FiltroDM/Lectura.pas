//  El m�dulo 'Lectura.pas' re�ne todos los procedimientos encargados de abrir
//  los ficheros con los datos de los alumnos y los datos de las asignaturas
//  cursadas por los mismos. Adem�s se leen los datos y se pasan a tuplas que
//  se insertan en la lista de experiencias.

unit Lectura;

interface

  uses
    SysUtils, Alumnos, Asignaturas, Experiencias, Dialogs;

  procedure Insertar_Tupla_Alumno (lista_exp : TListaExperiencia; tupla : TuplaAlumno);
  procedure Insertar_Tupla_Asignatura (lista_exp : TListaExperiencia; tupla : TuplaAsignatura);
  procedure Inicializar (alumnos, asignaturas : string; var fichero_alumno, fichero_asignatura : TextFile; var error : boolean);
  procedure Leer_Hasta_Coincidencia (var fichero_alumno, fichero_asignatura : TextFile; var buffer_alumno, buffer_asignatura : string; var codigo_alumno : integer; var coincidencia : boolean);
  procedure Extraer_Mientras_Coincidan (var fichero_alumno, fichero_asignatura : TextFile; lista_exp : TListaExperiencia; var buffer_alumno, buffer_asignatura : string; codigo_guia : integer; var fin : boolean);
  procedure Principal (var fichero_alumno, fichero_asignatura : TextFile; lista_exp : TListaExperiencia; var buffer_alumno, buffer_asignatura : string; var codigo_alumno : integer; var fin : boolean);
  procedure Finalizar (var fichero_alumno, fichero_asignatura : TextFile);





implementation




//  El procedimiento 'Insertar_Tupla_Alumno' inserta en la lista de experiencias
//  la tupla del alumno le�da del fichero. Los atributos cuyos valores se
//  calculan a partir de los conocidos se rellenan con el valor cero.

procedure Insertar_Tupla_Alumno (lista_exp : TListaExperiencia; tupla : TuplaAlumno);

begin
  lista_exp.Insertar (tupla.centro,       tupla.seccion,        tupla.plan,
                      tupla.especialidad, tupla.codigo_postal,  tupla.provincia,
                      tupla.genero,       tupla.nacionalidad,   tupla.acceso,
                      tupla.calificacion, tupla.curso_fin,      0,
                      0,                  0,                    0,
                      0,                  0,                    0,
                      0,                  0,                    0,
                      0,                  tupla.nacimiento,     tupla.expediente,
                      tupla.localidad);
end;





//  El procedimiento 'Insertar_Tupla_Asignatura' inserta en la lista de
//  experiencias la tupla de la asignatura le�da del fichero.

procedure Insertar_Tupla_Asignatura (lista_exp : TListaExperiencia; tupla : TuplaAsignatura);

begin
  lista_exp.Experiencia(0).Lista_Asignatura.Insertar (
            tupla.centro,       tupla.seccion,            tupla.plan,
            tupla.asignatura,   tupla.calificacion,       tupla.curso,
            tupla.convocatoria, tupla.num_convocatorias,  tupla.num_matriculas);
end;





//  El procedimiento 'Inicializar' asigna punteros a ficheros a los nombres de
//  archivos de los alumnos y las asignaturas que se pasaron como par�metros.
//  En la variable por referencia error se devuelve si se produjo un error en
//  el proceso.

procedure Inicializar (alumnos, asignaturas : string; var fichero_alumno, fichero_asignatura : TextFile; var error : boolean);

begin
  //  El modo de apertura de fichero se pone en s�lo lectura. En la variable
  //  booleana error se guarda el resultado de comprobar si existe el fichero
  //  'alumnos'.
  FileMode := fmOpenRead;
  error    := not FileExists (alumnos);

  //  Si existe el fichero entonces se asigna el puntero 'fichero_alumno' y se
  //  abre en modo lectura. Se comprueba el tama�o del fichero si es igual a
  //  cero y el resultado se almacena en la variable 'error'. Si 'error' es
  //  'true' se finaliza el procedimiento.
  if not error then begin
    AssignFile (fichero_alumno, alumnos);
    Reset (fichero_alumno);
    error := FileSize (fichero_alumno) = 0;
  end;

  if error then exit;

  //  Se vuelve a poner el modo de apertura de fichero en s�lo lectura. En la
  //  variable booleana error se guarda el resultado de comprobar si existe el
  //  fichero asignaturas.
  FileMode := fmOpenRead;
  error    := not FileExists (asignaturas);

  //  Si existe el fichero entonces se asigna el puntero fichero_asignatura
  //  y se abre en modo lectura. Se comprueba el tama�o del fichero si es
  //  igual a cero y el resultado se almacena en la variable error.
  if not error then begin
    AssignFile (fichero_asignatura, asignaturas);
    Reset (fichero_asignatura);
    error := FileSize (fichero_asignatura) = 0;
  end;
end;





//  El procedimiento 'Leer_Hasta_Coincidencia' va leyendo de los ficheros de
//  alumnos y asignaturas hasta que los dos se sit�en en una l�nea donde
//  coincida el c�digo de alumno de ambas.

procedure Leer_Hasta_Coincidencia (var fichero_alumno, fichero_asignatura : TextFile; var buffer_alumno, buffer_asignatura : string; var codigo_alumno : integer; var coincidencia : boolean);

var
  codigo_alumno_as : integer;
  fin : boolean;

begin

  //  Se pone la variable de control 'fin' a 'false'. Se extrae el c�digo del
  //  alumno del buffer de lectura.
  fin := false;

  Asignaturas.Extraer_Atributo (buffer_asignatura, as_alumno, codigo_alumno_as);

  //  Mientras no se alcance el final del fichero y los c�digos del fichero de
  //  alumnos y del fichero de asignaturas no coincidan se itera recorriendo
  //  ambos ficheros.
  repeat

    //  Si el c�digo del fichero de alumnos es menor que el c�digo del fichero
    //  de asignaturas entonces se lee una l�nea del fichero de alumnos,
    //  se comprueba si se alcanz� el final del archivo y se lee el c�digo de
    //  alumno de dicha l�nea del fichero.

    if (codigo_alumno < codigo_alumno_as) then begin
      ReadLn (fichero_alumno, buffer_alumno);
      fin := SeekEof (fichero_alumno);
      Alumnos.Extraer_Atributo     (buffer_alumno,     al_codigo, codigo_alumno);

    //  Si el c�digo del fichero de alumnos es mayor que el c�digo del fichero
    //  de asignaturas entonces se lee una l�nea del fichero de asignaturas, se
    //  comprueba si se alcanz� el final del archivo y se lee el c�digo de
    //  alumno de dicha l�nea del fichero.

    end else if (codigo_alumno > codigo_alumno_as) then begin
      ReadLn (fichero_asignatura, buffer_asignatura);
      fin := SeekEof (fichero_asignatura);
      Asignaturas.Extraer_Atributo (buffer_asignatura, as_alumno, codigo_alumno_as);
    end;

    coincidencia := (codigo_alumno = codigo_alumno_as);
  until fin or coincidencia;

  if fin and (not coincidencia) then
    buffer_alumno := '';
end;





//  El procedimiento 'Extraer_Mientras_Coincidan' va leyendo de los ficheros de
//  alumnos y de asignaturas mientras el c�digo de alumnos de ambos coincida
//  con el del c�digo gu�a. Las l�neas le�das se pasan a la lista de experiencias.

procedure Extraer_Mientras_Coincidan (var fichero_alumno, fichero_asignatura : TextFile; lista_exp : TListaExperiencia; var buffer_alumno, buffer_asignatura : string; codigo_guia : integer; var fin : boolean);

var
  fin_al, fin_as, coincidencia : boolean;
  codigo_alumno_as, codigo_alumno : integer;
  tupla_alumno : TuplaAlumno;
  tupla_asignatura : TuplaAsignatura;

begin
  fin_al       := SeekEof (fichero_alumno);
  fin_as       := SeekEof (fichero_asignatura);

  repeat
    Alumnos.Extraer_Tupla (buffer_alumno, tupla_alumno);
    Insertar_Tupla_Alumno (lista_exp,     tupla_alumno);

    if not fin_al then begin
      ReadLn (fichero_alumno, buffer_alumno);
      fin_al := SeekEof (fichero_alumno);
      Alumnos.Extraer_Atributo (buffer_alumno, al_codigo, codigo_alumno);
      coincidencia := (codigo_alumno = codigo_guia);
    end else begin
      buffer_alumno := '';
      codigo_alumno := 0;
      coincidencia := false;
    end;
  until not coincidencia;

  repeat
    Asignaturas.Extraer_Tupla (buffer_asignatura, tupla_asignatura);
    Insertar_Tupla_Asignatura (lista_exp,         tupla_asignatura);

    if not fin_as then begin
      ReadLn (fichero_asignatura, buffer_asignatura);
      fin_as := SeekEof (fichero_asignatura);
      Asignaturas.Extraer_Atributo (buffer_asignatura, as_alumno, codigo_alumno_as);
      coincidencia := (codigo_alumno_as = codigo_guia);
    end else begin
      buffer_asignatura := '';
      codigo_alumno_as := 0;
      coincidencia := false;
    end;
  until not coincidencia;

  fin := (fin_al and (codigo_alumno = 0)) or (fin_as and (codigo_alumno_as = 0));
end;





//  El procedimiento 'Principal' realiza todo el proceso de extracci�n de datos
//  de los ficheros. Lee las l�neas de los ficheros de alumnos y asignaturas
//  hasta que encuentra una coincidencia en el c�digo de ambos. En ese momento
//  se encarga de extraer la informaci�n hasta que difiera el c�digo le�do de
//  alguno de los ficheros y se van guardando todos los datos en la lista de
//  experiencias.

procedure Principal (var fichero_alumno, fichero_asignatura : TextFile; lista_exp : TListaExperiencia; var buffer_alumno, buffer_asignatura : string; var codigo_alumno : integer; var fin : boolean);

var
      coincidencia : boolean;
      codigo_alumno_as : integer;

begin
  fin := (SeekEof (fichero_alumno) or SeekEof (fichero_asignatura)) and (Length (buffer_alumno) = 0);

  if (not fin) then begin
    if Length (buffer_alumno) = 0 then begin
      ReadLn (fichero_alumno,     buffer_alumno);
      ReadLn (fichero_asignatura, buffer_asignatura);
    end;

    Alumnos.Extraer_Atributo     (buffer_alumno,     al_codigo, codigo_alumno);
    Asignaturas.Extraer_Atributo (buffer_asignatura, as_alumno, codigo_alumno_as);

    coincidencia := (codigo_alumno = codigo_alumno_as);

    if (not coincidencia) then
      Leer_Hasta_Coincidencia (fichero_alumno, fichero_asignatura, buffer_alumno, buffer_asignatura, codigo_alumno, coincidencia);

    fin := not coincidencia;

    if (not fin) then
      Extraer_Mientras_Coincidan (fichero_alumno, fichero_asignatura, lista_exp, buffer_alumno, buffer_asignatura, codigo_alumno, fin);

  end;
end;





//  El procedimiento 'Finalizar' se encarga de cerrar los ficheros de alumnos y
//  de asignaturas.

procedure Finalizar (var fichero_alumno, fichero_asignatura : TextFile);

begin
  CloseFile (fichero_alumno);
  CloseFile (fichero_asignatura);
end;


end.

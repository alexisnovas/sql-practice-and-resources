-- Log IN
SELECT U.UserType, DP.Nombre, DP.Apellido
	FROM Usuario AS U
	INNER JOIN Empleado AS E ON U.IdEmpleado = E.IdEmpleado
	INNER JOIN DatosPersonales AS DP ON E.IdDatosPersonales = DP.IdDatosPersonales
	WHERE Username = 'alexisnovas' AND UserPassword = '123'

-- Buscar Paciente por ID
	SELECT P.IdPaciente,DP.Nombre, DP.Apellido, DP.Cedula, DP.Telefono, DP.EstadoCivil, 
	DP.Sexo, DP.Edad, DP.Email, DP.FechaNacimiento, DP.PesoEnKilogramos, DP.Direccion, 
	DP.Nacionalidad FROM DatosPersonales AS DP
	INNER JOIN Paciente AS P ON DP.IdDatosPersonales = P.IdDatosPersonales
    ORDER BY IdPaciente

-- Buscar Paciente por Cedula
	SELECT P.IdPaciente,DP.Nombre, DP.Apellido, DP.Cedula, DP.Telefono, DP.EstadoCivil, DP.Sexo, DP.Edad, DP.Email, DP.FechaNacimiento, DP.PesoEnKilogramos, DP.Direccion,
    DP.Nacionalidad FROM DatosPersonales AS DP
    INNER JOIN Paciente AS P ON DP.IdDatosPersonales = P.IdDatosPersonales
    WHERE DP.Cedula = '98786890232'

-- Agregar un Paciente nuevo
INSERT INTO DatosPersonales VALUES ('Jose Alfonso', 'Martinez Tavarez', '00127376252', 'Casado', 'M', '58', 'tobiaspedro@hotmail.com','1958/01/12', 189.8, 'Calle manzana 4', 'Dominicano', '8298772875');
INSERT INTO SeguroMedico VALUES ('SENASA', 'Pedro Suarez', '092192', 'Avanzado', '34516323421', 'Jose Alfonso Martinez Tavarez');


INSERT INTO Paciente
    (IdSeguroMedico, IdDatosPersonales, CondicionEspecial, AfeccionOftalmologica)
SELECT
	(SELECT TOP 1 IdSeguroMedico FROM SeguroMedico ORDER BY IdSeguroMedico DESC),
    (SELECT TOP 1 IdDatosPersonales FROM DatosPersonales ORDER BY IdDatosPersonales DESC),
	('Ninguna'), 
	('Miopia');
   
--INSERT INTO Paciente (CondicionEspecial, AfeccionOftalmologica) VALUES ('Ninguna', 'Miopía');

--ALTER TABLE SeguroMedico ADD NombreAfiliado VARCHAR(100)


-- Buscar todos los datos del paciente, incluyendo detalles.

SELECT DP.Nombre, DP.Apellido, DP.Cedula, DP.Telefono, DP.EstadoCivil, DP.Sexo, DP.Edad, DP.Email, DP.FechaNacimiento,
	   DP.PesoEnKilogramos, DP.Direccion, DP.Nacionalidad, P.CondicionEspecial, P.AfeccionOftalmologica, SM.Empresa,
	   SM.Titular, SM.NumeroContrato, SM.TipoPlan, SM.NSS FROM DatosPersonales AS DP 
       INNER JOIN Paciente AS P ON DP.IdDatosPersonales = P.IdDatosPersonales
	   INNER JOIN SeguroMedico AS SM ON P.IdSeguroMedico = SM.IdSeguroMedico
       WHERE P.IdPaciente = 1002

SELECT DP.Nombre, DP.Apellido, DP.Cedula, DP.Telefono, DP.EstadoCivil, DP.Sexo, DP.Edad, DP.Email, DP.FechaNacimiento, DP.PesoEnKilogramos, DP.Direccion, DP.Nacionalidad, P.CondicionEspecial, P.AfeccionOftalmologica, SM.Empresa, SM.Titular, SM.NumeroContrato, SM.TipoPlan, SM.NSS FROM DatosPersonales AS DP
INNER JOIN Paciente AS P ON DP.IdDatosPersonales = P.IdDatosPersonales
INNER JOIN SeguroMedico AS SM ON P.IdSeguroMedico = SM.IdSeguroMedico
WHERE P.IdPaciente = 1002


UPDATE DatosPersonales
SET Direccion = 'Calle Kiwi' 
WHERE idDatosPersonales = 1002

--Actualizar Data Paciente
UPDATE DatosPersonales SET Nombre = @nombre WHERE idDatosPersonales = @id_DP AND Nombre != @nombre

-- Buscar Ids Paciente
SELECT DP.IdDatosPersonales, SM.IdSeguroMedico FROM DatosPersonales AS DP 
                                                             INNER JOIN Paciente AS P ON DP.IdDatosPersonales = P.IdDatosPersonales
                                                             INNER JOIN SeguroMedico AS SM ON P.IdSeguroMedico = SM.IdSeguroMedico
                                                             WHERE P.IdPaciente = 1002

-- Buscar Consultas de un paciente.
SELECT C.IdConsulta, C.IdPaciente, C.IdTratamiento, C.IdMedico, DP.Nombre AS NombreMedico, C.Diagnostico, C.Fecha, C.Hora FROM Consulta AS C 
INNER JOIN Medico AS M ON C.IdMedico = M.IdMedico
INNER JOIN Empleado AS E ON M.IdEmpleado = E.IdEmpleado
INNER JOIN DatosPersonales AS DP ON E.IdDatosPersonales = DP.IdDatosPersonales
WHERE C.IdPaciente = 2


--Agregar Consulta

INSERT INTO Tratamiento VALUES ('2020-10-12', '2020-11-12', 'Antibiotico 3 veces al dia')
INSERT INTO Consulta (IdPaciente, IdMedico, IdTratamiento, Fecha, Hora, Diagnostico)
SELECT
	 (1006),
     (SELECT M.IdMedico FROM Usuario AS U
	  INNER JOIN Empleado AS E ON  E.IdEmpleado = U.IdEmpleado
	  INNER JOIN Medico AS M ON M.IdEmpleado = E.IdEmpleado
	  WHERE U.Username = 'juanaepacheco' AND U.UserType = 'Medico'),
	 (SELECT TOP 1 IdTratamiento FROM Tratamiento ORDER BY IdTratamiento DESC), 
     ('2020-10-2'), 
	 ('11:07'),
     ('Aumento de miopia en ojo izquierdo a -0.50');

-- Obtener Datos de Consulta
SELECT C.Diagnostico, T.FechaInicio, T.FechaFin, T.Indicaciones FROM Consulta AS C
INNER JOIN Tratamiento AS T ON C.IdTratamiento = T.IdTratamiento 
WHERE C.IdConsulta = 11

-- Obtener Datos de Consulta si el medico que la realizo es quien la consulta.
SELECT C.Diagnostico, T.FechaInicio, T.FechaFin, T.Indicaciones FROM Consulta AS C
INNER JOIN Tratamiento AS T ON C.IdTratamiento = T.IdTratamiento 
INNER JOIN Usuario AS U ON U.Username = 'juanapacheco'
INNER JOIN Empleado AS E ON E.IdEmpleado = U.IdEmpleado
INNER JOIN Medico AS M ON M.IdEmpleado = E.IdEmpleado
WHERE C.IdConsulta = 4 AND C.IdMedico = M.IdMedico

-- Buscar Id tratamiento
SELECT T.IdTratamiento FROM Consulta AS C
INNER JOIN Tratamiento AS T ON T.IdTratamiento = C.IdTratamiento
WHERE C.IdConsulta = 4



--Agregar Empleado Medico
 IF NOT EXISTS(SELECT * FROM Usuario WHERE username = 'juanapacheco')
 BEGIN
   INSERT INTO DatosPersonales VALUES ('Miriam', 'Altagracia', '12392791021', 'Soltero', 'F', 27, 'miriam@gmail.com', '1991-08-19', 158, 'Calle guineo', 'Dominicana', '8907652256');
   INSERT INTO Empleado (IdDatosPersonales, IdSucursal, Estado, FechaIngreso, Salario, Observaciones)
      SELECT
         (SELECT TOP 1 IdDatosPersonales FROM DatosPersonales ORDER BY IdDatosPersonales DESC),
	     (1), 
	     ('Activo'),
         ('2017-08-12'),
         (35000),
         ('Ninguna');
   INSERT INTO Medico (IdEmpleado, FacultadDeMedicina, CostoPorConsulta)
      SELECT
         (SELECT TOP 1 IdEmpleado FROM Empleado ORDER BY IdEmpleado DESC),
	     ('INTEC'), 
	     (500);
   INSERT INTO Usuario (IdEmpleado, Username, UserPassword, PasswordSalt, UserType) 
      SELECT
         (SELECT TOP 1 IdEmpleado FROM Empleado ORDER BY IdEmpleado DESC),
	     ('juanapacheco'), 
	     ('12345'),
         ('12345'),
         ('Medico');
  END


ALTER TABLE Medico ADD DescripcionProfesional VARCHAR(500) 

SELECT * FROM Usuario AS U WHERE U.Username = 'juanapacheco'


SELECT DP.IdDatosPersonales, M.IdMedico FROM DatosPersonales AS DP
INNER JOIN Empleado AS E ON DP.IdDatosPersonales = E.IdDatosPersonales
INNER JOIN Medico AS M ON E.IdEmpleado = M.IdEmpleado
WHERE E.IdEmpleado = 8

SELECT S.IdSecretaria FROM Secretaria AS S 
INNER JOIN Empleado AS E ON S.IdEmpleado = E.IdEmpleado
WHERE IdSecretaria = 1
                                   
-- HALLAR DATOS COMPLETOS DE LA CONSULTA				   
SELECT C.Diagnostico, T.Indicaciones, T.FechaInicio, T.FechaFin, DP.Nombre AS NombrePaciente, 
DP.Apellido AS ApellidoPaciente, DPM.Nombre AS NombreMedico, DPM.Apellido AS ApellidoMedico FROM Consulta AS C
INNER JOIN Tratamiento AS T ON C.IdTratamiento = T.IdTratamiento 
INNER JOIN Paciente AS P ON C.IdPaciente = P.IdPaciente
INNER JOIN DatosPersonales AS DP ON P.IdDatosPersonales = DP.IdDatosPersonales
INNER JOIN Medico AS M ON C.IdMedico = M.IdMedico
INNER JOIN Empleado AS E ON M.IdEmpleado = E.IdEmpleado
INNER JOIN DatosPersonales AS DPM ON E.IdDatosPersonales = DPM.IdDatosPersonales
WHERE C.IdConsulta = 23



SELECT DP.Nombre AS NombreMedico, DP.Apellido AS ApellidoMedico FROM Consulta AS C
INNER JOIN Medico AS M ON C.IdMedico = M.IdMedico
INNER JOIN Empleado AS E ON M.IdEmpleado = E.IdEmpleado
INNER JOIN DatosPersonales AS DP ON E.IdDatosPersonales = DP.IdDatosPersonales
WHERE C.IdConsulta = 23


 CREATE TABLE Prueba_Clinica.dbo.Sucursal (
 IdSucursal INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 Nombre VARCHAR(200) NOT NULL,
 Domicilio VARCHAR(500) NOT NULL,
 Telefono CHAR(10) NOT NULL,
 Provincia VARCHAR(50) NOT NULL,
);


CREATE TABLE Prueba_Clinica.dbo.DatosPersonales (
 IdDatosPersonales INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 Nombre NVARCHAR(50) NOT NULL,
 Apellido NVARCHAR(50) NOT NULL,
 Cedula CHAR(11),
 EstadoCivil VARCHAR(20) NOT NULL,
 Sexo CHAR(1) NOT NULL,
 Edad INT NOT NULL,
 Email NVARCHAR(100) NOT NULL,
 FechaNacimiento DATE NOT NULL,
 PesoEnKilogramos DECIMAL(6,2) NOT NULL,
 Direccion VARCHAR(500) NOT NULL,
 Nacionalidad VARCHAR(50) NOT NULL,
 Telefono CHAR(10) NOT NULL
);

CREATE TABLE Prueba_Clinica.dbo.SeguroMedico (
 IdSeguroMedico INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 Empresa VARCHAR(100) NOT NULL,
 Titular VARCHAR(50) NOT NULL,
 NombreAfiliado VARCHAR(50) NOT NULL,
 NumeroContrato INT NOT NULL,
 TipoPlan VARCHAR(100) NOT NULL,
 NSS CHAR(11) NOT NULL
);

CREATE TABLE Prueba_Clinica.dbo.Paciente (
 IdPaciente INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 IdSeguroMedico INT UNIQUE FOREIGN KEY REFERENCES Prueba_Clinica.dbo.SeguroMedico(IdSeguroMedico),
 IdDatosPersonales INT UNIQUE FOREIGN KEY REFERENCES Prueba_Clinica.dbo.DatosPersonales(IdDatosPersonales),
 CondicionEspecial VARCHAR(200),
 AfeccionOftalmologica VARCHAR(100)
);

CREATE TABLE Prueba_Clinica.dbo.Empleado (
 IdEmpleado INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 IdDatosPersonales INT UNIQUE FOREIGN KEY REFERENCES Prueba_Clinica.dbo.DatosPersonales(IdDatosPersonales),
 IdSucursal INT NOT NULL FOREIGN KEY REFERENCES Prueba_Clinica.dbo.Sucursal(IdSucursal),
 Estado VARCHAR(20) NOT NULL,
 FechaIngreso DATE NOT NULL,
 Salario DECIMAL(10,2) NOT NULL,
 Observaciones VARCHAR(500)
);


CREATE TABLE Prueba_Clinica.dbo.Secretaria (
 IdSecretaria INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 IdEmpleado INT UNIQUE FOREIGN KEY REFERENCES Prueba_Clinica.dbo.Empleado(IdEmpleado),
 NivelAcademico VARCHAR(50) NOT NULL, --Normalizar
 TituloUniversitario VARCHAR(100) NOT NULL,
 DominioIngles CHAR(2) NOT NULL --Bit
);


CREATE TABLE Prueba_Clinica.dbo.Medico (
 IdMedico INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 IdEmpleado INT UNIQUE FOREIGN KEY REFERENCES Prueba_Clinica.dbo.Empleado(IdEmpleado),
 FacultadDeMedicina VARCHAR(100) NOT NULL, --Normalizar
 CostoPorConsulta DECIMAL(6,2) NOT NULL,
 DescripcionProfesional VARCHAR(500) NOT NULL
);


CREATE TABLE Prueba_Clinica.dbo.Usuario (
 IdUsuario INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 IdEmpleado INT UNIQUE FOREIGN KEY REFERENCES Prueba_Clinica.dbo.Empleado(IdEmpleado),
 Username VARCHAR(50) NOT NULL,
 UserPassword NVARCHAR(200) NOT NULL,
 UserType VARCHAR(50) NOT NULL
);

CREATE TABLE Prueba_Clinica.dbo.Tratamiento (
 IdTratamiento INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 FechaInicio DATE NOT NULL,
 FechaFin DATE NOT NULL,
 Indicaciones NVARCHAR(500)
);

CREATE TABLE Prueba_Clinica.dbo.Consulta (
 IdConsulta INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 IdPaciente INT NOT NULL FOREIGN KEY REFERENCES Prueba_Clinica.dbo.Paciente(IdPaciente),
 IdMedico INT NOT NULL FOREIGN KEY REFERENCES Prueba_Clinica.dbo.Medico(IdMedico),
 IdTratamiento INT UNIQUE FOREIGN KEY REFERENCES Prueba_Clinica.dbo.Tratamiento(IdTratamiento),
 Fecha DATE NOT NULL,
 Hora TIME NOT NULL,
 Diagnostico NVARCHAR(500) NOT NULL
);
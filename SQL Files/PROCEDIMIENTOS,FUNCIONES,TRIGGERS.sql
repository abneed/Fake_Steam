--------------------PROCEDIMIENTO AGREGAR A ESTADO-----------------------------------------------------
CREATE PROCEDURE AGREGAR_ESTADO @NOMBRE VARCHAR(25),@ABREVIATURA VARCHAR(5) AS
INSERT INTO ESTADO(NOMBRE,ABREVIATURA) VALUES (UPPER(@NOMBRE),UPPER(@ABREVIATURA))
------------------------VALIDACION-----------------------------------------------------
CREATE TRIGGER AGREGARESTADO ON ESTADO 
FOR INSERT,UPDATE 
AS
IF(EXISTS(SELECT ES.NOMBRE 
          FROM   inserted AS ES 
          GROUP BY ES.NOMBRE
          HAVING  1 < ANY           (SELECT COUNT(*)
		                             FROM ESTADO AS EST
									WHERE ES.NOMBRE=NOMBRE 
									 GROUP BY EST.NOMBRE
									 )
	     
		  			        )  )
  BEGIN
    ROLLBACK TRAN
    RAISERROR('EL ESTADO YA EXISTE DENTRO DE LA BASE DE DATOS', 16, 1)
  END
-----------------------------------CAMPO DE PRUEBA-------------------------------------------------------
EXEC AGREGAR_ESTADO 'CAMPECHE','Camp'
EXEC AGREGAR_ESTADO 'Chiapas','CHP'
EXEC AGREGAR_ESTADO 'TAMAULIPAS','TAM'
EXEC AGREGAR_ESTADO 'NUEVO LEON','NLE'
EXEC AGREGAR_ESTADO 'TEXAS','TEX'
EXEC AGREGAR_ESTADO 'CALIFORNIA','CAL'
--------------------------------PROCEDIMIENTO AGREGAR CIUDAD-*--------+-------------
CREATE PROCEDURE AGREGAR_CIUDAD @NOMBRE VARCHAR(25) AS

INSERT INTO CIUDAD(NOMBRE) VALUES (UPPER(@NOMBRE))
-------------------------------VALIDACION--------------------------------------
CREATE TRIGGER AGREGARCIUDAD ON CIUDAD 
FOR INSERT,UPDATE 
AS
IF(EXISTS(SELECT ES.NOMBRE 
          FROM   inserted AS ES 
          GROUP BY ES.NOMBRE
          HAVING  1 < ANY           (SELECT COUNT(*)
		                             FROM CIUDAD AS EST
									WHERE ES.NOMBRE=NOMBRE 
									 GROUP BY EST.NOMBRE
									 )
	     
		  			        )  )
  BEGIN
    ROLLBACK TRAN
    RAISERROR('LA CIUDAD YA EXISTE EN LA BASE DE DATOS', 16, 1)
  END
 ---------------------------EJEMPLO--------------
 EXEC AGREGAR_CIUDAD 'NUEVO LAREDO'
 EXEC AGREGAR_CIUDAD 'Carmen'
 EXEC AGREGAR_CIUDAD 'Abasolo'
 EXEC AGREGAR_CIUDAD 'Tuxtla Guti�rrez'
 EXEC AGREGAR_CIUDAD 'LAREDO'--San Francisco
 EXEC AGREGAR_CIUDAD 'San Francisco'--Tampico
 EXEC AGREGAR_CIUDAD 'TAMPICO'
----------------------------------AGREGAR PAIS--------------------
CREATE PROCEDURE AGREGAR_PAIS @NOMBRE VARCHAR(25) AS
INSERT INTO PAIS(NOMBRE) VALUES (UPPER(@NOMBRE))
-------------------------------VALIDACION--------------------------------------
CREATE TRIGGER AGREGARPAIS ON PAIS
FOR INSERT,UPDATE 
AS
IF(EXISTS(SELECT ES.NOMBRE 
          FROM   inserted AS ES 
          GROUP BY ES.NOMBRE
          HAVING  1 < ANY           (SELECT COUNT(*)
		                             FROM PAIS AS EST
									WHERE ES.NOMBRE=NOMBRE 
									 GROUP BY EST.NOMBRE
									 )
	     
		  			        )  )
  BEGIN
    ROLLBACK TRAN
    RAISERROR('EL PAIS YA EXISTE EN LA BASE DE DATOS', 16, 1)
  END 
  --------------PRUEBA---------------------------
  EXEC AGREGAR_PAIS 'MEXICO'
  EXEC AGREGAR_PAIS 'ESTADOS UNIDOS'
  ---------------------PAIS-ESTADO----------------------------------------------------------
  CREATE PROCEDURE AGREGAR_PAIS_ESTADO @PAIS INT,@ESTADO INT AS
INSERT INTO PAIS_ESTADO(IDESTADO,IDPAIS) VALUES (@ESTADO,@PAIS)
----------------------------------PRUEBA-------------------------------------------------
exec AGREGAR_PAIS_ESTADO 1,1
exec AGREGAR_PAIS_ESTADO 1,2
exec AGREGAR_PAIS_ESTADO 1,3
exec AGREGAR_PAIS_ESTADO 1,4
exec AGREGAR_PAIS_ESTADO 2,5
exec AGREGAR_PAIS_ESTADO 2,6

-------------------ESTAD0_CIUDAD------------------------------------
  CREATE PROCEDURE AGREGAR_ESTADO_CIUDAD @ESTADO INT,@CIUDAD INT AS
  INSERT INTO ESTADO_CIUDAD(IDESTADO,IDCIUDAD) VALUES (@ESTADO,@CIUDAD)
  --------------------PRUEBA--------------------------------
  EXEC AGREGAR_ESTADO_CIUDAD 1,2
  EXEC AGREGAR_ESTADO_CIUDAD 3,1
  EXEC AGREGAR_ESTADO_CIUDAD 4,3
  EXEC AGREGAR_ESTADO_CIUDAD 2,4
  EXEC AGREGAR_ESTADO_CIUDAD 5,5
  EXEC AGREGAR_ESTADO_CIUDAD 6,6
  EXEC AGREGAR_ESTADO_CIUDAD 3,7
  ---------------------------AGREGAR IMAGEN--------------
   CREATE PROCEDURE AGREGAR_IMAGEN @IMAGEN IMAGE AS
  INSERT INTO IMAGENES(IMAGEN) VALUES (@IMAGEN)
  ---------------AGREGAR USUARIO---------------------------------
    CREATE PROCEDURE AGREGAR_USUARIO @NOMBREDELPERFIL VARCHAR(50),@APPATERNO VARCHAR(20)
	,@APMATERNO VARCHAR(20),@NOMBRE VARCHAR(20),@FECHANACIMIENTO DATE,@CORREO VARCHAR(255)
	,@DESCRIPCION VARCHAR(255),@IDPAIS INT,@IDESTADO INT,@IDCIUDAD INT,@IDIMAGEN INT AS

  INSERT INTO USUARIOS(NOMBREPERFIL,APPATERNO,APMATERNO,NOMBRE,FECHANACIMIENTO,
  CORREOELECTRONICO,DESCRIPCION,IDPAIS,IDESTADO,IDCIUDAD,IDIMAGEN) 
  VALUES (@NOMBREDELPERFIL,@APPATERNO,@APMATERNO,@NOMBRE,@FECHANACIMIENTO,@CORREO,
  @DESCRIPCION,@IDPAIS,@IDESTADO,@IDCIUDAD,@IDIMAGEN)

  --------------PRUEBA DE AGREGAR USUARIOS---------------------
  CREATE PROCEDURE AGREGAR_USUARIO2 @NOMBREDELPERFIL VARCHAR(50),@APPATERNO VARCHAR(20)
	,@APMATERNO VARCHAR(20),@NOMBRE VARCHAR(20),@FECHANACIMIENTO DATE,@CORREO VARCHAR(255)
	,@DESCRIPCION VARCHAR(255),@PAIS VARCHAR(50),@ESTADO VARCHAR(50),@CIUDAD VARCHAR(50),@UBICACIONIMAGEN VARCHAR(50) AS
	 INSERT INTO IMAGENES(UBICACIONIMAGEN)VALUES (@UBICACIONIMAGEN)
	 declare @IDIMAGEN int
    set @IDIMAGEN=( SELECT TOP 1 P.IDIMAGEN
	                FROM  IMAGENES AS P
				    WHERE P.UBICACIONIMAGEN=@UBICACIONIMAGEN)
				

	declare @IDPAIS int
    set @IDPAIS=( SELECT P.IDPAIS
	              FROM  PAIS AS P
				  WHERE NOMBRE=@PAIS)

	declare @IDESTADO int
    set @IDESTADO=(SELECT P.IDESTADO
	              FROM  ESTADO AS P
				  WHERE P.NOMBRE=@ESTADO)

	declare @IDCIUDAD int
    set @IDCIUDAD=(SELECT P.IDCIUDAD
	              FROM  CIUDAD AS P
				  WHERE NOMBRE=@CIUDAD)

 INSERT INTO USUARIOS(NOMBREPERFIL,APPATERNO,APMATERNO,NOMBRE,FECHANACIMIENTO,
  CORREOELECTRONICO,DESCRIPCION,IDPAIS,IDESTADO,IDCIUDAD,IDIMAGEN) 
  VALUES (@NOMBREDELPERFIL,@APPATERNO,@APMATERNO,@NOMBRE,@FECHANACIMIENTO,@CORREO,
  @DESCRIPCION,@IDPAIS,@IDESTADO,@IDCIUDAD,@IDIMAGEN)
  ---------------VALIDACION--------------------------------------------------------------------------------------------
  CREATE TRIGGER AGREGARUSUARIO ON USUARIOS
FOR INSERT,UPDATE 
AS
IF(EXISTS(SELECT ES.NOMBREPERFIL
          FROM   inserted AS ES 
          GROUP BY ES.NOMBREPERFIL
          HAVING  1 < ANY           (SELECT COUNT(*)
		                             FROM USUARIOS AS EST
									WHERE ES.NOMBREPERFIL=EST.NOMBREPERFIL
									 GROUP BY EST.NOMBREPERFIL
									 )
	     
		  			        )  )
  BEGIN
    ROLLBACK TRAN
    RAISERROR('EL PERFIL YA EXISTE', 16, 1)
  END
  IF(EXISTS(SELECT ES.CORREOELECTRONICO
          FROM   inserted AS ES 
          GROUP BY ES.CORREOELECTRONICO
          HAVING  1 < ANY           (SELECT COUNT(*)
		                             FROM USUARIOS AS EST
									WHERE ES.CORREOELECTRONICO=EST.CORREOELECTRONICO
									 GROUP BY EST.CORREOELECTRONICO
									 )
	     
		  			        )  )
  BEGIN
    ROLLBACK TRAN
    RAISERROR('EL CORREO YA TIENE UN PERFIL ASIGNADO', 16, 1)
  END  

  --------------AGREGAR VENTA---------------------------------------
  CREATE PROCEDURE AGREGAR_VENTA @FECHA DATE,@IDMETODODEPAGO TINYINT,@IDUSUARIO INT AS
  INSERT INTO VENTAS(FECHAVENTA,IDMETODOPAGO,IDUSUARIO) VALUES (GETDATE(),@IDMETODODEPAGO,@IDUSUARIO)
  -------------AGREGAR METODO DE PAGO--------------------------------
  CREATE PROCEDURE AGREGAR_METODOPAGO @DESCRIPCION VARCHAR(25) AS
  INSERT INTO METODOPAGO(DESCRIPCION)VALUES(@DESCRIPCION)
  ---------VENTAS_JUEGOS-------------
  CREATE PROCEDURE AGREGAR_VENTAS_JUEGOS @IDVENTA INT ,@IDJUEGO INT AS
  INSERT INTO VENTAS_JUEGOS(IDVENTA,IDJUEGO) VALUES (@IDVENTA,@IDJUEGO)
  ---------------create funcion======================
  select CI.NOMBRE
  from CIUDAD AS CI
  JOIN ESTADO_CIUDAD AS ESTCIU ON(ESTCIU.IDCIUDAD=CI.IDCIUDAD)
  JOIN ESTADO AS EST ON(EST.IDESTADO=ESTCIU.IDESTADO)
  WHERE EST.NOMBRE='TAMAULIPAS'
  ---------------------------MODIFICACION TABLA IMAGENES---------------------------------------
 alter table IMAGENES ADD  UBICACIONIMAGEN VARCHAR(50) NOT NULL DEFAULT'C:\Users\Angel\Pictures\Usuario.jpg'
 alter table imagenes DROP COLUMN IMAGEN

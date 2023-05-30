create database soporte_tecnico_1;
use soporte_tecnico_1;
#drop database soporte_tecnico_1;

CREATE TABLE usuario (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    edad INT,
    email VARCHAR(100),
    numero_veces_utilizado INT DEFAULT 1
);

CREATE TABLE operario (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    edad INT,
    email VARCHAR(100),
    numero_veces_servicio INT DEFAULT 1
);

CREATE TABLE soporte (
    id INT PRIMARY key auto_increment,
    operario_id INT,
    usuario_id INT,
    fecha TIMESTAMP,
    evaluacion INT,
    comentario VARCHAR(255),
    FOREIGN KEY (operario_id) REFERENCES operario(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);


/* Procesamiento de almacenado creado para aplicar los conceptos de transacción, rollback y commit*/
DELIMITER //

CREATE PROCEDURE atencion_usuario(in id_usuario_in int, in id_operario_in int, in evaluacion_in int, in comentario_in varchar(255))
BEGIN
   DECLARE estado_rollback BOOLEAN DEFAULT FALSE;
   declare n_usuarios	 INT;	
   declare n_operarios	 INT;	
   
   START TRANSACTION;
 
   SELECT COUNT(*)  INTO n_usuarios  from  USUARIO WHERE id= id_usuario_in;
   SELECT COUNT(*)  INTO n_operarios  from  operario WHERE id= id_operario_in;
	
    CASE
        when n_usuarios > 0 and n_operarios > 0  THEN
       
 		  INSERT INTO Soporte (operario_id, usuario_id, fecha,comentario,evaluacion)
  		  VALUES(id_operario_in,id_usuario_in,now(), comentario_in, evaluacion_in );
	
          update usuario 
          set numero_veces_utilizado = numero_veces_utilizado  + 1
          where ID = id_usuario_in;
          update operario  
          set numero_veces_servicio = numero_veces_servicio  + 1
          where ID = id_operario_in;
      
        ELSE
            SET estado_rollback = TRUE;
            SELECT 'no funciona';
     END CASE;
    
        IF estado_rollback THEN
    
        ROLLBACK;
        SELECT 'Se produjo un error, id de usuario u operario inexistente.';
    ELSE
        
        COMMIT;
        SELECT 'Soporte tecnico realizado, gracias';
    END IF;
           


END//
DELIMITER  



INSERT INTO usuario (id, nombre, apellido, edad, email)
VALUES
    (1, 'Élise', 'Dubois', 30, 'elise.dubois@example.com'),
    (2, 'Hugo', 'Martin', 25, 'hugo.martin@example.com'),
    (3, 'Camille', 'Lambert', 40, 'camille.lambert@example.com'),
    (4, 'Léa', 'Leroux', 28, 'lea.leroux@example.com'),
    (5, 'Lucas', 'Moreau', 35, 'lucas.moreau@example.com');

   
   
INSERT INTO Operario (id, nombre, apellido, edad, email)
VALUES
    (1, 'John Smith', 'Doe', 35, 'john.smith@example.com'),
    (2, 'Jane Johnson', 'Smith', 28, 'jane.johnson@example.com'),
    (3, 'Michael Davis', 'Brown', 42, 'michael.davis@example.com'),
    (4, 'Emily Wilson', 'Miller', 31, 'emily.wilson@example.com'),
    (5, 'Daniel Anderson', 'Taylor', 37, 'daniel.anderson@example.com');

  
/* Ingreso de datos a la tabla soporte por medio de el procesamiento de almacenado */
   
call atencion_usuario(2,2,4,'Medianamente bien');
call atencion_usuario(1,3,4,'Medianamente bien');
call atencion_usuario(1,3,7,'Excelente');
call atencion_usuario (1,1,5,'Buen servicio');
call atencion_usuario (2,3,6,'Excelente atención');
call atencion_usuario(3,2,5,'Muy útil');
call atencion_usuario(4,4,4,'Regular experiencia');
call atencion_usuario (5,5,5,'Podría mejorar');
call atencion_usuario(4,3,4,'ahí nomas');
call atencion_usuario (2,1,2,'Atencio Mediocre');
call atencion_usuario(1,2,6,'Muy eficiente');
call atencion_usuario (5,4,3,'No resolvieron mi problema');
call atencion_usuario (3,5,7,'Increíble soporte');    



# Seleccione las 3 operaciones con mejor evaluación.
SELECT *
FROM soporte
ORDER BY evaluacion DESC
LIMIT 3;

# Seleccione las 3 operaciones con menos evaluación.
SELECT *
FROM soporte
ORDER BY evaluacion
LIMIT 3;
select * from soporte ;

# Seleccione al operario que más soportes ha realizado.
SELECT concat ('El operario ', operario.nombre,' realizo ' , COUNT(*) , ' soportes ' )AS total_soportes
FROM soporte inner join operario 
on soporte.operario_id = operario.id
GROUP BY soporte.operario_id
ORDER BY operario.numero_veces_servicio DESC
LIMIT 1;

# Seleccione al cliente que menos veces ha utilizado la aplicación.
SELECT CONCAT(' El usuario ', nombre, ' ocupó la aplicación solo ', MIN(numero_veces_utilizado), ' veces') AS Respuesta
FROM usuario;


# Agregue 10 años a los tres primeros usuarios registrados.
UPDATE usuario
SET edad = edad + 10
WHERE id IN (1, 2, 3);

#Renombre todas las columnas ‘correo electrónico’. El nuevo nombre debe ser email.
ALTER TABLE usuario
RENAME COLUMN email TO correo_electrónico;

ALTER TABLE operario
RENAME COLUMN email TO correo_electrónico;

# Seleccione solo los operarios mayores de 20 años.
SELECT *
FROM operario
WHERE Edad > 20;

#Prueba de errores al ingresar un usuario u operario inexistente
call atencion_usuario (123,123,4,'error provocado');


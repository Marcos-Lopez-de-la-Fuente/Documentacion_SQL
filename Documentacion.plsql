-- CREATE TABLE
CREATE TABLE Tabla1 (
    Columna1 varchar(4), -- Tipo de dato "varchar", con el "4" indico un máximo de 4 carácteres. Se pueden insertar menos de 4
    Columna2 varchar(4) NOT NULL, -- Con "NOT NULL" obligo a que este campo siempre se tenga que rellenar

    Columna3 number(5), -- Tipo de dato "number", con el "5" indico un máximo de 5 números. Como no he indicado un segundo parámetro no podrá tener decimales
    Columna4 number(*,0), -- Con "(*,0)" indico que pueden haber "infitinos" números enteros, pero no pueden haber decimales
    Columna5 number(5,2), -- Con "(5,2)" indico que como máximo tendrá una longitud de 5 carácteres, de los cuales tendrá 2 decimales. (3 enteros y 2 decimales máximo). Si se intentan poner 4 enteros salta error

    Columna6 date, -- Tipo de dato "date", de esta forma establezco que esta columna tendrá fechas. El resto del "trabajo" lo tendrán los INSERTs

    CONSTRAINT Tabla1_PK PRIMARY KEY (Columna1), -- Para declarar la "PK" de una tabla
    CONSTRAINT Tabla1_PK PRIMARY KEY (Columna1, Columna2), -- Declarar una "PK" combinada de una tabla

    CONSTRAINT Columna3_FK FOREIGN KEY (Columna3) REFERENCES Tabla2(Columna1) -- Para declarar la "FK" de otra tabla.
                    --  Nombre de la columna de la Tabla1 | Nombre Tabla2 y la columna en cuestión
);


-- INSERT INTO
-- FORMATO COMPLETO
INSERT INTO Tabla1 (Columna1, Columna2, Columna3, Columna4, Columna5, Columna6)
    VALUES ('3453','6453',45336,56347643,423.57,TO_DATE('09-07-2003', 'dd-mm-yyyy'));

-- FORMATO SELECTIVO (Solo introduces en los que quieres. Es importante siempre introducir los que tengan el valor "NOT NULL")
INSERT INTO Tabla1 (Columna1, Columna2, Columna6)
    VALUES ('3453','6453',TO_DATE('09-07-2003', 'dd-mm-yyyy'));

-- FORMATO DISMINUIDO (De esta forma se tendrán que completar todas las columnas)
INSERT INTO Tabla1 VALUES ('3453','6453',45336,56347643,423.57,TO_DATE('09-07-2003', 'dd-mm-yyyy'));

-- FORMATO DISMINUIDO ORDENADO (El que más me gusta)
INSERT INTO Tabla1 VALUES (
    '3453',
    '6453',
    45336,
    56347643,
    423.57,
    TO_DATE('09-07-2003', 'dd-mm-yyyy')
);


-- EJEMPLOS DE USO CON EL "TO_DATE"
CREATE TABLE Tabla0 ( -- Tabla de ejemplo
    fecha date
);
INSERT INTO Tabla0 VALUES (
    TO_DATE('31-12-2022', 'dd-mm-yyyy') -- Formato completo, los "-" se pueden cambiar por "/"
);
INSERT INTO Tabla0 VALUES (
    TO_DATE('2022', 'yyyy') -- Formato de solo el año, en "mm" pondrá el més actual y en "dd" pondrá "01"
);
INSERT INTO Tabla0 VALUES (
    TO_DATE('12', 'mm') -- Formato de solo el mes, en 'yyyy' pondrá el año actual y en "dd" pondrá "01"
);
INSERT INTO Tabla0 VALUES (
    TO_DATE('31', 'dd') -- Formato de solo el día, en 'yyyy' pondrá el año actual, y en "mm" pondrá el més actual
);


-- EJEMPLOS DE USO CON EL "SYSDATE"
CREATE TABLE Tabla0 ( -- Tabla de ejemplo
    fecha date
);
INSERT INTO Tabla0 VALUES (
    SYSDATE -- Insertará el día actual en el que nos encontramos
);
INSERT INTO Tabla0 VALUES (
    SYSDATE + 1 -- Insertará el día de mañana
);
INSERT INTO Tabla0 VALUES (
    SYSDATE - 1 -- Insertará el día de ayer
);
-- También se puede utilizar en los SELECTs
-- La tabla "dual" creo que viene integrada con Oracle y sus mierdas, idk
-- De esta forma restamos el último día del año "-" el primero, devolverá la cantidad de días que tiene el año
SELECT (TO_DATE('31-Dec-2022') - TO_DATE('01-Jan-2022')) FROM dual;
-- Restamos el día de final de año "-" la fecha actual, devolverá la cantidad de días que faltan para final de año
SELECT (TO_DATE('31-Dec-2022') - SYSDATE) FROM dual;


-- EJEMPLOS DE USO CON "TO_CHAR"
-- Si sale algo de esto en el examen importante mirar: https://www.techonthenet.com/oracle/functions/to_char.php
-- Se suele utilizar para transformar un tipo "date" a "string" o cambiar su formato en la salida
-- Utilizaré la "Tabla0" como ejemplo
SELECT TO_CHAR(fecha, 'dd/mm/yyyy') FROM Tabla0;
-- En el primer parámetro metemos un valor "date" (Podríamos usar "SYSDATE") y en el segundo parámetro usamos el formato que queramos mostrar
SELECT TO_CHAR(fecha, 'yyyy/mm/dd') FROM Tabla0; -- Se puede hacer todas las combinaciones posibles.
-- En el siguiente ejemplo solo saldrán los valores de los meses (Se puede utilizar con los otros formatos también)
SELECT TO_CHAR(fecha, 'mm') FROM Tabla0;


-- EJEMPLOS DE USO CON "MONTHS_BETWEEN()"
-- Devuelve la cantidad de meses que hay entre 2 valores "date"
-- En este ejemplo estoy restando El último día del año "-" el primero, devolverá 12 meses (Es posible que devuelva una cantidad muy cercana "11,967...")
SELECT MONTHS_BETWEEN(TO_DATE('31/12/2022', 'dd/mm/yyyy'), TO_DATE('01/01/2022', 'dd/mm/yyyy')) FROM Tabla0; -- Para que no de error es necesario poner una tabla aunque no usemos sus columnas
-- En el siguiente ejemplo podemos comprobar la cantidad de meses que faltan para acabar el año (Desde la fecha en la que nos encontramos)
SELECT MONTHS_BETWEEN(TO_DATE('31/12/2022', 'dd/mm/yyyy'), SYSDATE) FROM Tabla0;



-- EJEMPLOS DE USO CON "GROUP BY"
CREATE TABLE Tabla0 ( -- Tabla de ejemplo
    Grupos number(2),
    fecha date
);
-- Formato típico donde agrupamos los valores iguales de una columna y vemos cuantas filas/rows hay en cada una
SELECT Grupos, COUNT(*)
FROM Tabla0
GROUP BY Grupos;

-- Formato con fechas. En el siguiente ejemplo estamos agrupando por meses. También se puede agrupar por años y días
-- OJO, de esta forma se agruparían los meses del año 2022 y del año 2023, en el siguiente ejemplo arreglo eso
SELECT TO_CHAR(Fecha, 'mm'), COUNT(*)
FROM Tabla0
GROUP BY TO_CHAR(Fecha, 'mm');
-- De la siguiente forma, no se agruparán meses iguales de distintos años:
SELECT TO_CHAR(Fecha, 'mm-yyyy'), COUNT(*)
FROM Tabla0
GROUP BY TO_CHAR(Fecha, 'mm-yyyy');



-- EJEMPLOS DE USO CON "ALTER TABLE"
-- Se utiliza para modificar una tabla
-- Añadir una columna a la "Tabla0"
ALTER TABLE Tabla0
    ADD Columna1 varchar(5);
-- El siguiente ejemplo es igual, pero si no se introduce nada su valor será "Ejemplo"
ALTER TABLE Tabla0
    ADD Columna1 varchar(5) DEFAULT 'Ejemplo';
-- Añadir múltiples columnas a la "Tabla0":
ALTER TABLE Tabla0 ADD (
    Columna1 varchar(5),
    Columna2 date,
    Columna3 number(2)
);

-- Modificar una columna de la "Tabla0":
ALTER TABLE Tabla0
    MODIFY fecha varchar(5); -- Cambio el tipo de datos de la columna
-- Modificar múltiples columnas:
ALTER TABLE Tabla0 MODIFY (
    fecha varchar(5),
    Grupo int(2),
    ColumnaX date
);

-- Eliminar una columna de la "Tabla0":
ALTER TABLE Tabla0
    DROP COLUMN fecha; -- Elimino la columna "fecha"

-- Renombrar una columna de la "Tabla0":
ALTER TABLE Tabla0
    RENAME COLUMN fecha TO Nuevo_Nombre_fecha;

-- Renombrar una tabla:
ALTER TABLE Tabla0
    RENAME TO Nuevo_Nombre_Tabla0;


-- EJEMPLOS DE USO CON "VIEW"
-- Crear un view:
CREATE VIEW Vista1 AS
    SELECT fecha
    FROM Tabla0;
-- Luego se puede visualizar como una tabla normal { SELECT * FROM Vista1 }
-- También se pueden añadir INNER JOINs y WHEREs:
CREATE VIEW Vista1 AS
    SELECT Tabla0.fecha
    FROM Tabla0
    INNER JOIN Tabla1 ON Tabla0.Fechas_id = Tabla1.Fechas_id
    -- Cuando el més sea diferente a "03"
    WHERE TO_CHAR(Tabla0.fecha, 'mm') != '03';

-- Se puede crear una vista, en caso de que se esté usando ese nombre la remplaza: (Se puede utilizar para ver los cambios de una tabla real y actualizar la vista)
CREATE OR REPLACE VIEW Vista1 AS
    SELECT fecha
    FROM Tabla0;

-- Eliminar una vista:
DROP VIEW Vista1;

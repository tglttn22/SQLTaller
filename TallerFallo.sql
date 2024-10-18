
CREATE TABLE Cliente (
    DNI VARCHAR(20) PRIMARY KEY NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    direccion VARCHAR(255)
);


CREATE TABLE Procurador (
    id_procurador INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    direccion VARCHAR(255)
);


CREATE TABLE Asunto (
    num_expediente INT PRIMARY KEY IDENTITY(1,1),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado VARCHAR(255) NOT NULL,
    DNI_cliente VARCHAR(20) NOT NULL,
    FOREIGN KEY (DNI_cliente) REFERENCES Cliente(DNI)
);


CREATE TABLE Asunto_Procurador (
    num_expediente INT NOT NULL,
    id_procurador INT NOT NULL,
    PRIMARY KEY (num_expediente, id_procurador),
    FOREIGN KEY (num_expediente) REFERENCES Asunto(num_expediente),
    FOREIGN KEY (id_procurador) REFERENCES Procurador(id_procurador)
);


INSERT INTO Cliente (DNI, nombre, direccion)
VALUES 
('12345678A', 'Juan Pérez', 'Calle Principal 123'),
('98765432B', 'María García', 'Avenida Central 456'),
('11122233C', 'Carlos López', 'Plaza del Sol 789');

INSERT INTO Procurador (nombre, id_procurador, direccion)
VALUES 
('Pedro', 'Rodríguez', 'Calle de los Abogados 101'),
('Ana', 'Martínez', 'Avenida Jurídica 202'),
('Luis', 'González', 'Plaza de la Justicia 303');

INSERT INTO Asunto (num_expediente, fecha_inicio, fecha_fin, estado, DNI_cliente)
VALUES 
(1, '2023-01-01', '2023-12-31', 'En trámite', '12345678A'),
(2, '2023-02-01', NULL, 'Archivado', '98765432B'),
(3, '2023-03-01', NULL, 'En trámite', '11122233C');

INSERT INTO Asunto_Procurador (num_expediente, id_procurador)
VALUES 
(1, 1),
(2, 2),
(3, 3);


EXEC sp_rename 'Cliente.DNI', 'NumeroIdentidad', 'COLUMN';
EXEC sp_rename 'Procurador.id_procurador', 'IdProcurador', 'COLUMN';
EXEC sp_rename 'Asunto.num_expediente', 'NumeroExpediente', 'COLUMN';
EXEC sp_rename 'Asunto_Procurador.num_expediente', 'NumeroExpediente', 'COLUMN';


ALTER TABLE Procurador ADD ColumnaNueva VARCHAR(50);
ALTER TABLE Asunto DROP COLUMN fecha_fin;


SELECT * FROM Asunto WHERE estado = 'Archivado';

UPDATE Asunto SET estado = 'Resuelto' WHERE NumeroExpediente = 1;

DELETE FROM Cliente WHERE DNI = '98765432B';

SELECT a.NumeroExpediente, c.Nombre AS Cliente, p.nombre AS Procurador
FROM Asunto a
INNER JOIN Asunto_Procurador ap ON a.NumeroExpediente = ap.NumeroExpediente
INNER JOIN Procurador p ON ap.IdProcurador = p.IdProcurador
WHERE a.Estado = 'En trámite';

SELECT a.NumeroExpediente, c.Nombre AS Cliente, p.nombre AS Procurador
FROM Asunto a
LEFT JOIN Asunto_Procurador ap ON a.NumeroExpediente = ap.NumeroExpediente
LEFT JOIN Procurador p ON ap.IdProcurador = p.IdProcurador
WHERE a.Estado = 'Archivado';

SELECT a.NumeroExpediente, c.Nombre AS Cliente, p.nombre AS Procurador
FROM Asunto a
RIGHT JOIN Asunto_Procurador ap ON a.NumeroExpediente = ap.NumeroExpediente
RIGHT JOIN Procurador p ON ap.IdProcurador = p.IdProcurador
WHERE p.Nombre IS NULL;

SELECT a.NumeroExpediente, c.Nombre AS Cliente, p.nombre AS Procurador
FROM Asunto a
FULL OUTER JOIN Asunto_Procurador ap ON a.NumeroExpediente = ap.NumeroExpediente
FULL OUTER JOIN Procurador p ON ap.IdProcurador = p.IdProcurador
UNION ALL
SELECT a.NumeroExpediente, c.Nombre AS Cliente, p.nombre AS Procurador
FROM Asunto a
FULL OUTER JOIN Asunto_Procurador ap ON a.NumeroExpediente = ap.NumeroExpediente
FULL OUTER JOIN Procurador p ON ap.IdProcurador = p.IdProcurador
WHERE a.NumeroExpediente IS NULL OR p.Nombre IS NULL;

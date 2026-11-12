CREATE DATABASE SupplierDB;
USE SupplierDB;
CREATE TABLE Suppliers (
    sid INT PRIMARY KEY,
    sname VARCHAR(30),
    city VARCHAR(30)
);
CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(30),
    color VARCHAR(20)
);
CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost INT,
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Suppliers(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);
INSERT INTO Suppliers VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');
INSERT INTO Parts VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');
INSERT INTO Catalog VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10002, 20003, 30),
(10003, 20003, 30),
(10004, 20003, 40);
SELECT DISTINCT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid;
SELECT S.sname
FROM Suppliers S
WHERE NOT EXISTS (
    SELECT *
    FROM Parts P
    WHERE NOT EXISTS (
        SELECT *
        FROM Catalog C
        WHERE C.sid = S.sid
        AND C.pid = P.pid
    )
);
SELECT S.sname
FROM Suppliers S
WHERE NOT EXISTS (
    SELECT *
    FROM Parts P
    WHERE P.color = 'Red'
    AND NOT EXISTS (
        SELECT *
        FROM Catalog C
        WHERE C.sid = S.sid
        AND C.pid = P.pid
    )
);
SELECT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE S.sname = 'Acme Widget'
AND NOT EXISTS (
    SELECT *
    FROM Catalog C2
    WHERE C2.pid = P.pid
    AND C2.sid <> C.sid
);
SELECT DISTINCT C.sid
FROM Catalog C
WHERE C.cost > (
    SELECT AVG(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C.pid
);
SELECT P.pname, S.sname, C.cost
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C.pid
);
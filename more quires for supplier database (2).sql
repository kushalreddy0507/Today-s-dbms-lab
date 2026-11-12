USE SupplierDB;


-- 1. FIND THE MOST EXPENSIVE PART OVERALL
-- AND THE SUPPLIER WHO SUPPLIES IT

SELECT P.pname, S.sname, C.cost
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(cost)
    FROM Catalog
);


-- 2. FIND SUPPLIERS WHO DO NOT SUPPLY
-- ANY RED PARTS

SELECT S.sname
FROM Suppliers S
WHERE NOT EXISTS (
    SELECT *
    FROM Catalog C
    JOIN Parts P ON C.pid = P.pid
    WHERE C.sid = S.sid
    AND P.color = 'Red'
);


-- 3. SHOW EACH SUPPLIER AND TOTAL VALUE
-- OF ALL PARTS THEY SUPPLY

SELECT S.sname, COALESCE(SUM(C.cost), 0) AS total_value
FROM Suppliers S
LEFT JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname;


-- 4. FIND SUPPLIERS WHO SUPPLY AT LEAST
-- 2 PARTS CHEAPER THAN 20

SELECT S.sname
FROM Suppliers S
JOIN Catalog C ON S.sid = C.sid
WHERE C.cost < 20
GROUP BY S.sid, S.sname
HAVING COUNT(DISTINCT C.pid) >= 2;


-- 5. LIST SUPPLIERS WHO OFFER THE
-- CHEAPEST COST FOR EACH PART

SELECT P.pname, S.sname, C.cost
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MIN(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = P.pid
);

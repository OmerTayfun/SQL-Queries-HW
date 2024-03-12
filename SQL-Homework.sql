
SELECT * FROM products


--1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
SELECT product_name,quantity_per_unit FROM products

--2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) 
--değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
SELECT product_id,product_name FROM products WHERE discontinued=0

--3. Durdurulmayan (`Discontinued`) Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) 
--değerleriyle almak için bir sorgu yazın.
SELECT product_id,product_name FROM products WHERE discontinued=0

--4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) 
--almak için bir sorgu yazın.
SELECT product_id, product_name,unit_price FROM products WHERE unit_price<20

--5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) 
--almak için bir sorgu yazın.
SELECT product_id, product_name,unit_price FROM products WHERE unit_price BETWEEN 15 and 25

--6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) 
--stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
SELECT product_name, units_on_order,units_in_stock FROM products WHERE units_in_stock < units_on_order

--7. İsmi `a` ile başlayan ürünleri listeleyeniz.
SELECT product_name FROM products WHERE product_name LIKE 'A%'

--8. İsmi `i` ile biten ürünleri listeleyeniz.
SELECT product_name FROM products WHERE product_name LIKE '%i'

--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) 
--için bir sorgu yazın.
SELECT product_name, unit_price,unit_price*0.18  AS unit_price_KDV FROM products 

--10. Fiyatı 30 dan büyük kaç ürün var?
SELECT COUNT(product_id) FROM products WHERE unit_price >30

--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
SELECT LOWER(product_name) AS product_name, unit_price FROM products order by unit_price DESC 

--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
SELECT CONCAT(first_name,' ',last_name) as full_name FROM employees 
SELECT first_name || ' ' || last_name as full_name FROM employees

--13. Region alanı NULL olan kaç tedarikçim var?
SELECT COUNT(supplier_id) AS Null_Region_Count FROM suppliers WHERE region IS NULL

--14. a.Null olmayanlar?
SELECT COUNT(supplier_id) AS Not_Null_Region_Count FROM suppliers WHERE region IS NOT NULL

--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
SELECT CONCAT ('TR ', UPPER(product_name)) AS product_name_with_TR FROM products 

--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
SELECT CONCAT ('TR ', product_name) FROM products WHERE unit_price <20

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products order by unit_price DESC

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products order by unit_price DESC LIMIT 10;

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products WHERE unit_price > (SELECT AVG(unit_price) FROM products)

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
SELECT SUM (unit_price * units_in_stock) AS Total_Sales FROM products WHERE units_in_stock >0

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
SELECT 
    CASE WHEN Discontinued = 0 THEN 'In stock' ELSE 'Discontinued' END AS Status,
    COUNT(*) AS product_number
FROM products
GROUP BY discontinued;

--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT p.product_name,c.category_name 
FROM products p 
INNER JOIN categories c ON p.category_id=c.category_id;

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT c.category_name, AVG(p.unit_price) AS AvgPrice
FROM products p
INNER JOIN categories c ON p.category_id=c.category_id
GROUP BY c.category_name;

--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
SELECT p.product_name, p.unit_price, c.category_name, MAX(unit_price)
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_name,p.unit_price,c.category_name;

--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name, c.category_name, t.company_name
FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN suppliers t ON p.supplier_id =t.supplier_id
GROUP BY p.product_name,c.category_name,t.company_name
ORDER BY SUM (od.Quantity) DESC
LIMIT 1;

SELECT p.product_name, c.category_name AS category_name, t.company_name AS supplier_name
FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN suppliers t ON p.supplier_id =t.supplier_id
GROUP BY p.product_name,c.category_name,t.company_name
ORDER BY SUM (od.Quantity) DESC
LIMIT 1;

--Alternatif
SELECT pro.product_name, cat.category_name AS "CATEGORYNAME", sup.company_name AS "SUPPLIERNAME"
FROM products pro
  JOIN categories cat ON pro.category_id = cat.category_id
  JOIN suppliers sup ON pro.supplier_id = sup.supplier_id
WHERE
  pro.product_id = (
    SELECT product_id
    FROM order_details
    GROUP BY product_id
    ORDER BY SUM(quantity) DESC  LIMIT 1 );






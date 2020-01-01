
create view kvitto 

SELECT 
	[Kvitto Nr / Order ID], 
	[Kund namn], [Person nr], 
	[Summa Pris bok/b�cker], 
	[Summa vikt bok/B�cker], 
	Fraktkostnad, 
	[Summa Pris bok/b�cker] + CAST(Fraktkostnad AS int) AS [Summa frakt och varor]
FROM     
(
	SELECT 
		[Kvitto Nr / Order ID], 
		[Kund namn], 
		[Person nr], 
		[Summa Pris bok/b�cker], 
		[Summa vikt bok/B�cker], 
            CASE 
			WHEN [Summa vikt bok/B�cker] < 250 THEN '20' 
			WHEN [Summa vikt bok/B�cker] < 500 THEN '40' 
			WHEN [Summa vikt bok/B�cker] < 1000 THEN '80' 
			WHEN [Summa vikt bok/B�cker] < 3000 THEN '140' 
			ELSE '300' 
			END AS Fraktkostnad
		FROM      
		(
		SELECT 
			O.ID AS [Kvitto Nr / Order ID], 
			Kd.Name AS [Kund namn], 
			Kd.Personnr AS [Person nr], 
			SUM(ODR.Antal * B.pris) AS [Summa Pris bok/b�cker], 
			SUM(ODR.Antal * B.Vikt) AS [Summa vikt bok/B�cker]
			FROM      
			dbo.B�cker AS B INNER JOIN
			dbo.Order_rad AS ODR ON B.ISBN13 = ODR.ISBN13ID INNER JOIN
			dbo.[Order] AS O ON O.ID = ODR.OrderID INNER JOIN
			dbo.Kund AS Kd ON Kd.ID = O.KundID
		GROUP BY 
			O.ID, Kd.Name, Kd.Personnr
	)AS Subquery
)AS subquery2



create view TitlarPerF�rfattare 
as
select 
	Concat(F.F�rnamn, ' ', F.Efternamn) as Name,
	DATEDIFF(year, f.F�delsedatum, getdate()) as �lder,
	count(distinct B.ISBN13) as Titel,
	sum(b.Pris * LS.lagersaldo) as Lagerv�rde
from
		 F�rfattare as F 
	join B�cker as B		on B.F�rfattareID = F.ID
	join LagerSaldo as LS	on B.ISBN13 =LS.ISBN13ID
	join Butiker as BU		on BU.ID = LS.ButiksID

Group by 
	F.ID, F.f�rnamn, F.Efternamn, F.F�delsedatum


	
------------ CHECK CONSTRAINS

ALTER TABLE B�cker
ADD CONSTRAINT PriceNotNegative
  CHECk (pris > 0);

ALTER TABLE B�cker
ADD CONSTRAINT ISBN1EqualTo13
  CHECk (Len(ISBN13) = 13 );

  --------------------- UNIQUE

ALTER TABLE Kund
ADD UNIQUE (Personnr);


-- f�r test

select top 1 * from Butiker 
select top 1 * from F�rfattare
select top 1 * from F�rlag
select top 1 * from B�cker
select top 1 * from Kund
select top 1 * from LagerSaldo
select top 1 * from [Order]
select top 1 * from Order_rad


-- fyll tabell Kund

insert into Kund(Name, shipCity, Personnr)
values('Rickard Wolf', 'M�lndal', '010101-1001')
insert into Kund(Name, shipCity, Personnr)
values('M�ns H�ggkvist', 'G�teborg', '010101-1002')
insert into Kund(Name, shipCity, Personnr)
values('Sebastian Walker', 'G�teborg','010101-1003')
insert into Kund(Name, shipCity, Personnr)
values('Johanna Scully', 'Stockholm', '010101-1004')
insert into Kund(Name, shipCity, Personnr)
values('Fox Johansson', 'Deathstar', '010101-1005')

select * from Kund

-- skapa f�rfattare  --select * from F�rfattare

insert into F�rfattare (F�rnamn, Efternamn, F�delsedatum)
values('Joshua', 'Bloch', '19700101');
insert into F�rfattare (F�rnamn, Efternamn, F�delsedatum)
values('Harrison ', 'Ferrone', '19621115');
insert into F�rfattare (F�rnamn, Efternamn, F�delsedatum)
values('Robert ', 'Martin', '19821023');
insert into F�rfattare (F�rnamn, Efternamn, F�delsedatum)
values('Chinmoy ', 'Mirray', '19920103');

-- skapa f�rlag

insert into [F�rlag] (F�rlagnamn, adressort)
values ('Pocket Brooks', 'London')
insert into [F�rlag] (F�rlagnamn, adressort)
values ('Villiams F�rlag', 'G�teborg')
insert into [F�rlag] (F�rlagnamn, adressort)
values ('PPprograming', 'New York')
insert into [F�rlag] (F�rlagnamn, adressort)
values ('Sage Inc', 'Odessa')
insert into [F�rlag] (F�rlagnamn, adressort)
values ('Looobster Boo-k', 'Link�ping')

-- skapa butiker  -- select * from Butiker

insert into Butiker (butiksNamn, Adress, stad)
values('NerdHell inc', 'Landsv�gsgatan 24', 'G�teborg')
insert into Butiker (butiksNamn, Adress, stad)
values('Programmer Heaven books', 'Rosenbad 2', 'Stockholm')
insert into Butiker (butiksNamn, Adress, stad)
values('Lur Bookstore', 'hagagatan 3', 'Malm�')


-- skapa b�cker  -- select * from B�cker

insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9780321356680, 'Slow Java', 'Engelska ', 93 , '2017-12-27',21 , 21, 90)
insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9781129707755, 'Effective Java', 'Engelska ', 418 , '2013-10-26', 21, 21 , 400)
insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9782129701388, 'Java or nothing', 'Engelska ', 416 , '2011-11-21', 21, 22, 300)

insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9785321356680 , 'Learning C#', 'Svenska ',143 , '2013-06-27', 22, 23, 133)
insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9786129707755, 'Games with Unity 2019', 'Engelska ', 756 , '2019-03-30', 22, 23, 560)
insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9787129701318, 'C# by Developing', 'Engelska ', 316 , '2007-11-21', 22, 24, 333)

insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9788129707725, 'Clean Code', 'Engelska ', 556 , '2019-01-20',23, 24, 444)
insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9789119701328, 'Agile Software Craftsmanship', 'Engelska ', 536 , '2017-11-12', 24, 25, 124)

insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9789129707745, 'Cracking the Coding Interview', 'Engelska ', 123 , '2012-05-20', 22, 25, 2333)
insert into B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID, F�rlagsID, Vikt)
values(9789129701368, 'Programming Questions and Solutions', 'Engelska ', 1435 , '2011-11-19',24, 23, 441)

-- skapa ordrar	-- select * from [order]
select * from Kund
select * from butiker


insert into [Order] (ID, KundID, ButikID, DatumVidK�p)
values(50, 21, 14, CONVERT(VARCHAR(8),GETDATE()))
insert into [Order] (ID, KundID, ButikID, DatumVidK�p)
values(51, 31, 14, CONVERT(VARCHAR(8),GETDATE()))
insert into [Order] (ID, KundID, ButikID, DatumVidK�p)
values(32, 32, 15, CONVERT(VARCHAR(8),GETDATE()))
insert into [Order] (ID, KundID, ButikID, DatumVidK�p)
values(33,33, 15, CONVERT(VARCHAR(8),GETDATE()))
insert into [Order] (ID, KundID, ButikID, DatumVidK�p)
values(34, 34, 16, CONVERT(VARCHAR(8),GETDATE()))
insert into [Order] (ID, KundID, ButikID, DatumVidK�p)
values(35, 35, 16, CONVERT(VARCHAR(8),GETDATE()))

-- skapa order_rad (tidigare kundvagn)			select * from Order_rad
insert into Order_rad(ISBN13ID, Antal, PrisVidOrder, [OrderID])
values(9788129707725, 6, (select pris from B�cker where ISBN13 = 9788129707725), 32)
insert into Order_rad(ISBN13ID, Antal, PrisVidOrder, [OrderID])
values(9789129701368, 3,(select pris from B�cker where ISBN13 = 9789129701368),32)
insert into Order_rad(ISBN13ID, Antal, PrisVidOrder, [OrderID])
values(9788129707725, 6,(select pris from B�cker where ISBN13 = 9788129707725),33)
insert into Order_rad(ISBN13ID, Antal, PrisVidOrder, [OrderID])
values(9789129701368, 1,(select pris from B�cker where ISBN13 = 9789129701368),34)
insert into Order_rad(ISBN13ID, Antal, PrisVidOrder, [OrderID])
values(9788129707725, 1,(select pris from B�cker where ISBN13 = 9788129707725),35)
insert into Order_rad(ISBN13ID, Antal, PrisVidOrder, [OrderID])
values(9789119701328, 2,(select pris from B�cker where ISBN13 = 9789119701328),36)



-- fyll lager i olika butiker --  

-- butik 1
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9780321356680, 14, 20)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9781129707755, 14, 60)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9782129701388, 14, 230)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9785321356680, 14, 70)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9786129707755, 14, 10)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9787129701318, 14, 265)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9788129707725, 14, 314)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789119701328, 14, 25)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789129707745, 14, 21)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789129701368, 14, 22)

-- butik 2
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9780321356680, 15, 5)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9781129707755, 15, 6)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9782129701388, 15, 23)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9785321356680, 15, 7)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9786129707755, 15, 1)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9787129701318, 15, 65)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9788129707725, 15, 34)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789119701328, 15, 5)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789129707745, 15, 1)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789129701368, 15, 2)

-- butik 3
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9780321356680, 16, 76)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9781129707755, 16, 7)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9782129701388, 16, 20)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9785321356680, 16, 320)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9786129707755, 16, 14)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9787129701318, 16, 45)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9788129707725, 16, 31)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789119701328, 16, 27)

insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789129707745, 16, 27)
insert into Lagersaldo(ISBN13ID, ButiksID, Lagersaldo)
values(9789129701368, 16, 132)

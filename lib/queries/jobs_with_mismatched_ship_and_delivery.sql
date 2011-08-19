select somast.fsono, sorels.frelease from somast
left join sorels on sorels.fsono = somast.fsono
left join soitem on soitem.fsono = somast.fsono
 where somast.FSOCOORD = 'LV'
   and (convert(varchar, sorels.fdelivery) <> convert(varchar, sorels.fduedate, 101))
   and soitem.fmultiple = 1

-- select fmasterrel, fpartno, frelease, flshipdate, fduedate, fdelivery from sorels where fsono = 528

select * from sorels where (convert(varchar, fdelivery) <> convert(varchar, fduedate, 101))

DECLARE @myDateTime DATETIME
SET @myDateTime = '2008-05-03'

--
-- Convert string
--
SELECT CONVERT(VARCHAR, @myDateTime, 101)

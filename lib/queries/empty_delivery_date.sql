-- Sales orders entered by LV with no delivery date
select somast.fsono from Somast
left join sorels on sorels.fsono = Somast.fsono
where somast.FSOCOORD = 'LV'
  and (datalength(sorels.fdelivery) = 0)

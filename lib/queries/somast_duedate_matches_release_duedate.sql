select somast.fsono, sorels.frelease from somast
left join sorels on sorels.fsono = somast.fsono
left join soitem on soitem.fsono = somast.fsono
 where somast.FSOCOORD = 'LV'
   and sorels.fduedate = somast.fduedate
   and soitem.fmultiple = 1
   and frelease != 0


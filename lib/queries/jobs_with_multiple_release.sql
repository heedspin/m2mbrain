select somast.fsono from somast
left join soitem on soitem.fsono = somast.fsono
where somast.FSOCOORD = 'LV'
  and soitem.fmultiple = 1

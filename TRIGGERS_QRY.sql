use Zoologico

-------NO BORRAR--------
create trigger NoBorrar
on ZOO for delete
as begin
print 'NO se permiten borrar registros'
rollback transaction
end

select * from ZOO

delete from ZOO where id_zoo=124

----------NO ACTUALIZAR-----
create trigger NoActualizar
on ZOO for update
as begin
print 'jajaja :P NO se permiten actualizar registros'
rollback transaction
end

select * from ZOO

update ZOO set nombre='Morelos' where nombre='Cuernavaca'

-------------NO INSERTAR----------
create trigger NoINSERTAR
on ZOO for insert
as begin
print 'jajaja :P NO se permiten insertar registros'
rollback transaction
end

select * from ZOO

insert into ZOO values (125, 'fghj','dfghj',54125,'fghj',98458)
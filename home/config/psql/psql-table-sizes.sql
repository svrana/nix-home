select
    trim(pgdb.datname) as Database,
    trim(pgn.nspname) as Schema,
    trim(a.name) as Table,
    b.mbytes,
    a.rows
from (
    select db_id, id, name, sum(rows) as rows
    from stv_tbl_perm a
    group by db_id, id, name
) as a
join pg_class as pgc on pgc.oid = a.id
join pg_namespace as pgn on pgn.oid = pgc.relnamespace
join pg_database as pgdb on pgdb.oid = a.db_id
join (
    select tbl, count(*) as mbytes
    from stv_blocklist
    group by tbl
) b on a.id = b.tbl
order by mbytes desc, a.db_id, a.name;

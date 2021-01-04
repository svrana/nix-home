select
namespace as schemaname , item as object, pu.groname as groupname
, decode(charindex('r',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)),0,0,1)  as select
, decode(charindex('w',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)),0,0,1)  as update
, decode(charindex('a',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)),0,0,1)  as insert
, decode(charindex('d',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)),0,0,1)  as delete
from
(select
use.usename as subject,
nsp.nspname as namespace,
c.relname as item,
c.relkind as type,
use2.usename as owner,
c.relacl
from
pg_user use
cross join pg_class c
left join pg_namespace nsp on (c.relnamespace = nsp.oid)
left join pg_user use2 on (c.relowner = use2.usesysid)
where c.relowner = use.usesysid
and  nsp.nspname not in ('pg_catalog', 'pg_toast', 'information_schema')
)
join pg_group pu on array_to_string(relacl, '|') like '%'||pu.groname||'%' ;

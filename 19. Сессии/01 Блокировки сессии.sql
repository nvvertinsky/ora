
-- 01. Сколько всего блокировок
select count(*)
  from v$session v
where v.username is not null
  and v.FINAL_BLOCKING_SESSION is not null;

-- 02. Кто сколько блокирует
select count(*),
       v.FINAL_BLOCKING_SESSION
  from v$session v
where v.username is not null
  and v.FINAL_BLOCKING_SESSION is not null
group by v.FINAL_BLOCKING_SESSION;


-- 03. Все о блокирующей сессии
select v.sid,
       v.CLIENT_INFO,
       v.STATUS,
       v.SERIAL#,
       l.SQL_TEXT,
       (select o.OBJECT_NAME
          from all_objects o
         where o.OBJECT_ID = v.PLSQL_ENTRY_OBJECT_ID) ENTRY_OBJECT_NAME,
       (select p.PROCEDURE_NAME
          from all_procedures p
         where p.SUBPROGRAM_ID = v.PLSQL_ENTRY_SUBPROGRAM_ID
           and p.object_id = v.PLSQL_ENTRY_OBJECT_ID) ENTRY_PROCEDURE,
       v.PLSQL_ENTRY_OBJECT_ID,
       v.PLSQL_ENTRY_SUBPROGRAM_ID,
       (select o.OBJECT_NAME
          from all_objects o
         where o.OBJECT_ID = v.PLSQL_OBJECT_ID) CURRENT_OBJECT_NAME,
         v.PLSQL_OBJECT_ID
  from v$session v,
       v$sql l
where v.username is not null
  and v.SID = 5873
  --
  and l.SQL_ID(+) = v.SQL_ID
order by v.FINAL_BLOCKING_SESSION nulls last


-- 03. Информацию собрали, теперь убиваем. Ждем когда откатится транзакция и только после этого начнут сниматься блокировки.
ALTER SYSTEM KILL SESSION '1528,55325' IMMEDIATE;


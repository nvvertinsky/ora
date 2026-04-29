-- Порядок действий
-- 1. Найти блокирующую сессию
-- 2. Посмотреть что за PLSQL_ENTRY_OBJECT_ID который вызвал блокировку строк. 
-- 3. Обычный запрос не может блокировать строки. Возможно до этого пользователь внес изменения в таблицах и заблокировал строки. 
-- 4. После чего пошел выполнять какой нибудь тяжелый запрос. Оставив строки заблокированными. 
-- 5. Нужно позвонить пользователю и спросить что он сейчас делает.
-- 6. Убить сессию.

select count(*)
  from v$session v
where v.username is not null
  and v.FINAL_BLOCKING_SESSION is not null;

select count(*),
       v.FINAL_BLOCKING_SESSION
  from v$session v
where v.username is not null
  and v.FINAL_BLOCKING_SESSION is not null
group by v.FINAL_BLOCKING_SESSION;



select v.sid,
       v.CLIENT_INFO,
       v.STATUS,
       v.SERIAL#,
       l.SQL_TEXT,
       (select o.OBJECT_NAME
          from all_objects o
         where o.OBJECT_ID = v.PLSQL_ENTRY_OBJECT_ID) OBJECT_NAME,
       v.PLSQL_ENTRY_OBJECT_ID
  from v$session v,
       v$sql l
where v.username is not null
  and v.SID = 8734
  --
  and l.SQL_ID(+) = v.SQL_ID
order by v.FINAL_BLOCKING_SESSION nulls last


ALTER SYSTEM KILL SESSION '1528,55325' IMMEDIATE;


SELECT v.TYPE, 
       v.STATE, 
       v.NUM_BLOCKED, 
       v.CLEANUP_ATTEMPTS
  FROM V$DEAD_CLEANUP v
 WHERE PADDR IN (SELECT PADDR FROM V$SESSION WHERE STATUS = 'KILLED');

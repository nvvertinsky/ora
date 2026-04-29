-- Ïîðÿäîê äåéñòâèé
-- 1. Íàéòè áëîêèðóþùóþ è ïîñìîòðåòü ñêîëüêî îíà áëîêèðóåò ñòðîê
-- 2. Ïîñìîòðåòü êàêèå îáúåêòû îíà áëîêèðóåò 
-- 3. Îáû÷íûé çàïðîñ íå ìîæåò áëîêèðîâàòü ñòðîêè. Âîçìîæíî äî ýòîãî ïîëüçîâàòåëü âíåñ èçìåíåíèÿ â òàáëèöàõ è çàáëîêèðîâàë ñòðîêè. 
-- 4. Ïîñëå ÷åãî ïîøåë âûïîëíÿòü êàêîé íèáóäü òÿæåëûé çàïðîñ. Îñòàâèâ ñòðîêè çàáëîêèðîâàííûìè. 
-- 5. Íóæíî ïîçâîíèòü ïîëüçîâàòåëè è ñïðîñèòü ÷òî îí ñåé÷àñ äåëàåò. Òîëüêî òàê ìîæíî óçíàòü òî÷íî ïðè÷èíó.
-- 6. Óáèòü ñåññèþ. 


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

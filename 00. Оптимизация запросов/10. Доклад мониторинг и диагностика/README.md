# Мониторинг и диагностика производительности приложения с точки зрения Oracle DB. 


```
-- Находим интересующий запрос 
select s.sql_id,
       s.executions, -- Сколько раз выполнялось
       s.elapsed_time, -- время выполнения в микросекундах
       s.sql_text
  from v$sql s
 where s.sql_text like '%documents%';

-- Находим параметры запроса
select b.name,
       b.last_captured,
       b.value_string
  from v$sql_bind_capture b
 where b.sql_id = 'sadk343r3fj3o434'
```

Индекс в предполагаемом плане может отличаться от индекса в реальном плане в большинстве случаев из-за того что он строит план изходя из первых параметров:
```
select *
  from table(dbms_xplan.display('sql_id', format=>'+peeked binds'))  #  Показать параметры на основании которых построили план
```

SQL Monitor мониторит все запрос которые выполнялись больше 5 сек, так же есть параметры запроса. Доступен только в Enteprise + Perfomance tune
```
select sql_id, sql_exec_id
  from v$sql_monitor
 where sql_text like '%documents%';
```

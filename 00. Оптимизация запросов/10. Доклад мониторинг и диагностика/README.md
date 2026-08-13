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

Индекс в 

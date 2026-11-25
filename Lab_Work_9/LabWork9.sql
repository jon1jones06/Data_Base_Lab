-- ============================================================
-- Laboratory Work 9: Stored Procedures and User-Defined Functions
-- Part 1: Database Setup  (CityBike rental network)
-- ============================================================

DROP TABLE IF EXISTS rentals, bikes, members, stations CASCADE;

-- Create table: stations
CREATE TABLE stations (
    station_id   INT PRIMARY KEY,
    station_name VARCHAR(50) NOT NULL,
    city         VARCHAR(40) NOT NULL,
    capacity     INT NOT NULL
);

-- Create table: bikes
CREATE TABLE bikes (
    bike_id    INT PRIMARY KEY,
    model      VARCHAR(50) NOT NULL,
    station_id INT REFERENCES stations(station_id),
    daily_rate NUMERIC(8,2) NOT NULL
);

-- Create table: members
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    full_name VARCHAR(60) NOT NULL,
    city      VARCHAR(40) NOT NULL,
    joined_on DATE NOT NULL
);

-- Create table: rentals
CREATE TABLE rentals (
    rental_id  INT PRIMARY KEY,
    member_id  INT REFERENCES members(member_id),
    bike_id    INT REFERENCES bikes(bike_id),
    start_date DATE NOT NULL,
    end_date   DATE,
    fee        NUMERIC(8,2)
);

INSERT INTO stations VALUES
 (10, 'Central Park', 'Almaty',   4),
 (20, 'Riverside',    'Almaty',   3),
 (30, 'Expo Gate',    'Astana',   5),
 (40, 'Old Town',     'Shymkent', 2),
 (50, 'Depot',        'Astana',   0);

INSERT INTO bikes VALUES
 (101, 'City Cruiser', 10,  4.50),
 (102, 'City Cruiser', 10,  4.50),
 (103, 'Mountain X',   20,  7.00),
 (104, 'Mountain X',   30,  7.00),
 (105, 'Road Sprint',  30,  9.25),
 (106, 'Folding Mini', 40,  3.75),
 (107, 'Cargo Hauler', 20, 12.00),
 (108, 'Road Sprint',  10,  9.25);

INSERT INTO members VALUES
 (1, 'Aisha Nurlanova', 'Almaty',   DATE '2023-03-14'),
 (2, 'Daniyar Serik',   'Almaty',   DATE '2023-07-02'),
 (3, 'Marta Kowalski',  'Astana',   DATE '2024-01-20'),
 (4, 'Chen Wei',        'Astana',   DATE '2024-05-11'),
 (5, 'Omar Haddad',     'Shymkent', DATE '2024-09-30'),
 (6, 'Elena Petrova',   'Almaty',   DATE '2025-02-05');

INSERT INTO rentals VALUES
 ( 1, 1, 101, DATE '2024-04-05', DATE '2024-04-08', 13.50),
 ( 2, 1, 103, DATE '2024-06-11', DATE '2024-06-16', 35.00),
 ( 3, 1, 108, DATE '2025-02-02', DATE '2025-02-04', 18.50),
 ( 4, 1, 102, DATE '2025-05-20', DATE '2025-05-27', 31.50),
 ( 5, 2, 101, DATE '2024-05-01', DATE '2024-05-02',  4.50),
 ( 6, 2, 107, DATE '2024-11-15', DATE '2024-11-19', 48.00),
 ( 7, 2, 107, DATE '2025-03-08', DATE '2025-03-14', 72.00),
 ( 8, 3, 104, DATE '2024-02-14', DATE '2024-02-18', 28.00),
 ( 9, 3, 105, DATE '2024-08-03', DATE '2024-08-06', 27.75),
 (10, 3, 104, DATE '2025-01-09', DATE '2025-01-10',  7.00),
 (11, 3, 105, DATE '2025-06-01', DATE '2025-06-09', 74.00),
 (12, 4, 104, DATE '2024-07-19', DATE '2024-07-21', 14.00),
 (13, 4, 105, DATE '2025-04-12', DATE '2025-04-15', 27.75),
 (14, 4, 103, DATE '2025-07-23', DATE '2025-07-29', 42.00),
 (15, 5, 106, DATE '2024-10-05', DATE '2024-10-12', 26.25),
 (16, 5, 106, DATE '2025-01-18', DATE '2025-01-20',  7.50),
 (17, 5, 106, DATE '2025-08-14', DATE '2025-08-21', 26.25),
 (18, 2, 102, DATE '2025-09-02', DATE '2025-09-05', 13.50),
 (19, 1, 101, DATE '2025-10-10', NULL,              NULL),
 (20, 4, 108, DATE '2024-12-28', DATE '2025-01-03', 55.50),
 (21, 3, 103, DATE '2025-02-26', DATE '2025-03-02', 28.00),
 (22, 5, 104, DATE '2025-05-05', DATE '2025-05-08', 21.00);
--========================================================================================================================

--Part 1
--1.1
DROP TABLE IF EXISTS rentals, bikes, members, stations CASCADE;
 -- Create table: stations
CREATE TABLE stations (
    station_id   INT PRIMARY KEY,
    station_name VARCHAR(50) NOT NULL,
    city         VARCHAR(40) NOT NULL,
    capacity     INT NOT NULL
);
 -- Create table: bikes
CREATE TABLE bikes (
    bike_id    INT PRIMARY KEY,
    model      VARCHAR(50) NOT NULL,
    station_id INT REFERENCES stations(station_id),
    daily_rate NUMERIC(8,2) NOT NULL
);
-- Create table: members
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    full_name VARCHAR(60) NOT NULL,
    city      VARCHAR(40) NOT NULL,
    joined_on DATE NOT NULL
);
 -- Create table: rentals
CREATE TABLE rentals (
    rental_id  INT PRIMARY KEY,
    member_id  INT REFERENCES members(member_id),
    bike_id    INT REFERENCES bikes(bike_id),
    start_date DATE NOT NULL,
    end_date   DATE,
    fee        NUMERIC(8,2)
);

--

--1.2
INSERT INTO stations VALUES
 (10, 'Central Park', 'Almaty',   4),
 (20, 'Riverside',    'Almaty',   3),
 (30, 'Expo Gate',    'Astana',   5),
 (40, 'Old Town',     'Shymkent', 2),
 (50, 'Depot',        'Astana',   0);

INSERT INTO bikes VALUES
 (101, 'City Cruiser', 10,  4.50),
 (102, 'City Cruiser', 10,  4.50),
 (103, 'Mountain X',   20,  7.00),
 (104, 'Mountain X',   30,  7.00),
 (105, 'Road Sprint',  30,  9.25),
 (106, 'Folding Mini', 40,  3.75),
 (107, 'Cargo Hauler', 20, 12.00),
 (108, 'Road Sprint',  10,  9.25);

INSERT INTO members VALUES
 (1, 'Aisha Nurlanova', 'Almaty',   DATE '2023-03-14'),
 (2, 'Daniyar Serik',   'Almaty',   DATE '2023-07-02'),
 (3, 'Marta Kowalski',  'Astana',   DATE '2024-01-20'),
 (4, 'Chen Wei',        'Astana',   DATE '2024-05-11'),
 (5, 'Omar Haddad',     'Shymkent', DATE '2024-09-30'),
 (6, 'Elena Petrova',   'Almaty',   DATE '2025-02-05');

INSERT INTO rentals VALUES
 ( 1, 1, 101, DATE '2024-04-05', DATE '2024-04-08', 13.50),
 ( 2, 1, 103, DATE '2024-06-11', DATE '2024-06-16', 35.00),
 ( 3, 1, 108, DATE '2025-02-02', DATE '2025-02-04', 18.50),
 ( 4, 1, 102, DATE '2025-05-20', DATE '2025-05-27', 31.50),
 ( 5, 2, 101, DATE '2024-05-01', DATE '2024-05-02',  4.50),
 ( 6, 2, 107, DATE '2024-11-15', DATE '2024-11-19', 48.00),
 ( 7, 2, 107, DATE '2025-03-08', DATE '2025-03-14', 72.00),
 ( 8, 3, 104, DATE '2024-02-14', DATE '2024-02-18', 28.00),
 ( 9, 3, 105, DATE '2024-08-03', DATE '2024-08-06', 27.75),
 (10, 3, 104, DATE '2025-01-09', DATE '2025-01-10',  7.00),
 (11, 3, 105, DATE '2025-06-01', DATE '2025-06-09', 74.00),
 (12, 4, 104, DATE '2024-07-19', DATE '2024-07-21', 14.00),
 (13, 4, 105, DATE '2025-04-12', DATE '2025-04-15', 27.75),
 (14, 4, 103, DATE '2025-07-23', DATE '2025-07-29', 42.00),
 (15, 5, 106, DATE '2024-10-05', DATE '2024-10-12', 26.25),
 (16, 5, 106, DATE '2025-01-18', DATE '2025-01-20',  7.50),
 (17, 5, 106, DATE '2025-08-14', DATE '2025-08-21', 26.25),
 (18, 2, 102, DATE '2025-09-02', DATE '2025-09-05', 13.50),
 (19, 1, 101, DATE '2025-10-10', NULL,              NULL),
 (20, 4, 108, DATE '2024-12-28', DATE '2025-01-03', 55.50),
 (21, 3, 103, DATE '2025-02-26', DATE '2025-03-02', 28.00),
 (22, 5, 104, DATE '2025-05-05', DATE '2025-05-08', 21.00);

SELECT (SELECT COUNT(*) FROM stations) AS stations,
       (SELECT COUNT(*) FROM bikes)    AS bikes,
       (SELECT COUNT(*) FROM members)  AS members,
       (SELECT COUNT(*) FROM rentals)  AS rentals;

--Part 2
CREATE OR REPLACE FUNCTION inc(val INTEGER) RETURNS INTEGER AS $$
DECLARE
result INTEGER;
BEGIN
result := val + 1;
RETURN result;
END; $$
LANGUAGE plpgsql;
SELECT inc(10);
--2.1
create function rental_days(p_rental_id INT) returns int as $$
declare
v_days int;
    begin
        SELECT end_date - start_date
        INTO v_days
        FROM rentals
        WHERE rental_id = p_rental_id;
        RETURN v_days;
    end; $$
language plpgsql;

select rental_days(19); -- null
select rental_days(999); -- null

-- ex 2.2
create or replace function member_rental_count(p_member_id int)
returns int as $$
declare
    v_count int;
begin
    select count(*)
    into v_count
    from rentals
    where member_id = p_member_id;

    return v_count;
end;
$$ language plpgsql;

select member_rental_count(1) as member_1_rentals; -- 5
select member_rental_count(5) as member_5_rentals; -- 4
select member_rental_count(6) as member_6_rentals; -- 0

-- ex 2.3
create or replace function station_city(p_station_id int)
returns varchar as $$
declare
    v_city varchar(40);
begin
    select city
    into v_city
    from stations
    where station_id = p_station_id;

    return v_city;
end;
$$ language plpgsql;

select station_city(30) as station_30_city; -- astana
select station_city(77) as station_77_city; -- null

-- ex 2.4
select rental_id, member_id, rental_days(rental_id) as duration_days
from rentals
where rental_days(rental_id) > 4
order by duration_days desc, rental_id;


-- part 3


-- ex 3.1
create or replace function fee_with_discount(
    p_fee numeric,
    p_percent numeric
)
returns numeric as $$
begin
    return round(p_fee * (1 - p_percent / 100), 2);
end;
$$ language plpgsql;

select fee_with_discount(74.00, 15) as discounted_fee; -- 62.90

-- ex 3.2
create or replace function member_stats(
    p_member_id int,
    out rental_cnt int,
    out total_fee numeric,
    out last_start date
) as $$
begin
    select count(*)::int,
           coalesce(sum(fee), 0),
           max(start_date)
    into rental_cnt, total_fee, last_start
    from rentals
    where member_id = p_member_id;
end;
$$ language plpgsql;

select member_stats(3);
select * from member_stats(3);
select * from member_stats(6);

-- ex 3.3
create or replace function apply_late_fee(inout p_fee numeric)
as $$
begin
    p_fee := p_fee + 5.00;
end;
$$ language plpgsql;

select apply_late_fee(4.50) as fee_after_late_charge; -- 9.50

-- ex 3.4
create or replace function fee_summary(
    variadic p_fees numeric[],
    out total numeric,
    out average numeric,
    out largest numeric
) as $$
begin
    select sum(p_fees[g.i]),
           round(avg(p_fees[g.i]), 2),
           max(p_fees[g.i])
    into total, average, largest
    from generate_subscripts(p_fees, 1) as g(i);
end;
$$ language plpgsql;

select * from fee_summary(13.50, 35.00, 18.50, 31.50);
select * from fee_summary(); -- total/average/largest are null for an empty array

-- ex 3.5
-- a) in b) inout c) variadic d) out parameters

-- part 4


-- ex 4.1
create or replace function total_fees(p_member_id int)
returns numeric as $$
declare
    v_total numeric;
begin
    select coalesce(sum(fee), 0)
    into v_total
    from rentals
    where member_id = p_member_id;

    return v_total;
end;
$$ language plpgsql;

select total_fees(1) as member_1_total; -- 98.50
select total_fees(6) as member_6_total; -- 0

-- ex 4.2
create or replace function total_fees(p_member_id int, p_from_date date)
returns numeric as $$
declare
    v_total numeric;
begin
    select coalesce(sum(fee), 0)
    into v_total
    from rentals
    where member_id = p_member_id
      and start_date >= p_from_date;

    return v_total;
end;
$$ language plpgsql;

select total_fees(1, date '2024-01-01'); -- 98.50
select total_fees(1, date '2025-01-01'); -- 50.00


-- ex 4.3

create or replace function total_fees(
    p_member_id int,
    p_from_date date default date '2025-01-01'
)
returns numeric as $$
declare
    v_total numeric;
begin
    select coalesce(sum(fee), 0)
    into v_total
    from rentals
    where member_id = p_member_id
      and start_date >= p_from_date;

    return v_total;
end;
$$ language plpgsql;

-- ex 4.4
drop function total_fees(integer);
select total_fees(1) as member_1_from_default_date; -- 50.00

-- ex 4.5
create or replace function total_fees(p_member_name varchar)
returns numeric as $$
declare
    v_total numeric;
begin
    select coalesce(sum(r.fee), 0)
    into v_total
    from members m
    left join rentals r on r.member_id = m.member_id
    where m.full_name = p_member_name;

    return v_total;
end;
$$ language plpgsql;

select total_fees('aisha nurlanova'::varchar); -- 98.50
select total_fees(1); -- calls (int, date default ...) -> 50.00


-- part 5

-- ex 5.1
create or replace function find_bikes(p_pattern varchar)
returns table (
    found_id int,
    found_model varchar,
    found_rate numeric
) as $$
begin
    return query
    select b.bike_id, b.model::varchar, b.daily_rate
    from bikes b
    where b.model ilike p_pattern
    order by b.bike_id;
end;
$$ language plpgsql;

select * from find_bikes('%road%'); -- bikes 105 and 108
select * from find_bikes('%mini'); -- bike 106
-- select find_bikes('%road%'); -- without from, each composite row is one value

-- ex 5.2
create or replace function member_history(p_member_id int)
returns table (
    rental_id int,
    bike_model varchar,
    station_name varchar,
    duration_days int,
    fee numeric
) as $$
begin
    return query
    select r.rental_id,
           b.model::varchar,
           s.station_name::varchar,
           (r.end_date - r.start_date)::int,
           r.fee
    from rentals r
    join bikes b on b.bike_id = r.bike_id
    left join stations s on s.station_id = b.station_id
    where r.member_id = p_member_id
    order by r.start_date, r.rental_id;
end;
$$ language plpgsql;

select * from member_history(3);

-- ex 5.3
-- create or replace function bike_list(p_station_id int)
-- returns table (bike_id int, model varchar) as $$
-- begin
--     return query select bike_id, model
--     from bikes
--     where station_id = p_station_id;
-- end;
-- $$ language plpgsql;
-- select * from bike_list(10); -- ambiguous names at execution time

-- fix 1
create or replace function bike_list(p_station_id int)
returns table (out_bike_id int, out_model varchar) as $$
begin
    return query
    select b.bike_id, b.model::varchar
    from bikes b
    where b.station_id = p_station_id
    order by b.bike_id;
end;
$$ language plpgsql;

select * from bike_list(10);

-- fix 2
drop function bike_list(int);
create or replace function bike_list(p_station_id int)
returns table (bike_id int, model varchar) as $$
begin
    return query
    select b.bike_id, b.model::varchar
    from bikes as b
    where b.station_id = p_station_id
    order by b.bike_id;
end;
$$ language plpgsql;

select * from bike_list(10);

-- ex 5.4
-- count(*) is bigint; the declared output column s_bikes is int.
-- uncomment the select after creating the uncast version to reproduce:
-- create or replace function station_board(p_city varchar)
-- returns table (s_name varchar, s_bikes int, s_free int) as $$
-- begin
--     return query
--     select s.station_name::varchar, count(*),
--            (s.capacity - count(*))::int
--     from stations s
--     left join bikes b on b.station_id = s.station_id
--     where s.city = p_city
--     group by s.station_id, s.station_name, s.capacity
--     order by s.station_id;
-- end;
-- $$ language plpgsql;
-- select * from station_board('almaty');

create or replace function station_board(p_city varchar)
returns table (s_name varchar, s_bikes int, s_free int) as $$
begin
    return query
    select s.station_name::varchar,
           count(b.bike_id)::int,
           (s.capacity - count(b.bike_id))::int
    from stations s
    left join bikes b on b.station_id = s.station_id
    where s.city = p_city
    group by s.station_id, s.station_name, s.capacity
    order by s.station_id;
end;
$$ language plpgsql;

select * from station_board('almaty');
select * from station_board('astana');
select * from station_board('shymkent');


-- part 6

-- ex 6.1
do $$
<<rental_report>>
declare
    total_rentals int := 0;
begin
    select count(*)::int
    into total_rentals
    from rentals;

    raise notice 'the rentals table holds % rows.', total_rentals;
end rental_report;
$$;

-- ex 6.2
do $$
<<outer_block>>
declare
    fee_total numeric;
begin
    select coalesce(sum(fee), 0)
    into fee_total
    from rentals;

    raise notice 'outer total before subblock: %', fee_total;

    declare
        fee_total numeric;
    begin
        select coalesce(sum(fee), 0)
        into fee_total
        from rentals
        where start_date >= date '2025-01-01';

        raise notice 'subblock total: %', fee_total;
        raise notice 'outer total from subblock: %', outer_block.fee_total;
    end;

    raise notice 'outer total after subblock: %', fee_total;
end outer_block;
$$;

-- ex 6.3
-- this would fail because a subblock-local variable is out of scope:
-- do $$
-- begin
--     declare
--         local_value int := 10;
--     begin
--         raise notice 'first block: %', local_value;
--     end;
--     declare
--     begin
--         raise notice '%', local_value; -- error: variable does not exist here
--     end;
-- end;
-- $$;

-- correct approach: declare the variable in the outer block.
do $$
declare
    shared_value int := 10;
begin
    declare
    begin
        raise notice 'first subblock sees: %', shared_value;
    end;

    declare
    begin
        raise notice 'second subblock sees: %', shared_value;
    end;
end;
$$;

-- ex 6.4
create or replace function fee_split(
    p_from_date date,
    out before_total numeric,
    out after_total numeric
) as $$
begin
    select coalesce(sum(fee) filter (where start_date < p_from_date), 0),
           coalesce(sum(fee) filter (where start_date >= p_from_date), 0)
    into before_total, after_total
    from rentals;
end;
$$ language plpgsql;

select * from fee_split(date '2025-01-01'); -- 252.50 and 369.00

-- part 7


-- ex 7.1
create or replace function station_load(
    p_station_id int,
    out bikes_parked int,
    out capacity_pct numeric
) as $$
declare
    v_capacity int;
begin
    select s.capacity, count(b.bike_id)::int
    into v_capacity, bikes_parked
    from stations s
    left join bikes b on b.station_id = s.station_id
    where s.station_id = p_station_id
    group by s.capacity;

    if not found then
        bikes_parked := 0;
        capacity_pct := null;
    elsif v_capacity = 0 then
        capacity_pct := null; -- percentage is undefined for zero capacity
    else
        capacity_pct := round(bikes_parked::numeric * 100 / v_capacity, 1);
    end if;
end;
$$ language plpgsql;

select s.station_id, s.station_name, l.*
from stations s
cross join lateral station_load(s.station_id) l
order by s.station_id;

-- ex 7.2
create or replace function top_members(p_limit int default 3)
returns table (
    member_name varchar,
    rental_count int,
    total_spent numeric
) as $$
begin
    return query
    select m.full_name::varchar,
           count(r.rental_id)::int,
           coalesce(sum(r.fee), 0)::numeric
    from members m
    left join rentals r on r.member_id = m.member_id
    group by m.member_id, m.full_name
    order by coalesce(sum(r.fee), 0) desc, m.member_id
    limit p_limit;
end;
$$ language plpgsql;

select * from top_members();
select * from top_members(6);

-- ex 7.3
create or replace function rental_invoice(p_rental_id int)
returns table (
    member_name varchar,
    bike_model varchar,
    days int,
    amount_owed numeric,
    status varchar
) as $$
begin
    return query
    select m.full_name::varchar,
           b.model::varchar,
           (coalesce(r.end_date, current_date) - r.start_date)::int,
           round(
               (coalesce(r.end_date, current_date) - r.start_date)::numeric
               * b.daily_rate, 2
           )::numeric,
           (case when r.end_date is null then 'open' else 'closed' end)::varchar
    from rentals r
    join members m on m.member_id = r.member_id
    join bikes b on b.bike_id = r.bike_id
    where r.rental_id = p_rental_id;
end;
$$ language plpgsql;

select * from rental_invoice(11); -- 8 days, 74.00, closed
select * from rental_invoice(19); -- depends on current_date, open

-- ex 7.4
create or replace function city_report(p_city varchar)
returns table (
    member_count int,
    rental_count int,
    total_revenue numeric
) as $$
begin
    return query
    select count(distinct m.member_id)::int,
           count(distinct r.rental_id)::int,
           coalesce(sum(r.fee), 0)::numeric
    from members m
    left join rentals r on r.member_id = m.member_id
    where m.city = p_city;
end;
$$ language plpgsql;

create or replace function city_report(p_city varchar, p_from_date date)
returns table (
    member_count int,
    rental_count int,
    total_revenue numeric
) as $$
begin
    return query
    select count(distinct m.member_id)::int,
           count(distinct r.rental_id)::int,
           coalesce(sum(r.fee), 0)::numeric
    from members m
    left join rentals r
      on r.member_id = m.member_id
     and r.start_date >= p_from_date
    where m.city = p_city;
end;
$$ language plpgsql;

select * from city_report('almaty');
select * from city_report('almaty', date '2025-01-01');
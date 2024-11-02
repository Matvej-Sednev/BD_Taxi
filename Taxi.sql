drop schema taxi cascade;
create schema taxi;
set search_path = 'taxi';

CREATE TABLE IF NOT EXISTS taxi."Order"
(
    order_id integer NOT NULL,
    id_klient integer,
    id_driver integer,
    adress_departure character varying COLLATE pg_catalog."default",
    adress_appointements character varying COLLATE pg_catalog."default",
    time_date timestamp without time zone,
    order_status character varying(20) COLLATE pg_catalog."default",
    price numeric(10, 2),
    CONSTRAINT "Order_pkey" PRIMARY KEY (order_id)
);

CREATE TABLE IF NOT EXISTS taxi.car
(
    car_id integer NOT NULL,
    make_car character varying(255) COLLATE pg_catalog."default",
    model_car character varying(255) COLLATE pg_catalog."default",
    year_of_release integer,
    registration_number character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT car_pkey PRIMARY KEY (car_id)
);

CREATE TABLE IF NOT EXISTS taxi.driver
(
    driver_id integer NOT NULL,
    driver_name character varying(255) COLLATE pg_catalog."default",
    driver_surname character varying(255) COLLATE pg_catalog."default",
    number_car character varying(20),
    car_model character varying(20) COLLATE pg_catalog."default",
    status character varying(10) COLLATE pg_catalog."default",
    CONSTRAINT driver_pkey PRIMARY KEY (driver_id)
);

CREATE TABLE IF NOT EXISTS taxi.driver_rate
(
    driver_id integer,
    rate_id integer
);
CREATE TABLE IF NOT EXISTS taxi.driver_car
(
    driver_id integer references driver (driver_id),
    car_id integer references car (car_id)
);
CREATE TABLE IF NOT EXISTS taxi.klient
(
    klient_id integer NOT NULL,
    klient_name character varying(255) COLLATE pg_catalog."default",
    klient_lastname character varying(255) COLLATE pg_catalog."default",
    number_phone character varying(20) COLLATE pg_catalog."default",
    adress character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT klient_pkey PRIMARY KEY (klient_id)
);

CREATE TABLE IF NOT EXISTS taxi.rate
(
    rate_id integer NOT NULL,
    rate_name character varying(255) COLLATE pg_catalog."default",
    base_price numeric(10, 2),
    price_km numeric(10, 2),
    price_minut numeric(10, 2),
    CONSTRAINT rate_pkey PRIMARY KEY (rate_id)
);

CREATE TABLE IF NOT EXISTS taxi.route
(
    route_id integer NOT NULL,
    id_order integer,
    duration_trip integer,
    distance numeric(10, 2),
    CONSTRAINT route_pkey PRIMARY KEY (route_id)
);

ALTER TABLE IF EXISTS taxi."Order"
    ADD CONSTRAINT "Order_id_driver_fkey" FOREIGN KEY (id_driver)
    REFERENCES taxi.driver (driver_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS taxi."Order"
    ADD CONSTRAINT "Order_id_klient_fkey" FOREIGN KEY (id_klient)
    REFERENCES taxi.klient (klient_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;




ALTER TABLE IF EXISTS taxi.driver_rate
    ADD CONSTRAINT driver_rate_driver_id_fkey FOREIGN KEY (driver_id)
    REFERENCES taxi.driver (driver_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS taxi.driver_rate
    ADD CONSTRAINT driver_rate_rate_id_fkey FOREIGN KEY (rate_id)
    REFERENCES taxi.rate (rate_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS taxi.route
    ADD CONSTRAINT route_id_order_fkey FOREIGN KEY (id_order)
    REFERENCES taxi."Order" (order_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

INSERT INTO taxi.klient (klient_id, klient_name, klient_lastname, number_phone, adress) VALUES
(1, 'Иван', 'Иванов', '+79123456789', 'ул. Ленина, д. 10'),
(2, 'Анна', 'Петрова', '+79231234567', 'ул. Пушкина, д. 15'),
(3, 'Сергей', 'Сидоров', '+79876543210', 'ул. Лермонтова, д. 20');


INSERT INTO driver (driver_id, driver_name, driver_surname, number_car, car_model, status) VALUES
(1, 'Дмитрий', 'Козлов',  'А123БВ', 'Toyota Camry', 'Доступен'),
(2, 'Ольга', 'Смирнова',  'Б234CD', 'Kia Rio', 'Занят'),
(3, 'Алексей', 'Кузнецов', 'В345DE', 'Hyundai Solaris', 'Доступен');


INSERT INTO "Order" (order_id, id_klient, id_driver, adress_departure, adress_appointements, time_date, order_status, price) VALUES
(1, 1, 1, 'ул. Ленина, д. 10', 'ул. Пушкина, д. 15', '2023-10-26 10:00:00', 'В ожидании', 500.00),
(2, 2, 2, 'ул. Пушкина, д. 15', 'ул. Лермонтова, д. 20', '2023-10-26 12:30:00', 'В пути', 350.00),
(3, 3, 3, 'ул. Лермонтова, д. 20', 'ул. Ленина, д. 10', '2023-10-26 14:15:00', 'В ожидании', 400.00);

INSERT INTO route (route_id, id_order, duration_trip, distance) VALUES
(1, 2, 15, 7.5);


INSERT INTO rate (rate_id, rate_name, base_price, price_km, price_minut) VALUES
(1, 'Эконом', 100.00, 10.00, 2.00),
(2, 'Комфорт', 150.00, 15.00, 3.00);


INSERT INTO car (car_id, make_car, model_car, year_of_release, registration_number) VALUES
(1, 'Toyota', 'Camry', 2020, 'А123БВ'),
(2, 'Kia', 'Rio', 2022, 'Б234CD'),
(3, 'Hyundai', 'Solaris', 2021, 'В345DE');


INSERT INTO driver_rate (driver_id, rate_id) VALUES
(1, 1),
(2, 2),
(3, 2);

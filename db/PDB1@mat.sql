begin 
for i in (select constraint_name, table_name from user_constraints 
where table_name IN ('AUCTIONBIDDERS', 'AUCTIONS', 'BIDDERS', 'PRODUCT_TYPES', 'PRODUCTS', 'SELLERS', 'TABLICE')) LOOP
execute immediate 'alter table '|| i.table_name||' disable constraint '||i.constraint_name||'';
END LOOP;
end;
/

drop table tablice;
drop table products;
drop table auctionBidders;
drop table auctions;
drop table bidders;
drop TABLE sellers;
drop table product_types;

alter sequence auctions_seq RESTART start WITH 1;
alter sequence bidders_seq RESTART start WITH 1;
alter sequence sellers_seq RESTART start WITH 1;
alter sequence products_seq RESTART START WITH 1;
-- tables
create table tablice(
    id VARCHAR2(20) primary key,
    full_name VARCHAR(255),
    info VARCHAR2(2000)
);

create TABLE products(
    id NUMBER primary key,
    p_name VARCHAR(500),
    brand VARCHAR2(100),
    worth NUMBER(10, 2),    -- check needed >0
    prodt_id VARCHAR2(25),
    tab_id VARCHAR2(20) -- check to tablice needed
);

create table product_types(
    id VARCHAR2(25) primary key,
    pt_name VARCHAR2(250),
    discount NUMBER,
    expiration_date DATE,
    tab_id VARCHAR2(20) -- check to tablice needed
);

create table auctions(
    id NUMBER primary key,
    price NUMBER(10, 2),     -- check needed >0
    start_date DATE,
    end_date DATE,
    amount NUMBER,
    seller_id NUMBER,
    product_id NUMBER,
    tab_id VARCHAR2(20) -- check to tablice needed
);

create table auctionBidders(
auction_id NUMBER,
bidder_id NUMBER,
tab_id VARCHAR2(20) -- check to tablice needed
);

create table bidders(
    id NUMBER primary key,
    b_name VARCHAR2(100),
    surname VARCHAR2(100),
    money NUMBER(10, 2),
    sign_up_date DATE,
    tab_id VARCHAR2(20) -- check to tablice needed
);

create table sellers(
    id NUMBER primary key,
    s_name VARCHAR2(100) NOT NULL,
    surname VARCHAR2(100) NOT NULL,
    contact_number VARCHAR2(20) NOT NULL,  -- check needed length of ther number
    tab_id VARCHAR2(20) -- check to tablice needed
);

-- constraints
/*PRODUCTS*/
alter table products 
add constraint value_check check (worth > 0);

alter table products
add constraint tab_id_check check (tab_id IN ('PROD'));

/*
alter table products
add constraint sellers_fk foreign key (seller_id) references sellers(id);
*/

alter table products 
add constraint prod_types_fk foreign key(prodt_id) references product_types(id);

/*PRODUCT_TYPES*/
ALTER TABLE product_types
MODIFY pt_name varchar2(250) not null;

ALTER TABLE product_types
add constraint tab_id_prodt_check check(tab_id IN ('PTYPES'));

/*SELLERS*/
ALTER TABLE sellers
add CONSTRAINT sel_tab_id_check check(tab_id in ('SEL')); 

/* BIDDERS */
ALTER TABLE BIDDERS
add CONSTRAINT tab_id_bid_check check(tab_id IN ('BID'));

/* AUCTIONS */
alter table auctions
add constraint price_check check(price > 0);

alter table auctions 
add constraint amount_check check(amount >= 0); 

alter table auctions
add constraint auc_sel_fk foreign key(seller_id) references sellers(id);

alter table auctions
add constraint auc_prod_fk foreign key(PRODUCT_ID) references products(ID);

select column_name, constraint_name from all_cons_columns where 
table_name LIKE 'AUCTIONS' OR table_name LIKE 'PRODUCTS';


ALTER TABLE auctions
add constraint auc_tab_id_check check(tab_id in ('AUC'));

/*auctionbidders*/
ALTER TABLE auctionbidders
ADD CONSTRAINT aac_auc_fk foreign key(auction_id) REFERENCES auctions(id); 

ALTER TABLE auctionbidders
ADD CONSTRAINT aac_bid_fk foreign key(bidder_id) REFERENCES bidders(id);
-- data
/* sequences */
CREATE SEQUENCE sellers_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE auctions_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE bidders_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE products_seq
START WITH 1
INCREMENT BY 1;

/* inserts */

INSERT INTO tablice(id, full_name, info) VALUES('AAC', 'AUCTIONBIDDERS', 'Table for auction and bidders relation');
INSERT INTO tablice(id, full_name, info) VALUES('BID', 'BIDDERS', 'Actually those are buyers');
INSERT INTO tablice(id, full_name, info) VALUES('PTYPES', 'PRODUCT_TYPES', 'Product types or cathegories like on amazon');
INSERT INTO tablice(id, full_name, info) VALUES('PROD', 'PRODUCTS', 'All products that you can imagine');
INSERT INTO tablice(id, full_name, info) VALUES('SEL', 'SELLERS', 'All sellers from kamazon etc.');

INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Rowan','Collins','(612) 823-2642','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Elijah','Mcpherson','(684) 607-4525','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Charde','Preston','(892) 258-5863','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Emery','Decker','(182) 741-4570','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Kelsey','Hartman','(349) 125-8289','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Georgia','Sims','(617) 230-6378','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Neve','Lloyd','(466) 704-2938','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Myra','Chandler','(526) 849-7731','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Ferris','Parks','(103) 746-2139','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Simon','Haynes','(999) 855-6574','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval, 'Elaine','Bernard','(464) 878-9189','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval,'Astra','Dudley','(938) 578-7034','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval,'Marshall','Owens','(336) 175-1757','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval,'Jada','Maxwell','(576) 468-3253','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval,'Dillon','Burris','(427) 723-7615','SEL');
INSERT INTO sellers (id, s_name,surname,contact_number,tab_id) VALUES (sellers_seq.nextval,'Fitzgerald','Wilkins','(653) 781-7451','SEL');


select * from sellers;

-- bidders
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Cameron','Williamson',9073,to_date('28/03/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Ulysses','Knapp',9777,to_date('03/06/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Elvis','Walter',2775,to_date('29/11/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Barclay','Kirby',4212,to_date('11/08/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Chester','Whitehead',8260,to_date('27/03/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Karly','Mueller',1752,to_date('30/07/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Kylie','Curtis',436,to_date('13/08/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Jacqueline','Lewis',2750,to_date('16/12/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Casey','Mckay',1107,to_date('07/04/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Amal','Herrera',2550,to_date('19/05/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Bert','Carroll',8107,to_date('26/05/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Denton','Stuart',4916,to_date('04/09/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Declan','Dalton',7842,to_date('02/04/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Callie','May',2796,to_date('01/12/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Ayanna','Keith',2602,to_date('18/11/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Minerva','Hale',8292,to_date('04/12/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Kathleen','Mcfadden',8173,to_date('27/12/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Aristotle','Wilkerson',1163,to_date('24/08/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Keith','Marshall',2392,to_date('21/05/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Wendy','Pickett',4148,to_date('13/01/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Jessamine','Jenkins',4667,to_date('12/05/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Heidi','Goodman',5594,to_date('02/08/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Joan','Parrish',303,to_date('21/11/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Nicholas','Higgins',5883,to_date('29/09/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Orson','Mcmahon',2257,to_date('29/10/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Felicia','Wade',8971,to_date('18/05/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Thomas','Daugherty',2199,to_date('28/01/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Aileen','Hickman',3547,to_date('14/10/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Morgan','Garza',6766,to_date('13/05/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Phillip','Newton',3114,to_date('17/01/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Darius','Malone',1474,to_date('10/06/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Thomas','Cunningham',6302,to_date('19/07/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Chadwick','Rowland',2072,to_date('04/04/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Yoko','Gallegos',9953,to_date('24/12/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Isabella','Cortez',8303,to_date('10/09/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Lucius','Noble',3135,to_date('11/12/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Sopoline','Cruz',1183,to_date('09/03/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Gemma','Weaver',8192,to_date('03/04/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Uriah','Foreman',5161,to_date('25/05/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Randall','Brooks',5435,to_date('21/01/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Shana','Peck',5991,to_date('12/08/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Adara','Ramsey',5816,to_date('19/05/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Dustin','Boyd',7208,to_date('07/01/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Lucas','Lowe',3294,to_date('25/02/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Julie','Boyd',2995,to_date('16/04/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Virginia','Johnson',2038,to_date('17/10/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Christian','Barnes',972,to_date('08/03/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Fitzgerald','Oconnor',793,to_date('30/11/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Tiger','Stafford',1090,to_date('23/01/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Mufutau','Dunlap',2462,to_date('26/12/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Anne','Wilson',6590,to_date('20/04/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Wade','Sampson',8911,to_date('22/04/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Jael','Pearson',8339,to_date('10/07/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Alana','Keller',2820,to_date('08/12/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Pearl','Davenport',5285,to_date('29/09/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Naomi','Conrad',5770,to_date('07/03/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Buckminster','Holcomb',7427,to_date('29/01/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Ciaran','Cleveland',5991,to_date('24/08/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Kai','Ryan',5688,to_date('30/08/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Kylan','Hartman',8466,to_date('21/09/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Ignacia','Paul',1858,to_date('13/02/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Jescie','Hendrix',2590,to_date('29/08/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Keaton','Huffman',7865,to_date('11/03/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Eagan','Hodges',4417,to_date('12/02/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Neil','Hickman',7510,to_date('10/08/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Jin','Bright',5129,to_date('07/12/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Velma','Nieves',8784,to_date('22/02/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Wynne','Terrell',3208,to_date('18/01/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Irene','Battle',1262,to_date('10/01/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Allistair','Stephens',6404,to_date('30/10/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Linus','Wilkinson',1154,to_date('21/09/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Echo','Harper',4201,to_date('12/04/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Caleb','Sampson',2212,to_date('03/11/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Daphne','Hutchinson',2045,to_date('30/04/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Madeson','Holcomb',4969,to_date('11/02/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Jonas','Patrick',7027,to_date('18/08/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Yen','Gomez',2848,to_date('27/04/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Simon','Mcmahon',6422,to_date('25/06/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Jane','Huffman',543,to_date('22/05/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Ferdinand','Hensley',9393,to_date('30/11/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Carl','Morse',5948,to_date('12/08/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Austin','Mccormick',3929,to_date('25/09/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Forrest','Brooks',9547,to_date('06/02/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Malachi','Perez',7784,to_date('13/05/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Venus','Lane',3095,to_date('22/02/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Ebony','Mcmahon',5126,to_date('16/11/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Germaine','Larsen',2264,to_date('13/06/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Castor','Fletcher',7320,to_date('06/03/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Lisandra','Cleveland',5226,to_date('19/10/2020', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Nita','Potter',203,to_date('04/11/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Lael','Dotson',4209,to_date('23/08/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Kelsie','Schultz',5675,to_date('12/03/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Xandra','Ayers',663,to_date('24/01/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Clayton','Campbell',3601,to_date('29/11/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Kirestin','Hodge',3926,to_date('30/06/2022', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Samuel','Hester',6107,to_date('04/12/2021', 'dd/mm/yyyy'),'BID');
INSERT INTO bidders (id, b_name,surname,money,sign_up_date,tab_id) VALUES (bidders_seq.nextval, 'Ramona','Riggs',2709,to_date('17/03/2022', 'dd/mm/yyyy'),'BID');

select * from bidders;
-- product_types
INSERT INTO product_types (id, pt_name, tab_id) VALUES ('ELE', 'ELECTRONIC',  'PTYPES');
INSERT INTO product_types (id, pt_name, tab_id) VALUES ('TRN', 'TRANSPORT', 'PTYPES');
INSERT INTO product_types (id, pt_name, tab_id) VALUES ('FD', 'FOOD', 'PTYPES');
INSERT INTO product_types (id, pt_name, tab_id) VALUES ('ART', 'ART', 'PTYPES');
INSERT INTO product_types (id, pt_name, tab_id) VALUES ('TOY', 'TOYS' ,'PTYPES');
INSERT INTO product_types (id, pt_name, tab_id) VALUES ('HP', 'HEALTH','PTYPES');
INSERT INTO product_types (id, pt_name, tab_id) VALUES ('RLES', 'REAL ESTATE', 'PTYPES');
INSERT INTO product_types (id, pt_name, tab_id) VALUES ('SPR', 'SPORT', 'PTYPES');

select * from product_types;

-- products
INSERT INTO products (id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'HP FOLIO 9470m', 'HP',  1000, 'ELE', 'PROD');
INSERT INTO products (id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'LENOVO LEGION Y520', 'LENOVO', 3500, 'ELE', 'PROD');
INSERT INTO products (id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'MOTOROLA G6', 'MOTOROLA', 1020, 'ELE', 'PROD');
INSERT INTO products (id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'MICROSOFT SURFACE GO', 'MICROSOFT', 2500, 'ELE', 'PROD');
INSERT INTO products (id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'ASUS E210MA', 'ASUS', 1340, 'ELE', 'PROD');

INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'CITROEN C4', 'CITROEN', 60000, 'TRN', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'DACIA SANDERO', 'DACIA''TRN', 55000, 'TRN', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'PEUGEOT 2008', 'PEUGEOT', 10000, 'TRN', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval,  'SEAT LEON', 'SEAT', 35000, 'TRN', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'SKODA OCTAVIA', 'SKODA', 45000, 'TRN', 'PROD');

INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'PEPPERONI PIZZA', 'GUISEPPE', 15, 'FD', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'LAYS CHIPS','LAYS', 4, 'FD', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'HARIBO JELLY CANDY', 'HARIBO', 5, 'FD', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'KEBAB', 'BTRNOT TO SAY', 12, 'FD', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, '4 CHEESE PIZZA', 'DOMINOS', 25, 'FD', 'PROD');

INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'KETTLEBELL 12 KG', 'KAYETAN', 50, 'SPR', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'JUMPING ROPE', 'KAYETAN', 15, 'SPR', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval,'DUMBBELLS 2KG x2', 'KAYETAN', 20, 'SPR', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'BARBELLS 120CM', 'KAYETAN', 120, 'SPR', 'PROD');
INSERT INTO products(id, p_name, brand, worth, prodt_id, tab_id) VALUES (products_seq.nextval, 'THREADMILL', 'KAYETAN', 1400, 'SPR', 'PROD');

select * FROM PRODUCTS;
select * FROM tablice;
-- auctions
INSERT INTO auctions(id, price, start_date, end_date, amount, seller_id, product_id, tab_id) 
VALUES (auctions_seq.nextval, 25, to_date('31/08/21', 'dd/mm/yy'), to_date('31/01/21', 'dd/mm/yy'), 1000, 1, 13, 'AUC');

INSERT INTO auctions(id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 2600, 1, 1,4, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 3400, 1, 4, 2, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 3450, 1, 4, 2, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 3200, 1, 4, 2, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 3500, 1, 4, 2, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 3400, 1, 4, 2, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 3000, 1, 4, 4, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 2000, 1, 4, 4, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1500, 1, 4, 4, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 100, 1, 6, 3, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1000, 1, 6, 3, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 450, 1, 6, 3, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 50000, 1, 8, 7, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 45000, 1, 8, 7, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 51000, 1, 8, 7, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 60000, 1, 8, 7, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 100, 1, 8, 1, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 150, 1, 10, 1, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 150, 1, 1100, 1, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1200, 1, 12, 5, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1210, 1, 12, 5, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1150, 1, 12, 5, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1150, 1, 13, 20, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1250, 1, 13, 20, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1050, 1, 13, 20, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 1150, 1, 15, 19, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 11, 15, 16, 18, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 15, 30, 16, 18, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 45, 15, 16, 18, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 10, 5, 16, 17, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 10, 5, 16, 17, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 15, 5, 5, 17, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 61000, 3, 4, 6, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 60500, 3, 4, 6, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 9999, 3, 7, 8, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 7000, 3, 7, 8, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 11000, 3, 7, 8, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 3, 999, 10, 12, 'AUC');

INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id)
VALUES (auctions_seq.nextval, 2, 999, 11, 12, 'AUC');

select * from products;
select distinct product_id from auctions order by product_id;
-- auctions_bidders
INSERT INTO auctionbidders(auction_id, bidder_id, tab_id) VALUES (1, 1, 'AAC');
INSERT INTO auctionbidders(auction_id, bidder_id, tab_id) VALUES (1, 2, 'AAC');
INSERT INTO auctionbidders(auction_id, bidder_id, tab_id) VALUES (1, 3, 'AAC');

INSERT INTO auctionbidders(auction_id, bidder_id, tab_id) VALUES (2, 2, 'ACC');
INSERT INTO auctionbidders(auction_id, bidder_id, tab_id) VALUES (2, 4, 'ACC');
INSERT INTO auctionbidders(auction_id, bidder_id, tab_id) VALUES (2, 5, 'ACC');
INSERT INTO auctionbidders(auction_id, bidder_id, tab_id) VALUES (2, 6, 'ACC');
INSERT INTO auctionbidders(auction_id, bidder_id, tab_id) VALUES (2, 8, 'ACC');

select * from sellers;
select * from bidders;
select * from auctions;

commit;



SELECT SUM(ac.price - pr.worth)
FROM auctions ac
INNER JOIN products pr ON ac.product_id = pr.id
GROUP BY product_id;




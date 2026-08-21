-- ============================================================
-- SEED DATA — The Tropical Bistro (Panadura)
-- Run this AFTER schema.sql in the same Supabase SQL Editor.
-- ============================================================

-- Add receipt header fields (not in the base schema yet)
alter table restaurants add column if not exists address text;
alter table restaurants add column if not exists phone text;

-- ---------- RESTAURANT ----------
-- ⚠️ CONFIRM WITH CLIENT: menu card says corkage is FREE for food orders
-- above Rs. 3,000, but you told me Rs. 500 flat. Using 500 for now —
-- change the corkage_fee value below once confirmed.
insert into restaurants (name, address, phone, corkage_fee, service_charge_pct, pool_hourly_rate)
values ('The Tropical Bistro', 'Panadura, Kiriberiya', '076 000 0000', 500, 10, 500);

-- ---------- TABLES ----------
-- ⚠️ ASSUMED seat counts (client only gave "8 tables" total) — edit the
-- (number, seats) pairs below to match reality before going live.
insert into dining_tables (restaurant_id, number, seats)
select (select id from restaurants where name = 'The Tropical Bistro'), t.number, t.seats
from (values
  (1, 2), (2, 2), (3, 4), (4, 4), (5, 4), (6, 4), (7, 6), (8, 6)
) as t(number, seats);

-- ---------- MENU ----------
-- "X / Y" items on the card are split into separate rows (same price)
-- so each can be added to an order individually.

insert into menu_items (restaurant_id, name, category, price)
select (select id from restaurants where name = 'The Tropical Bistro'), m.name, m.category, m.price
from (values
  -- Appetizers & Bites
  ('Hot Butter Cuttlefish',        'Appetizers & Bites', 2400),
  ('Devilled Pork',                'Appetizers & Bites', 1800),
  ('Devilled Beef',                'Appetizers & Bites', 1800),
  ('Devilled Chicken',             'Appetizers & Bites', 1800),
  ('Garlic Butter Prawns',         'Appetizers & Bites', 2600),
  ('French Fries & Dips',          'Appetizers & Bites', 950),

  -- Fried Rice Variety
  ('Special Mixed Fried Rice',     'Fried Rice Variety', 1950),
  ('Chicken Fried Rice',           'Fried Rice Variety', 1450),
  ('Egg Fried Rice',               'Fried Rice Variety', 1450),
  ('Seafood Fried Rice',           'Fried Rice Variety', 1850),
  ('Nasi Goreng',                  'Fried Rice Variety', 2100),

  -- Traditional Rice & Curry
  ('Chicken Rice & Curry Meal',    'Traditional Rice & Curry', 1200),
  ('Fish Rice & Curry Meal',       'Traditional Rice & Curry', 1000),
  ('Egg Rice & Curry Meal',        'Traditional Rice & Curry', 1000),
  ('Special Pork Curry Plate',     'Traditional Rice & Curry', 1500),

  -- Kottu Specialities
  ('Chicken Kottu Roti',           'Kottu Specialities', 1400),
  ('Egg Kottu Roti',               'Kottu Specialities', 1400),
  ('Seafood Kottu Roti',           'Kottu Specialities', 1850),
  ('Cheese Chicken Kottu',         'Kottu Specialities', 1750),
  ('Roast Paan String Hopper Kottu','Kottu Specialities', 1600),

  -- Chef's Special Dishes
  ('Grilled Chicken Steak',        'Chef''s Special Dishes', 2200),
  ('BBQ Grilled Pork Ribs',        'Chef''s Special Dishes', 2800),
  ('Fish & Chips',                 'Chef''s Special Dishes', 1900),

  -- Soft Drinks & Sodas
  ('Coca-Cola (Can)',              'Soft Drinks & Sodas', 350),
  ('Coke Zero (Can)',              'Soft Drinks & Sodas', 350),
  ('Sprite (300ml)',               'Soft Drinks & Sodas', 300),
  ('Fanta (300ml)',                'Soft Drinks & Sodas', 300),
  ('EGB Ginger Beer',              'Soft Drinks & Sodas', 300),
  ('Elephant House Soda',          'Soft Drinks & Sodas', 250),

  -- BYOB Mixers & Chasers
  ('Coca-Cola Mixer (1.5L Pitcher)','BYOB Mixers & Chasers', 850),
  ('Sprite Mixer (1.5L Pitcher)',  'BYOB Mixers & Chasers', 850),
  ('Soda Mixer (1.5L Pitcher)',    'BYOB Mixers & Chasers', 700),
  ('Tonic Water (Can)',            'BYOB Mixers & Chasers', 450),
  ('Red Bull Energy Drink',        'BYOB Mixers & Chasers', 950),
  ('Cranberry Juice Mixer',        'BYOB Mixers & Chasers', 800),
  ('Apple Juice Mixer',            'BYOB Mixers & Chasers', 800),

  -- Juices & Chillers
  ('Fresh Lime Juice',             'Juices & Chillers', 500),
  ('Fresh Lime Soda',              'Juices & Chillers', 500),
  ('Passion Fruit Mocktail',       'Juices & Chillers', 650),
  ('Watermelon Juice',             'Juices & Chillers', 600),
  ('Mango Juice',                  'Juices & Chillers', 600),
  ('Iced Milo Dinosaur',           'Juices & Chillers', 600),

  -- BYOB Essentials
  ('Ice Bucket (Large)',           'BYOB Essentials', 350),
  ('Extra Ice Refill',             'BYOB Essentials', 200)
) as m(name, category, price);

-- Pool table row (one per restaurant, matches pool_hourly_rate above)
insert into pool_tables (restaurant_id, hourly_rate, status)
values ((select id from restaurants where name = 'The Tropical Bistro'), 500, 'available');

-- Run this once — adds a "type" column (Food/Drinks) used by the menu
-- filter buttons in the app, and fills it in for the items you already
-- inserted from seed_tropical_bistro.sql.

alter table menu_items add column if not exists type text not null default 'Food' check (type in ('Food', 'Drinks'));

update menu_items set type = 'Drinks'
where category in ('Soft Drinks & Sodas', 'BYOB Mixers & Chasers', 'Juices & Chillers');

-- Ice bucket / ice refill counted as Food-tab items (bar essentials, not
-- a drink itself) — move to Drinks instead if you'd rather they sit there:
-- update menu_items set type = 'Drinks' where category = 'BYOB Essentials';

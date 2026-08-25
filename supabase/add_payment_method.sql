-- Adds a payment method column to track Cash / Card / Bank Transfer / QR
-- per bill. Run this once in Supabase SQL Editor.

alter table bills add column if not exists payment_method text not null default 'Cash'
  check (payment_method in ('Cash', 'Card', 'Bank Transfer', 'QR'));

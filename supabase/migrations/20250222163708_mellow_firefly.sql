/*
  # Add sample building data

  1. Sample Data
    - 20 buildings with details
    - 4 sets of changes by different users
  
  2. Changes
    - Building updates
    - Detail modifications
    - Multiple user contributions
*/

-- Insert 20 buildings with varying details
INSERT INTO buildings (id, name, created_at, updated_at, created_by, updated_by)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'Downtown Office Tower', now() - interval '60 days', now() - interval '30 days', (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('22222222-2222-2222-2222-222222222222', 'Central Park Plaza', now() - interval '55 days', now() - interval '25 days', (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('33333333-3333-3333-3333-333333333333', 'Riverside Apartments', now() - interval '50 days', now() - interval '20 days', (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('44444444-4444-4444-4444-444444444444', 'Tech Hub Center', now() - interval '45 days', now() - interval '15 days', (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('55555555-5555-5555-5555-555555555555', 'Green Energy Building', now() - interval '40 days', now() - interval '10 days', (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('66666666-6666-6666-6666-666666666666', 'Innovation Center', now() - interval '35 days', now() - interval '5 days', (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('77777777-7777-7777-7777-777777777777', 'Skyline Tower', now() - interval '30 days', now(), (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('88888888-8888-8888-8888-888888888888', 'Harbor View Complex', now() - interval '25 days', now(), (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('99999999-9999-9999-9999-999999999999', 'Metropolitan Center', now() - interval '20 days', now(), (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Eco-friendly Office', now() - interval '15 days', now(), (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Smart Building One', now() - interval '14 days', now(), (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'The Sustainable Tower', now() - interval '13 days', now(), (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Future Hub', now() - interval '12 days', now(), (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Cloud Nine Center', now() - interval '11 days', now(), (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('ffffffff-ffff-ffff-ffff-ffffffffffff', 'The Glass House', now() - interval '10 days', now(), (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('11111111-2222-3333-4444-555555555555', 'Digital Plaza', now() - interval '9 days', now(), (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('22222222-3333-4444-5555-666666666666', 'Green Tower', now() - interval '8 days', now(), (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('33333333-4444-5555-6666-777777777777', 'Solar Building', now() - interval '7 days', now(), (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('44444444-5555-6666-7777-888888888888', 'Wind Power Center', now() - interval '6 days', now(), (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('55555555-6666-7777-8888-999999999999', 'Eco Hub', now() - interval '5 days', now(), (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com'));

-- Insert building details
INSERT INTO building_details (building_id, height, area, floors, energy_consumption, created_by, updated_by)
VALUES
  ('11111111-1111-1111-1111-111111111111', 150.5, 5000, 30, 250000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('22222222-2222-2222-2222-222222222222', 120.0, 4500, 25, 200000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('33333333-3333-3333-3333-333333333333', 80.0, 3000, 15, 150000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('44444444-4444-4444-4444-444444444444', 200.0, 8000, 40, 400000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('55555555-5555-5555-5555-555555555555', 100.0, 4000, 20, 180000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('66666666-6666-6666-6666-666666666666', 90.0, 3500, 18, 160000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('77777777-7777-7777-7777-777777777777', 180.0, 7000, 35, 350000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('88888888-8888-8888-8888-888888888888', 130.0, 5500, 28, 220000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('99999999-9999-9999-9999-999999999999', 160.0, 6000, 32, 280000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 110.0, 4200, 22, 190000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 140.0, 5800, 29, 240000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 95.0, 3800, 19, 170000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 170.0, 6500, 34, 320000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 125.0, 4800, 26, 210000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('ffffffff-ffff-ffff-ffff-ffffffffffff', 145.0, 5200, 31, 260000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('11111111-2222-3333-4444-555555555555', 85.0, 3200, 17, 155000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('22222222-3333-4444-5555-666666666666', 155.0, 5900, 33, 290000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('33333333-4444-5555-6666-777777777777', 105.0, 4100, 21, 185000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com')),
  ('44444444-5555-6666-7777-888888888888', 165.0, 6200, 36, 310000, (SELECT id FROM auth.users WHERE email = 'admin@admin.com'), (SELECT id FROM auth.users WHERE email = 'admin@admin.com')),
  ('55555555-6666-7777-8888-999999999999', 115.0, 4300, 23, 195000, (SELECT id FROM auth.users WHERE email = 'member@member.com'), (SELECT id FROM auth.users WHERE email = 'member@member.com'));

-- Insert sample change logs (4 sets of changes by different users)
INSERT INTO change_logs (table_name, record_id, change_type, old_values, new_values, user_id, created_at)
VALUES
  -- Admin updates Downtown Office Tower height
  ('building_details', '11111111-1111-1111-1111-111111111111', 'UPDATE', 
   '{"height": 150.5, "area": 5000, "floors": 30, "energy_consumption": 250000}',
   '{"height": 155.0, "area": 5000, "floors": 30, "energy_consumption": 250000}',
   (SELECT id FROM auth.users WHERE email = 'admin@admin.com'),
   now() - interval '25 days'),
   
  -- Member updates Central Park Plaza energy consumption
  ('building_details', '22222222-2222-2222-2222-222222222222', 'UPDATE',
   '{"height": 120.0, "area": 4500, "floors": 25, "energy_consumption": 200000}',
   '{"height": 120.0, "area": 4500, "floors": 25, "energy_consumption": 195000}',
   (SELECT id FROM auth.users WHERE email = 'member@member.com'),
   now() - interval '20 days'),
   
  -- Admin updates Riverside Apartments floors
  ('building_details', '33333333-3333-3333-3333-333333333333', 'UPDATE',
   '{"height": 80.0, "area": 3000, "floors": 15, "energy_consumption": 150000}',
   '{"height": 80.0, "area": 3000, "floors": 16, "energy_consumption": 150000}',
   (SELECT id FROM auth.users WHERE email = 'admin@admin.com'),
   now() - interval '15 days'),
   
  -- Member updates Tech Hub Center area
  ('building_details', '44444444-4444-4444-4444-444444444444', 'UPDATE',
   '{"height": 200.0, "area": 8000, "floors": 40, "energy_consumption": 400000}',
   '{"height": 200.0, "area": 8200, "floors": 40, "energy_consumption": 400000}',
   (SELECT id FROM auth.users WHERE email = 'member@member.com'),
   now() - interval '10 days');
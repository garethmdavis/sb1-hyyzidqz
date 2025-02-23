/*
  # Add coordinates to buildings

  1. Changes
    - Add latitude and longitude columns to buildings table
    - Update existing buildings with coordinates in Liverpool area
    - Add indexes for spatial queries

  2. Notes
    - Coordinates are centered around Liverpool city center
    - Buildings are spread across the city center and surrounding areas
*/

-- Add coordinates columns
ALTER TABLE buildings
ADD COLUMN latitude numeric(10,6) NOT NULL DEFAULT 53.4084,
ADD COLUMN longitude numeric(10,6) NOT NULL DEFAULT -2.9916;

-- Create indexes for spatial queries
CREATE INDEX idx_buildings_coordinates ON buildings (latitude, longitude);

-- Update existing buildings with coordinates around Liverpool
UPDATE buildings SET
  latitude = CASE id
    WHEN '11111111-1111-1111-1111-111111111111' THEN 53.4084  -- Downtown Office Tower (City Center)
    WHEN '22222222-2222-2222-2222-222222222222' THEN 53.4056  -- Central Park Plaza (Near St John's Gardens)
    WHEN '33333333-3333-3333-3333-333333333333' THEN 53.3961  -- Riverside Apartments (Near Albert Dock)
    WHEN '44444444-4444-4444-4444-444444444444' THEN 53.4007  -- Tech Hub Center (Baltic Triangle)
    WHEN '55555555-5555-5555-5555-555555555555' THEN 53.4121  -- Green Energy Building (Knowledge Quarter)
    WHEN '66666666-6666-6666-6666-666666666666' THEN 53.4157  -- Innovation Center (University Area)
    WHEN '77777777-7777-7777-7777-777777777777' THEN 53.4048  -- Skyline Tower (Business District)
    WHEN '88888888-8888-8888-8888-888888888888' THEN 53.3919  -- Harbor View Complex (Waterfront)
    WHEN '99999999-9999-9999-9999-999999999999' THEN 53.4103  -- Metropolitan Center (Shopping District)
    WHEN 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' THEN 53.4198  -- Eco-friendly Office (Edge Lane)
    WHEN 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' THEN 53.4144  -- Smart Building One (Near Lime Street)
    WHEN 'cccccccc-cccc-cccc-cccc-cccccccccccc' THEN 53.3998  -- The Sustainable Tower (Near Parliament Street)
    WHEN 'dddddddd-dddd-dddd-dddd-dddddddddddd' THEN 53.4067  -- Future Hub (Commercial District)
    WHEN 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee' THEN 53.4178  -- Cloud Nine Center (Islington)
    WHEN 'ffffffff-ffff-ffff-ffff-ffffffffffff' THEN 53.4023  -- The Glass House (Ropewalks)
    WHEN '11111111-2222-3333-4444-555555555555' THEN 53.4134  -- Digital Plaza (Near Royal Hospital)
    WHEN '22222222-3333-4444-5555-666666666666' THEN 53.3941  -- Green Tower (Kings Dock)
    WHEN '33333333-4444-5555-6666-777777777777' THEN 53.4089  -- Solar Building (Near Central Station)
    WHEN '44444444-5555-6666-7777-888888888888' THEN 53.4167  -- Wind Power Center (Everton)
    WHEN '55555555-6666-7777-8888-999999999999' THEN 53.3978  -- Eco Hub (Baltic Triangle)
    ELSE 53.4084
  END,
  longitude = CASE id
    WHEN '11111111-1111-1111-1111-111111111111' THEN -2.9916  -- City Center
    WHEN '22222222-2222-2222-2222-222222222222' THEN -2.9843  -- Near St John's Gardens
    WHEN '33333333-3333-3333-3333-333333333333' THEN -2.9889  -- Near Albert Dock
    WHEN '44444444-4444-4444-4444-444444444444' THEN -2.9789  -- Baltic Triangle
    WHEN '55555555-5555-5555-5555-555555555555' THEN -2.9669  -- Knowledge Quarter
    WHEN '66666666-6666-6666-6666-666666666666' THEN -2.9645  -- University Area
    WHEN '77777777-7777-7777-7777-777777777777' THEN -2.9912  -- Business District
    WHEN '88888888-8888-8888-8888-888888888888' THEN -2.9945  -- Waterfront
    WHEN '99999999-9999-9999-9999-999999999999' THEN -2.9878  -- Shopping District
    WHEN 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' THEN -2.9567  -- Edge Lane
    WHEN 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' THEN -2.9778  -- Near Lime Street
    WHEN 'cccccccc-cccc-cccc-cccc-cccccccccccc' THEN -2.9823  -- Near Parliament Street
    WHEN 'dddddddd-dddd-dddd-dddd-dddddddddddd' THEN -2.9901  -- Commercial District
    WHEN 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee' THEN -2.9734  -- Islington
    WHEN 'ffffffff-ffff-ffff-ffff-ffffffffffff' THEN -2.9812  -- Ropewalks
    WHEN '11111111-2222-3333-4444-555555555555' THEN -2.9712  -- Near Royal Hospital
    WHEN '22222222-3333-4444-5555-666666666666' THEN -2.9923  -- Kings Dock
    WHEN '33333333-4444-5555-6666-777777777777' THEN -2.9789  -- Near Central Station
    WHEN '44444444-5555-6666-7777-888888888888' THEN -2.9678  -- Everton
    WHEN '55555555-6666-7777-8888-999999999999' THEN -2.9845  -- Baltic Triangle
    ELSE -2.9916
  END;
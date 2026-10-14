CREATE TABLE users (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  created_at timestamptz NOT NULL DEFAULT now(),
  username text NOT NULL UNIQUE,
  email text NOT NULL UNIQUE
);

CREATE TABLE orders (
  -- resource
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id bigint NOT NULL REFERENCES users(id),
  status text NOT NULL DEFAULT 'pending' check(status in ('pending', 'fulfilled', 'canceled')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  -- order data
  total_cents integer NOT NULL,
  currency char(3) NOT NULL,
  shipping_street_address text,
  shipping_city text,
  shipping_state text,
  shipping_zip text,
  shipping_country text,
  notes text
);
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =========================
-- SUPER ADMIN
-- =========================
INSERT INTO users (
  id, tenant_id, email, password_hash, full_name, role, is_active
)
SELECT
  gen_random_uuid(),
  NULL,
  'superadmin@system.com',
  'TEMP_PASSWORD',
  'System Admin',
  'super_admin',
  true
WHERE NOT EXISTS (
  SELECT 1 FROM users WHERE email = 'superadmin@system.com'
);

-- =========================
-- TENANT
-- =========================
INSERT INTO tenants (
  id, name, subdomain, status, subscription_plan, max_users, max_projects
)
SELECT
  gen_random_uuid(),
  'Demo Company',
  'demo',
  'active',
  'pro',
  25,
  15
WHERE NOT EXISTS (
  SELECT 1 FROM tenants WHERE subdomain = 'demo'
);

-- =========================
-- TENANT ADMIN
-- =========================
INSERT INTO users (
  id, tenant_id, email, password_hash, full_name, role, is_active
)
SELECT
  gen_random_uuid(),
  t.id,
  'admin@demo.com',
  'TEMP_PASSWORD',
  'Demo Admin',
  'tenant_admin',
  true
FROM tenants t
WHERE t.subdomain = 'demo'
AND NOT EXISTS (
  SELECT 1 FROM users WHERE email = 'admin@demo.com'
);

-- =========================
-- REGULAR USERS
-- =========================
INSERT INTO users (
  id, tenant_id, email, password_hash, full_name, role
)
SELECT
  gen_random_uuid(),
  t.id,
  'user1@demo.com',
  'TEMP_PASSWORD',
  'Demo User One',
  'user'
FROM tenants t
WHERE t.subdomain = 'demo'
AND NOT EXISTS (
  SELECT 1 FROM users WHERE email = 'user1@demo.com'
);

INSERT INTO users (
  id, tenant_id, email, password_hash, full_name, role
)
SELECT
  gen_random_uuid(),
  t.id,
  'user2@demo.com',
  'TEMP_PASSWORD',
  'Demo User Two',
  'user'
FROM tenants t
WHERE t.subdomain = 'demo'
AND NOT EXISTS (
  SELECT 1 FROM users WHERE email = 'user2@demo.com'
);

-- =========================
-- PROJECTS
-- =========================
INSERT INTO projects (id, tenant_id, name, description, status)
SELECT
  gen_random_uuid(),
  t.id,
  'Project Alpha',
  'First demo project',
  'active'
FROM tenants t
WHERE t.subdomain = 'demo'
AND NOT EXISTS (
  SELECT 1 FROM projects WHERE name = 'Project Alpha'
);

INSERT INTO projects (id, tenant_id, name, description, status)
SELECT
  gen_random_uuid(),
  t.id,
  'Project Beta',
  'Second demo project',
  'active'
FROM tenants t
WHERE t.subdomain = 'demo'
AND NOT EXISTS (
  SELECT 1 FROM projects WHERE name = 'Project Beta'
);

-- =========================
-- TASKS
-- =========================
INSERT INTO tasks (
  id, project_id, tenant_id, title, status, priority
)
SELECT
  gen_random_uuid(),
  p.id,
  p.tenant_id,
  'Initial Task',
  'todo',
  'high'
FROM projects p
WHERE NOT EXISTS (
  SELECT 1 FROM tasks WHERE title = 'Initial Task'
)
LIMIT 1;

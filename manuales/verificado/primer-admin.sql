-- Activar y promover al primer usuario. Unico camino en un sistema virgen:
-- /api/user/register deja el usuario en UNCONFIRMED y la confirmacion exige
-- correo (SMTP) o un SYSTEM_ADMIN que todavia no existe.
UPDATE "User"
SET status = 'ACTIVE', role = 'SYSTEM_ADMIN'
WHERE email = 'admin@mi-cooperativa.org';

SELECT id, email, name, surname, status, role FROM "User";

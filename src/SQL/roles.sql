-- Role ao amin'ny ilay Localhost
CREATE USER 'administrateur'@'localhost' IDENTIFIED BY 'Admin123?';
CREATE USER 'utilisateur'@'localhost' IDENTIFIED BY 'User123?';
CREATE USER 'moderateur'@'localhost' IDENTIFIED BY 'Mod123?';

-- ito aloha no ampiasaina
-- CREATE USER 'machine'@'localhost' IDENTIFIED BY '123_machine';
CREATE USER 'machine'@'localhost' IDENTIFIED BY 'Machine123!';

-- Grant the permissions of the user
GRANT INSERT, UPDATE ON ticket TO 'machine'@'localhost';

CREATE  FUNCTION `generate_reference_recolte`() RETURNS varchar(30) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN CONCAT('RCLT', UUID(), '', DATE_FORMAT(NOW(), '%y%m%d%h%m%s'));
END
-- v1
CREATE  PROCEDURE `verifier_code_pin`(IN id_utilisateur int, IN cp varchar(4), IN cp_tente_max int, IN cp_tente_delais int)
BEGIN
    DECLARE cp_tente_init INT;
    DECLARE cp_tente_final INT;
    DECLARE cp_timestamp_expire DATETIME;

    START TRANSACTION;

    SELECT id INTO @user_verify
    FROM utilisateur
    WHERE id = id_utilisateur AND code_pin = cp;

    SELECT cp_tentative, cp_timestamp_exp INTO cp_tente_init, cp_timestamp_expire
    FROM utilisateur
    WHERE id = id_utilisateur;

    SET cp_tente_final = cp_tente_init + 1;
    set @cp_tente_reste = cp_tente_max - cp_tente_final;
    SET @cpttexp = DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL cp_tente_delais HOUR);

    IF cp_timestamp_expire > CURRENT_TIMESTAMP() THEN
        set @error_msg = CONCAT('Vous avez atteint la limite de votre tentative. Veuillez patientez jusqu''à', cp_timestamp_expire);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    IF @cp_tente_reste <> 0 THEN
        UPDATE utilisateur set cp_timestamp_exp = @cpttexp where id = id_utilisateur;
        set @error_msg = CONCAT('Vous avez atteint la limite de votre tentative. Veuillez patientez jusqu''à', @cpttexp);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    IF @id_user IS NULL THEN
        UPDATE utilisateur set cp_tentative = cp_tente_final where id = id_utilisateur;
        set @cp_tente_reste = cp_tente_max - cp_tente_final;
        set @error_msg = CONCAT( 'Vous avez saisissez un faux code pin. Tentative restante: ', @cp_tente_reste);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    IF cp_timestamp_expire > CURRENT_TIMESTAMP() THEN
        set @error_msg = CONCAT('Vous avez atteint la limite de votre tentative. Veuillez patientez jusqu''à', cp_timestamp_expire);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    COMMIT;
END

-- v2
CREATE  PROCEDURE `verifier_code_pin`(IN id_utilisateur int, IN cp varchar(4), IN cp_tente_max int, IN cp_tente_delais int)
BEGIN
    DECLARE cp_tente_init INT;
    DECLARE cp_tente_final INT;
    DECLARE cp_timestamp_expire DATETIME;

    SELECT id INTO @user_verify
    FROM utilisateur
    WHERE id = id_utilisateur AND code_pin = cp;

    SELECT cp_tentative, cp_timestamp_exp INTO cp_tente_init, cp_timestamp_expire
    FROM utilisateur
    WHERE id = id_utilisateur;

    SET cp_tente_final = cp_tente_init + 1;
    set @cp_tente_reste = (cp_tente_max - cp_tente_init);
    SET @cpttexp = DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL cp_tente_delais HOUR);

    START TRANSACTION;
    
    IF cp_timestamp_expire > CURRENT_TIMESTAMP() THEN
        set @error_msg = CONCAT('Veuillez patientez jusqu''à ', cp_timestamp_expire);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg; 
    ELSEIF @cp_tente_reste < 0 THEN
        UPDATE utilisateur set cp_timestamp_exp = @cpttexp, cp_tentative = 0 where id = id_utilisateur;
        set @error_msg = CONCAT('Vous avez atteint la limite de votre tentative. Veuillez patientez jusqu''à ', @cpttexp);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    ELSE
        select @user_verify,@cp_tente_reste, cp_tente_final,cp_tente_init, @cpttexp;
    END IF;

    IF @user_verify IS NULL THEN
        UPDATE utilisateur set cp_tentative = cp_tente_final where id = id_utilisateur;
        set @error_msg = CONCAT( 'Vous avez saisissez un faux code pin. Tentative restante: ', @cp_tente_reste);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    COMMIT;
END


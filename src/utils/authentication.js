import {z, ZodError} from "zod"
import mysqlPool from "../config/database.js";
import DateFormat from "./date.format.js";

const minimumPasswordLength = 8;
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&\-_])[A-Za-z\d@$!%*?&\-_]+$/;

const signUpSchema = z.object({
    email: z.string().min(1, "L'email est requis").email("Email invalide"),
    mdp: z.string().min(1, "Le mot de passe est requis"),
    nom: z.string().min(1, "Votre nom est requis"),
    prenom: z.string().min(1, "Votre prénom est requis"),
    date_naissance: z.string()
    .transform(dateStr => DateFormat.parseDate(dateStr))
    .refine(date => {
        const today = new Date();
        const minAge = 18;
        const minBirthDate = new Date(today.getFullYear() - minAge, today.getMonth(), today.getDate());
        return date <= minBirthDate; // Ensure the birthdate is at least 18 years ago
    }, {
        message: "Vous devez avoir au moins 18 ans.",
    })
});


const signInSchema = z.object({
    username: z.string().min(1, "Le nom d'utilisateur est requis").max(50, "Le nom d'utilisateur est trop long"),
    password: z.string()
        .min(minimumPasswordLength, `Le mot de passe doit contenir au moins ${minimumPasswordLength} caractères`)
        .max(100, "Le mot de passe est trop long")
        .regex(passwordRegex, "Le mot de passe doit contenir au moins une lettre majuscule, une lettre minuscule, un chiffre et un caractère spécial"),
});

class AuthenticationController {

    static validateLogin = (req, res, next) => {
        try {
            // Validate the request body against the schema
            signInSchema.parse(req.body);
            next();
        } catch (error) {
            if (error instanceof ZodError) {
                // Map the validation errors to the corresponding fields
                const validationErrors = error.errors.reduce((acc, err) => {
                    acc[err.path[0]] = err.message;
                    return acc;
                }, {});
                // Return the validation errors in the desired format
                res.status(400).json({ error: validationErrors });
            } else {
                console.error(error); // Log the unexpected error for debugging
                res.status(500).json({ error: 'Internal Server Error' });
            }
        }
    };

    static login = async (req, res) => {
        try {
            // Validate the request body against the schema
            signInSchema.parse(req.body);

            // If validation passes, perform login
            const { username, password } = req.body;

            const sql_username = `select
                    u.email,
                    CONCAT(u.nom,' ',u.prenom) as nom_complet,
                    u.pseudo_utilisateur,
                    u.id
                    from utilisateur u
                    where (u.email= ? or u.pseudo_utilisateur = ?)`

            const sql_username_pwd = `select
                    u.email,
                    CONCAT(u.nom, ' ', u.prenom) as nom_complet,
                    u.pseudo_utilisateur,
                    u.id
                from utilisateur u
                where
                    (u.email = ? and u.mot_de_passe = ?)
                    or
                    (u.pseudo_utilisateur = ? and u.mot_de_passe = ?)`;

            const values_username = [username, password]
            const values_username_pwd = [username, password, username, password];

            // Assuming you're using a promise-based db query function
            mysqlPool.query(sql_username,values_username,(err,result)=>{
                // console.log(result)
                if (result.length > 0) {
                    mysqlPool.query(sql_username_pwd,values_username_pwd,(err,result)=>{
                        if (result.length > 0 ) {
                            res.json({user: result[0]});
                        } else {
                            res.status(401).json({ error: {password: "Votre mot de passe est incorrect"}});
                        }
                    })
                    // res.json({user: result[0]});
                } else {
                    res.status(401).json({ error: {username: "Votre email ou pseudo utilisateur est incorrect"}});
                }
            })
            // const [result] = await mysqlPool.query(sql, values)
        } catch (error) {
            if (error instanceof ZodError) {
                // Map the validation errors to the corresponding fields
                const validationErrors = error.errors.reduce((acc, err) => {
                    acc[err.path[0]] = err.message;
                    return acc;
                }, {});
                // Return the validation errors in the desired format
                res.status(400).json({ error: validationErrors });
            } else {
                console.error(error); // Log the unexpected error for debugging
                res.status(500).json({ error: 'Internal Server Error' });
            }
        }
    };

    static sInscrire = async (req,res)=>{
        try {

            signUpSchema.parse(req.body)

            const { email, mdp, nom, prenom, date_naissance } = req.body;
            // console.log(req.body)

            const sql = `INSERT INTO utilisateur
	( nom, prenom, email, mot_de_passe, date_naissance ) VALUES ( ?, ?, ?, ?, ? )`
            mysqlPool.query(sql,[nom,prenom,email,mdp,date_naissance],(err,result)=>{
                if (err) {
                    console.error('Erreur insertion de donnnee:\n', err);
                    res.json({error:err.sqlMessage})
                } else {
                    console.log('Insertion avec succes: ', result);
                    res.json({message: 'Votre compte plastikoo a bien ete crée'});
                }
            })
        } catch (error) {
            if (error instanceof ZodError) {
                // Map the validation errors to the corresponding fields
                const validationErrors = error.errors.reduce((acc, err) => {
                    acc[err.path[0]] = err.message;
                    return acc;
                }, {});
                // Return the validation errors in the desired format
                res.status(400).json({ error: validationErrors });
            } else {
                console.error(error); // Log the unexpected error for debugging
                res.status(500).json({ error: 'Internal Server Error' });
            }
        }
    }

}

export default AuthenticationController
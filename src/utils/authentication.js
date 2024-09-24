import {z, ZodError} from "zod"
import mysqlPool from "../config/database.js";
import DateFormat from "./date.format.js";
import bcrypt from "bcrypt";
import JwtUtils from "../utils/jwt.js"
import jwt, { decode } from 'jsonwebtoken';
import "dotenv/config"
import Passport  from "passport";

const {JWT_SECRET,BCRYPT_SALT_ROUNDS, MIN_PASSWORD_LENGTH} = process.env;

const minimumPasswordLength = Number(MIN_PASSWORD_LENGTH);
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]+$/;

const signUpSchema = z.object({
    email: z.string().min(1, "L'email est requis").email("Email invalide"),
    mdp: z.string()
    .min(minimumPasswordLength, `Le mot de passe doit contenir au moins ${minimumPasswordLength} caractères`)
    .max(100, "Le mot de passe est trop long")
    .regex(passwordRegex, "Le mot de passe doit contenir au moins une lettre majuscule, une lettre minuscule, et un chiffre"),
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
    password: z.string().min(1, "Le nom d'utilisateur est requis")
});

// console.log(BCRYPT_SALT_ROUNDS)
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

    // static login = async (req, res) => {
    //     try {
    //         // Validate the request body against the schema
    //         signInSchema.parse(req.body);

    //         // If validation passes, perform login
    //         const { username, password } = req.body;

    //         const sql_username = `select
    //                 u.email,
    //                 CONCAT(u.nom,' ',u.prenom) as nom_complet,
    //                 u.pseudo_utilisateur,
    //                 u.id
    //                 from utilisateur u
    //                 where (u.email= ? or u.pseudo_utilisateur = ?)`

    //         const sql_username_pwd = `select
    //                 u.email,
    //                 CONCAT(u.nom, ' ', u.prenom) as nom_complet,
    //                 u.pseudo_utilisateur,
    //                 u.id
    //             from utilisateur u
    //             where
    //                 (u.email = ? and u.mot_de_passe = ?)
    //                 or
    //                 (u.pseudo_utilisateur = ? and u.mot_de_passe = ?)`;

    //         const values_username = [username, password]
    //         const values_username_pwd = [username, password, username, password];

    //         // Assuming you're using a promise-based db query function
    //         mysqlPool.query(sql_username,values_username,(err,result)=>{
    //             // console.log(result)
    //             if (result.length > 0) {
    //                 mysqlPool.query(sql_username_pwd,values_username_pwd,(err,result)=>{
    //                     if (result.length > 0 ) {
    //                         res.json({user: result[0]});
    //                     } else {
    //                         res.status(401).json({ error: {password: "Votre mot de passe est incorrect"}});
    //                     }
    //                 })
    //                 // res.json({user: result[0]});
    //             } else {
    //                 res.status(401).json({ error: {username: "Votre email ou pseudo utilisateur est incorrect"}});
    //             }
    //         })
    //         // const [result] = await mysqlPool.query(sql, values)
    //     } catch (error) {
    //         if (error instanceof ZodError) {
    //             // Map the validation errors to the corresponding fields
    //             const validationErrors = error.errors.reduce((acc, err) => {
    //                 acc[err.path[0]] = err.message;
    //                 return acc;
    //             }, {});
    //             // Return the validation errors in the desired format
    //             res.status(400).json({ error: validationErrors });
    //         } else {
    //             console.error(error); // Log the unexpected error for debugging
    //             res.status(500).json({ error: 'Internal Server Error' });
    //         }
    //     }
    // };

    static login = async (req, res) => {
        try {
            // Validate the request body against the schema
            signInSchema.parse(req.body);

            // If validation passes, perform login
            const { username, password } = req.body;

            // SQL query to get the user data including the hashed password
            const sql = `SELECT
                    email,
                    CONCAT(nom, ' ', prenom) as nom_complet,
                    pseudo_utilisateur,
                    id ,
                    mot_de_passe
                FROM utilisateur
                WHERE email = ? OR pseudo_utilisateur = ?`;

            // Values for the query
            const values = [username, username];

            // Query the database
            mysqlPool.query(sql, values, async (err, results) => {
                if (err) {
                    console.error('Database query error:', err);
                    return res.status(500).json({ error: err.message });
                }

                if (results.length > 0) {
                    const user = results[0];

                    // Compare the provided password with the hashed password
                    try {
                        const match = await bcrypt.compare(password, user.mot_de_passe);

                        if (match) {
                            // console.log(token)
                            // res.json({ user, token });
                            // Password matched
                            // let pseudo = user.pseudo_utilisateur
                            // if(user.pseudo_utilisateur == null){
                            //     pseudo = user.nom_complet
                            // }
                            // const userData = {
                            //     "id_utilisateur":user.id,
                            //     "pseudo_utilisateur": pseudo,
                            //     "nom_complet": user.nom_complet
                            // }
                            // console.log("Here is the data after loged:\n",{
                            //     "id_utilisateur":user.id,
                            //     "pseudo_utilisateur": pseudo,
                            //     "nom_complet": user.nom_complet
                            // })
                            // const token = await JwtUtils.generateToken({
                            //     "id_utilisateur":user.id,
                            //     "pseudo_utilisateur": pseudo,
                            //     "nom_complet": user.nom_complet
                            // });
                            const token = await JwtUtils.generateToken({
                                "id_utilisateur":user.id
                            });
                            res.status(200).json({token});
                        } else {
                            // Password did not match
                            res.status(401).json({ error: { password: 'Votre mot de passe est incorrect' } });
                        }
                    } catch (error) {
                        console.error('Password comparison error:', error);
                        res.status(500).json({ error: 'Internal Server Error' });
                    }
                } else {
                    // No user found with the given username
                    res.status(401).json({ error: { username: 'Votre email ou pseudo utilisateur est incorrect' } });
                }
            });
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
                console.error('Unexpected error:', error); // Log the unexpected error for debugging
                res.status(500).json({ error: 'Internal Server Error' });
            }
        }
    }

    // Refactor function with promise-based approach
    static sInscrire = async (req, res) => {
        let connection;
        try {
            // Validate request body using Zod
            signUpSchema.parse(req.body);
    
            const { email, mdp, nom, prenom, date_naissance } = req.body;
            // console.log(req.body)

            const salt = bcrypt.genSaltSync(Number(BCRYPT_SALT_ROUNDS));
            const hashMdp = bcrypt.hashSync(mdp, salt);
    
            // Get a connection from the pool wrapped in a Promise
            connection = await new Promise((resolve, reject) => {
                mysqlPool.getConnection((err, conn) => {
                    if (err) return reject(err);
                    resolve(conn);
                });
            });
    
            // Begin transaction
            await new Promise((resolve, reject) => {
                connection.beginTransaction((err) => {
                    if (err) {
                        connection.release();
                        res.json({error:err.message})
                        return reject(err);
                    }
                    resolve();
                });
            });
    
            // Execute the query with promises
            const sql = 'CALL inscrireUtilisateur (?, ?, ?, ?, ?)';
            const result = await new Promise((resolve, reject) => {
                connection.query(sql, [nom, prenom, email, hashMdp, date_naissance], (err, results) => {
                    if (err) {
                        res.json({error:err.sqlMessage})
                        return reject(err);
                    }
                    resolve(results);
                });
            });
            // Assuming the stored procedure returns the user's ID
            const userId = result[0][0] // Adjust based on your stored procedure result
            console.log(userId)
            // const tokenPayload = { id: userId };
            const tokenPayload = userId;

            // Generate JWT token
            const token = await JwtUtils.generateToken(tokenPayload);
    
            // Commit the transaction
            await new Promise((resolve, reject) => {
                connection.commit((err) => {
                    if (err) {
                        res.json({error:err.sqlMessage})
                        return reject(err);
                    }
                    resolve();
                });
            });
    
            console.log('Insertion réussie et jeton généré:', result);
    
            // Send success message and token
            res.status(201).json({
                message: "Votre compte Plastikoo a bien été créé.",
                token: token
            });
    
        } catch (error) {
            if (connection) {
                // Rollback the transaction in case of error
                await new Promise((resolve, reject) => {
                    connection.rollback(() => {
                        connection.release();
                        resolve();
                    });
                });
            }
    
            if (error instanceof ZodError) {
                const validationErrors = error.errors.reduce((acc, err) => {
                    acc[err.path[0]] = err.message;
                    return acc;
                }, {});
                return res.status(400).json({ error: validationErrors });
            } else {
                console.error("Erreur inattendue:", error);
                return res.status(500).json({ error: "Erreur interne du serveur." });
            }
        } finally {
            if (connection) {
                // Release the connection back to the pool
                connection.release();
            }
        }
    };

    static verifyRoleToken = (requiredRole) => {
        return async (req, res, next) => {
            try {
                // Verify the JWT token
                const token = req.header('Authorization').replace('Bearer ', '');
                const decodedToken = jwt.verify(token, JWT_SECRET);
                console.log(decodedToken)
                const { id_utilisateur } = decodedToken;
                if(id_utilisateur == undefined){
                    res.json({error:"l'utilisateur n'exsite pas"})
                }

                // Query to check if the user has the required role
                const query = `
                    SELECT COUNT(u.id) as role_exist
                    FROM utilisateur_role ur
                    JOIN utilisateur u ON ur.id_utilisateur = u.id
                    JOIN role r ON ur.id_role = r.id
                    WHERE ur.id_utilisateur = ? AND ur.id_role = (
                        SELECT r.id FROM role r WHERE r.designation = ?
                    )
                `;

                mysqlPool.query(query, [id_utilisateur, requiredRole], (err, results) => {
                    if (err) {
                        return res.status(500).json({ error: 'La requête de base de données a échoué', details: err });
                    }
                    // console.log(query)
                    // console.log(results[0].role_exist)
                    if (results[0].role_exist > 0) {
                        // User has the required role, proceed to the next middleware
                        req.utilisateur = decodedToken;  // Attach user info to request for further use
                        next();
                    } else {
                        // User does not have the required role
                        return res.status(403).json({ error: 'Accès non autorisé' });
                    }
                });

            } catch (error) {
                return res.status(401).json({ error: 'Veuillez vous authentifier' });
            }
        };
    };

    static logOut = async(req,res) =>{

    }

    static googleAuth = Passport.authenticate('google', { scope: ['profile', 'email'] });

    static googleCallback = (req, res) => {
      const token = signToken(req.user);
      res.json({ token });
    };
    
    static getProfile = (req, res) => {
      res.json(req.user);
    };
}

export default AuthenticationController
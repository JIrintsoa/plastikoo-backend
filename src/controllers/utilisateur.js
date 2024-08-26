import { z,ZodError } from "zod"
import mysqlPool from "../config/database.js"


const PINSchemas = z.object({
    id_utilisateur: z.number().int().positive({message:"l'id_utilisateur doit etre positive"}),
    code_pin: z.string()
    .regex(/^\d+$/, {
        message: 'Veuillez saisir une valeur numérique'
    }).min(4,{message:"le code doit etre 4 chiffre"}).max(4,{message:"le code doit etre 4 chiffre"})
})

const verifieSoldeSchemas = z.object({
    id_utilisateur : z.number().int().positive({message:"id_utilisateur doit etre superieur à 0"}),
    montant: z.number().int().multipleOf(0.01).positive({message:"Solde doit etre superieur à 0"}),
})

const pseudoSchemas = z.object({
    pseudo: z.string()
    .min(3, "Le pseudo doit comporter au moins 3 caractères.")
    .max(20, "Le pseudo ne peut pas dépasser 20 caractères.")
    .regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]+$/, "Le pseudo doit contenir au moins une lettre majuscule, une lettre minuscule, un chiffre et un underscore.")
})

const verifierSolde = ({id_user, somme},res) => {
    let isVerify = 0
    const form = verifieSoldeSchemas.parse({
        id_utilisateur: id_user,
        montant: somme
    })
    const {id_utilisateur, montant} = form
    const sql  = `call verifier_solde(?,?)`
    mysqlPool.query(sql,[id_utilisateur,montant],(err, result)=>{
        if (err) {
            console.error('solde insuffisant :: ', err);
            res.json({error:err.sqlMessage})
        }
        else {
            // console.log('good data')
            // res.json({valeur:1})
            isVerify = 1
        }
    })
    return isVerify
}

const verifierCodePIN = (req,res) => {

    try {
        const form = PINSchemas.parse({
            id_utilisateur: req.body.id_utilisateur,
            code_pin: req.body.code_pin
        })
        const {
            id_utilisateur,
            code_pin
        } = form

        // const sql = `select id from utilisateur where id = ? and code_pin = ?`;
        const sql = `CALL verifier_code_pin(?,?,3,1)`
        mysqlPool.query(sql,[id_utilisateur,code_pin],(err,result) => {
            if (err) {
                console.error('Erreur fetch de l\'utilisateur:: ', err);
                res.json({error:err.sqlMessage})
            } else {
                console.log('Code pin verifie:\n', result);
                res.json(result[0]);
            }
        });
    } catch (error) {
        if (error instanceof ZodError) {
            const validationErrors = error.errors.map(err => err.message).join(', ');
            console.error(error)
            res.status(400).json({ error: validationErrors });
        } else {
            console.error(error); // Log the unexpected error for debugging
            res.status(500).json({ error: 'Internal Server Error' });
        }
    }
}

const creeCodePIN = (req,res) =>{
    try {
        const form = PINSchemas.parse({
            id_utilisateur: req.body.id_utilisateur,
            code_pin: req.body.code_pin
        })
        const {
            id_utilisateur,
            code_pin
        } = form

        const sql = `UPDATE utilisateur set code_pin = ? where id = ?`;
        mysqlPool.query(sql,[code_pin,id_utilisateur],(err,result) => {
            if (err) {
                console.error('Erreur d\'ajoute CODE PIN de l\'utilisateur: ', err);
                res.json({error:err.sqlMessage})
            } else {
                console.log('Code pin ajouté', result);
                res.json({message: 'Code PIN ajouté'});
            }
        });
    } catch (error) {
        if (error instanceof ZodError) {
            const validationErrors = error.errors.map(err => err.message).join(', ');
            console.error(error)
            res.status(400).json({ error: validationErrors });
        } else {
            console.error(error); // Log the unexpected error for debugging
            res.status(500).json({ error: 'Internal Server Error' });
        }
    }
}

const creePseudo = (req,res) => {
    try {
        pseudoSchemas.parse(req.body)
        const {pseudo, id_utilisateur} = req.body
        const sql = `UPDATE utilisateur SET pseudo_utilisateur = ? where id = ?`
        mysqlPool.query(sql,[pseudo, id_utilisateur],(err,result)=>{
            if (err) {
                console.error('Erreur d\'ajout pseudo de l\'utilisateur: ', err);
                res.json({error:err.sqlMessage})
            } else {
                console.log('ajout de pseudo success', result);
                res.json({message: 'Votre pseudo a bien été ajouté'});
            }
        })
        // console.log('helloo world')
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

export default {
    creeCodePIN,
    verifierCodePIN,
    verifierSolde,
    creePseudo
}
import { z,ZodError } from "zod"
import mysqlPool from "../config/database.js"

import 'dotenv/config'
import UploadController from "./upload.js"

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

const profileSchemas = z.object({
    email: z.string().min(1, "L'email est requis").email("Email invalide"),
    pseudo: z.string().min(1, "Pseudo est requis"),
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
            id_utilisateur: req.utilisateur.id_utilisateur,
            code_pin: req.body.code_pin
        })
        const {
            id_utilisateur,
            code_pin
        } = form

        // const sql = `select id from utilisateur where id = ? and code_pin = ?`;
        const sql = `CALL verifier_code_pin(?,?,${process.env.CP_TENTE_MAX},${process.env.CP_TENTE_DELAIS})`
        console.log(sql)
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
            id_utilisateur: req.utilisateur.id_utilisateur,
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
        if(!req.fileUploaded) {
            return res.status(400).json({ error: 'Erreur à la récuperation du nom de fichier' });
        }
        pseudoSchemas.parse(req.body)

        const id_utilisateur = req.utilisateur.id_utilisateur
        const {pseudo} = req.body
        const pseudo_img = req.fileUploaded

        const sql = `UPDATE utilisateur SET pseudo_utilisateur = ?, img_profil = ? where id = ?`
        mysqlPool.query(sql,[pseudo,pseudo_img,id_utilisateur],(err,result)=>{
            if (err) {
                console.error('Erreur d\'ajout pseudo de l\'utilisateur: ', err);
                UploadController.deleteFileLocalUploaded(pseudo_img)
                res.json({error:err.sqlMessage})
            } else {
                console.log('ajout de pseudo success', result);
                res.json({message: 'Votre pseudo a bien été ajouté'});
            }
        })
        // console.log('helloo world')
    } catch (error) {
        if (error instanceof ZodError) {
            const validationErrors = error.errors.map(err => err.message).join(', ');
            if (req.fileUploaded) {
                UploadController.deleteFileLocalUploaded(req.fileUploaded)
            }
            console.error(error)
            res.status(400).json({ error: validationErrors });
        } else {
            console.error(error);
            if (req.fileUploaded) {
                UploadController.deleteFileLocalUploaded(req.fileUploaded)
            } // Log the unexpected error for debugging
            res.status(500).json({ error: 'Internal Server Error' });
        }
    }
}

const liste = (req,res) =>{
    const sql = ` SELECT * FROM utilisateur`
    mysqlPool.query(sql,(err,result)=>{
        if (err) {
            console.error('Erreur de fetch des utilisateur: ', err);
            res.json({error:err.sqlMessage})
        } else {
            console.log('fetch liste:: ', result);
            res.json(result);
        }
    })
}

const modifierProfile = (req,res) => {
    const userId = req.utilisateur.id_utilisateur;
    profileSchemas.parse(req.body)

    const { nom, prenom,email, date_naissance } = req.body;

    // Create dynamic SQL query based on provided fields
    let updateFields = [];
    if (nom) updateFields.push(`nom = '${nom}'`);
    if (prenom) updateFields.push(`prenom = '${prenom}'`);
    if (email) updateFields.push(`email = '${email}'`);
    if (date_naissance) updateFields.push(`date_naissance = '${date_naissance}'`);

    if (updateFields.length === 0) {
        return res.status(400).send('No fields to update');
    }

    const query = `UPDATE utilisateur SET ${updateFields.join(', ')} WHERE id = ?`;

    // Execute the query
    db.query(query, [userId], (err, result) => {
        if (err) {
            console.error('Error updating user:', err);
            return res.status(500).send('Internal server error');
        }

        if (result.affectedRows === 0) {
            return res.status(404).send('User not found');
        }

        res.send('User updated successfully');
    });
}

export default {
    creeCodePIN,
    verifierCodePIN,
    verifierSolde,
    creePseudo,
    liste,
    modifierProfile
}
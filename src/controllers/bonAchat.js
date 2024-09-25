import {z, ZodError} from "zod"
import mysqlPool from "../config/database.js";

const bonAchatSchema = z.object({
    solde: z.number().int().multipleOf(0.01).positive({message:"Solde doit etre superieur à 0"}),
    commission: z.number().multipleOf(0.01).positive({message: "commission doit etre superieur à 0"}),
    duree_exp: z.number().int().positive({message: "duree d'expiration doit etre superieur à 0"})
})

// const userService = z.object({
//     id_utilisateur: z.number().int().positive({message:"id_utilisateur doit etre superieur a 0"}),
//     id_service: z.number().int().positive({message: "id_service doit etre superieur à 0"})
// })

const userService = z.object({
    id_utilisateur: z.string().transform((val) => parseInt(val, 10)).pipe(
        z.number().int().positive({ message: "id_utilisateur doit être supérieur à 0" })
    ),
    id_service: z.string().transform((val) => parseInt(val, 10)).pipe(
        z.number().int().positive({ message: "id_service doit être supérieur à 0" })
    )
});

const creer = (req, res) => {
    try {
        const {id_utilisateur} = req.utilisateur;
        const {id_service} = req.params
        const form = bonAchatSchema.parse({
            solde: req.body.montant,
            commission: req.body.commission,
            duree_exp : req.body.duree_exp
        })
        const {solde,commission,duree_exp} = form
        console.log(form)
        const sql_creer_ba = `call creer_ba(?,?,?,?,?)`;
        mysqlPool.query(sql_creer_ba,[id_utilisateur,id_service, solde,commission,duree_exp],(err,result) => {
            if (err) {
                console.error('Erreur création du bon d\'achat:: ', err);
                res.json({error:err.sqlMessage})
            } else {
                const value = Object.assign({message:"Bon d'\'achat crée"},result[0][0])
                console.log('Transaction made successfully:', value);
                res.json(value);
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

const details = (req,res) =>{
    const {id_utilisateur} = req.utilisateur;
    const {id_service} = req.params;
    // const form = userService.parse({
    //     id_utilisateur: req.utilisateur.id_utilisateur,
    //     id_service: req.params.id_service
    // })
    const sql = `select
        u.id as id_utilisateur,
        s.id as id_service,
        u.solde as montant,
        s.libelle as entreprise,
        s.commission_plastikoo as commission,
        s.duree_jour_valide as duree_exp
        from utilisateur u
        inner join service s on s.id = ?
        where u.id = ?`
    // const {id_utilisateur, id_service} = form
    mysqlPool.query(sql,[id_service,id_utilisateur],(err,result) => {
        if (err) {
            console.error('Erreur:: ', err);
            res.json({error:err.sqlMessage})
        } else {
            // const value = Object.assign({message:"Bon d'\'achat crée"},result[0][0])
            console.log('Data fetched successfully:', result[0]);
            res.json(result[0]);
        }
    });
}

const liste = (req,res)=> {
    const {
        id_utilisateur
    } = req.utilisateur
    const sql = `SELECT
                ba.code_barre,
                t.montant,
                s.libelle as entreprise,
                CASE
                    WHEN DATEDIFF(ba.date_exp,CURRENT_TIMESTAMP()) <= 0 THEN
                        'EXPIRE'
                    ELSE DATEDIFF(ba.date_exp,CURRENT_TIMESTAMP()) END AS jour_restant,
                ba.etat,
                ba.id_transaction
            FROM
                bon_achat ba
            INNER JOIN transaction t ON ba.id_transaction = t.id
            INNER JOIN service s on t.id_service =  s.id
            WHERE ba.etat = 'cree' and t.id_utilisateur = ?`
    mysqlPool.query(sql,[id_utilisateur],(err, result) => {
        if(err){
            console.error('Erreur:: ', err);
            res.json({error:err.sqlMessage})
        } else {
            console.log('Data fetched successfully: ', result[0]);
            res.json(result);
        }
    })
    console.log('Liste des bon d\'achats')
}

const detailsAvecCodeBarre = (req,res) => {
    const {
        id_utilisateur
    } = req.utilisateur
    const sql = `SELECT
                ba.code_barre,
                t.montant,
                s.libelle as entreprise,
                CASE
                    WHEN DATEDIFF(ba.date_exp,CURRENT_TIMESTAMP()) <= 0 THEN
                        'EXPIRE'
                    ELSE DATEDIFF(ba.date_exp,CURRENT_TIMESTAMP()) END AS jour_restant,
                ba.etat,
                ba.id_transaction
            FROM
                bon_achat ba
            INNER JOIN transaction t ON ba.id_transaction = t.id
            INNER JOIN service s on t.id_service =  s.id
            WHERE ba.etat = 'cree' and t.id_utilisateur = ? and DATEDIFF(ba.date_exp,CURRENT_TIMESTAMP()) > 0 `
    mysqlPool.query(sql,[id_utilisateur],(err,result) => {
        if (err) {
            console.error('Erreur:: ', err);
            res.json({error:err.sqlMessage})
        } else {
            // const value = Object.assign({message:"Bon d'\'achat crée"},result[0][0])
            console.log('Data fetched successfully:', result[0]);
            res.json(result[0]);
        }
    });
}

const genererBarCode = (req,res) => {
    mysqlPool.
    console.log('valider')
}

export default {
    creer,
    detailsAvecCodeBarre,
    genererBarCode,
    details,
    liste
}
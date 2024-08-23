import { z,ZodError } from "zod";
import mysqlPool from "../config/database.js";
import phoneNumberPattern from "../utils/phone.number.pattern.js";
// import dateFormat from "../utils/date.format.js";

const transactionSchema = z.object({
    montant_entrant: z.number().nonnegative().default(0),
    montant_sortant: z.number().nonnegative().default(0),
    id_type_transaction: z.number().nonnegative(),
    id_utilisateur: z.number().nonnegative(),
    id_condition_generale: z.number().nonnegative(),
    numero_beneficiaire: z.string({message:"Vous devez ajouter un numero beneficiaire"})
    .trim().refine(phoneNumberPattern.validateMalagasyPhoneNumber,{message:"Format de numéro de téléphone invalide. Doit être au format: \n +261XXXXXXXXX (tous les chiffres) \n +261 XX XX XXX XX (avec espaces) \n 03[2348]XXXXXXXXX (tous chiffres) \n 03[2348] XX XXX XX (avec espaces)\n"}),
    numero_expediteur: z.string({message:"Vous devez ajouter un numero expediteur"})
    .trim().refine(phoneNumberPattern.validateMalagasyPhoneNumber,{message:"Format de numéro de téléphone invalide. Doit être au format: \n +261XXXXXXXXX (tous les chiffres) \n +261 XX XX XXX XX (avec espaces) \n 03[2348]XXXXXXXXX (tous chiffres) \n 03[2348] XX XXX XX (avec espaces)\n"}),
    date_transaction: z.date()
})

// const retraitSchema = z.object({
//     montant: z.number().positive({message: "Le montant devrait etre superieur a 0"}).default(0),
//     numero_beneficiaire:  z.string({message:"Vous devez ajouter un numero beneficiaire"})
//     .trim().refine(phoneNumberPattern.validateMalagasyPhoneNumber,{message:"Format de numéro de téléphone invalide. Doit être au format: \n +261XXXXXXXXX (tous les chiffres) \n +261 XX XX XXX XX (avec espaces) \n 03[2348]XXXXXXXXX (tous chiffres) \n 03[2348] XX XXX XX (avec espaces)\n"}),
//     id_utilisateur: z.number().nonnegative(),
// })

const retraitSchema = z.object({
    montant: z.number().positive({message: "Le montant devrait etre superieur a 0"}).default(0),
    numero_beneficiaire:  z.string({message:"Vous devez ajouter un numero beneficiaire"})
    .trim().refine(phoneNumberPattern.validateMalagasyPhoneNumber,{message:"Format de numéro de téléphone invalide. Doit être au format: \n +261XXXXXXXXX (tous les chiffres) \n +261 XX XX XXX XX (avec espaces) \n 03[2348]XXXXXXXXX (tous chiffres) \n 03[2348] XX XXX XX (avec espaces)\n"}),
    numero_expediteur: z.string({message:"Vous devez ajouter un numero beneficiaire"})
    .trim().refine(phoneNumberPattern.validateMalagasyPhoneNumber,{message:"Format de numéro de téléphone invalide. Doit être au format: \n +261XXXXXXXXX (tous les chiffres) \n +261 XX XX XXX XX (avec espaces) \n 03[2348]XXXXXXXXX (tous chiffres) \n 03[2348] XX XXX XX (avec espaces)\n"}),
    commission_service: z.number().positive({message: "Le montant devrait etre superieur a 0"}),
    id_utilisateur: z.number().positive({message: "id_utilisateur doit etre positif"}),
    id_service: z.number().positive({message: "id_service doit etre positif"})
})

// const recolteSchema = z.object({
//     montant_entrant: z.number().nonnegative({message: "Le montant devrait etre superieur a 0"}).default(0),
//     id_utilisateur: z.number().nonnegative({message: "id_utilisateur doit etre positif"}),
//     id_details_service: z.number().nonnegative({message: "id_utilisateur doit etre positif"}),
//     id_machine_recolte: z.number().nonnegative({message: "id_utilisateur doit etre positif"}),
//     reference_ticket: z.string().min(1, {message:"Ajouter la reference du ticket "})
// })

const recolteSchema = z.object({
    montant: z.number().nonnegative({message: "Le montant devrait etre superieur a 0"}).default(0),
    id_utilisateur: z.number().nonnegative({message: "id_utilisateur doit etre positif"}),
    code_recolte: z.string().min(1,{message:"le code doit contenir 6 chiffres"}),
    id_machine_recolte: z.number().nonnegative({message: "id_utilisateur doit etre positif"}),
})

const inputBA = z.object({
    montant: z.number().nonnegative({message: "Le montant devrait etre superieur a 0"}).default(0),
    id_utilisateur: z.number().nonnegative({message: "id_utilisateur doit etre positif"}),
    id_details_service: z.number().nonnegative({message: "id_utilisateur doit etre positif"}),
})

const retrait = (req,res) => {
    try {
        const form = retraitSchema.parse({
            montant: req.body.montant,
            id_utilisateur: req.body.id_utilisateur,
            id_service: req.body.id_service,
            numero_beneficiaire: req.body.numero_beneficiaire,
            numero_expediteur: req.body.numero_expediteur,
            commission_service: req.body.commission_service
        })
        const {
            montant,
            id_utilisateur,
            id_service,
            numero_beneficiaire,
            numero_expediteur,
            commission_service
        } = form
        const sql = `call retrait_gains (?,?,?,?,?,?)`
        mysqlPool.query(sql,[id_utilisateur,id_service,montant,numero_beneficiaire,numero_expediteur,commission_service],(err,result)=>{
            if (err) {
                console.error('Erreur liste de donnee:', err);
                res.json({error:err.sqlMessage})
            } else {
                console.log('Transaction succeed: ', result);
                res.json({message: 'Retrait réussi'});
            }
        })
    } catch (error) {
        if (error instanceof ZodError) {
            const validationErrors = error.errors.map(err => err.message).join(', ');
            res.status(400).json({ error: validationErrors });
        } else {
            console.error(error); // Log the unexpected error for debugging
            res.status(500).json({ error: 'Internal Server Error' });
        }
    }

}

const infosRetrait = (req,res) =>{
    const {
        id_user,
        id_serv
    } = req.params

    const sql = `SELECT
        u.id,
        u.solde,
        s.id,
        s.libelle,
        s.commission_service,
        s.url_logo AS logo
    FROM
        utilisateur u
    INNER JOIN
        service s
    ON
        s.id = ?
    WHERE
        u.id = ?
    LIMIT 1`
    mysqlPool.query(sql,[id_serv,id_user],(err,result)=>{
        if (err) {
            console.error('Erreur liste de donnee:', err);
            res.json({error:err.sqlMessage})
        } else {
            console.log('Data fetched successfully:', result);
            res.json(result[0]);
        }
    })
}

async function recolte(req, res) {
    try {
        const form = recolteSchema.parse({
            montant: req.body.montant,
            id_utilisateur: req.body.id_utilisateur,
            id_machine_recolte: req.body.id_machine_recolte,
            code_recolte:req.body.code_recolte
        })
        const {
            montant,
            id_utilisateur,
            id_machine_recolte,
            code_recolte
        }= form;
        const sql = `CALL recolte_ticket(?,?,?,?)`
        mysqlPool.query(sql,[montant,id_utilisateur,id_machine_recolte,code_recolte],(err,result)=>{
            if (err) {
                console.error('Erreur insertion de donnee:', err);
                res.json({error:err.sqlMessage})
            } else {
                console.log('Data inserted successfully:', result);
                res.json({message: `Votre avez obtenu un gain de ${montant}Ar`});
            }
        })
    } catch (error) {
        if (error instanceof ZodError) {
            const validationErrors = error.errors.map(err => err.message).join(', ');
            res.status(400).json({ error: validationErrors });
        } else {
            console.error(error); // Log the unexpected error for debugging
            res.status(500).json({ error: 'Internal Server Error' });
        }
    }
}

const historique = (req,res)=>{
    const {
        id_utilisateur
    } = req.params
    const sql = `select
            t.id as id_transaction,
            t.reference,
            CASE
                WHEN tt.type_transaction = 'Bon d''achat' THEN t.commission_plastikoo
                WHEN tt.type_transaction = 'Recolte' THEN 0
                WHEN tt.type_transaction = 'Achat Plastikoo' THEN 0
                WHEN tt.type_transaction = 'Retrait' THEN t.commission_service
                ELSE 0
            END as commission,
            t.montant as montant_initial,
            CASE
                WHEN tt.type_transaction = 'Bon d''achat' THEN (t.montant - (t.montant * t.commission_plastikoo))
                WHEN tt.type_transaction = 'Recolte' THEN t.montant
                WHEN tt.type_transaction = 'Achat Plastikoo' THEN t.montant
                WHEN tt.type_transaction = 'Retrait' THEN (t.montant - (t.montant * t.commission_service))
                ELSE 0
            END as montant_final,
            t.numero_beneficiaire,
            t.numero_expediteur,
            t.date_transaction,
            s.libelle as entreprise,
            tt.type_transaction,
            mr.designation as machine,
            mr.lieu
            from transaction t
            JOIN service s on t.id_service = s.id
            JOIN type_transaction tt on t.id_type_transaction = tt.id
            JOIN machine_recolte mr on t.id_machine_recolte = mr.id
            where t.id_utilisateur = ?
            ORDER BY t.date_transaction DESC
            LIMIT 5`
    mysqlPool.query(sql,[id_utilisateur],(err,result)=>{
        if (err) {
            console.error('Erreur data fecthed:\n', err);
            res.json({error:err.sqlMessage})
        } else {
            console.log(sql)
            console.log('Data fetched successfully:', result);
            res.json(result);
        }
    })
}

export default {
    recolte,
    retrait,
    infosRetrait,
    historique
}

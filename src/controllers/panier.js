import {mysqlPool} from "../config/database.js";
import { z,ZodError } from "zod";

const ajoutPanier = z.object({
    qte: z.number().nonnegative({message:"la quantité doit etre supérieur à 0"}).default(1),
    id_produit: z.number().positive({message: "id_produit doit etre positif"})
})

const supprimerPanier = z.object({
    id_produit: z.string().min(1,{message:"id_produit requis"})
})

class PanierController {
    static liste = (req,res) => {
        const {id_utilisateur} = req.utilisateur
        const sql = `SELECT
            panier.id AS id_panier,
            produit.id AS id_produit,
            produit.designation,
            produit.description,
            panier.qte,
            produit.prix_vente,
            produit.img
        FROM
            panier
        JOIN
            produit ON panier.id_produit = produit.id
        WHERE
            panier.id_utilisateur = ?;`
        mysqlPool.query(sql,[id_utilisateur],(err,result)=>{
            if (err) {
                console.error('Erreur liste panier:\n', err);
                if(result.length == 0){
                    res.json({error:"Aucun produits"})
                }
                res.json({error:err.sqlMessage})
            } else {
                console.log('Ajout succeed:\n', result);
                res.json(result);
            }
        })
    }

    static ajouter = (req,res) => {
        try {
            const {id_utilisateur} = req.utilisateur
            ajoutPanier.parse(req.body)

            const {
                id_produit,
                qte
            } = req.body
            const sql = `INSERT INTO panier (id_utilisateur, id_produit, qte) VALUES(?,?,?)`
            mysqlPool.query(sql,[id_utilisateur,id_produit,qte],(err,result)=>{
                if (err) {
                    console.error('Erreur ajout panier:\n', err);
                    res.json({error:err.sqlMessage})
                } else {
                    console.log('Ajout succeed:\n', result);
                    res.json({message: 'Ajout réussi'});
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

    static supprimer = (req,res) => {
        try {
            const { id_utilisateur } = req.utilisateur
    
            supprimerPanier.parse(req.params)
    
            const { id_produit} = req.params
            const sql = `DELETE FROM panier where id_produit = ? and id_utilisateur = ?`
    
            mysqlPool.query(sql,[id_produit,id_utilisateur],(err,result)=>{
                if (err) {
                    console.error('Erreur suppression panier:\n', err);
                    res.json({error:err.sqlMessage})
                } else {
                    if(result.affectedRows == 0) {
                        res.json({error:"Aucun produit a été supprimé"})
                    }
                    console.log('Supprimer avec succès:\n', result);
                    res.json({message: 'Suppression réussi'});
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
}

export default PanierController
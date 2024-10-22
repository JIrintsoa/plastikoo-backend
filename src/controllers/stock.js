import { z,ZodError } from "zod";
import {mysqlPool} from "../config/database.js";

const stockFormSchema = z.object({
    qte_kg_entrant: z.number().nonnegative({message:'Veuillez ajouter un nombre positif'}).default(0),
    qte_kg_sortant: z.number().nonnegative({message:'Veuillez ajouter un nombre positif'}).default(0),
    date_mouvement: z.date(),
    id_type_plastique: z.number().int().positive(),
})

const addStock = async (req,res) => {
    try {
        const form = stockFormSchema.parse({
            qte_kg_entrant: req.body.qte_kg_entrant,
            qte_kg_sortant: req.body.qte_kg_sortant,
            date_mouvement: new Date(req.body.date_mouvement),
            id_type_plastique: req.body.id_type_plastique
        })
        const {
            qte_kg_sortant,
            qte_kg_entrant,
            date_mouvement,
            id_type_plastique} = form;
        const sql = `INSERT INTO stock (qte_kg_entrant, qte_kg_sortant, date_mouvement, id_type_plastique)
                        VALUES (?,?,?,?)`;
        mysqlPool.query(sql,[qte_kg_sortant,qte_kg_entrant,date_mouvement,id_type_plastique],(err,result)=>{
            if (err) {
                console.error('Erreur insertion de donnee:', err);
                res.json({error:err.message})
            } else {
                console.log('Data inserted successfully:', result);
                res.json({message: 'Formulaire envoyée'});
            }
        })

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

export default {
    addStock
}
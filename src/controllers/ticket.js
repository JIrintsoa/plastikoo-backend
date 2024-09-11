import { z,ZodError } from "zod"
import mysqlPoolMachine from "../config/database.js";

const creerTicketSchemas = z.object({
    montant: z.number().nonnegative({message: "Le montant devrait etre superieur a 0"}).default(0),
    // id_machine_recolte: z.number().nonnegative({message: "id_machine_recolte doit etre positif"}),
})

// const modifierTicketSchemas = z.object({
//     id_ticket: z.number().nonnegative({message: "id_ticket doit etre positif"}),
//     montant: z.number().nonnegative({message: "Le montant devrait etre superieur a 0"}).default(0),
//     id_machine_recolte: z.number().nonnegative({message: "id_machine_recolte doit etre positif"}),
// })

class TicketController {

    static infos = (req,res) => {
        const {id_ticket} = req.params
        const sql = `select
            t.id as id_ticket,
            mr.id as id_machine_recolte,
            t.montant,
            t.date_creation,
            mr.designation as machine,
            mr.lieu
            from ticket t
            JOIN machine_recolte mr on t.id_machine_recolte = mr.id
            where t.id = ${id_ticket}`
        mysqlPoolMachine.query(sql, (err, result) => {
            if (err) {
                console.error('Erreur fetch infos donnée:', err);
                res.json({error:err.sqlMessage})
            } else {
                console.log('infos ticket: \n', result);
                res.json(result);
            }
        });
    }


    static creer = (req, res) => {
        try {
            creerTicketSchemas.parse(req.body)
            const { montant } = req.body;
            const {id_machine_recolte} = req.params
            const sql = `INSERT INTO ticket (montant, code_recolte, id_machine_recolte) VALUES (?, (select generate_code_recolte()), ?)`;

            mysqlPoolMachine.query(sql, [montant,id_machine_recolte], (err, result) => {
                if (err) {
                    console.error('Erreur ajout de donnee:', err);
                    res.json({error:err.sqlMessage})
                } else {
                    console.log('Ticket ajouté avec succès: ', result);
                    res.json({message: 'Ticket ajouté'});
                }
            });
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

    static utilise = (req, res) => {
        try {
            const {id_ticket} = req.params
            const query = `UPDATE ticket SET est_utilise = true, date_utilisation = (select current_timestamp) where id = ${id_ticket}`;

            mysqlPoolMachine.query(query, (err, result) => {
                if (err) {
                    console.error('Erreur ticket utilise:', err);
                    res.json({error:err.sqlMessage})
                } else {
                    console.log('Ticket utilisé avec succès: ', result);
                    res.json({message: 'Ticket utilisé'});
                }
            });
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

export default TicketController

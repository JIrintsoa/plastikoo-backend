import { z,ZodError } from "zod"
import {mysqlPoolMachine} from "../config/database.js";

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
                // req.ticket = result[0]
                // next()
                res.json(result);
            }
        });
        
    }

    static afficher = (req,res) => {
        // console.log(req.ticket)
        if(!req.ticket) {
            res.json({error:"Aucun ticket passer dans la requete"})
        }
        // Render the EJS template with ticket data and service fee
        res.render('ticket', { ticket: req.ticket, serviceFee: 0.20 });
    }

    // static creer = (req, res) => {
    //     try {
    //         creerTicketSchemas.parse(req.body)
    //         const { montant } = req.body;
    //         const {id_machine_recolte} = req.params
    //         // const sql = `INSERT INTO ticket (montant, code_recolte, id_machine_recolte) VALUES (?, (select generate_code_recolte()), ?)`;
    //         const sql = `call creerTicket(?,?)`
    //         mysqlPoolMachine.query(sql, [montant,id_machine_recolte], (err, result) => {
    //             if (err) {
    //                 console.error('Erreur ajout de donnee:', err);
    //                 res.json({error:err.sqlMessage})
    //             } else {
    //                 console.log('Ticket ajouté avec succès: ', result);
    //                 // res.json({message: 'Ticket ajouté'});
    //                 res.json(result[0][0])
    //             }
    //         });
    //     } catch (error) {
    //         if (error instanceof ZodError) {
    //             const validationErrors = error.errors.map(err => err.message).join(', ');
    //             res.status(400).json({ error: validationErrors });
    //         } else {
    //             console.error(error); // Log the unexpected error for debugging
    //             res.status(500).json({ error: 'Internal Server Error' });
    //         }
    //     }
    // }

    static creer = (req, res) => {
        const connection = mysqlPoolMachine; // Utilisez le pool de connexions
        connection.getConnection((err, conn) => {
            if (err) {
                console.error('Erreur lors de l\'obtention de la connexion:', err);
                return res.status(500).json({ error: 'Erreur de connexion à la base de données' });
            }
    
            try {
                // Valider le corps de la requête
                creerTicketSchemas.parse(req.body);
    
                const { montant } = req.body;
                const { id_machine_recolte } = req.params;
    
                // Démarrer la transaction
                conn.beginTransaction(err => {
                    if (err) {
                        conn.release(); // Toujours libérer la connexion
                        console.error('Erreur lors du démarrage de la transaction:', err);
                        return res.status(500).json({ error: 'Erreur de transaction' });
                    }
    
                    // Requête SQL pour insérer dans `ticket`
                    const sql = `INSERT INTO ticket (montant, code_recolte, id_machine_recolte) VALUES (?, (SELECT generate_code_recolte()), ?)`;
    
                    conn.query(sql, [montant, id_machine_recolte], (err, result) => {
                        if (err) {
                            console.error('Erreur lors de l\'insertion des données:', err);
                            return conn.rollback(() => {
                                conn.release(); // Rollback et libération en cas d'erreur
                                res.status(500).json({ error: 'Échec de la création du ticket' });
                            });
                        }
    
                        const id_ticket = result.insertId;
    
                        // Valider la transaction
                        conn.commit(err => {
                            if (err) {
                                console.error('Erreur lors de la validation de la transaction:', err);
                                return conn.rollback(() => {
                                    conn.release(); // Rollback et libération en cas d'erreur
                                    res.status(500).json({ error: 'Échec de la validation de la transaction' });
                                });
                            }
    
                            console.log('Ticket créé avec succès avec l\'ID:', id_ticket);
                            conn.release(); // Toujours libérer la connexion
                            res.json({ id_ticket }); // Envoyer l'ID du ticket créé
                        });
                    });
                });
            } catch (error) {
                conn.release(); // Libérer la connexion en cas d'échec de la validation ou d'erreur inattendue
                if (error instanceof ZodError) {
                    const validationErrors = error.errors.map(err => err.message).join(', ');
                    res.status(400).json({ error: `Erreur de validation: ${validationErrors}` });
                } else {
                    console.error('Erreur inattendue:', error);
                    res.status(500).json({ error: 'Erreur interne du serveur' });
                }
            }
        });
    };
    

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

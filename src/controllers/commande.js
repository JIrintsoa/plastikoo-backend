import { z,ZodError } from "zod"
import { mysqlAchatPlastikoo } from "../config/database"

const commandeSchemas = z.object({
    id_produit: z.number({ required_error: 'Le champ id_produit est requis' }).positive({message:'id_produit doit etre positif'}),
    qte: z.number({ required_error: 'Le champ qte est requis' }).default(1).positive({message:'qte doit etre superieure a 1'}),
})

class CommandeController {

    static ajout = (req,res,next) => {

        return new Promise((resolve, reject)=>{
            mysqlAchatPlastikoo.getConnection((err, conn)=>{
                if (err) {
                    console.error('Erreur lors de l\'obtention de la connexion:', err);
                    return res.status(500).json({ error: 'Erreur de connexion à la base de données' });
                }
                return conn.beginTransaction(err =>{
                    if (err) {
                        conn.release(); // Toujours libérer la connexion
                        console.error('Erreur lors du démarrage de la transaction:', err);
                        return res.status(500).json({ error: 'Erreur de transaction' });
                    }

                    try {
                        return conn.execute('INSERT INTO commande (id_produit, qte, id_utilisateur) VALUES (?,?,?)',(err,result)=>{
                            if (err) {
                                return conn.rollback(() => {
                                    conn.release();
                                    console.error('Erreur lors de l\'insertion dans commande:', err);
                                    return reject(res.status(500).json({ error: 'Erreur lors de l\'insertion dans commande' }));
                                });
                            }
    
                            return conn.commit((err) => {
                                if (err) {
                                    return conn.rollback(() => {
                                        conn.release();
                                        console.error('Erreur lors du commit de la transaction:', err);
                                        return reject(res.status(500).json({ error: 'Erreur lors du commit de la transaction' }));
                                    });
                                }
                                console.log('Transaction réussie, commande ajoutée avec succès');
                                req.id_commande = result.insertId
                                next()
                                conn.release();
                                return resolve(res.status(201).json({
                                    message: 'Commande ajoutée avec succès',
                                    commandeId: result.insertId
                                }));
                            });
                        })
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
                })
            })
        })
    }

    static liste
}

export default CommandeController
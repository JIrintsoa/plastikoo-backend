import { z,ZodError } from "zod";
import mysqlPool from "../../config/database.js";
import UploadController from "../upload.js";

import 'dotenv/config'

const fc_socket_commentaire = process.env.SOCKET_IO_COMMENTAIRE
const fc_socket_reponse_commentaire = process.env.SOCKET_IO_REPONSE_COMMENTAIRE
const fc_socket_reaction = process.env.SOCKET_IO_REACTION

const forumSchemas = z.object({
    titre: z.string().min(1,{message:"Veuillez ajouter un titre"}),
    contenu: z.string().min(1,{message:"Veuillez ajouter du contenu"}),
    img: z.string().min(1, {message:"L'image est vide"}),
    id_utilisateur: z.number().int().positive({message:"id_utilisateur doit etre superieur a 0"}),
});

const commentaireSchemas = z.object({
    contenu: z.string().min(1,{message:"Veuillez ajouter un commenter"})
});

const liste = (req,res) => {
    const sql = `SELECT
            publication.id AS publication_id,
            publication.titre,
            publication.contenu,
            publication.date_creation,
            publication.lien,
            utilisateur.nom AS utilisateur_nom,
            utilisateur.prenom AS utilisateur_prenom,
            utilisateur.pseudo_utilisateur AS pseudo_utilisateur,
            utilisateur.email AS utilisateur_email,
            utilisateur.img_profil as img_utilisateur,
            utilisateur.url_profil AS utilisateur_url_profil,
            pp.img_url as img_publication,
            pp.img_alt,
            COUNT(DISTINCT reaction_pub.id) AS nbr_reactions,
            COUNT(DISTINCT commentaire_pub.id) AS nbr_commentaires
        FROM
            plastikoo2.publication
        JOIN
            plastikoo2.utilisateur
        ON
            publication.id_utilisateur = utilisateur.id
        LEFT JOIN
            plastikoo2.photo_publication pp
        ON
            pp.id_publication = publication.id
        LEFT JOIN
            plastikoo2.reaction_pub
        ON
            publication.id = reaction_pub.id_publication
        LEFT JOIN
            plastikoo2.commentaire_pub
        ON
            publication.id = commentaire_pub.id_publication
        GROUP BY
            publication.id,
            publication.titre,
            publication.contenu,
            publication.date_creation,
            publication.lien,
            utilisateur.nom,
            utilisateur.prenom,
            utilisateur.email,
            utilisateur.url_profil,
            pp.img_url,
            pp.img_alt
        ORDER BY
            publication.date_creation DESC;
        `
//     const sql = `SELECT
//     p.id AS publication_id,
//     p.titre,
//     p.contenu,
//     p.date_creation,
//     p.lien,
//     u.nom AS utilisateur_nom,
//     u.prenom AS utilisateur_prenom,
//     u.pseudo_utilisateur AS pseudo_utilisateur,
//     u.email AS utilisateur_email,
//     pp.img_url as img_publication,
//     COUNT(DISTINCT rp.id) AS nbr_reactions,
//     COUNT(DISTINCT cp.id) AS nbr_commentaires
// FROM
//     plastikoo2.publication p
// JOIN
//     plastikoo2.utilisateur u
// ON
//     p.id_utilisateur = u.id
// LEFT JOIN
//     plastikoo2.reaction_pub rp
// ON
//     p.id = rp.id_publication
// LEFT JOIN
//     plastikoo2.commentaire_pub cp
// ON
//     p.id = cp.id_publication
// LEFT JOIN
//     plastikoo2.photo_publication pp
// ON
//     p.id = pp.id_publication
// JOIN
//     plastikoo2.publication_valide pv
// ON
//     p.id = pv.id_publication
// JOIN
//     plastikoo2.utilisateur ur
// ON
//     pv.id_utilisateur = ur.id
// JOIN
//     plastikoo2.utilisateur_role ur_role
// ON
//     ur.id = ur_role.id_utilisateur
// JOIN
//     plastikoo2.role r
// ON
//     ur_role.id_role = r.id
// AND r.designation = 'administrateur'
// GROUP BY
//     p.id,
//     p.titre,
//     p.contenu,
//     p.date_creation,
//     p.lien,
//     u.nom,
//     u.prenom,
//     u.pseudo_utilisateur,
//     u.email,
//     pp.img_url
// ORDER BY
//     p.date_creation DESC;
//     `

    mysqlPool.query(sql,(err,result) => {
        if (err) {
            console.error('Erreur data fetched:: \n', err);
            res.json({error:err.sqlMessage})
        } else {
            console.log('Data fetched : \n', result);
            res.json(result);
        }
    });
}

const listeCommentaire = (req,res) => {
    const {id_publication} = req.params
    const sql = `SELECT 
            c.id AS commentaire_id,
            c.contenu AS commentaire_contenu,
            c.date_creation AS commentaire_date_creation,
            p.titre AS publication_titre,
            p.contenu AS publication_contenu,
            p.date_creation AS publication_date_creation,
            u.img_profil AS img_utilisateur,
            u.pseudo_utilisateur AS pseudo_utilisateur,
            COUNT(responses.id) AS nbr_reponse
        FROM
            plastikoo2.commentaire_pub AS c
        JOIN 
            plastikoo2.publication AS p
            ON c.id_publication = p.id
        JOIN 
            plastikoo2.utilisateur AS u
            ON c.id_utilisateur = u.id
        LEFT JOIN 
            plastikoo2.commentaire_pub AS responses
            ON responses.id_main_commentaire = c.id
        WHERE 
            c.id_publication = ${id_publication}
        GROUP BY 
            c.id, c.contenu, c.date_creation, 
            p.titre, p.contenu, p.date_creation,
            u.url_profil, u.pseudo_utilisateur
        ORDER BY 
            c.date_creation DESC;
`

    mysqlPool.query(sql,(err,result) => {
        if (err) {
            console.error('Erreur data fetched:: \n', err);
            res.json({error:err.sqlMessage})
        } else {
            // console.log('Data fetched : \n', result);
            res.json(result);
        }
    });
}

const listSousCommentaire =  (req,res) => {
    const {id_publication, id_commentaire} = req.params
    const sql = `SELECT
        plastikoo2.commentaire_pub.id AS commentaire_id,
        	plastikoo2.commentaire_pub.contenu AS commentaire_contenu,
        	plastikoo2.commentaire_pub.date_creation AS commentaire_date_creation,
        	plastikoo2.utilisateur.pseudo_utilisateur AS utilisateur_pseudo,
        	plastikoo2.utilisateur.url_profil AS utilisateur_url_profil
        FROM
        	plastikoo2.commentaire_pub
        JOIN
        	plastikoo2.publication
        ON
        	commentaire_pub.id_publication = publication.id
        JOIN
        	plastikoo2.utilisateur
        ON
        	commentaire_pub.id_utilisateur = utilisateur.id
        WHERE
        	plastikoo2.commentaire_pub.id_publication = ${id_publication}
        AND
        	plastikoo2.commentaire_pub.id_main_commentaire = ${id_commentaire}
        ORDER BY
        	commentaire_pub.date_creation DESC;
        `
        mysqlPool.query(sql,(err,result) => {
            if (err) {
                console.error('Erreur data fetched:: \n', err);
                res.json({error:err.sqlMessage})
            } else {
                console.log('Data fetched : \n', result);
                res.json(result);
            }
        });
}

// ajouter publication
const publier = async(req,res) => {
    try {
        if(!req.fileUploaded) {
            return res.status(400).json({ error: 'Erreur à la récuperation du nom de fichier' });
        }
        const form = forumSchemas.parse({
            titre: req.body.titre,
            contenu: req.body.contenu,
            img: req.fileUploaded,
            id_utilisateur: req.utilisateur.id_utilisateur
        })
        const {titre, contenu, img, id_utilisateur } = form
        // const sql = `INSERT into publication(titre,contenu,img,id_utilisateur) values (?,?,?,?)`
        // console.log(form)
        const sql = `CALL storePublicationPhoto(?,?,?,?)`
        // const sql_creer_ba = `call creer_ba(?,?,?,?,?)`;
        mysqlPool.query(sql,[titre,contenu, id_utilisateur,img],(err,result) => {
            if (err) {
                console.error('Erreur création du forum:: ', err);
                UploadController.deleteFileLocalUploaded(img)
                res.json({error:err.sqlMessage})
            } else {
                console.log('Publication created succesfully:', result);
                res.json({message:"Votre publication a bien été crée"});
            }
        });
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

    // console.log(req.fileUploaded)
    // if (req.files) {
    //     // Process the uploaded files
    //     req.files.forEach(file => {
    //         console.log(file.originalname, file.filename, file.path);
    //       // Perform any additional file processing or storage operations here
    //     });
    //     res.send('Files uploaded successfully!');
    // } else {
    //     res.status(400).send('No files were uploaded.');
    // }
    // console.log('hello world')
}

const bannir = async (req,res) => {
    try {
        const {id_utilisateur} = req.params
        // const sql = ``
        console.log('bannisseo')
    } catch (error) {
        console.log(error)
    }
}

// valider publication
const valider = async(req,res) => {
    try {
        const {id_publication} = req.params
        const {id_utilisateur} = req.utilisateur
        const sql = `INSERT INTO publication_valide (id_utilisateur,id_publication) VALUES (?,?)`
        mysqlPool.query(sql,[id_utilisateur,id_publication],(err,result)=>{
            if(err){
                console.log('erreur validation publication :: \n',err)
                res.status(401).json({error:err.message})
            }
            else {
                console.log(result)
                res.status(200).json({message:"La publication a été validée"})
            }
        })
    } catch (error) {
        console.log('Internal erreur :: \n',err)
        res.status(401).json({error:err.message})
    }
}

// supprimer publication
const supprimer = async (req,res) => {
    try {
        const {id_publication} = req.params
        const {id_utilisateur} = req.utilisateur
        const sql = `delete from publication where id = ? and id_utilisateur = ?`
        mysqlPool.query(sql,[id_publication,id_utilisateur],(err,result)=>{
            if(err){
                console.log('erreur validation publication :: \n',err)
                res.status(401).json({error:err.message})
            }
            else {
                console.log(result)
                if(result.affectedRows == 0){
                    res.status(200).json({error:"Vous n'avez pas droit à supprimer cette publication"})
                }
                res.status(200).json({message:"La publication a été validée"})
            }
        })
    } catch (error) {
        console.log('Internal erreur :: \n',err)
        res.status(401).json({error:err.message})
    }
}

const supprimerAdmin = async (req,res) => {
    try {
        const {id_publication} = req.params
        const sql = `delete from publication where id = ? `
        mysqlPool.query(sql,[id_publication],(err,result)=>{
            if(err){
                console.log('erreur validation publication :: \n',err)
                res.status(401).json({error:err.message})
            }
            else {
                console.log(result)
                if(result.affectedRows == 0){
                    res.status(200).json({error:"Vous n'avez pas droit à supprimer cette publication"})
                }
                res.status(200).json({message:"La publication a été supprimée"})
            }
        })
    } catch (error) {
        console.log('Internal erreur :: \n',err)
        res.status(401).json({error:err.message})
    }
}

// reagir a une publication
const reagir = (io) => async (req,res) => {
    try {
        const {id_publication} = req.params
        const {id_utilisateur} = req.utilisateur
        const sql = `call reagirPublication (?, ?)`
        mysqlPool.query(sql,[id_publication,id_utilisateur],(err,result)=>{
            if(err){
                console.log('erreur reaction publication :: \n',err)
                res.status(401).json({error:err.message})
            }
            else {
                const est_utilise = result[0][0].est_utilise
                console.log(result[0])
                io.emit(fc_socket_reaction, {
                    id_publication,
                    id_utilisateur,
                    est_utilise
                });
                res.status(200).json({message:"La publication a été réagi",data:result[0][0]})
            }
        })
    } catch (error) {
        console.log('Internal erreur :: \n',err)
        res.status(401).json({error:err.message})
    }
}

// Comment creation function with transaction handling
const commenter = (io) => async (req, res) => {
    let connection;
    try {
        // Validate request body using Zod schema
        commentaireSchemas.parse(req.body);

        const { id_publication } = req.params;
        const { id_utilisateur } = req.utilisateur;
        const { contenu } = req.body;

        // Get a connection from the pool
        connection = await new Promise((resolve, reject) => {
            mysqlPool.getConnection((err, conn) => {
                if (err) return reject(new Error("Erreur lors de la connexion à la base de données"));
                resolve(conn);
            });
        });

        // Begin transaction
        await new Promise((resolve, reject) => {
            connection.beginTransaction((err) => {
                if (err) {
                    connection.release();
                    return reject(new Error("Erreur lors du début de la transaction"));
                }
                resolve();
            });
        });

        // SQL query to insert the comment into the database
        const sql = `INSERT INTO commentaire_pub (contenu, id_utilisateur, id_publication) VALUES (?, ?, ?)`;
        const result = await new Promise((resolve, reject) => {
            connection.query(sql, [contenu, id_utilisateur, id_publication], (err, results) => {
                if (err) {
                    return reject(new Error("Erreur lors de l'insertion du commentaire"));
                }
                resolve(results);
            });
        });

        // Commit the transaction
        await new Promise((resolve, reject) => {
            connection.commit((err) => {
                if (err) {
                    return reject(new Error("Erreur lors de la validation de la transaction"));
                }
                resolve();
            });
        });

        console.log('Commentaire créé avec succès:', result);

        // Emit the new comment event via Socket.io after successful insert
        io.emit(fc_socket_commentaire, {
            id_publication,
            id_utilisateur,
            contenu,
            id_commentaire: result.insertId // Include the new comment's ID in the emitted event
        });

        // Send success message
        res.json({ message: "Votre commentaire a bien été créé" });

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

        // Determine the error message to send based on the error type
        let errorMessage = "Erreur interne du serveur";
        if (error.message) {
            errorMessage = error.message;
        }

        if (error instanceof ZodError) {
            const validationErrors = error.errors.map(err => err.message).join(', ');
            return res.status(400).json({ error: validationErrors });
        } else {
            console.error("Erreur inattendue:", error);
            return res.status(500).json({ error: errorMessage });
        }
    } finally {
        if (connection) {
            // Release the connection back to the pool
            connection.release();
        }
    }
};


const repondreCommentaire = (io) => async (req, res) => {
    let connection;
    try {
        // Validate request body using Zod schema
        commentaireSchemas.parse(req.body);

        const { id_publication, id_commentaire } = req.params;
        const { id_utilisateur } = req.utilisateur;
        const { contenu } = req.body;

        // Get a connection from the pool
        connection = await new Promise((resolve, reject) => {
            mysqlPool.getConnection((err, conn) => {
                if (err) {
                    res.json({error:err.message})
                    return reject(new Error("Erreur lors de la connexion à la base de données"));
                }
                resolve(conn);
            });
        });

        // Begin transaction
        await new Promise((resolve, reject) => {
            connection.beginTransaction((err) => {
                if (err) {
                    res.json({error:err.message})
                    connection.release();
                    return reject(new Error("Erreur lors du début de la transaction"));
                }
                resolve();
            });
        });

        // SQL query to insert the reply to a comment
        const sql = `INSERT INTO commentaire_pub (contenu, id_utilisateur, id_publication, id_main_commentaire) VALUES (?, ?, ?, ?)`;
        const result = await new Promise((resolve, reject) => {
            connection.query(sql, [contenu, id_utilisateur, id_publication, id_commentaire], (err, results) => {
                if (err) {
                    res.json({error:err.message})
                    return reject(new Error("Erreur lors de l'insertion du commentaire"));
                }
                resolve(results);
            });
        });

        // Commit the transaction
        await new Promise((resolve, reject) => {
            connection.commit((err) => {
                if (err) {
                    res.json({error:err.message})
                    return reject(new Error("Erreur lors de la validation de la transaction"));
                }
                resolve();
            });
        });

        console.log('Commentaire créé avec succès: \n', result);

        // Emit the new comment reply event via Socket.io after successful insert
        io.emit(fc_socket_reponse_commentaire, {
            id_publication,
            id_utilisateur,
            contenu,
            id_main_commentaire: id_commentaire,
            id_commentaire: result.insertId // Include the new comment's ID in the emitted event
        });

        // Send success message
        res.json({ message: "Votre réponse au commentaire a bien été créée" });

    } catch (error) {
        if (connection) {
            // Rollback the transaction in case of error
            await new Promise((resolve) => {
                connection.rollback(() => {
                    connection.release();
                    resolve();
                });
            });
        }

        // Determine the error message to send based on the error type
        let errorMessage = "Erreur interne du serveur";
        if (error.message) {
            errorMessage = error.message;
        }

        if (error instanceof ZodError) {
            const validationErrors = error.errors.map(err => err.message).join(', ');
            return res.status(400).json({ error: validationErrors });
        } else {
            console.error("Erreur inattendue:", error);
            return res.status(500).json({ error: errorMessage });
        }
    } finally {
        if (connection) {
            // Release the connection back to the pool
            connection.release();
        }
    }
};


export default {
    liste,
    publier,
    bannir,
    valider,
    supprimer,
    supprimerAdmin,
    reagir,
    commenter,
    repondreCommentaire,
    listeCommentaire,
    listSousCommentaire
}
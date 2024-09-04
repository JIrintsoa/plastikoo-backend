import { z,ZodError } from "zod";
import mysqlPool from "../../config/database.js";
import UploadController from "../upload.js";

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
            utilisateur.url_profil AS utilisateur_url_profil,
            COUNT(DISTINCT reaction_pub.id) AS nbr_reactions,
            COUNT(DISTINCT commentaire_pub.id) AS nbr_commentaires
        FROM
            plastikoo2.publication
        JOIN
            plastikoo2.utilisateur
        ON
            publication.id_utilisateur = utilisateur.id
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
            utilisateur.url_profil
        ORDER BY
            publication.date_creation DESC;
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

const forumSchemas = z.object({
    titre: z.string().min(1,{message:"Veuillez ajouter un titre"}),
    contenu: z.string().min(1,{message:"Veuillez ajouter du contenu"}),
    lien: z.string().min(1, {message:"Le liens de l'image est vide"}),
    id_utilisateur: z.number().int().positive({message:"id_utilisateur doit etre superieur a 0"}),
});

const publier = async(req,res) => {
    try {
        if(!req.fileUploaded) {
            return res.status(400).json({ error: 'Erreur à la récuperation du nom de fichier' });
        }
        const form = forumSchemas.parse({
            titre: req.body.titre,
            contenu: req.body.contenu,
            lien: req.fileUploaded,
            id_utilisateur: req.utilisateur.id_utilisateur
        })
        const {titre, contenu, lien, id_utilisateur } = form
        const sql = `INSERT into publication(titre,contenu,lien,id_utilisateur) values (?,?,?,?)`
        // console.log(form)
        // const sql_creer_ba = `call creer_ba(?,?,?,?,?)`;
        mysqlPool.query(sql,[titre,contenu, lien,id_utilisateur],(err,result) => {
            if (err) {
                console.error('Erreur création du forum:: ', err);
                UploadController.deleteFileLocalUploaded(lien)
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

export default {
    liste,
    publier,
    bannir
}
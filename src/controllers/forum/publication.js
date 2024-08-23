import mysqlPool from "../../config/database.js";

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

const publier = async(req,res) => {
    if (req.files) {
        // Process the uploaded files
        req.files.forEach(file => {
            console.log(file.originalname, file.filename, file.path);
          // Perform any additional file processing or storage operations here
        });
        res.send('Files uploaded successfully!');
    } else {
        res.status(400).send('No files were uploaded.');
    }
    // console.log('hello world')
}

export default {
    liste,
    publier
}
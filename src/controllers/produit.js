import { z, ZodError } from "zod";
import {mysqlPool} from "../config/database.js";
import {mysqlAchatPlastikoo} from "../config/database.js"


const ajoutProduitSchema = z.object({
    designation: z.string().min(1, "Designation is required"),
    description: z.string().optional(),
    img: z.string().url("Invalid image URL"),
    pu: z.number().positive("Price must be a positive number"),
    id_type_pack: z.number().int().positive("Invalid pack type ID"),
    id_meuble: z.number().int().positive().optional(),
    id_electromenager: z.number().int().positive().optional(),
    id_electricite: z.number().int().positive().optional(),
    id_eaux: z.number().int().positive().optional(),
    id_type_produit: z.number().int().positive("Invalid product type ID"),
    id_modele: z.number().int().positive("Invalid model ID"),
});

const rechercheProduitSchema = z.object({
    id_type_pack: z.number().int().positive().nullable().optional(),
    id_meuble: z.number().int().positive().nullable().optional(),
    id_electromenager: z.number().int().positive().nullable().optional(),
    id_electricite: z.number().int().positive().nullable().optional(),
    id_eaux: z.number().int().positive().nullable().optional(),
    id_type_produit: z.number().int().positive().nullable().optional(),
    id_modele: z.number().int().positive().nullable().optional(),
});

class ProduitController {

    static listeTroisPremier = (req,res) => {
        const limit = parseInt(req.query.limit) || 3;
        const sql = `
            SELECT
            	produit.id,
            	produit.designation,
            	produit.description,
            	produit.prix_vente,
            	produit.img,
            	produit.qte_kg,  
            	categorie.type_categorie,
            	type_plastique.p_type
            FROM
            	plastikoo2.produit
            JOIN
            	plastikoo2.categorie ON produit.id_cat = categorie.id
            JOIN
            	plastikoo2.type_plastique ON produit.id_type_plastique = type_plastique.id
            LIMIT ?`; // Using LIMIT and OFFSET for pagination
        
        mysqlPool.query(sql, [ limit], (err, result) => {
            if (err) {
                console.error('Erreur data fetched:\n', err);
                res.status(500).json({ error: err.sqlMessage });
            } else if (result.length == 0) {
                res.json({ message: "Aucun produits" });
            } else {
                console.log('Data fetched successfully:', result);
                res.json(result);
            }
        });
    }

    static catalogueTroisPremier = (req,res) => {
        const limit = parseInt(req.query.limit) || 3
        const sql = `
            SELECT
            	produit.id as id_produit,
            	produit.designation,
            	produit.description,
            	produit.img,
                categorie.id as id_categorie,
            	categorie.type_categorie
            FROM
            	plastikoo2.produit
            JOIN
            	plastikoo2.categorie ON produit.id_cat = categorie.id
            WHERE produit.designation LIKE '%Tiny%';`; // Using LIMIT and OFFSET for pagination
        
        mysqlPool.query(sql, [ limit], (err, result) => {
            if (err) {
                console.error('Erreur data fetched:\n', err);
                res.status(500).json({ error: err.sqlMessage });
            } else if (result.length == 0) {
                console.log(result)
                res.json({ message: "Aucun catalogue" });
            } else {
                console.log('Data fetched successfully:', result);
                res.json(result);
            }
        });
    }

    static catalogue =  (req,res) => {
    
        // Get the page from the query parameters, default to page 1
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 5;
        
        // Limit to 5 rows per page (you can also make this dynamic by accepting it as a parameter)
        // const limit = 5;
        
        // Calculate the offset based on the current page
        const offset = (page - 1) * limit;
    
        const sql = `
            SELECT
            	produit.id,
            	produit.designation,
            	produit.description,
            	produit.prix_vente,
            	produit.img,
            	produit.qte_kg,  
            	categorie.type_categorie,
            	type_plastique.p_type
            FROM
            	plastikoo2.produit
            JOIN
            	plastikoo2.categorie ON produit.id_cat = categorie.id
            JOIN
            	plastikoo2.type_plastique ON produit.id_type_plastique = type_plastique.id
            LIMIT ? OFFSET ?;`; // Using LIMIT and OFFSET for pagination
        
        mysqlPool.query(sql, [ limit, offset], (err, result) => {
            if (err) {
                console.error('Erreur data fetched:\n', err);
                res.status(500).json({ error: err.sqlMessage });
            } else if (result.length == 0) {
                res.json({ message: "Aucun produits" });
            } else {
                console.log('Data fetched successfully:', result);
                res.json(result);
            }
        });
    }

    static liste = (req,res) => {
        // Get the page from the query parameters, default to page 1
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 5;
        
        // Limit to 5 rows per page (you can also make this dynamic by accepting it as a parameter)
        // const limit = 5;
        
        // Calculate the offset based on the current page
        const offset = (page - 1) * limit;
    
        const sql = `SELECT
            	produit.id,
            	produit.designation,
            	produit.description,
            	produit.prix_vente,
            	produit.img,
            	produit.qte_kg,  
            	categorie.type_categorie,
            	type_plastique.p_type
            FROM
            	plastikoo2.produit
            JOIN
            	plastikoo2.categorie ON produit.id_cat = categorie.id
            JOIN
            	plastikoo2.type_plastique ON produit.id_type_plastique = type_plastique.id
            LIMIT ? OFFSET ?;`; // Using LIMIT and OFFSET for pagination
        
        mysqlPool.query(sql, [ limit, offset], (err, result) => {
            if (err) {
                console.error('Erreur data fetched:\n', err);
                res.status(500).json({ error: err.sqlMessage });
            } else if (result.length == 0) {
                res.json({ message: "Aucun produits" });
            } else {
                console.log('Data fetched successfully:', result);
                res.json(result);
            }
        });
    }

    static details = (req,res) => {
        const {id_produit} = req.params
        const sql = `SELECT
            	produit.id,
            	produit.designation,
            	produit.description,
            	produit.prix_vente,
            	produit.img,
            	produit.qte_kg,  
                categorie.id as id_categorie,
            	categorie.type_categorie,
            	type_plastique.p_type
            FROM
            	plastikoo2.produit
            JOIN
            	plastikoo2.categorie ON produit.id_cat = categorie.id
            JOIN
            	plastikoo2.type_plastique ON produit.id_type_plastique = type_plastique.id
            where produit.id = ?`
        mysqlPool.query(sql, [id_produit], (err, result) => {
            if (err) {
                console.error('Erreur data fetched:\n', err);
                res.status(500).json({ error: err.sqlMessage });
            } else if (result.length == 0) {
                res.json({ message: "Aucun produit" });
            } else {
                console.log('Data fetched successfully:', result);
                res.json(result);
            }
        });   
    }

    static photos = (req,res) => {
        const {id_produit} = req.params
        const sql = `select 
               id,
               image
            from photo_produit where id_produit = ?`
        mysqlPool.query(sql, [id_produit], (err, result) => {
            if (err) {
                console.error('Erreur data fetched:\n', err);
                res.status(500).json({ error: err.sqlMessage });
            } else if (result.length == 0) {
                res.json({ message: "Aucun produit" });
            } else {
                console.log('Data fetched successfully:', result);
                res.json(result);
            }
        });   
    }

    static parCategorie = (req,res) => {
        const {id_categorie} = req.params
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 5;
        // const {id_categorie} = req.params
        // const limit = parseInt(req.query.limit) || 3;

        const offset = (page - 1) * limit;

        const sql = `SELECT
            	produit.id,
            	produit.designation,
            	produit.description,
            	produit.prix_vente,
            	produit.img,
            	produit.qte_kg,  
            	categorie.type_categorie,
            	type_plastique.p_type
            FROM
            	plastikoo2.produit
            JOIN
            	plastikoo2.categorie ON produit.id_cat = categorie.id
            JOIN
            	plastikoo2.type_plastique ON produit.id_type_plastique = type_plastique.id
            where categorie.id = ?
            LIMIT ? OFFSET ?`
        mysqlPool.query(sql, [id_categorie, limit, offset], (err, result) => {
            if (err) {
                console.error('Erreur data fetched:\n', err);
                res.status(500).json({ error: err.sqlMessage });
            } else if (result.length == 0) {
                res.json({ message: "Aucun produits" });
            } else {
                console.log('Data fetched successfully:', result);
                res.json(result);
            }
        });
    }

    static ajoutProduit = (req,res) => {
        const connection = mysqlPool
        connection.getConnection((err, conn) => {
            if (err) {
                console.error('Erreur lors de l\'obtention de la connexion:', err);
                return res.status(500).json({ error: 'Erreur de connexion à la base de données' });
            }
            try {
                // Validate request body
                ajoutProduitSchema.parse(req.body)
    
                // Extract validated data in the order of SQL placeholders
                const {
                    designation, description, img, pu, id_type_pack, id_meuble,
                    id_electromenager, id_electricite, id_eaux, id_type_produit, id_modele
                } = req.body;

                conn.beginTransaction(err => {
                    if (err) {
                        conn.release(); // Toujours libérer la connexion
                        console.error('Erreur lors du démarrage de la transaction:', err);
                        return res.status(500).json({ error: 'Erreur de transaction' });
                    }

                    const sql = `INSERT INTO produits
                    (designation, description, img, pu, id_type_pack, id_meuble, id_electromenager, id_electricite, id_eaux, id_type_produit, id_modele)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

                    conn.query(sql, [
                        designation, description, img, pu, id_type_pack, id_meuble,
                        id_electromenager, id_electricite, id_eaux, id_type_produit, id_modele],(err,result)=>{
                            if (err) {
                                console.error('Erreur lors de l\'insertion des données:', err);
                                return conn.rollback(() => {
                                    conn.release(); // Rollback et libération en cas d'erreur
                                    res.status(500).json({ error: 'Échec de la création du ticket' });
                                });
                            }
                        const id_produit = result.insertId
                        conn.commit(err => {
                            if (err) {
                                console.error('Erreur lors de la validation de la transaction:', err);
                                return conn.rollback(() => {
                                    conn.release(); // Rollback et libération en cas d'erreur
                                    res.status(500).json({ error: 'Échec de la validation de la transaction' });
                                });
                            }
                            console.log('Produit créé avec succès avec l\'ID:', id_produit);
                            conn.release(); // Toujours libérer la connexion
                            return id_produit
                        })
                    })
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
    }

    static rechercheProduit =  (req, res) => {
        try {
            // Validate query parameters
            rechercheProduitSchema.parse(req.body);

            const {
                id_type_pack, id_meuble, id_electromenager, id_electricite, id_eaux, id_modele
            } = req.body;

            // SQL query with parameterized inputs
            const sql = `
                SELECT
                    id, designation, description, img, pu, id_type_pack, id_meuble, id_electromenager, id_electricite, id_eaux, id_type_produit, id_modele
                FROM
                    produits
                WHERE
                    (id_type_pack = ? OR ? IS NULL)
                    AND (id_meuble = ? OR ? IS NULL)
                    AND (id_electromenager = ? OR ? IS NULL)
                    AND (id_electricite = ? OR ? IS NULL)
                    AND (id_eaux = ? OR ? IS NULL)
                    AND (id_modele = ? OR ? IS NULL);
            `;

            mysqlAchatPlastikoo.query(sql, [
                    id_type_pack, id_type_pack,
                    id_meuble, id_meuble,
                    id_electromenager, id_electromenager,
                    id_electricite, id_electricite,
                    id_eaux, id_eaux,
                    id_modele, id_modele
                ]).then(([rows]) => {
                    if (rows.length > 0) {
                        res.json({rows });
                    } else {
                        res.json({message: 'Aucun produits' });
                    }
                })
                .catch((error) => {
                    console.error('Error fetching products:', error);
                    res.status(500).json({  error:  error.sqlMessage });
                });

        } catch (error) {
            if (error instanceof z.ZodError) {
                // Zod validation error
                return res.status(400).json({ error: error.errors });
            } else {
                // SQL or other server error
                console.error("Error fetching products:", error);
                return res.status(500).json({ error: "Internal Server Error" });
            }
        }
    };

    // static
}

export default ProduitController
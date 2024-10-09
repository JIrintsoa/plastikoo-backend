import mysqlPool from "../config/database.js";

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
}

export default ProduitController
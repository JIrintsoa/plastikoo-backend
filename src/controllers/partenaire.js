// import {  z,ZodError } from "zod";
import mysqlPool from "../config/database.js";


const listePartenaire = async (req,res) => {
//     const sql = `select
//                 id,
//                 libelle,
//                 duree_jour_valide,
//                 commission_plastikoo
//                 from service
//                 where id_type_service = (select id from type_service
//                 where type_s = 'partenariat')
// `
    const sql = `select
    id as id_service,
    libelle as entreprise
    from service
    where id_type_service = (select id from type_service
    where type_s = 'partenariat')
    `
    mysqlPool.query(sql, (err,result) =>{
        // const req.body.
        if (err) {
            console.error('Erreur liste partenaires:: ', err);
            res.json({error:err.sqlMessage})
        } else {
            console.log('Data retrieved:', result);
            res.json(result);
        }
    })
};

const listeOperateur = (req,res)=>{
    const sql = `SELECT
            s.id as id_service,
            s.libelle as entreprise
            FROM service s
            where id_type_service = (SELECT id FROM type_service where type_s = 'Operateur')`
    mysqlPool.query(sql,(err,result)=>{
        if (err) {
            console.error('Erreur liste Operateur:: ', err);
            res.json({error:err.sqlMessage})
        } else {
            console.log('Data retrieved:', result);
            res.json(result);
        }
    })
}

export default{
    listePartenaire,
    listeOperateur
};
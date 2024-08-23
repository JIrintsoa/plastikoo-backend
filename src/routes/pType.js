import { Router } from "express";
import mysqlPool from "../config/database.js";

const route = Router()

route.get('', (req, res) => {
        const sql = 'SELECT * from type_plastique'
        mysqlPool.query(sql,(err,result)=>{
            if (err) {
                console.error('Erreur la selection de donnee:', err);
                res.json({error:err.message})
            } else {
                console.log(`FETCH:: "${sql}"\n, ${result}`);
                res.json({data: result});
            }
        })
    console.log('hello type plastique here...')
})

export default route
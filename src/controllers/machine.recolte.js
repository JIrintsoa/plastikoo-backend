import { z,ZodError } from "zod";
import mysqlPoolMachine from "../config/database.js";

const inputValidator = z.object({
    designation: z.string().min(1, { message: "La désignation ne peut pas être vide" }),
    lieu: z.string().min(1, { message: "Le lieu ne peut pas être vide" })
  });

class MachineRecolteController {

    static getIdByDesignationLieu = (req,res) => {
        try {
            inputValidator.parse(req.body)

            const sql = `select id as id_machine_recolte
            from machine_recolte
            where designation = ? and lieu = ?`

            const {designation, lieu } = req.body
            mysqlPoolMachine.query(sql,[designation, lieu] ,(err,result) =>{
                // const req.body.
                if (err) {
                    console.error(`Identifiant de ${req.body.designation} inconnue`, err);
                    res.json({error:err.sqlMessage})
                } else {
                    console.log('Data retrieved:', result);
                    res.json(result[0]);
                }
            })
        } catch (error) {
            if (error instanceof ZodError) {
                const validationErrors = error.errors.map(err => err.message).join(', ');
                console.error(error)
                res.status(400).json({ error: validationErrors });
            } else {
                console.error(error); // Log the unexpected error for debugging
                res.status(500).json({ error: 'Internal Server Error' });
            }
        }
    }
}

export default MachineRecolteController
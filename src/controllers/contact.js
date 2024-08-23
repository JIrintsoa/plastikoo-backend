import { z,ZodError } from "zod";
// import contactService from "../service/contact.js";
import mysqlPool from "../config/database.js";

const contactFormSchema = z.object({
    nom: z.string().min(1, {message: 'Veuillez saisir votre nom'}),
    prenom: z.string().min(1, {message: 'Veuillez saisir votre prénom'}),
    email: z.string().email(),
    id_type_contact: z.number(),
    message: z.string().min(1,{message: 'Veuillez fournir un message'}),
})

async function handleContactForm (req, res) {
    try {
        const form = contactFormSchema.parse({
            nom:req.body.nom,
            prenom:req.body.prenom,
            email:req.body.email,
            id_type_contact:req.body.id_type_contact,
            message:req.body.message
        })
        const { nom, prenom, email, id_type_contact, message } = form;
        const sql = `INSERT INTO contact_forms (nom, prenom, email, id_type_contact, message) VALUES (?,?,?,?,?)`;

        mysqlPool.query(sql,[nom, prenom, email, id_type_contact, message],(err,result)=>{
            if (err) {
                console.error('Erreur insertion de donnee:', err);
                res.json({error:err.message})
            } else {
                console.log('Data inserted successfully:', result);
                res.json({message: 'Formulaire envoyée'});
                // cache.default.contactCache.del(cache.default.cacheKey.contact);
                // console.log(cache.default.contactCache.get(cache.default.cacheKey.contact))
            }
        })
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

export default {
    handleContactForm
};
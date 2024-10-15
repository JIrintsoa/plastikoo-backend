import DBAchatPlastikoo from '../config/database.js'
import {z, ZodError} from "zod"
import mailing from '../utils/mailing.js';
import phoneNumberPattern from '../utils/phone.number.pattern.js';


const produitSchema = z.object({
    id_produit: z.number({
      required_error: "L'identifiant du produit est requis.",
      invalid_type_error: "L'identifiant du produit doit être un nombre.",
    }),
    id_type_produit: z.number().optional().nullable().refine((val) => val !== null, {
      message: "L'identifiant du type de produit doit être un nombre ou nul.",
    }),
    id_option: z.number().optional().nullable().refine((val) => val !== null, {
      message: "L'identifiant de l'option doit être un nombre ou nul.",
    }),
    qte_produit: z.number({
      invalid_type_error: "La quantité du produit doit être un nombre.",
    }).default(1),
    qte_type_produit: z.number({
      invalid_type_error: "La quantité du type de produit doit être un nombre.",
    }).default(1),
    qte_option: z.number({
      invalid_type_error: "La quantité de l'option doit être un nombre.",
    }).default(1),
  });
  
  // Define the schema for the entire form validation
  const formSchema = z.object({
    produits: z.array(z.array(produitSchema)).min(1, {
      message: "Au moins un produit est requis.",
    }),
    nom: z.string().min(1, { message: "Le nom est requis." }),
    prenom: z.string().min(1, { message: "Le prénom est requis." }),
    nom_entreprise: z.string().optional(),
    id_region: z.number({
      required_error: "L'identifiant de la région est requis.",
      invalid_type_error: "L'identifiant de la région doit être un nombre.",
    }),
    ville: z.string().min(1, { message: "La ville est requise." }),
    quartier: z.string().min(1, { message: "Le quartier est requis." }),
    code_postal: z.string().min(1, { message: "Le code postal est requis." }),
    telephone:z.string().min(1,{ message:"Le numéro de téléphone est requis."})
    .trim().refine(phoneNumberPattern.validateMalagasyPhoneNumber,{message:"Format de numéro de téléphone invalide. Doit être au format: \n +261XXXXXXXXX (tous les chiffres) \n +261 XX XX XXX XX (avec espaces) \n 03[2348]XXXXXXXXX (tous chiffres) \n 03[2348] XX XXX XX (avec espaces)\n"}),
    email: z.string().min(1, { message: "L'email est requis." }).email({ message: "L'email est invalide." }),
  });

class DevisController {
    static faireDevis = (req,res) => {
      mailing.sendEmail(
        'johnsirintsoa18@gmail.com',
        'Johns',
        "Code de réinitialisation du mot de passe",
        `Votre code de réinitialisation de mot de passe est :<strong> 1234 </strong>. Le code est valable pendant 10 minutes.`,
        (err, info) => {
            if (err) {
                return res.status(500).send({ message: "Erreur lors de l'envoi de l'e-mail." });
            }
            // Redirect to the code entry form
            console.log(info)
            res.status(200).send({ message: "Code de vérification envoyé" });
        }
    );
        // DBAchatPlastikoo.getConnection((err, conn) => {
        //     if (err) {
        //         console.error('Erreur lors de l\'obtention de la connexion:', err);
        //         return res.status(500).json({ error: 'Erreur de connexion à la base de données' });
        //     }
    
        //     try {
        //         // Valider le corps de la requête
        //         creerTicketSchemas.parse(req.body);
    
        //         const { montant } = req.body;
        //         const { id_machine_recolte } = req.params;
    
        //         // Démarrer la transaction
        //         conn.beginTransaction(err => {
        //             if (err) {
        //                 conn.release(); // Toujours libérer la connexion
        //                 console.error('Erreur lors du démarrage de la transaction:', err);
        //                 return res.status(500).json({ error: 'Erreur de transaction' });
        //             }
    
        //             // Requête SQL pour insérer dans `ticket`
        //             const sql = `INSERT INTO ticket (montant, code_recolte, id_machine_recolte) VALUES (?, (SELECT generate_code_recolte()), ?)`;
    
        //             conn.query(sql, [montant, id_machine_recolte], (err, result) => {
        //                 if (err) {
        //                     console.error('Erreur lors de l\'insertion des données:', err);
        //                     return conn.rollback(() => {
        //                         conn.release(); // Rollback et libération en cas d'erreur
        //                         res.status(500).json({ error: 'Échec de la création du ticket' });
        //                     });
        //                 }
    
        //                 const id_ticket = result.insertId;
    
        //                 // Valider la transaction
        //                 conn.commit(err => {
        //                     if (err) {
        //                         console.error('Erreur lors de la validation de la transaction:', err);
        //                         return conn.rollback(() => {
        //                             conn.release(); // Rollback et libération en cas d'erreur
        //                             res.status(500).json({ error: 'Échec de la validation de la transaction' });
        //                         });
        //                     }
    
        //                     console.log('Ticket créé avec succès avec l\'ID:', id_ticket);
        //                     conn.release(); // Toujours libérer la connexion
        //                     res.json({ id_ticket }); // Envoyer l'ID du ticket créé
        //                 });
        //             });
        //         });
        //     } catch (error) {
        //         conn.release(); // Libérer la connexion en cas d'échec de la validation ou d'erreur inattendue
        //         if (error instanceof ZodError) {
        //             const validationErrors = error.errors.map(err => err.message).join(', ');
        //             res.status(400).json({ error: `Erreur de validation: ${validationErrors}` });
        //         } else {
        //             console.error('Erreur inattendue:', error);
        //             res.status(500).json({ error: 'Erreur interne du serveur' });
        //         }
        //     }
        // });
    }
}

export default DevisController
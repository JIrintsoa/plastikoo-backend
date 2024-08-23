import { Router } from "express";
import transactionController from "../controllers/transaction.gains.js";
import utilisateurController from "../controllers/utilisateur.js"
import dateFormat from "../utils/date.format.js";
const router = Router()

// historie que des transaction effectuee par utilisateur
router.get('/:id_utilisateur', transactionController.historique)

router.post('/recolte', transactionController.recolte)

router.get('/retrait/:id_user/:id_serv',transactionController.infosRetrait)

router.post('/retrait', transactionController.retrait)

export default router
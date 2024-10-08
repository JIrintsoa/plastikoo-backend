import { Router } from "express";
import transactionController from "../../controllers/transaction.gains.js";
import AuthenticationController from "../../utils/authentication.js"
import BonAchat from "../../controllers/bonAchat.js";
const router = Router()

// historie que des transaction effectuee par utilisateur
router.get('',AuthenticationController.verifyRoleToken('utilisateur') ,transactionController.historique)

// Recolte
router.post('/recolte', AuthenticationController.verifyRoleToken('utilisateur'),transactionController.recolte)

router.get('/recolte/:id_ticket', AuthenticationController.verifyRoleToken('utilisateur'),transactionController.recolte)

// Details du retrait a faire
router.get('/retrait/:id_service',AuthenticationController.verifyRoleToken('utilisateur'),transactionController.infosRetrait)

// Retrait a faire
router.post('/retrait', AuthenticationController.verifyRoleToken('utilisateur'),transactionController.retrait)

// Bon d'achat
router.get('', AuthenticationController.verifyRoleToken('utilisateur'), BonAchat.liste)

router.get('/details/:id_service', BonAchat.details)

router.get('',AuthenticationController.verifyRoleToken('utilisateur'),BonAchat.creer)

export default router
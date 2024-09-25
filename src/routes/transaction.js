import { Router } from "express";
import transactionController from "../controllers/transaction.gains.js";
import utilisateurController from "../controllers/utilisateur.js"
import dateFormat from "../utils/date.format.js";
import AuthenticationController from "../utils/authentication.js";
const router = Router()

// historie que des transaction effectuee par utilisateur
router.get('',
    AuthenticationController.verifyRoleToken('utilisateur'), 
    transactionController.historique
)

router.post('/recolte',
    AuthenticationController.verifyRoleToken('utilisateur'), 
    transactionController.recolte
)

router.get('/retrait/:id_serv',
    AuthenticationController.verifyRoleToken('utilisateur'),
    transactionController.infosRetrait
)

router.post('/retrait',
    AuthenticationController.verifyRoleToken('utilisateur'),
    transactionController.retrait
)

export default router
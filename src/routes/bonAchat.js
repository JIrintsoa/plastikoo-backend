import { Router } from "express";
import BonAchat from "../controllers/bonAchat.js";
import AuthenticationController from "../utils/authentication.js";
import UtilisateurController from "../controllers/utilisateur.js"

const route = Router()

// creer un bon achat
route.post('/:id_service',
    AuthenticationController.verifyRoleToken('utilisateur'),
    BonAchat.creer
)

route.get('',
    AuthenticationController.verifyRoleToken('utilisateur'),
    BonAchat.liste
)

route.get('/valide',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UtilisateurController.verifierCodePIN,
    BonAchat.creer,
    BonAchat.detailsAvecCodeBarre
)

route.get('/details/:id_service',
    AuthenticationController.verifyRoleToken('utilisateur'),
    BonAchat.details
)

route.get('/genere/:id_transaction',
    AuthenticationController.verifyRoleToken('utilisateur'),
    BonAchat.detailsAvecCodeBarre
)

export default route
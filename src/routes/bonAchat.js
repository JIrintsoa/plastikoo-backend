import { Router } from "express";
import BonAchat from "../controllers/bonAchat.js";
import AuthenticationController from "../utils/authentication.js";

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

route.get('/details/:id_service',
    AuthenticationController.verifyRoleToken('utilisateur'),
    BonAchat.details
)

route.get('/genere/:id_transaction',
    AuthenticationController.verifyRoleToken('utilisateur'),
    BonAchat.detailsAvecCodeBarre
)

export default route
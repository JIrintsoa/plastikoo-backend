import { Router } from "express";
import AuthenticationController from "../../utils/authentication.js";
import BonAchat from "../../controllers/jwt/bonAchat.js";

const route =  Router()

// creer un bon achat
route.post('', AuthenticationController.verifyRoleToken('utilisateur'), BonAchat.creer)

route.get('/:id_utilisateur',AuthenticationController.verifyRoleToken('utilisateur'), BonAchat.liste)

route.get('/details/:id_utilisateur/:id_service',AuthenticationController.verifyRoleToken('utilisateur'), BonAchat.details)

route.get('/genere/:id_transaction',
    AuthenticationController.verifyRoleToken('utilisateur'),
    BonAchat.detailsAvecCodeBarre
)
export default route;
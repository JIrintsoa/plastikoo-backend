import { Router } from "express";
import PanierController from "../controllers/panier.js";
import AuthenticationController from "../utils/authentication.js"

const route = Router()

route.get('', 
    AuthenticationController.verifyRoleToken('utilisateur'),
    PanierController.liste
)

route.post('',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PanierController.ajouter
)

route.delete('/:id_produit',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PanierController.supprimer
)

export default route;


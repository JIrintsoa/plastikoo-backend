import { Router } from "express";
import PublicationController from "../../controllers/forum/publication.js";
import AuthenticationController from "../../utils/authentication.js";

const router = Router()

router.get('', PublicationController.liste)

router.post('', PublicationController.publier)

router.get('/admin/bannir/:id_utilisateur', AuthenticationController.verifyRoleToken('administrateur'),PublicationController.bannir)

export default router
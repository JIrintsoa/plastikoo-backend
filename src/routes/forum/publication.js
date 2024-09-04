import { Router } from "express";
import PublicationController from "../../controllers/forum/publication.js";
import AuthenticationController from "../../utils/authentication.js";
import UploadController from "../../controllers/upload.js";

const router = Router()

router.get('',AuthenticationController.verifyRoleToken('utilisateur'), PublicationController.liste)

router.post('',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UploadController.singleFileUpload('forum'),
    PublicationController.publier)

router.get('/admin/bannir/:id_utilisateur', AuthenticationController.verifyRoleToken('administrateur'),PublicationController.bannir)

export default router
import { Router } from "express";
import PublicationController from "../../controllers/forum/publication.js";
import AuthenticationController from "../../utils/authentication.js";
import UploadController from "../../controllers/upload.js";

const router = Router()

// Liste des publications
router.get('',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PublicationController.liste
)

// Poster une publication
router.post('',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UploadController.singleFileUpload('forum'),
    PublicationController.publier)

router.delete('/:id_publication',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PublicationController.supprimer
)

router.get ('/reagir/:id_publication',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PublicationController.reagir
)

//commenter publication
router.post('/commenter/:id_publication',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PublicationController.commenter
)

// commenter un commentaire
router.post('/commentaire/repondre/:id_publication/:id_commentaire',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PublicationController.repondreCommentaire
)

// valider publication
router.get('/admin/valider/:id_publication',
    AuthenticationController.verifyRoleToken('administrateur'),
    PublicationController.valider
)

router.get('/admin/valider/:id_publication',
    AuthenticationController.verifyRoleToken('administrateur'),
    PublicationController.valider
)

router.delete('/admin/:id_publication',
    AuthenticationController.verifyRoleToken('administrateur'),
    PublicationController.supprimerAdmin
)

// Supprimer un publication
router.get('/admin/bannir/:id_utilisateur', AuthenticationController.verifyRoleToken('administrateur'),PublicationController.bannir)

export default router
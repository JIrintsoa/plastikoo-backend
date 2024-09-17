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
    (req, res) => {
        const io = req.io; // Get the io instance from the request object
        const reagir = PublicationController.reagir(io); // Pass the io instance to the controller
        reagir(req, res); // Call the commenter function
    }
)

//commenter publication
// router.post('/commenter/:id_publication',
//     AuthenticationController.verifyRoleToken('utilisateur'),
//     PublicationController.commenter
// )

router.post('/commenter/:id_publication',
    AuthenticationController.verifyRoleToken('utilisateur'),
    (req, res) => {
      const io = req.io; // Get the io instance from the request object
      const commenter = PublicationController.commenter(io); // Pass the io instance to the controller
      commenter(req, res); // Call the commenter function
    }
);

// commenter un commentaire
router.post('/commentaire/repondre/:id_publication/:id_commentaire',
    AuthenticationController.verifyRoleToken('utilisateur'),
    (req,res) => {
        const io = req.io
        const reponseCommentaire = PublicationController.repondreCommentaire(io)
        reponseCommentaire(req,res)
    }
)

router.get('/commentaire/:id_publication',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PublicationController.listeCommentaire
)

router.get('/commentaire/:id_publication/:id_commentaire',
    AuthenticationController.verifyRoleToken('utilisateur'),
    PublicationController.listSousCommentaire
)

// valider publication
// router.get('/admin/valider/:id_publication',
//     AuthenticationController.verifyRoleToken('administrateur'),
//     PublicationController.valider
// )

// router.get('/admin/valider/:id_publication',
//     AuthenticationController.verifyRoleToken('administrateur'),
//     PublicationController.valider
// )

router.delete('/admin/:id_publication',
    AuthenticationController.verifyRoleToken('administrateur'),
    PublicationController.supprimerAdmin
)

// Supprimer un publication
router.get('/admin/bannir/:id_utilisateur', AuthenticationController.verifyRoleToken('administrateur'),PublicationController.bannir)

export default router
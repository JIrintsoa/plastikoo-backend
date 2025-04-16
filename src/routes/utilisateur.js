import { Router } from "express";
import UtilisateurController from "../controllers/utilisateur.js";
import AuthenticationController from "../utils/authentication.js";
import Passport from "passport";
import '../utils/passport.config.js'
import UploadController from "../controllers/upload.js";

const route = Router()

route.post('/cree-code-pin',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UtilisateurController.creeCodePIN
)

route.post('/use-code-pin', AuthenticationController.verifyRoleToken('utilisateur'), async (req, res) => {
    await UtilisateurController.verifierCodePIN(req, res)
})

route.post('/verifie-solde', async (req, res) => {
    const arg = {
        id_user: req.body.id_utilisateur,
        somme: req.body.montant
    }
    await UtilisateurController.verifierSolde(arg, res)
})

route.post('/connecter', AuthenticationController.login)

route.post('/inscription', AuthenticationController.sInscrire)

// route.post('/cree-pseudo',
//     AuthenticationController.verifyRoleToken('utilisateur'),
//     UploadController.singleFileUpload('pseudo'),
//     UtilisateurController.creePseudo
// )

route.post('/cree-pseudo',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UploadController.singleFileUpload('pseudo'),
    UtilisateurController.creePseudo
)

route.get('',
    AuthenticationController.verifyRoleToken('administrateur'),
    UtilisateurController.liste
)

route.put('',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UtilisateurController.modifierProfile
)

route.get('/infos',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UtilisateurController.infos
)

route.get('/:id_utilisateur', UtilisateurController.getById)

// mot de passe oublie
route.post('/mdp-oublie', UtilisateurController.mdpOublie)

route.put('/mdp-oublie',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UtilisateurController.changeMdp
)
route.post('/mdp-oublie/verifier-code/:email',
    UtilisateurController.verifierCodeMdpOublie
)

// Modifier mot de passe utilisateur
route.post('/change-mdp',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UtilisateurController.verifierMdp,
    UtilisateurController.changeMdp
)


// Modifier Image Profil utilisateur
route.post('/photo-profil',
    AuthenticationController.verifyRoleToken('utilisateur'),
    UtilisateurController.changePhotoProfil
)

route.get('', UtilisateurController.liste)

route.get('/auth/google',
    Passport.authenticate('google', {
        scope: ['email', 'profile'],
    })
);

route.get('/auth/google/callback',
    Passport.authenticate('google', {
        successRedirect: '/auth/google/protected',
        failureRedirect: '/auth/google/failure'
    })
)

route.get('/auth/google/failure', (req, res) => {
    res.send(`Something went wrong`)
})

route.get('/auth/google/callback', Passport.authenticate('google', { failureRedirect: '/login' }),
    function (req, res) {
        res.redirect('/');
    }
)

// route.get('/auth/protected', (req,res)=>{
//     let name = req.user.displayName
//     res.send(`Hello world ${name}`)
// })

export default route;
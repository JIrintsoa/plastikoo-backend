import { Router } from "express";
import UtilisateurController from "../controllers/utilisateur.js";
import AuthenticationController from "../utils/authentication.js";

const route =  Router()

route.post('/cree-code-pin',async (req,res) => {
    await UtilisateurController.creeCodePIN(req,res)
    // console.log('cree code pin')
})

route.post('/use-code-pin',async(req,res)=>{
    await UtilisateurController.verifierCodePIN(req,res)
})

route.post('/verifie-solde', async(req,res)=>{
    const arg = {
        id_user: req.body.id_utilisateur,
        somme: req.body.montant
    }
    await UtilisateurController.verifierSolde(arg,res)
})

route.post('/connecter', AuthenticationController.login)

route.post('/inscription',AuthenticationController.sInscrire)

route.put('/cree-pseudo', UtilisateurController.creePseudo)
// route.update('/pseudo', UtilisateurController.creePseudo)

route.get('',UtilisateurController.liste)

route.get('/auth/google',AuthenticationController.googleAuth)

route.get('/google/callback', AuthenticationController.googleAuth, AuthenticationController.googleCallback);

route.get('/profile', AuthenticationController.verifyRoleToken('utilisateur'), AuthenticationController.getProfile);

export default route;
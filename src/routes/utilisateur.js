import { Router } from "express";
import UtilisateurController from "../controllers/utilisateur.js";
import AuthenticationController from "../utils/authentication.js";
import Passport from "passport";
import '../utils/passport.config.js'

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

route.put('/cree-pseudo', AuthenticationController.verifyRoleToken('utilisateur'),UtilisateurController.creePseudo)
// route.update('/pseudo', UtilisateurController.creePseudo)

route.get('',UtilisateurController.liste)

route.get('/auth/google',
    Passport.authenticate('google', {
        scope: ['email','profile'],
    })
);

route.get('/auth/google/callback',
    Passport.authenticate('google', {
        successRedirect: '/auth/google/protected',
        failureRedirect: '/auth/google/failure'
    })
)

route.get('/auth/google/failure', (req,res)=>{
    res.send(`Something went wrong`)
})

route.get('/auth/google/callback', Passport.authenticate('google', { failureRedirect: '/login' }),
    function(req, res) {
        res.redirect('/');
    }
)

route.get('/auth/protected', (req,res)=>{
    let name = req.user.displayName
    res.send(`Hello world ${name}`)
})

export default route;
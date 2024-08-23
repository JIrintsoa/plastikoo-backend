import { Router } from "express";
import UtilisateurController from "../controllers/utilisateur.js";

const route =  Router()

route.post('/cree-code-pin',async (req,res)=>{
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

export default route;
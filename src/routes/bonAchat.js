import { Router } from "express";
import BonAchat from "../controllers/bonAchat.js";

const route = Router()

// creer un bon achat
route.post('', BonAchat.creer)

route.get('/:id_utilisateur',async (req,res)=>{
    await BonAchat.liste(req,res)
})

route.get('/details/:id_utilisateur/:id_service', async (req,res)=>{
    await BonAchat.details(req, res)
})


export default route
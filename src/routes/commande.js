import { Router } from "express";
import CommandeController from '.'

const route = Router()

route.post('/produit',CommandeController.ajout)

export default route
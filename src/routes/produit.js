import { Router } from "express";
import ProduitController from "../controllers/produit.js"

const route = Router()

route.get('', ProduitController.catalogue)

route.get('/catalogue/troisPremiers', ProduitController.catalogueTroisPremier)

export default route;
import { Router } from "express";
import ProduitController from "../controllers/produit.js"

const route = Router()

// route.get('', ProduitController.catalogue)

// route.get('/catalogue/troisPremiers', ProduitController.catalogueTroisPremier)

// route.get('/troisPremiers', ProduitController.listeTroisPremier)

// route.get('/:id_produit', ProduitController.details)

// route.get('/photos/:id_produit', ProduitController.photos)

// route.get('/parCategorie/:id_categorie', ProduitController.parCategorie)

route.post('/search', ProduitController.rechercheProduit)

export default route;
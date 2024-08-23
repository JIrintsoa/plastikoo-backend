import Router from 'express'
import PartenaireController from '../controllers/partenaire.js'

const router = new Router()

router.get('', async (req,res)=>{
    await PartenaireController.listePartenaire(req,res)
    console.log("liste des partenaires...")
})


router.get('/operateur', async (req,res)=>{
    await  PartenaireController.listeOperateur(req,res)
    console.log("Listes des operateurs...")
    // console.log('Hello world')
})

export default router;
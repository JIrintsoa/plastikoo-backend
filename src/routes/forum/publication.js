import { Router } from "express";
import PublicationController from "../../controllers/forum/publication.js";

const router = Router()

router.get('', PublicationController.liste)

router.post('', PublicationController.publier)



export default router
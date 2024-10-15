import { Router } from "express";
import DevisController from "../controllers/devis.js";

const route = Router()

route.get('',DevisController.faireDevis)

export default route
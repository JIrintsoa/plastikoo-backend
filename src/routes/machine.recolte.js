import { Router } from "express";
import MachineRecolteController from "../controllers/machine.recolte.js";

const route =  Router()

route.post('', MachineRecolteController.getIdByDesignationLieu)

export default route;
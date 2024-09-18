import { Router } from "express";
import TicketController from "../controllers/ticket.js";

const route = Router()

route.get('/:id_ticket',TicketController.infos)

// route.get('/')

route.post('/:id_machine_recolte',TicketController.creer)

route.get('/utilise/:id_ticket', TicketController.utilise)

export default route
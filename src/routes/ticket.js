import { Router } from "express";
import TicketController from "../controllers/ticket.js";
import TransactionController from "../controllers/transaction.gains.js";
import AuthenticationController from "../utils/authentication.js";

const route = Router()

route.get('/:id_ticket',
    AuthenticationController.verifyRoleToken('utilisateur'),
    TransactionController.recolte,
    TicketController.utilise,
    TicketController.infos,
)

// route.get('/')

route.post('/:id_machine_recolte',TicketController.creer)

route.get('/utilise/:id_ticket', TicketController.utilise)

export default route
import express from "express";
import bodyParser from "body-parser";
import path from "path"; // Importation du module path pour gérer les chemins
import ContactRoutes from "./routes/contact.js";
import StockRoutes from "./routes/stock.js";
import PtypeRoutes from "./routes/pType.js";
import TransactionRoutes from "./routes/transaction.js";
import PartenaireRoutes from "./routes/partenaire.js";
import UtilisateurRoutes from "./routes/utilisateur.js";
import BonAchatRoutes from "./routes/bonAchat.js";
import PublicationRoutes from "./routes/forum/publication.js"
import UploadFileRoutes from "./routes/upload.js"
import TicketRoutes from "./routes/ticket.js"

// Import routes with JWT
import TransactionRoutesJWT from './routes/withJWT/transactions.js'
import 'dotenv/config'


import { Server } from "socket.io";
import http from "http"
const host = process.env.DEV_HOST
const port = process.env.DEV_PORT

const app = express()
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: '*', // Adjust this to match your front-end origin
    },
});

app.use("/uploads", express.static(path.join(path.resolve(), "uploads")));
app.use(express.json());
app.use(bodyParser.json())

app.use((req, res, next) => {
    req.io = io; // Attach Socket.io instance to req object
    next();
});

// middlewares
app.use('/contact', ContactRoutes);

app.use('/stock', StockRoutes)

app.use('/type_plastique', PtypeRoutes)

app.use('/transaction', TransactionRoutes)

app.use('/partenaire', PartenaireRoutes)

app.use('/utilisateur', UtilisateurRoutes)

app.use('/bon-achat', BonAchatRoutes)

app.use('/forum/publication', PublicationRoutes)

app.use('/upload',UploadFileRoutes)

app.use('/ticket',TicketRoutes)

// API with JWT token
app.use('/jwt/transaction', TransactionRoutesJWT)

app.use('/jwt/utilisateur', UtilisateurRoutes)

// Démarrer le serveur
app.listen(port, host, () => {
  console.log(`App running on http://${host}:${port}`);
});

io.on('connection', (socket) => {
    console.log('Un utilisateur connecte');

    socket.on('disconnect', () => {
        console.log('Un utilisateur est deconnecte');
    });
})
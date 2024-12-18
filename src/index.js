import express from "express";
import bodyParser from "body-parser";
import path from "path";
import passport from "passport";
import passportFacebook from "passport-facebook";
import session from "express-session";

const facebookStrategy = passportFacebook.Strategy

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
import MachineRecolteRoutes from "./routes/machine.recolte.js"
import DevisRoutes from "./routes/devis.js"
import FacebookRoutes from "./routes/facebook.js"
import GoogleRoutes from "./routes/google.js"

// import for e-commerce
import ProduitRoutes from "./routes/produit.js"
import PanierRoutes from "./routes/panier.js"

// Import routes with JWT
import TransactionRoutesJWT from './routes/withJWT/transactions.js'
import 'dotenv/config'

// import authentication google facebook config
import './config/auth.google.js'
import './config/auth.facebook.js'

import cors from "cors"

import { Server } from "socket.io";
import http from "http"

const host = process.env.DEV_HOST
const port = process.env.DEV_PORT

const app = express()
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: '*', 
    },
});

import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use("/uploads", express.static(path.join(path.resolve(), "uploads")));
app.use(express.static('src'));

app.use(express.json());
app.use(bodyParser.json())

// CORS Middleware Configuration
const corsOptions = {
    // origin: ['http://localhost:3000','https://plastikoo.mg'], 
    origin: '*', 
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
    allowedHeaders: ["Content-Type", "Authorization"]
};

app.use(cors(corsOptions));  // Use CORS middleware

// use the passport facebook

app.use(session({
    resave: false,
    saveUninitialized: true,
    secret: 'SECRET'
}));
app.use(passport.initialize());
app.use(passport.session());

// passport.serializeUser(function (user, done) {
//     done(null, user);
// });
  
// passport.deserializeUser(function (id, done) {
//     return done(null, id);
// });

// passport.use(new facebookStrategy({
//         clientID: process.env.FACEBOOK_CLIENT_ID,
//         clientSecret: process.env.FACEBOOK_CLIENT_SECRET,
//         callbackURL: 'http://localhost:5000/facebook/auth/callback',
//         profileFields: ['id', 'displayName', 'name', 'gender','email','picture.type(large)']
//     }, function (accessToken, refreshToken, profile, done) {
//         console.log(profile)
//         return done(null, profile);
//     }
// ));

app.use((req, res, next) => {
    req.io = io; 
    next();
});

app.get('/hello',(req,res) => {
    res.send(`hello world`)
})

// middlewares
app.use('/contact', ContactRoutes);
app.use('/stock', StockRoutes)
app.use('/type_plastique', PtypeRoutes)
app.use('/transaction', TransactionRoutes)
app.use('/partenaire', PartenaireRoutes)
app.use('/utilisateur', UtilisateurRoutes)
app.use('/bon-achat', BonAchatRoutes)
app.use('/forum/publication', PublicationRoutes)
app.use('/upload', UploadFileRoutes)
app.use('/ticket', TicketRoutes)
app.use('/machine', MachineRecolteRoutes)

// middlewares for e-commerce:
app.use('/produits', ProduitRoutes )
app.use('/panier', PanierRoutes)

// middlewares for sales funnel
app.use('/devis', DevisRoutes)

// middlwares authentication google, facebook
app.use('/google',GoogleRoutes)
app.use('/facebook',FacebookRoutes)

// API with JWT token
app.use('/jwt/transaction', TransactionRoutesJWT)
app.use('/jwt/utilisateur', UtilisateurRoutes)

// Serveur version local
// server.listen(port, host, () => {
//    console.log(`App running on http://${host}:${port}`);
// });

server.listen(port, () => {
    console.log(`App running on  port: ${port}`);
});

// Serveur version prod
// module.exports.handler = ServerlessHttp(app)

io.on('connection', (socket) => {
    console.log('Un utilisateur connecte');

    socket.on('disconnect', () => {
        console.log('Un utilisateur est deconnecte');
    });
});
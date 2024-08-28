import jwt, { decode } from "jsonwebtoken";


const { JWT_SECRET,JWT_EXPIRES_IN } = process.env;

const authentification = async (req,res,next) => {
    try {
        const token = req.header('Authorization').replace('Bearer ','')
        const decodedToken = jwt.verify(token, JWT_SECRET)
        // if(decodedToken.id_utilisateur != id_utilisateur) throw new Error()
        // req.utilisateur =
        // req.utilisateur = decodedToken
        console.log(decodedToken)
        next()
    } catch (error) {
        res.status(401).json({error:"Veuillez vous authentifier"})
    }
}

async function generateToken(arg){
    return jwt.sign({...arg},JWT_SECRET, { expiresIn: JWT_EXPIRES_IN })
    // console.log(token)
    // return token
}

export default {
    generateToken,
    authentification
    // verifyToken
    // authenticateToken
}
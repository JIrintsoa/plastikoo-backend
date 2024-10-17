import { Router } from "express";
import passport from "passport";
import JwtUtils from "../utils/jwt.js";

const route = Router()

function isLogged(req,res,next){
    // console.log(req.user)
    req.user ? next() : res.sendStatus(401)
}

route.get('',(req,res)=> {
    res.send(`<a href="/google/auth">Login with google</a>`)
})

route.get('/auth', passport.authenticate('google', {scope:['email','profile','https://www.googleapis.com/auth/user.birthday.read']}))
// route.get('/auth', )

route.get('/auth/callback', passport.authenticate('google', {
    successRedirect: '/google/auth/protected',
    failureRedirect: '/google/auth/error'
}));

route.get('/auth/protected', isLogged ,async (req,res) => {
    if(req.user){
        // console.log("the id user is", req.user); //Just for debugging
          //Creating a unique token using sign method which is provided by JWT, remember the 2nd parameter should be a secret key and that should have atleast length of 20, i have just passed 'rahulnikam' but you should not do the same and this should be kept in environment variable so that no one can see it
        const token = await JwtUtils.generateToken({
            "id_utilisateur":req.user
        });
        res.status(200).json({token});
        // const googleAuthToken = jwt.sign({googleAuthToken: req.user[0].googleId}, "rahulnikam", {expiresIn:86400000 })
    }
})

route.get('/auth/error', (req,res)=> {
    res.send('there is an error')
})

route.get("/logout", (req, res) => {
    req.logout();
    res.json({
        logout: req.user
    })
});

export default route
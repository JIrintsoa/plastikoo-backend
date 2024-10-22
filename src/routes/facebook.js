import passport from 'passport';
import { Router } from 'express';
import JwtUtils from "../utils/jwt.js";

const router = Router()


router.get('/', function (req, res) {
    res.render('pages/index.ejs'); // load the index.ejs file
});

router.get('/profile', isLoggedIn, async function (req, res) {
    // res.render('pages/profile.ejs', {
    //   user: req.user // get the user out of session and pass to template
    // });
    if(req.user){
      // console.log("the id user is", req.user); //Just for debugging
        //Creating a unique token using sign method which is provided by JWT, remember the 2nd parameter should be a secret key and that should have atleast length of 20, i have just passed 'rahulnikam' but you should not do the same and this should be kept in environment variable so that no one can see it
      const token = await JwtUtils.generateToken({
          "id_utilisateur":req.user
      });
      res.status(200).json({token});
      // const googleAuthToken = jwt.sign({googleAuthToken: req.user[0].googleId}, "rahulnikam", {expiresIn:86400000 })
  }
});

router.get('/error', isLoggedIn, function (req, res) {
    res.render('pages/error.ejs');
});

router.get('/auth', passport.authenticate('facebook', { scope: ['public_profile','email'] }));

router.get('/auth/callback', passport.authenticate('facebook', {
    successRedirect: '/facebook/profile',
    failureRedirect: '/facebook/error'
}));

router.get('/logout', function (req, res) {
  req.logout();
  res.redirect('/');
});

function isLoggedIn(req, res, next) {
  if (req.isAuthenticated())
    return next();
  res.redirect('/error');
}
export default router;
import passport from 'passport';
import { Router } from 'express';

const router = Router()


router.get('/', function (req, res) {
    res.render('pages/index.ejs'); // load the index.ejs file
});

router.get('/profile', isLoggedIn, function (req, res) {
    res.render('pages/profile.ejs', {
      user: req.user // get the user out of session and pass to template
    });
});

router.get('/error', isLoggedIn, function (req, res) {
    res.render('pages/error.ejs');
});

router.get('/auth', passport.authenticate('facebook', { scope: ['email'] }));

router.get('/auth/callback', passport.authenticate('facebook', {
    successRedirect: '/profile',
    failureRedirect: '/error'
}));

router.get('/logout', function (req, res) {
  req.logout();
  res.redirect('/');
});

function isLoggedIn(req, res, next) {
  if (req.isAuthenticated())
    return next();
  res.redirect('/');
}
export default router;
import passport  from 'passport';
import passportGoogleAuth from 'passport-google-oauth20'
const GoogleStrategy = passportGoogleAuth.Strategy;
import utilisateurModel from '../models/utilisateur.passport'
// const { findUserByGoogleId, createUser } = require('../models/userModel');
// import AuthenticationController from './authentication';
import 'dotenv/config'

passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: '/auth/google/callback',
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        let user = await utilisateurModel.findUserByGoogleId(profile.id);
        if (!user) {
          const userId = await utilisateurModel.createUser(profile.id, profile.emails[0].value);
          user = { id: userId, google_id: profile.id, email: profile.emails[0].value };
        }
        done(null, user);
      } catch (err) {
        done(err);
      }
    }
  )
);

passport.serializeUser((user, done) => done(null, user.id));

passport.deserializeUser(async (id, done) => {
  try {
    const [rows] = await pool.query('SELECT * FROM utilisateur WHERE id = ?', [id]);
    done(null, rows[0]);
  } catch (err) {
    done(err);
  }
});

export default passport;

import passport  from 'passport';
import passportGoogleAuth from 'passport-google-oauth20'
const GoogleStrategy = passportGoogleAuth.Strategy;
import 'dotenv/config'

// passport.use(
//   new GoogleStrategy(
//     {
//       clientID: process.env.GOOGLE_CLIENT_ID,
//       clientSecret: process.env.GOOGLE_CLIENT_SECRET,
//       callbackURL: 'htt/auth/google/callback',
//     },

//     async (accessToken, refreshToken, profile, done) => {
//       done(null, user);
//     }
//   )
// );

passport.serializeUser((user, done) => done(null, user));

passport.deserializeUser((user, done) => done(null, user));

export default passport;

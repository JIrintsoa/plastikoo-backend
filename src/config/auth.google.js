import passport from "passport";
import googleAuth from "passport-google-oauth20"
import { baseUrlLocal } from "../utils/nom.domaine.js";
import AuthenticationController from "../utils/authentication.js";
import 'dotenv/config'

const GoogleStrategy = googleAuth.Strategy

const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID
const GOOGLE_CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET

passport.use(new GoogleStrategy({
        clientID: GOOGLE_CLIENT_ID,
        clientSecret: GOOGLE_CLIENT_SECRET,
        callbackURL:`${baseUrlLocal()}/google/auth/callback`,
        passReqToCallback: true
    },
    async function(request, accessToken, refreshToken, profile,done) {
        try {
            // Use the People API to fetch detailed profile information, including birthday
            const response = await fetch(`https://people.googleapis.com/v1/people/me?personFields=birthdays`, {
              headers: {
                'Authorization': `Bearer ${accessToken}`
              }
            });
      
            const data = await response.json();
            // Get the user's birthday from the response (if available)
            const birthday = data.birthdays ? data.birthdays[0].date : null;
            // console.log(profile._json)
            const userProfile = {
              id: profile.id,
              nom: profile._json.family_name,
              prenom: profile._json.given_name,
              email: profile.emails ? profile.emails[0].value : null,
              birthday: birthday,  // Now we have the birthday from the People API
              img_profil: profile.photos[0].value
            };

            // console.log(userProfile)

            const user = await AuthenticationController.verifyEmail(profile._json.email)
            console.log(user)
            if (user){
                return done(null, user.id)
            }
            else{
                AuthenticationController.ajouterUtilisateur(userProfile).then(userId => {
                  console.log('User inserted with ID:', userId);
                  return done(null, userId)
                }).catch(err => {
                  console.error('Error:', err);
                });
            }
      
            // return done(null, userProfile);
          } catch (error) {
            console.log(error)
            // return done(null, error);
          }
    }
))

passport.serializeUser((user, done) =>{
    done(null, user.id)
})

passport.deserializeUser((user, done) => {
    done(null, user.id)
})
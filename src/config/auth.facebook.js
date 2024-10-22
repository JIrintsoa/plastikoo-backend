import passport from "passport";
import facebookAuth from "passport-facebook"
import { baseUrlLocal, baseUrlProd } from "../utils/nom.domaine.js";
import AuthenticationController from "../utils/authentication.js";

const FacebookStrategy = facebookAuth.Strategy

const FACEBOOK_CLIENT_ID = process.env.FACEBOOK_CLIENT_ID
const FACEBOOK_CLIENT_SECRET = process.env.FACEBOOK_CLIENT_SECRET

passport.use(new FacebookStrategy({
        clientID: FACEBOOK_CLIENT_ID, // Remplace avec ton App ID
        clientSecret: FACEBOOK_CLIENT_SECRET, // Remplace avec ton App Secret
        callbackURL: `${baseUrlProd}/facebook/auth/callback`,  // Production URL
        // callbackURL: `${baseUrlLocal}/facebook/auth/callback`,  // Production URL
        // profileFields: ['id', 'emails', 'displayName', 'name', 'birthday', 'photos'] // Champs que tu veux récupérer (ajoute 'email' si besoin)
        profileFields: ['id', 'emails', 'displayName', 'name', 'photos'] // Champs que tu veux récupérer (ajoute 'email' si besoin)

    },
    async function(accessToken, refreshToken, profile, done) {
        try {
            console.log('Access Token:', accessToken);
            console.log('Profile:', profile);
            // console.log(profile)
            const { id, emails, displayName, name, photos } = profile;

            const email = emails && emails.length ? emails[0].value : null;
            const firstName = name.givenName;
            const lastName = name.familyName;
            const pseudo = displayName || `${firstName} ${lastName}`;
            const profilePicture = photos && photos.length ? photos[0].value : null;
            // const birthDate = birthday || null; // Peut nécessiter un formatage si nécessaire

            const userProfile = {
                id: id,
                nom: name.familyName,
                prenom: name.givenName,
                email: emails && emails.length ? emails[0].value : null,
                // birthday: birthday,  // Now we have the birthday from the People API
                img_profil: photos[0].value
            };

            // console.log('ato ny information a partir an ilay user \n',userProfile)
            const user = await AuthenticationController.verifyEmail(email)
            // console.log(user)
            if (user){
                return done(null, user.id)
            }
            else{
                AuthenticationController.ajouterUtilisateurFacebook(userProfile).then(userId => {
                    console.log('User inserted with ID:', userId);
                    return done(null, userId)
                }).catch(err => {
                    console.error('Error:', err);
                });
            }

        } catch (error) {
            console.log(error)
        }
    }
));

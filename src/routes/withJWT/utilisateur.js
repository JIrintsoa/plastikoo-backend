import { Router } from "express";
import UtilisateurController from "../../controllers/utilisateur.js";
import AuthenticationController from "../../utils/authentication.js";
import UploadController from "../../controllers/upload.js";

const route = Router();

route.post(
  "/cree-code-pin",
  AuthenticationController.verifyRoleToken("utilisateur"),
  async (req, res) => {
    await UtilisateurController.creeCodePIN(req, res);
  }
);

route.post(
  "/use-code-pin",
  AuthenticationController.verifyRoleToken("utilisateur"),
  async (req, res) => {
    await UtilisateurController.verifierCodePIN(req, res);
  }
);

route.post(
  "/verifie-solde",
  AuthenticationController.verifyRoleToken("utilisateur"),
  async (req, res) => {
    const arg = {
      id_user: req.utilisateur.id_utilisateur,
      somme: req.body.montant,
    };
    await UtilisateurController.verifierSolde(arg, res);
  }
);

route.put(
  "/cree-pseudo",
  AuthenticationController.verifyRoleToken("utilisateur"),
  UploadController.singleFileUpload("pseudo"),
  UtilisateurController.creePseudo
);

export default route;
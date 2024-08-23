import { Router } from "express";
import uploadFile from "../utils/upload.file.js";
import UploadController from '../controllers/upload.js';

import fs from "fs"

const upload = uploadFile.upload

const router = Router()

const MB = 5;

const maxSize = 5 * 1024 * 1024; // 5 MB in bytes

router.post('/single', UploadController.singleFileUpload);

router.post('/multiple', UploadController.multipleFileUpload)

// router.post('/multiple', (req, res) => {
//     upload.array('forum-img')(req, res, (err) => {
//         if (err) {
//             console.log(err)
//             if (err.code === 'INVALID_FILE_FORMAT') {
//                 return res.status(400).json({ error: err.message });
//             }
//             else if(err.code === 'LIMIT_FILE_SIZE'){
//                 return res.status(400).json({error:`Fichier trop volumineux. Veuillez ajouter un fichier moins de ${MB} MB`})
//             }
//             // Handle other errors here
//             return res.status(500).json({ error: ' Une erreur inattendue s\'est produite lors du téléchargement du fichier. ' });
//         }

//         if (!req.files || req.files.length === 0) {
//             return res.status(400).json({ error: 'Aucun fichier n\'a été téléchargé.' });
//         }

//         let isValid = true;
//         const uploadedFiles = [];

//         for (const file of req.files) {
//             if (!file) {
//                 isValid = false;
//                 break;
//             }
//             uploadedFiles.push(file);

//             console.log(file.originalname, file.filename, file.path);

//             if (!uploadFile.isValidFile(file)) {
//                 isValid = false;
//                 break;
//             }
//         }

//         if (isValid) {
//             return res.json({ message: 'Fichiers téléchargés avec succès!' });
//         }

//         // Remove all files if any file is invalid
//         for (const file of uploadedFiles) {
//             fs.unlink(file.path, (err) => {
//                 if (err) {
//                     console.error('Error removing file:', err);
//                 }
//             });
//         }

//         return res.status(413).json({ error: 'Fichier non téléchargé ! Veuillez joindre des fichiers valides. (jpeg,png,jpg)' });
//     });
// });




export default router
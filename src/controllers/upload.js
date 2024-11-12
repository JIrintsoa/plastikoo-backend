import uploadUtils from '../utils/upload.file.js';

const { upload, MBsize, isValidFile } = uploadUtils

class UploadController {

    static singleFileUpload(typeFieldName) {
        return (req, res, next) => {
            const upload = uploadUtils.getUploadMiddleware(typeFieldName);
            upload.single(typeFieldName)(req, res, (err) => {
                if (err) {
                    const errorMessages = {
                        'LIMIT_FILE_SIZE': `La taille du fichier dépasse la limite de ${MBsize} Mo.`,
                        'INVALID_FILE_FORMAT': err.message
                    };
                    return res.status(err.code === 'LIMIT_FILE_SIZE' || err.code === 'INVALID_FILE_FORMAT' ? 400 : 500).json({ error: errorMessages[err.code] || 'Une erreur inattendue s\'est produite lors du téléchargement du fichier.' });
                }
                
                // Skip error if `typeFieldName` is "forum" and no file uploaded
                if (!req.file && typeFieldName === "forum") {
                    req.fileUploaded = null;
                    return next();
                }
                
                // Return error if no file is uploaded for other types
                if (!req.file) return res.status(400).json({ error: 'Aucun fichier n\'a été téléchargé.' });
    
                req.fileUploaded = req.file.filename;
                next();
            });
        };
    }

    static multipleFileUpload(req,res) {
        upload.array('forum-img')(req,res,err =>{
            if (err) {
                console.log(err);
                if (err.code === 'INVALID_FILE_FORMAT') {
                    return res.status(400).json({ error: err.message });
                } else if (err.code === 'LIMIT_FILE_SIZE') {
                    return res.status(413).json({ error: `La taille du fichier dépasse la limite de ${MBsize} Mo.`});
                }
                return res.status(500).json({ error: 'Une erreur inattendue s\'est produite lors du téléchargement du fichier.' });
            }

            if (!req.files || req.files.length === 0) {
                return res.status(400).json({ error: 'Aucun fichier n\'a été téléchargé.' });
            }

            let isValid = true;
            const uploadedFiles = [];

            for (const file of req.files) {
                if (!file) {
                    isValid = false;
                    break;
                }
                uploadedFiles.push(file);

                console.log(file.originalname, file.filename, file.path);

                if (!isValidFile(file)) {
                    isValid = false;
                    break;
                }
            }

            if (isValid) {
                return res.status(201).json({ message: 'Fichier téléchargé avec succès !' });
            }

            // Remove all files if any file is invalid
            for (const file of uploadedFiles) {
                fs.unlink(file.path, (err) => {
                    if (err) {
                        console.error('Error removing file:', err);
                    }
                });
            }

            return res.status(413).json({ error: 'Fichier non téléchargé ! Veuillez joindre des fichiers valides (jpeg, png, jpg).' });
        })
    }

    static deleteFileLocalUploaded(filename){
        uploadUtils.deleteFileLocalUploaded(filename)
    }

}

export default UploadController;

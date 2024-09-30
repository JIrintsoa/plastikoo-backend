import multer from "multer";
import path from "path";
import { fileURLToPath } from "url";
import fs from 'fs'
import 'dotenv/config'

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const MBsize = 2;
const maxSize = MBsize * 1024 * 1024;

function generateRandomName() {
    return Math.floor(Math.random() * 1e9); // Generates a random 9-digit number
}

function getMulterStorage(typeFieldName) {
    return multer.diskStorage({
        destination: path.join(__dirname, "../../uploads"),
        
        // destination: path.join(process.env.DIR_LOCAL_STORAGE_FILE, "uploads"),
        filename: (req, file, cb) => {
            const randomName = generateRandomName();
            const fileExtension = path.extname(file.originalname);
            const finalFileName = `${typeFieldName}-${randomName}${fileExtension}`;
            cb(null, finalFileName);
        }
    });
}

const fileFilterConfig = function(req, file, cb) {
    const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/jpg']; // Add more allowed mime types if needed
    if (allowedMimeTypes.includes(file.mimetype)) {
        cb(null, true); // File is valid
    } else {
        const error = new Error('Invalid file format. Please attach a jpeg/png/jpg');
        error.code = 'INVALID_FILE_FORMAT'; // Custom error code
        cb(error, false);
    }
};

function getUploadMiddleware(typeFieldName) {
    const storage = getMulterStorage(typeFieldName);

    return multer({
        storage,
        limits: {
            fileSize: maxSize
        },
        fileFilter: fileFilterConfig
    });
}

function deleteFileLocalUploaded(filename){
    const fileNameDir = '/uploads/'+filename
    const filePath = path.join(process.env.DIR_LOCAL_STORAGE_FILE, fileNameDir);
    fs.unlink(filePath, (unlinkErr) => {
        if (unlinkErr) {
            console.error('Erreur lors de la suppression du fichier: ', unlinkErr);
        }
    });
}

export default {
    MBsize,
    getUploadMiddleware,
    isValidFile: file => {
        return file.size <= maxSize && ['image/jpeg', 'image/png', 'image/jpg'].includes(file.mimetype);
    },
    deleteFileLocalUploaded
};

import multer from "multer"
import path from "path"
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const MBsize = 2
const maxSize = MBsize * 1024 * 1024;

const storageConfig = multer.diskStorage({
    destination: path.join("/home/johns-irintsoa/Documents/GitHub/plastikoo_backend", "uploads"),
    filename: (req, file, res) => {
        res(null, Date.now() + "-" + file.originalname);
    }
})

const fileFilterConfig = function(req, file, cb) {
    const allowedMimeTypes = ['image/jpeg','image/png','image/JPG']; // Add more allowed mime types if needed
    if (allowedMimeTypes.includes(file.mimetype)) {
       cb(null, true); // File is valid
    }
    else {
        const error = new Error('Invalid file format. Please attach a jpeg/png/jpg');
        error.code = 'INVALID_FILE_FORMAT'; // Custom error code
        cb(error, false);
    }
};

const upload = multer({
    storage: storageConfig,
    limits: {
        fileSize: maxSize
    },
    fileFilter: fileFilterConfig
});

export default {
    MBsize,
    upload,
    isValidFile: file => {
        return file.size <= maxSize && ['image/jpeg', 'image/png', 'image/jpg'].includes(file.mimetype);
    }
}
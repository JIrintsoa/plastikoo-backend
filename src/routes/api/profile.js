// import AWS from 'aws-sdk'
// import multerS3 from 'multer-s3'
// import { S3Client }  from '@aws-sdk/client-s3'
// // const multerS3 = require( 'multer-s3' );
// import path from 'path'
// import multer from 'multer'
// import url from 'url'
// import  { Router } from 'express';

// /**
//  * express.Router() creates modular, mountable route handlers
//  * A Router instance is a complete middleware and routing system; for this reason, it is often referred to as a “mini-app”.
//  */
// const router = Router();

// /**
//  * PROFILE IMAGE STORING STARTS
//  */



// /**
//  * Single Upload
//  */
// const profileImgUpload = multer({
//     storage: multerS3({
//         s3: s3Access,
//         bucket: 'plastikoo-files',
//         acl: 'public-read',
//         key: function (req, file, cb) {
//             cb(null, path.basename( file.originalname, path.extname( file.originalname ) ) + '-' + Date.now() + path.extname( file.originalname ) )
//         }
//     }),
//     limits:{ fileSize: 2000000 }, // In bytes: 2000000 bytes = 2 MB
//     fileFilter: function( req, file, cb ){
//         checkFileType( file, cb );
//     }
// }).single('profileImage');

// /**
//  * Check File Type
//  * @param file
//  * @param cb
//  * @return {*}
//  */

// function checkFileType( file, cb ) {
//     // Allowed ext
//     const filetypes = /jpeg|jpg|png|gif/;
//     // Check ext
//     const extname = filetypes.test( path.extname( file.originalname ).toLowerCase());
//     // Check mime
//     const mimetype = filetypes.test( file.mimetype );
//     if( mimetype && extname ){
//         return cb( null, true );
//     } else {
//         cb( 'Error: Images Only!' );
//     }
// }
// /**
//  * @route POST api/profile/business-img-upload
//  * @desc Upload post image
//  * @access public
//  */
// router.post( '/single-file', ( req, res ) => {
//     profileImgUpload( req, res, ( error ) => {
//         if( error ){
//             console.log(req.file)
//             console.log( 'errors', error );
//             res.json( { error: error } );
//         } else {
//              // If File not found
//             if( req.file === undefined ){
//                 console.log( 'Error: No File Selected!' );
//                 res.json( 'Error: No File Selected' );
//             } else {
//               // If Success
//                 const imageName = req.file.key;
//                 const imageLocation = req.file.location;
//                 // Save the file name into database into profile model
//                 res.json({
//                     image: imageName,
//                     location: imageLocation
//                 });
//             }
//         }
//     });
// });
// // End of single profile upload

// /**
//  * BUSINESS GALLERY IMAGES
//  * MULTIPLE FILE UPLOADS
//  */// Multiple File Uploads ( max 4 )
// const uploadsBusinessGallery = multer({
//     storage: multerS3({
//         s3: s3Access,
//         bucket: 'plastikoo-files',
//         acl: 'public-read',
//         key: function (req, file, cb) {
//             cb( null, path.basename( file.originalname, path.extname( file.originalname ) ) + '-' + Date.now() + path.extname( file.originalname ) )
//         }
//     }),
//     limits:{ fileSize: 2000000 }, // In bytes: 2000000 bytes = 2 MB
//     fileFilter: function( req, file, cb ){
//         checkFileType( file, cb );
//     }
// }).array( 'galleryImage', 4 );

// /**
//  * @route POST /api/profile/business-gallery-upload
//  * @desc Upload business Gallery images
//  * @access public
//  */


// router.post('/multiple-file', ( req, res ) => {
//     uploadsBusinessGallery( req, res, ( error ) => {
//         console.log( 'files', req.files );
//         if( error ){
//             console.log( 'errors', error );
//             res.json( { error: error } );
//         } else {
//             // If File not found
//             if( req.files === undefined ){
//                 console.log( 'Error: No File Selected!' );
//                 res.json( 'Error: No File Selected' );
//             } else {
//               // If Success
//                 let fileArray = req.files, fileLocation;
//                 const galleryImgLocationArray = [];
//                 for ( let i = 0; i < fileArray.length; i++ ) {
//                     fileLocation = fileArray[ i ].location;
//                     console.log( 'filenm', fileLocation );
//                     galleryImgLocationArray.push( fileLocation )
//                 }
//                 // Save the file name into database
//                 res.json( {
//                     filesArray: fileArray,
//                     locationArray: galleryImgLocationArray
//                 } );
//             }
//         }
//     });
// });

// // We export the router so that the server.js file can pick it up
// export default router;

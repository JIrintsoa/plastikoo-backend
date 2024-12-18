import nodemailer from "nodemailer"
import path from "path";
import { fileURLToPath } from "url";
import fs from 'fs'
import 'dotenv/config'

import { promisify } from "util";

const readFileAsync = promisify(fs.readFile);

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const sendEmail = async (to, prenom,subject, text, callback) => {
  try {
    // Create a Nodemailer transporter
    let transporter = nodemailer.createTransport({
        service: 'Gmail', // You can use other services or SMTP config
        auth: {
            user: process.env.PLASTIKOO_MAIL,
            pass: process.env.PLASTIKOO_SENDER_MAIL_MDP
        }
    });

    // Read the HTML template
    const emailTemplatePath = path.join(__dirname, '../templates', 'emailTemplate.html');
    const emailTemplate = fs.readFileSync(emailTemplatePath, 'utf8');

    // Get the image directory path from the .env file
    const imagesDirectory = path.join(__dirname, '../images');

    // Resolve the full path to the logo and signature images
    const logoPath = path.join(imagesDirectory, 'LOGO-FINALE-vert.png');
    const signaturePath = path.join(imagesDirectory, 'signature-email.png');

    // Read images and convert them to base64
    const logoBase64 = fs.readFileSync(logoPath, { encoding: 'base64' });
    const signatureBase64 = fs.readFileSync(signaturePath, { encoding: 'base64' });
    
    const htmlContent = emailTemplate
    .replace('{{logo}}', `data:image/png;base64,${logoBase64}`)  // Embed logo as base64
    .replace('{{prenom}}', prenom)
    .replace('{{content}}', text)
    .replace('{{signature}}', `data:image/png;base64,${signatureBase64}`);

    const mailOptions = {
      from: "no-reply@plastikoo.mg",
      to,
      subject,
      text,
      html: htmlContent
    };

    // Send the email
    let info = await transporter.sendMail(mailOptions);

    if (callback) {
      callback(null, info); // No error, pass info
    }

    console.log('Email sent: %s', info.messageId);
  } catch (error) {
    console.error('Error sending email:', error);

    if (callback) {
      callback(error, null); // Error occurred, no info
    }
  }
}

const sendEmailByDirectAdmin = async (to, prenom, subject, text, callback) =>{
  try {
    // Create a Nodemailer transporter
    let transporter = nodemailer.createTransport({
        host: 'mail.plastikoo.mg',
        port: 587,
        secure:false,
        auth: {
          user: 'no-reply@plastikoo.mg', // Your email
          pass: '123noreply', // Your email password
        },
        // auth: {
        //     user: process.env.PLASTIKOO_MAIL,
        //     pass: process.env.PLASTIKOO_SENDER_MAIL_MDP
        // }
    });

    // Read the HTML template
    const emailTemplatePath = path.join(__dirname, '../templates', 'devisTemplate.html');
    const emailTemplate = fs.readFileSync(emailTemplatePath, 'utf8');

    // Get the image directory path from the .env file
    // const imagesDirectory = path.join(__dirname, '../images');

    // // Resolve the full path to the logo and signature images
    // const logoPath = path.join(imagesDirectory, 'LOGO-FINALE-vert.png');
    // const signaturePath = path.join(imagesDirectory, 'signature-email.png');

    
    const htmlContent = emailTemplate
    // .replace('{{logo}}', `data:image/png;base64,${logoBase64}`)  // Embed logo as base64
    .replace('{{prenom}}', prenom)
    .replace('{{content}}', text)
    // .replace('{{signature}}', `data:image/png;base64,${signatureBase64}`);

    const mailOptions = {
      from: "no-reply@plastikoo.mg",
      to,
      subject,
      text,
      html: htmlContent,
    };

    // Send the email
    let info = await transporter.sendMail(mailOptions);

    if (callback) {
      callback(null, info); // No error, pass info
    }

    console.log('Email sent: %s', info.messageId);
  } catch (error) {
    console.error('Error sending email:', error);

    if (callback) {
      callback(error, null); // Error occurred, no info
    }
  }
}

const sendFormContact = async (formContact, callback) =>{
  try {
    // Create a Nodemailer transporter
    let transporter = nodemailer.createTransport({
        host: 'mail.plastikoo.mg',
        port: 587,
        secure:false,
        auth: {
          user: 'akory@plastikoo.mg', // Your email
          pass: 'Akoryaby24.', // Your email password
        },
        // auth: {
        //     user: process.env.PLASTIKOO_MAIL,
        //     pass: process.env.PLASTIKOO_SENDER_MAIL_MDP
        // }
    });

    // Read the HTML template
    const emailTemplatePath = path.join(__dirname, '../templates', 'contactForm.html');
    const emailTemplate = fs.readFileSync(emailTemplatePath, 'utf8');

    // Get the image directory path from the .env file
    // const imagesDirectory = path.join(__dirname, '../images');

    // // Resolve the full path to the logo and signature images
    // const logoPath = path.join(imagesDirectory, 'LOGO-FINALE-vert.png');
    // const signaturePath = path.join(imagesDirectory, 'signature-email.png');

    const {nom, prenom, email, type_contact, message} = formContact
    
    const htmlContent = emailTemplate
    // .replace('{{logo}}', `data:image/png;base64,${logoBase64}`)  // Embed logo as base64
    .replace('{{nom}}', nom)
    .replace('{{prenom}}', prenom)
    .replace('{{email}}', email)
    .replace('{{type_contact}}', type_contact)
    .replace('{{message}}', message)
    // .replace('{{signature}}', `data:image/png;base64,${signatureBase64}`);

    const mailOptions = {
      to: "akory@plastikoo.mg",
      subject: "Nouveau Contact",
      text: "Voici les information du nouveau contact:",
      html: htmlContent,
    };

    // Send the email
    let info = await transporter.sendMail(mailOptions);

    if (callback) {
      callback(null, info); // No error, pass info
    }

    console.log('Email sent: %s', info.messageId);
  } catch (error) {
    console.error('Error sending email:', error);

    if (callback) {
      callback(error, null); // Error occurred, no info
    }
  }
}

export default {
    sendEmail,
    sendEmailByDirectAdmin,
    sendFormContact
}

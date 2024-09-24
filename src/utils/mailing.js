import nodemailer from "nodemailer"
import path from "path";
import { fileURLToPath } from "url";
import fs from 'fs'
import 'dotenv/config'

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

export default {
    sendEmail
}

const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: process.env.MAIL_HOST,
  port: process.env.MAIL_PORT,
  secure: false, // true pour 465, false pour 587
  auth: {
    user: process.env.MAIL_USER,
    pass: process.env.MAIL_PASS,
  },
});

async function sendResetEmail(to, resetLink) {
  const mailOptions = {
    from: process.env.MAIL_FROM,
    to,
    subject: 'Réinitialisation de votre mot de passe - PeinturePro TN',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px;">
        <h2 style="color: #C8441A;">PeinturePro TN</h2>
        <p>Bonjour,</p>
        <p>Cliquez sur le lien ci-dessous pour réinitialiser votre mot de passe :</p>
        <a href="${resetLink}" style="display: inline-block; padding: 10px 20px; background-color: #C8441A; color: white; text-decoration: none; border-radius: 8px;">Réinitialiser</a>
        <p>Ce lien expire dans 1 heure.</p>
        <p>Si vous n'êtes pas à l'origine de cette demande, ignorez cet email.</p>
        <p>Cordialement,<br/>L'équipe PeinturePro TN</p>
      </div>
    `,
  };
  await transporter.sendMail(mailOptions);
}

module.exports = { sendResetEmail };
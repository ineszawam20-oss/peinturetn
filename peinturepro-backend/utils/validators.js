const Joi = require('joi');

const validators = {

  login: Joi.object({
    email:    Joi.string().email().required(),
    password: Joi.string().min(1).required(),
    role:     Joi.string().valid('admin','commercial','livreur','client').optional()
  }),

  register: Joi.object({
    nom:       Joi.string().min(2).max(100).required(),
    email:     Joi.string().email().required(),
    password:  Joi.string()
                  .min(8)
                  .pattern(/[A-Z]/, 'majuscule')
                  .pattern(/[a-z]/, 'minuscule')
                  .pattern(/[0-9]/, 'chiffre')
                  .pattern(/[^A-Za-z0-9]/, 'special')
                  .required()
                  .messages({
                    'string.pattern.name': 'Le mot de passe doit contenir au moins 1 {#name}'
                  }),
    telephone: Joi.string().pattern(/^[0-9+\s]{8,15}$/).optional(),
    adresse:   Joi.string().max(255).optional()
  }),

  produit: Joi.object({
    nom:            Joi.string().min(2).max(100).required(),
    type:           Joi.string().valid('interieure','exterieure','impermeabilisante').required(),
    finition:       Joi.string().valid('mate','satinee','brillante').optional(),
    couleur_code:   Joi.string().pattern(/^#[0-9A-Fa-f]{6}$/).optional(),
    rendement_m2_L: Joi.number().positive().optional(),
    prix_litre:     Joi.number().positive().required(),
    stock_litres:   Joi.number().min(0).optional(),
    stock_minimum:  Joi.number().min(0).optional()
  }),

  commande: Joi.object({
    produit_id:              Joi.number().integer().positive().required(),
    surface_m2:              Joi.number().positive().required(),
    litres_calcules:         Joi.number().min(5).required()
                               .messages({ 'number.min': 'Minimum 5 litres requis.' }),
    date_livraison_souhaitee: Joi.date().min('now').optional(),
    chantier_id:             Joi.number().integer().positive().optional()
  }),

  devis: Joi.object({
    client_id:      Joi.number().integer().positive().required(),
    surface_m2:     Joi.number().positive().required(),
    produit_id:     Joi.number().integer().positive().required(),
    prix_litre:     Joi.number().positive().required(),
    litres_calcules:Joi.number().min(5).required()
  })
};

// Middleware de validation
function validate(schema) {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, { abortEarly: false });
    if (error) {
      return res.status(400).json({
        message: 'Données invalides.',
        details: error.details.map(d => d.message)
      });
    }
    next();
  };
}

module.exports = { validators, validate };
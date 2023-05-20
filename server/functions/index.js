/* eslint-disable space-before-function-paren */
/* eslint-disable comma-dangle */
/* eslint-disable indent */
/* eslint-disable object-curly-spacing */
/* eslint-disable no-unused-vars */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

const functions = require("firebase-functions");
const stripe = require("stripe")(functions.config().stripe.testkey);

const generateResponse = function (intent) {
  switch (intent.status) {
    case "requires_action":
      return {
        clientSecret: intent.client_secret,
        requiresAction: true,
        status: intent.status,
      };
    case "requires_payment_method":
      return {
        error: "Your card was denied, please provide a new payment method",
      };
    case "succeeded":
      console.log("Payment succeeded.");
      return { clientSecret: intent.client_secret, status: intent.status };
  }
  return { error: "Failed" };
};

exports.StripePayEndpointMethodId = functions
  .runWith({ maxInstances: 3, maxScale: 10 })
  .region("asia-southeast1")
  .https.onRequest(async (req, res) => {
    const { paymentMethodId, currency, useStripeSdk, amount } = req.body;

    try {
      if (paymentMethodId) {
        // Create a new PaymentIntent
        const params = {
          amount: amount,
          confirm: true,
          confirmation_method: "manual",
          currency: currency,
          payment_method: paymentMethodId,
          use_stripe_sdk: useStripeSdk,
        };
        const intent = await stripe.paymentIntents.create(params);
        console.log(`Intent: ${intent}`);
        return res.send(generateResponse(intent));
      }
      return res.sendStatus(400);
    } catch (e) {
      return res.send({ error: e.message });
    }
  });

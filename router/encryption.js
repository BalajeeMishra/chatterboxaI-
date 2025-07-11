import express from 'express';
import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import { decryptRequest, encryptResponse, FlowEndpointException } from "../controller/encryption.js";

const router = express.Router();

const APP_SECRET = process.env.APP_SECRET;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const PASSPHRASE = process.env.PASSPHRASE;

// function isRequestSignatureValid(req) {
//   console.log("Validating Request Signature...");
//   if(!APP_SECRET) {
//     console.warn("App Secret is not set up. Please Add your app secret in /.env file to check for request validation");
//     return true;
//   }

//   const signatureHeader = req.get("x-hub-signature-256");
//   const signatureBuffer = Buffer.from(signatureHeader.replace("sha256=", ""), "utf-8");

//   const hmac = crypto.createHmac("sha256", APP_SECRET);
//   const digestString = hmac.update(req.rawBody).digest('hex');
//   const digestBuffer = Buffer.from(digestString, "utf-8");
//   console.log("Header Signature:", signatureHex);
// console.log("Digest Calculated:", digestHex);
// console.log("Raw Body (Buffer):", req.rawBody);

//   if ( !crypto.timingSafeEqual(digestBuffer, signatureBuffer)) {
//     console.error("Error: Request Signature did not match");
//     return false;
//   }
//   return true;
// }

function isRequestSignatureValid(req) {
  if (!APP_SECRET) {
    console.warn("APP_SECRET not set");
    return true;
  }

  const signatureHeader = req.get("x-hub-signature-256");
  if (!signatureHeader || !signatureHeader.startsWith("sha256=")) {
    console.error("Missing or malformed signature header");
    return false;
  }

  const signatureHex = signatureHeader.replace("sha256=", "");

  const hmac = crypto.createHmac("sha256", APP_SECRET);
  const digestHex = hmac.update(req.rawBody).digest("hex");

  console.log("Expected:", digestHex);
  console.log("Actual:", signatureHex);

  const signatureBuffer = Buffer.from(signatureHex, "hex");
  const digestBuffer = Buffer.from(digestHex, "hex");

  if (
    signatureBuffer.length !== digestBuffer.length ||
    !crypto.timingSafeEqual(signatureBuffer, digestBuffer)
  ) {
    console.error("❌ Signature mismatch");
    return false;
  }

  console.log("✅ Signature match");
  return true;
}


router.post("/", async (req, res) => {
  if (!PRIVATE_KEY) {
    throw new Error(
      'Private key is empty. Please check your env variable "PRIVATE_KEY".'
    );
  }

  if(!isRequestSignatureValid(req)) {
    // Return status code 432 if request signature does not match.
    // To learn more about return error codes visit: https://developers.facebook.com/docs/whatsapp/flows/reference/error-codes#endpoint_error_codes
    return res.status(432).send();
  }

  let decryptedRequest = null;
  try {
    decryptedRequest = decryptRequest(req.body, PRIVATE_KEY, PASSPHRASE);
  } catch (err) {
    console.error(err);
    if (err instanceof FlowEndpointException) {
      return res.status(err.statusCode).send();
    }
    return res.status(500).send();
  }

  const { aesKeyBuffer, initialVectorBuffer, decryptedBody } = decryptedRequest;
  console.log("💬 Decrypted Request:", decryptedBody);

  // TODO: Uncomment this block and add your flow token validation logic.
  // If the flow token becomes invalid, return HTTP code 427 to disable the flow and show the message in `error_msg` to the user
  // Refer to the docs for details https://developers.facebook.com/docs/whatsapp/flows/reference/error-codes#endpoint_error_codes

  /*
  if (!isValidFlowToken(decryptedBody.flow_token)) {
    const error_response = {
      error_msg: `The message is no longer available`,
    };
    return res
      .status(427)
      .send(
        encryptResponse(error_response, aesKeyBuffer, initialVectorBuffer)
      );
  }
  */

  // const screenResponse = await getNextScreen(decryptedBody);
  console.log("👉 Response to Encrypt:", screenResponse);

  res.send(encryptResponse(screenResponse, aesKeyBuffer, initialVectorBuffer));
});

export default router;
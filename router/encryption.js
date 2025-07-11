import express from "express";
import crypto from "crypto";
import fs from "fs";
const router = express.Router();

const privateKey = fs.readFileSync('private.pem', 'utf8');

const key = crypto.createPrivateKey({
  key: privateKey,
  format: 'pem',     // must be 'pem'
  type: 'pkcs1',     // or 'pkcs8' depending on key
  passphrase: 'balajee'// if needed
});
// console.log(key.export({ type: 'pkcs1', format: 'pem' })); // Export the key in PEM format
// console.log("Private Key:", key);
router.post("/data", async ({ body }, res) => {
  // const PRIVATE_KEY = process.env.PRIVATE_KEY;
  const { decryptedBody, aesKeyBuffer, initialVectorBuffer } = decryptRequest(
    body,
    key
  );

  // console.log(firstname, "Decrypted Body:", decryptedBody);

  console.log(decryptedBody," Decrypted Body:");

  const { screen, data, version, action } = decryptedBody;
  // Return the next screen & data to the client
  // const screenData = {
  //   screen: "SCREEN_NAME",
  //   data: {
  //     some_key: "some_value",
  //   },
  // };

  const responseData = {
    data: {
      status: "active", // or dynamic logic based on input
    },
  };

  // Return the response as plaintext
  res.send(encryptResponse(responseData, aesKeyBuffer, initialVectorBuffer));
});

const decryptRequest = (body, privatePem) => {
 
  try{
  const { encrypted_aes_key, encrypted_flow_data, initial_vector } = body;

  // Decrypt the AES key created by the client
  const decryptedAesKey = crypto.privateDecrypt(
    {
      key: privatePem,
      padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
      oaepHash: "sha256",
    },
    Buffer.from(encrypted_aes_key, "base64"),
  );

  // Decrypt the Flow data
  const flowDataBuffer = Buffer.from(encrypted_flow_data, "base64");
  const initialVectorBuffer = Buffer.from(initial_vector, "base64");

  const TAG_LENGTH = 16;
  const encrypted_flow_data_body = flowDataBuffer.subarray(0, -TAG_LENGTH);
  const encrypted_flow_data_tag = flowDataBuffer.subarray(-TAG_LENGTH);

  const decipher = crypto.createDecipheriv(
    "aes-128-gcm",
    decryptedAesKey,
    initialVectorBuffer,
  );
  decipher.setAuthTag(encrypted_flow_data_tag);

  const decryptedJSONString = Buffer.concat([
    decipher.update(encrypted_flow_data_body),
    decipher.final(),
  ]).toString("utf-8");

  return {
    decryptedBody: JSON.parse(decryptedJSONString),
    aesKeyBuffer: decryptedAesKey,
    initialVectorBuffer,
  };
}
catch (error) {
    console.error("Decryption error:", error);
    // throw new Error("Decryption failed");
  } 
};

const encryptResponse = (
  response,
  aesKeyBuffer,
  initialVectorBuffer,
) => {

  console.log(response, "Response to encrypt");
  // Flip the initialization vector
  const flipped_iv = [];
  for (const pair of initialVectorBuffer.entries()) {
    flipped_iv.push(~pair[1]);
  }
  // Encrypt the response data
  const cipher = crypto.createCipheriv(
    "aes-128-gcm",
    aesKeyBuffer,
    Buffer.from(flipped_iv),
  );

  return Buffer.concat([
    cipher.update(JSON.stringify(response), "utf-8"),
    cipher.final(),
    cipher.getAuthTag(),
  ]).toString("base64");
};

export default router;

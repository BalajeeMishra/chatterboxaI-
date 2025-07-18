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

// 0|chatterb | started
// 0|chatterb | {
// 0|chatterb |   data: { full_name: 'Hhh', pickup_address: 'Hhhh' },
// 0|chatterb |   flow_token: 'unused',
// 0|chatterb |   screen: 'PROFILE_UPDATE',
// 0|chatterb |   action: 'data_exchange',
// 0|chatterb |   version: '3.0'
// 0|chatterb | }  Decrypted Body:
// 0|chatterb | { data: { status: 'active' } } Response to encrypt



const getNextScreen = async (decryptedBody) => {
  console.log("balajee mishra", decryptedBody);
  const { screen, data, version, action, flow_token } = decryptedBody;
  // handle health check request
  if (action === "ping") {
    return {
      data: {
        status: "active",
      },
    };
  }

  // handle error notification
  if (data?.error) {
    
    return {
      data: {
        acknowledged: true,
      },
    };
  }

  // // handle initial request when opening the flow
  if (action === "INIT") {
    console.log("Flow initialized with screen:okkkkkkkkkkkkkkkkkkkkkkkkkk");
    console.log("Flow started with screen:", screen);
    return {
      screen: "PROFILE_UPDATE",
      data: {
        // custom data for the screen
        greeting: "Hey there! 👋",
      },
    };
  }

  // if (action === "data_exchange") {
  //   // handle the request based on the current screen
  //   switch (screen) {
  //     case "PROFILE_UPDATE":
        

  //       // send success response to complete and close the flow
  //       return {
  //         screen: "COMPLETE",
  //         data: {
  //           extension_message_response: {
  //             params: {
  //               flow_token,
  //             },
  //           },
  //         },
  //       };
  //     default:
  //       break;
  //   }
  // }

  console.log("Flow started with screen:", screen, action);

  if (action === "data_exchange") {
    Console.log("Flow completed with screen: SCHOOL balajeeeee",Screen);
    // handle the request based on the current screen
    switch (screen) {
      case "SCHOOL":
        // send success response to complete and close the flow
        return {
          screen: "COMPLETE",
          data: {
            school: [
              { id: "abc", title: "Modern School" },
              { id: "xyz", title: "IPS" },
              { id: "pqr", title: "DPS" },
            ]
          },
        };
      default:
        break;
    }
  }




  throw new Error(
    "Unhandled endpoint request. Make sure you handle the request action & screen logged above."
  );
};


router.post("/data", async ({ body }, res) => {
  console.log("hello world")
  const { decryptedBody, aesKeyBuffer, initialVectorBuffer } = decryptRequest(
    body,
    key
  );

  console.log(decryptedBody," Decrypted Body:");

  // const { screen, data, version, action } = decryptedBody;

  const screenResponse = await getNextScreen(decryptedBody);

  // Return the response as plaintext
  res.send(encryptResponse(screenResponse, aesKeyBuffer, initialVectorBuffer));
});


router.post("/school", async ({ body }, res) => {
  console.log("hello world")
  const { decryptedBody, aesKeyBuffer, initialVectorBuffer } = decryptRequest(
    body,
    key
  );

  console.log(decryptedBody," Decrypted Body:");

  // const { screen, data, version, action } = decryptedBody;

  const screenResponse = await getNextScreen(decryptedBody);

  // Return the response as plaintext
  res.send(encryptResponse(screenResponse, aesKeyBuffer, initialVectorBuffer));
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

/**
 * TODO(developer): Uncomment these variables before running the sample.
 */
// projects/322417518708/secrets/OPENAI_SECRET
const name = 'projects/dialogflow-first-test/secrets/OPENAI_SECRET/versions/latest';

// Imports the Secret Manager library
import {SecretManagerServiceClient} from '@google-cloud/secret-manager';

// Instantiates a client
const client = new SecretManagerServiceClient();

export default async function getSecret() {
  // const [secret] = await client.getSecret({
  //   name: name,
  // });

  

  // const policy = secret.replication.replication;

  // console.info(`Found secret ${secret.name} (${policy})`);
  // console.log(secret)

  const [accessResponse] = await client.accessSecretVersion({
    name: name,
  });

  // Decode the secret payload
  const secretValue = accessResponse.payload.data.toString('utf8');

  return secretValue
  

}
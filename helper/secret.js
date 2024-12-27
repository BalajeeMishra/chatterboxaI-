/**
 * TODO(developer): Uncomment these variables before running the sample.
 */
const name = 'projects/dialogflow-first-test/secrets/OPENAI_SECRET';

// Imports the Secret Manager library
import {SecretManagerServiceClient} from '@google-cloud/secret-manager';

// Instantiates a client
const client = new SecretManagerServiceClient();

async function getSecret() {
  const [secret] = await client.getSecret({
    name: name,
  });

  const policy = secret.replication.replication;

  console.info(`Found secret ${secret.name} (${policy})`);
}

getSecret();
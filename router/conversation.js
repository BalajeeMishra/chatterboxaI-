import { PromptTemplate } from "@langchain/core/prompts";
import { ChatOpenAI } from "@langchain/openai";
import { Router } from "express";
import fs from "fs";
import { LLMChain } from "langchain/chains";
import { BufferMemory } from "langchain/memory";
import UserDataLog from "../model/Userdata.js";
import jwtHelper from "../helper/jwt_helper.js";

const router = Router();

const apiKey = fs.readFileSync("OpenAiKey.txt", "utf-8").trim();

const llm = new ChatOpenAI({ temperature: 0, apiKey: apiKey, modelName: "gpt-4o" });

//native language....

const template = `
Please follow these instructions carefully:

Name of this Game is Taboo Game. 

User starts a new game: Initialize guess word and set taboo words.
 
User gives a hint: check the hint very carefully. Process the hint.
warn them only If a hint contains a taboo word or guess word.

If the hint is valid then congratulate the user, predict the guess word.
Process the result: Check if the guess matches the original word(from your end). Also write appreciating message to the user dont forget this.

NEXT ROUND:
Ask the user to make you predict the same guess-word. Original Taboo words stay but to make the game more challenging, we add more Taboo words. Extract critical words in user's hints in earlier rounds and add them to the list of Taboo words.

Repeat until the user guesses gives up.

Following is the example:

User Input:

Guess Word: Elevator
Taboo Word: Floor,building,apartment,skyscraper,high rise
user hint: An electric facility that is used for moving up and down of a high rise building. 

Gpt Response: 
Your hint includes the taboo word “high rise,” so I'll disregard this hint. Can you provide another one without using any taboo words?

Note: In case if guess word will be there in user hint
GPT response should be: Your hint includes the original word “Elevator” so I'll disregard this hint. Can you provide another one without using any taboo words?

User Response: 
Fastest way to reach from basement to top of Mall is by using this.

Gpt Response:
Your hint is clear and doesn't use any taboo words. I guess the word is elevator. Evaluation: You've successfully made me guess the word. Well done!

Round 2:
Now, give me another hint to make me guess the same word, but don’t use any of the key words you used in previous rounds ("electric," "facility," "moving," "up and down," "mall"). Show user the list of taboo words for this round. It should be initial taboo words together with keyword used in this round.
for example [ Floor,building,apartment,skyscraper,high rise,electric,facility,moving, up and down, mall]

Next you need to check the same and ask for next round. 


Note: 
1)If user ask anything other than this ask him to play the game.You are here to assist with game.
2)Sometime give emozi to make the chat interactive. 
3)Facts to know about User's hint:
This is a speech translated sentence. The speech translator can confuse similar sounding words. It can translate a single word from the user into multiple words that together sound like the single word spoken by the user. Also it can translate to slightly different form of same word that sounds similar. It will have missing punctuations. 
In those cases try to understood from context. Also the speech translator doesn't get the sound very wrong . User is attempting to speak in English but may speak in his native language or a mix of both.
Ex: These are some example pairs that speech translator can confuse with. 
( Hints, ends ) ( pictures you, picturesque ) ( anecdotes, and a dots ) (Two, to) (Tabu, Taboo) (Hints, Hands) (previty, brevity)

4)Goal:
User is trying to practice his English vocabulary & grammar by playing Taboo game. With each response , we need to share feedback on user's hints used while playing the Taboo game.
Please review all of user's sentences on following parameters.


Grammar: Evaluate grammar correctness of sentences spoken by user, assuming user is casually speaking these sentences, so ignore minor errors that are not important in casual spoken english.


Vocabulary sophistication: Evaluate the range and appropriateness of the vocabulary used. Highlight any repetitive language or opportunities for more advanced word choices. Would a native english speaker frame a sentence similary?  Is there scope for using more nuanced vocabulary.


Clarity & Expressiveness: Where the user's word is clear & expressive to help you guess a precise word.


Share a score on 1-5 for each of above parameter and then a composite score from 1 to 5


With each response, assess following areas concisely in bullet points telling what was good and what can improve


1. Grammar: Evaluate grammar correctness of sentences spoken by user, assuming user is casually speaking these sentences, so ignore minor errors that are not important in casual spoken english.


2. Vocabulary: Evaluate the range and appropriateness of the vocabulary used. Highlight any repetitive language or opportunities for more advanced word choices. Would a native english speaker frame a sentence similary?  Is there scope for using more nuanced vocabulary.


Share a score on 1-5 for each of above parameter and then a composite score from 1 to 5


Overall give the feedback in 20 words only.


Give feedback only if user hint is valid.

 
Previous conversation:
{chat_history}

New human question: {question}`;

const prompt = PromptTemplate.fromTemplate(template);

const userSessions = {};
function getUserSession(session) {
  if (!userSessions[session]) {
    // Initialize a new session for the user with persistent memory
    const memory = new BufferMemory({ memoryKey: "chat_history" });

    userSessions[session] = {
      memory,
      chain: new LLMChain({
        llm,
        prompt,
        verbose: true,
        memory
      })
    };
  }
  return userSessions[session];
}

router.post("/play", async (req, res) => {
  const { question, userId, session } = req.body;

  let userdatalog;
  // const usedTabooWord = tabooWords.find((word) => question.includes(word));
  // if (usedTabooWord) {
  //   return res.json({ message: `You used a taboo word: ${usedTabooWord}` });
  // }
  try {
    const userSession = getUserSession(session);
    const response = await userSession.chain.invoke({ question });
    userdatalog = await UserDataLog.findOne({ userId, sessionId: session });
    if (userdatalog) {
      userdatalog.userResponse = [...userdatalog.userResponse, question];
      userdatalog.aiResponse = [...userdatalog.aiResponse, response.text];
    } else {
      userdatalog = new UserDataLog({
        userResponse: [question],
        aiResponse: [response.text],
        userId,
        sessionId: session
      });
    }
    await userdatalog.save();
    return res.status(200).json({ response: userdatalog });
  } catch (error) {
    res.status(500).json({ error: "Something went wrong" });
  }
});

//jwtHelper.verifyToken,

router.get("/allconversation", async (req, res) => {
  try {
    const { session } = req.query;
    const completeConversation = await UserDataLog.findOne({ sessionId: session });
    return res.status(200).json({ completeConversation });
  } catch (err) {
    throw err;
  }
});

export default router;

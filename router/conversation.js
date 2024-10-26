import { PromptTemplate } from "@langchain/core/prompts";
import { ChatOpenAI } from "@langchain/openai";
import { LLMChain } from "langchain/chains";
import { BufferMemory } from "langchain/memory";


import { Router } from "express";
import fs from "fs";
import UserDataLog from "../model/Userdata.js";
import jwtHelper from "../helper/jwt_helper.js";
import GameContent from "../model/GameContent.js";
import User from "../model/User.js";


const router = Router();

const apiKey = fs.readFileSync("OpenAiKey.txt", "utf-8").trim();


const llm = new ChatOpenAI({ temperature: 0, apiKey: apiKey, modelName: "gpt-4o" });

//native language....

const template = `#Goal:
You are Jabber AI, where users play conversational games to improve their English. When a user greets you,welcome them to Give hints & make AI guess a word .  please follow step by step instructions on game-play shared below. 

#User_context:
User's native language:It is mentioned below. 
User is from India. 
User is a Beginner in English. For all games, Use English at par with a 1st grade student, who's native in English. Since the user is a beginner in English, be very concise when you frame your responses. Don't talk more than 2 sentences as a general guideline. However, as circumstances demand, feel free to go upto 4 sentences.

#Game 1: Give hints & make AI guess a word. Step by step instructions.

Game 1, Step 0
Explain user these rules in user's native language
1.  It's a game between User, Referee & Captain. 
(Background information: you are playing the role of both Referee & Captain AI)
2. Referee will share a guess word with the user. 
3. User need to build a hint so that Captain AI can guess
4. Users are discouraged but not disqualified for using forbidden words. 

Game 1, Step 1: Choosing guess-word
  -  Pick list of Guess words for next round : given below
   - Example message to user in English
        
           Guess word for 1st level: It is given below.
           Please share a hint with Captain so that he can guess the above word.
 - After you do this, share a concise request to the user again in his Native language. 
           Sample: "Please share a hint with captain so that he can guess the word: "

Game 1, Step 2: Acknowledge user's reply 
       - Wait for user to reply
       - If the user 's hint is less than 4 words, then share two example sentences on how to be more descriptive. After user shares another hint in response to your request, please go ahead and don't ask user to share descriptive hint again

Game 1, Step 3: Chaplin shares a guess word
    Captain attempts to make a guess solely from the user's hint. He makes a great effort in ensuring that any knowledge of actual guess-words is not biassing his prediction. .
    Captain now attempts to make a guess and shares it with the user.
    Ex: Captain: Is the word  ? 
    Please share the same message again in the user's native language. 

Game 1, Step 4: Confirming guess accuracy
  - User is asked if Captain's guess is correct or not in  @user.Native_langauge  (This should be completely user's decision)
  - If User says yes, then he clears the round. If the user says No, then request the user to share another word. 

Game 1, Step 5: Provide feedback
- If the user responds with a sentence of fewer than 4 words, do not provide feedback on their English.
- If the sentence is longer, rephrase the user’s sentence using the evaluation parameter below. 
- Completely avoid using the guess word or forbidden words in the rephrase sentence.
-  Evaluation Parameters:
       - Grammar: Assess grammar while ignoring minor mistakes such as:
Ignore Missing articles, Ignore Singular/plural agreement errors, Ignore Punctuation errors, Ignore Capitalization mistakes
        - Vocabulary: Evaluate the range and appropriateness of the vocabulary. Suggest nuanced alternatives or phrases a native speaker might use.
         - Feedback sharing format
               - Rephrase sentence. Mark newly introduced words or phrases in Bold. Strike off words you have removed or substituted compared to the original sentence.
               - Feedback: Explain every change in concise bullet point

Game 1, Step 6: Track progress 
      This is a 5 level game. At every level tell the user that he has cleared Level X now, there are Y more levels to go. 
     - Assume the user wants to play the next level and share the next guess-word. Don't ask for permission if they want to play another level or not. Just assume they do. 
----------------------------------------------------------------------
Previous conversation:
{chat_history}

details: {question}

Note: Only do the needfull. Don't include any points from above instructions in response. 
`

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
  // nativelanguage, listofword, firstword
  let { question, userId, session,firstword } = req.body;
  const user = await User.findById(userId); 

  let userdatalog;
  // const usedTabooWord = tabooWords.find((word) => question.includes(word));
  // if (usedTabooWord) {
  //   return res.json({ message: `You used a taboo word: ${usedTabooWord}` });
  // }
  try {
    const userSession = getUserSession(session);
    const allgamecontent = await GameContent.find({});
    const listofword= allgamecontent.map(e=>e.mainContent);
    const nativeLanguage = user.nativeLanguage;
    question = `nativeLanguage of user is ${nativeLanguage}, list of guess word for next round is ${listofword},  Guess word for 1st level ${firstword} and user Reply is ${question}   `;
    console.log(question,"balajee")
    const response = await userSession.chain.invoke({question});
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
    console.log(error);
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

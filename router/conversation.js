import {Router} from "express";
import UserDataLog from "../model/Userdata.js";
import fs from  'fs';
import { PromptTemplate } from "@langchain/core/prompts";
import { ChatOpenAI } from "@langchain/openai";
import { LLMChain } from "langchain/chains";
import { BufferMemory } from "langchain/memory";
const router = Router();



const apiKey = fs.readFileSync('OpenAiKey.txt', 'utf-8').trim();

const llm = new ChatOpenAI({ temperature: 0,apiKey:apiKey,modelName: "gpt-4o" });



const template = `
Please follow these instructions carefully:

User starts a new game: Initialize guess word and set taboo words.
 
User gives a hint: check the hint very carefully. Process the hint.
warn them only If a hint contains a taboo word.
If the hint is valid then congratulate the user, predict the guess word.
Process the result: Check if the guess matches the original word(from your end). Also write appreciating message to the user dont forget this.

NEXT ROUND:
Ask the user to make you predict the same guess-word. Original Taboo words stay but to make the game more challenging, we add more Taboo words. Extract critical words in user's hints in earlier rounds and add them to the list of Taboo words.

Repeat until the user guesses gives up.

Following is the response format that I expect from you:

User Input:

Guess Word: Elevator
Taboo Word: Floor,building,apartment,skyscraper,high rise
user hint: An electric facility that is used for moving up and down of a high rise building. 

Gpt Response: 
Your hint includes the taboo word “high rise,” so I'll disregard this hint. Can you provide another one without using any taboo words?

User Response: 
Fastest way to reach from basement to top of Mall is by using this.

Gpt Response:
Your hint is clear and doesn't use any taboo words. I guess the word is elevator. Evaluation: You've successfully made me guess the word. Well done!

Round 2:
Now, give me another hint to make me guess the same word, but don’t use any of the key words you used in Round 1 ("electric," "facility," "moving," "up and down," "mall").

Previous conversation:
{chat_history}

New human question: {question}
Response:`;

const prompt = PromptTemplate.fromTemplate(template);

const userSessions = {};
function getUserSession(userId) {
    if (!userSessions[userId]) {
        // Initialize a new session for the user with persistent memory
        const memory = new BufferMemory({ memoryKey: "chat_history" });
        
        userSessions[userId] = {
            memory,
            chain: new LLMChain({
                llm,
                prompt,
                verbose: true,
                memory 
            })
        };
    }
    return userSessions[userId];
}


router.post("/play", async (req, res) => {
  const { question,userId,session } = req.body;
  let userdatalog;
  // const usedTabooWord = tabooWords.find((word) => question.includes(word));
  // if (usedTabooWord) {
  //   return res.json({ message: `You used a taboo word: ${usedTabooWord}` });
  // }
  try {
    const userSession = getUserSession(userId);
    const response = await userSession.chain.invoke({ question });
    userdatalog = await UserDataLog.findOne({userId,session});
     if(userdatalog){
      userdatalog.userResponse = [...userdatalog.userResponse,question]
      userdatalog.aiResponse =[...userdatalog.aiResponse,response.text]
     }
     else {
      userdatalog = new UserDataLog({
      userResponse:[question],
      aiResponse:[response.text],
      userId,
      session
    });
    await userdatalog.save();
  }
    return res.status(200).json({userdatalog});
  } catch (error) {
    console.log(error,"hello okayy");
    res.status(500).json({ error: "Something went wrong" });
  }
});





export default router;

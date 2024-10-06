import fs from  'fs';
import { PromptTemplate } from "@langchain/core/prompts";
import { ChatOpenAI } from "@langchain/openai";
import { LLMChain } from "langchain/chains";
import { BufferMemory } from "langchain/memory";
import express from 'express';
import connectDB from "./config/database/db.js"
import Game from "./router/game.js";

const app = express();
connectDB();

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


Previous conversation:
{chat_history}

New human question: {question}
Response:`;

const prompt = PromptTemplate.fromTemplate(template);

// const response = await conversationChain.call({question:"Guess word is elevator and taboo words are floor,apartment,skyscraper,high rise,building and user hint is an electric facility that used for moving up and down of a building"});

// const response1= await conversationChain.invoke({ question: "" })
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


app.use(express.json());
app.use("/api/game",Game);

app.post("/play", async (req, res) => {
  const { question,userId } = req.body;
  // const usedTabooWord = tabooWords.find((word) => question.includes(word));
  // if (usedTabooWord) {
  //   return res.json({ message: `You used a taboo word: ${usedTabooWord}` });
  // }
  try {
    const userSession = getUserSession(userId);
    const response = await userSession.chain.invoke({ question });
    res.json({ response });
  } catch (error) {
    res.status(500).json({ error: "Something went wrong" });
  }
});

app.listen(3000,()=>console.log("Server started"))
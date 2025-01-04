import { PromptTemplate } from "@langchain/core/prompts";
import { ChatOpenAI } from "@langchain/openai";
import { LLMChain } from "langchain/chains";
import { BufferMemory } from "langchain/memory";

import { Router } from "express";
import fs from "fs";
import UserDataLog from "../model/Userdata.js";
import GameContent from "../model/GameContent.js";
import User from "../model/User.js";
import Prompt from "../model/Template.js";
import jwtHelper from "../helper/jwt_helper.js";
import getSecret from "../helper/secret.js";
import Pronounciation from "../model/PronounciationTemplate.js";
const router = Router();

// const apiKey = fs.readFileSync("OpenAiKey.txt", "utf-8").trim();

const apiKey = await getSecret();

// gpt-4o
const llm = new ChatOpenAI({
  temperature: 0,
  apiKey: apiKey,
  modelName: "gpt-4o-mini",
});

const userSessions = {};
const userSessionsfor ={};

function getUserSessionfor(session, prompt) {
  if (!userSessionsfor[session]) {
      userSessionsfor[session] = {
        chain: new LLMChain({
          llm,
          prompt,
          verbose: true,
        }),
      };
  }

  return userSessionsfor[session];
}


function getUserSession(session, prompt) {
  if (!userSessions[session]) {
      // Initialize a new session for the user with persistent memory
      const memory = new BufferMemory({ memory_key: "chat_history" });
      //
      userSessions[session] = {
        memory,
        chain: new LLMChain({
          llm,
          prompt,
          verbose: true,
          memory,
        }),
      };
    }

  return userSessions[session];
}

router.post("/play", jwtHelper.verifyToken, async (req, res) => {
  // nativelanguage, listofword, firstword
  // let { question, userId, session,firstword } = req.body;

  let { sessionId, mainContent, question, gameId } = req.body;
  const userId = req.userId;
  let history = "";

  const user = await User.findById(userId);

  const promptTemplate = await Prompt.findOne({
    gameId,
    engprolevel: user.engprolevel,
  });

  const promptTemplateContent = promptTemplate.content;

  const template = `User native language is {nativeLanguage} {maincontent} {detailOfContent} User english proficiency is ${user.engprolevel} ${promptTemplateContent} Previous conversation:
{chat_history} current question is {question} `;

  const prompt = new PromptTemplate({
    inputVariables: [
      "question",
      "nativeLanguage",
      "maincontent",
      "detailOfContent",
      "chat_history",
    ],
    template: template,
  });

  let userdatalog = await UserDataLog.findOne({ userId, sessionId: sessionId });
  if (!userdatalog) {
    delete userSessions[sessionId];
  }
  // const usedTabooWord = tabooWords.find((word) => question.includes(word));
  // if (usedTabooWord) {
  //   return res.json({ message: `You used a taboo word: ${usedTabooWord}` });
  // }
  try {
    const userSession = getUserSession(sessionId, prompt);
    const gamecontent = await GameContent.findOne({ mainContent });

    const maincontent = gamecontent.mainContent;
    const detailOfContent = gamecontent.detailOfContent;
    // const detailOfContent = "";

    const nativeLanguage = user.nativeLanguage;

    if(userdatalog && userdatalog?.engprolevel != user.engprolevel){
      userSession.history = "";
      userdatalog.engprolevel = user.engprolevel;
      await userdatalog.save();
    }

    const response = await userSession.chain.invoke({
      question: question,
      maincontent: maincontent,
      detailOfContent: detailOfContent,
      nativeLanguage: nativeLanguage,
      chat_history: userSession.history ?? "",
      human_input: "",
    });

    await userSession.memory.saveContext(
      { input: question },
      { output: response.text }
    );
    history = await userSession.memory.loadMemoryVariables({});
    userSession.history = history.history;
    if (userdatalog) {
      userdatalog.userResponse = [...userdatalog.userResponse, question];
      userdatalog.aiResponse = [...userdatalog.aiResponse, response.text];
    } else {
      userdatalog = new UserDataLog({
        userResponse: [question],
        aiResponse: [response.text],
        userId,
        sessionId: sessionId,
        engprolevel:user.engprolevel
      });
    }
    await userdatalog.save();
    return res.status(200).json({ response: userdatalog });
  } catch (error) {
    res.status(500).json({ error: "Something went wrong" });
  }
});

router.post("/correctsentance", jwtHelper.verifyToken, async (req, res) => {
  try {
    const { sentence, sessionId,previousSentence } = req.body;
    const words = sentence.trim().split(/\s+/);
    if (words.length < 5) {
      return res.status(200).json({ response:{text:sentence} });
    } else {
      const pronounciation = await Pronounciation.find({
      });
      const {content} = pronounciation[0];
     
      const template = `previous sentence was ${previousSentence},Follow the rule:${content} You need to correct the current sentence based on previous sentence and rule. You dont need to suggest anything from your side. You only need to check on given sentence. If you found nothing wrong with sentence just return the original sentence. Following is the current sentence: {sentence}`;
      const prompt = new PromptTemplate({
        inputVariables: ["sentence"],
        template: template,
      });
      const userSession = getUserSessionfor(sessionId, prompt);
      const response = await userSession.chain.invoke({ sentence });
      return res.status(200).json({ response });
    }
  } catch (err) {
    throw err;
  }
});

//jwtHelper.verifyToken,

router.get("/allconversation", async (req, res) => {
  try {
    const { sessionId } = req.query;
    const completeConversation = await UserDataLog.findOne({
      sessionId: sessionId,
    });
    return res.status(200).json({ completeConversation });
  } catch (err) {
    throw err;
  }
});

export default router;
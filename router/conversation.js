import { PromptTemplate } from "@langchain/core/prompts";
import { ChatOpenAI } from "@langchain/openai";
import { LLMChain } from "langchain/chains";
import { BufferMemory } from "langchain/memory";
import { Router } from "express";
import UserLog from "../model/logs.js";
import GameContent from "../model/GameContent.js";
import User from "../model/User.js";
import Prompt from "../model/Template.js";
import jwtHelper from "../helper/jwt_helper.js";
import getSecret from "../helper/secret.js";
import Pronounciation from "../model/PronounciationTemplate.js";
import lastActivity from "../helper/lastactivity.js";

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
const userSessionsfor = {};

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

router.post(
  "/play",
  jwtHelper.verifyToken,
  lastActivity,
  async (req, res, next) => {
    // nativelanguage, listofword, firstword
    // let { question, userId, session,firstword } = req.body;
    let { sessionId, mainContent, question, gameId, modality } = req.body;

    const userId = req.userId;
    let history = "";

    let responseforuser = {};

    const user = await User.findById(userId);

    const promptTemplate = await Prompt.findOne({
      gameId,
      engprolevel: user.engprolevel,
    });

    const promptTemplateContent = promptTemplate.content;

    const template = `User native language is {nativeLanguage}. user is from this ${user.country}. user name is ${user.name}. maincontent is {maincontent}. detailofcontent is {detailOfContent}. User english proficiency is ${user.engprolevel}. ${promptTemplateContent} Previous conversation:
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

    let userdatalog = await UserLog.findOne({ userId, sessionId: sessionId });
    if (!userdatalog) {
      delete userSessions[sessionId];
    }
    // const usedTabooWord = tabooWords.find((word) => question.includes(word));
    // if (usedTabooWord) {
    //   return res.json({ message: `You used a taboo word: ${usedTabooWord}` });
    // }
    try {
      if (userdatalog && userdatalog?.engprolevel != user.engprolevel) {
        // userSession.history = "";
        delete userSessions[sessionId];
        userdatalog.engprolevel = user.engprolevel;
        await userdatalog.save();
      }

      const userSession = getUserSession(sessionId, prompt);

      const gamecontent = await GameContent.findOne({ mainContent });

      const maincontent = gamecontent.mainContent;
      const detailOfContent = gamecontent.detailOfContent;
      // const detailOfContent = "";

      const nativeLanguage = user.nativeLanguage;

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
        userdatalog.userResponse = [
          ...userdatalog.userResponse,
          { text: question },
        ];
        userdatalog.aiResponse = [
          ...userdatalog.aiResponse,
          { text: response.text },
        ];
        userdatalog.count = userdatalog.count + 1;
        const allUsertext = userdatalog.userResponse.map((item) => item.text);
        const allAiText = userdatalog.aiResponse.map((item) => item.text);

        responseforuser.userResponse = [...allUsertext];
        responseforuser.aiResponse = [...allAiText];
        responseforuser.userId = userId;
        responseforuser.sessionId = sessionId;
        responseforuser.engprolevel = user.engprolevel;
        responseforuser.modality = modality;
        responseforuser.count = userdatalog.count;
      } else {
        userdatalog = new UserLog({
          userResponse: [{ text: question, modality }],
          aiResponse: [{ text: response.text }],
          userId,
          sessionId: sessionId,
          engprolevel: user.engprolevel,
          gameId,
        });
        responseforuser.userResponse = [question];
        responseforuser.aiResponse = [response.text];
        responseforuser.userId = userId;
        responseforuser.sessionId = sessionId;
        responseforuser.engprolevel = user.engprolevel;
        responseforuser.modality = modality;
        responseforuser.count = 0;
      }
      await userdatalog.save();
      return res.status(200).json({ response: responseforuser });
    } catch (error) {
      res.status(500).json({ error: "Something went wrong" });
    }
  }
);

router.post(
  "/completetheanswer",
  jwtHelper.verifyToken,
  lastActivity,
  async (req, res, next) => {

    console.log("api called for completetheanswer");
    let { sessionId, mainContent, question, gameId } = req.body;

    const userId = req.userId;

    const user = await User.findById(userId);

    const promptTemplate = await Prompt.findOne({
      gameId,
      engprolevel: user.engprolevel,
    });

    const promptTemplateContent = promptTemplate.content;

    const template = `User native language is {nativeLanguage}. user is from this ${user.country}. user name is ${user.name}. maincontent is {maincontent}. detailofcontent is {detailOfContent}. User english proficiency is ${user.engprolevel}. ${promptTemplateContent}
  user wants to give the answer on the basis of Previous AI response. You can refer previous ai response in {chat_history}. User may find difficulty to give answer. They have written something as answer to previous AI response.  see user written text {question} carefully and complete it so that this would be the answer of last one AI response in order to continue playing the game.  `;

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

    try {
      const userSession = getUserSession(sessionId, prompt);

      const gamecontent = await GameContent.findOne({ mainContent });

      const maincontent = gamecontent.mainContent;
      const detailOfContent = gamecontent.detailOfContent;

      const nativeLanguage = user.nativeLanguage;

      const response = await userSession.chain.invoke({
        question: question,
        maincontent: maincontent,
        detailOfContent: detailOfContent,
        nativeLanguage: nativeLanguage,
        chat_history: userSession.history ?? "",
        human_input: "",
      });

      console.log("response", response.text);
      console.log("userSession.history");
      // await userSession.memory.saveContext(
      //   { input: question },
      //   { output: response.text }
      // );

      return res.status(200).json({ text: response.text });
    } catch (error) {
      res.status(500).json({ error: "Something went wrong" });
    }
  }
);

router.post("/correctsentance", jwtHelper.verifyToken, async (req, res) => {
  try {
    const { sentence, sessionId, previousSentence } = req.body;
    const words = sentence.trim().split(/\s+/);
    if (words.length < 5) {
      return res.status(200).json({ response: { text: sentence } });
    } else {
      const pronounciation = await Pronounciation.find({});
      const { content } = pronounciation[0];

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
    let userCompeleteConversation = {};
    const completeConversation = await UserLog.aggregate([
      {
        $match: {
          sessionId: sessionId, // Match the sessionId
        },
      },
      {
        $addFields: {
          gameIdObjectId: { $toObjectId: "$gameId" }, // Convert gameId (string) to ObjectId
        },
      },
      {
        $lookup: {
          from: "games", // The name of the collection for the Game model
          localField: "gameIdObjectId", // The converted ObjectId field
          foreignField: "_id", // Match with the _id field in the Game collection
          as: "gameDetails", // Output field for the joined documents
        },
      },
      {
        $unwind: {
          path: "$gameDetails", // Unwind the joined array to a single object
          preserveNullAndEmptyArrays: true, // Include documents with no matching Game
        },
      },
    ]).sort({ createdAt: -1 });
    // console.log(completeConversation,"completeConversation");
    userCompeleteConversation.userResponse =
      completeConversation[0].userResponse.map((e) => e.text);
    userCompeleteConversation.aiResponse =
      completeConversation[0].aiResponse.map((e) => e.text);
    userCompeleteConversation.userId = completeConversation[0].userId;
    userCompeleteConversation.sessionId = completeConversation[0].sessionId;
    userCompeleteConversation.engprolevel = completeConversation[0].engprolevel;
    userCompeleteConversation.gameDetails = completeConversation[0].gameDetails;
    userCompeleteConversation.createdAt = completeConversation[0].createdAt;
    // console.log(userCompeleteConversation,"responseforuserresponseforuser");
    return res
      .status(200)
      .json({ completeConversation: userCompeleteConversation });
  } catch (err) {
    throw err;
  }
});

export default router;

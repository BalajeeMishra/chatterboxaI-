import 'express-async-errors';
import express from 'express';
import connectDB from "./config/database/db.js"
import Game from "./router/game.js";
import User from "./router/user.js";
import ConverSation from "./router/conversation.js"
import Admin from "./router/admin.js";
import cors from "cors";
import AI from './model/ai.js';
import Encryption from "./router/encryption.js";

const app = express();
connectDB();

const corsOptions = {
  origin: '*', // Allow all origins, or specify a particular domain
  methods: ['GET', 'POST', 'PUT','PATCH' ,'DELETE', 'OPTIONS'], // Allow specific methods
  allowedHeaders: ['Content-Type', 'Authorization'], // Specify allowed headers
};

app.use(cors(corsOptions));
// app.use(express.json());
app.use(
  express.json({
    // store the raw request body to use it for signature verification
    verify: (req, res, buf, encoding) => {
      req.rawBody = buf?.toString(encoding || "utf8");
    },
  }),
);
app.use("/api/game", Game);
app.use("/api/user", User);
app.use("/api", ConverSation);
app.use("/api/auth", Admin);


app.use("/api/encryption", Encryption);
app.get("/", async (_, res) => res.send("Server is running"));

app.post("/api/ai", async (req, res) => {
  try {
    const {selectedAi}= req.body;
    const ai = await AI.findOne({});
    if (!ai) {
      await new AI({aitouse:selectedAi}).save();
      return res.status(200).json({ ai });
    }
    ai.aitouse = selectedAi;
    await ai.save();
    return res.status(200).json({ ai });
  } catch (error) {
    return res.status(500).json({ message: "Internal server error." });
  }
});

app.get("/api/ai", async (req, res) => {
  try {
    const ai = await AI.findOne({});
    if (!ai) {
      return res.status(404).json({ message: "AI configuration not found." });
    }
    return res.status(200).json({ ai });
  } catch (error) {
    return res.status(500).json({ message: "Internal server error." });
  }
});




app.use(async (err, req, res, next) => {
  if (!err?.status) {
    err.status = 404;
  }
  if (err.name == "MongoServerError") {
    return res.status(err.status).json({ message: "Field already exist." });
  }
  return res.status(err.status).json({ message: err.message });
});

app.listen(3000, () => console.log("Server started"))



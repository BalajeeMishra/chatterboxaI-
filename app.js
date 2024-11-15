import 'express-async-errors';
import express from 'express';
import connectDB from "./config/database/db.js"
import Game from "./router/game.js";
import User from "./router/user.js";
import ConverSation from "./router/conversation.js"
import Admin from "./router/admin.js";
import cors from "cors";

const app = express();
connectDB();

const corsOptions = {
  origin: '*', // Allow all origins, or specify a particular domain
  methods: ['GET', 'POST', 'PUT','PATCH' ,'DELETE', 'OPTIONS'], // Allow specific methods
  allowedHeaders: ['Content-Type', 'Authorization'], // Specify allowed headers
};

app.use(cors(corsOptions));
app.use(express.json());
app.use("/api/game", Game);
app.use("/api/user", User);
app.use("/api", ConverSation);
app.use("/api/auth", Admin);
app.get("/", async (_, res) => res.send("Server is running"));
app.use(async (err, req, res, next) => {
  if (!err?.status) {
    err.status = 404;
  }
  if (err.name == "MongoServerError") {
    return res.status(err.status).json({ message: "Field already exist." });
  }
  return res.status(err.status).json({ message: err.message });
});

app.listen(8000, () => console.log("Server started"))



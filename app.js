import 'express-async-errors';
import express from 'express';
import connectDB from "./config/database/db.js"
import Game from "./router/game.js";
import ConverSation from "./router/conversation.js"

const app = express();
connectDB();
app.use(express.json());
app.use("/api/game",Game);
app.use("/api",ConverSation);
app.get("/",async(_,res)=>res.send("Server is running"));
app.use(async(err, req, res, next) => {
  if(!err?.status){
    err.status = 404;
  }
  if(err.name == "MongoServerError"){
    return res.status(err.status).json({ message: "Field already exist." });
  }
  return res.status(err.status).json({ message: err.message });
});

app.listen(3000,()=>console.log("Server started"))



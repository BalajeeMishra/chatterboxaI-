import mongoose from "mongoose";
const gameContentSchema = new mongoose.Schema({
  gameId: {
    type: mongoose.Schema.ObjectId,
    ref : "Game",
  },
  mainContent: {
    type: String,
    unique: true
  },
  level: {
    type: String,
    enum: ["easy", "medium", "hard"]
  },
  detailOfContent: [String]
});

const GameContent = mongoose.model("GameContent", gameContentSchema);

export default GameContent;

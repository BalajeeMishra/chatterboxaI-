import mongoose from "mongoose";
const templateSchema = new mongoose.Schema({
  gameId: {
    type: mongoose.Schema.ObjectId,
    ref : "Game",
  },
  engprolevel:{
    type:String, 
    enum: ["Beginner","Intermediate","Advanced"],
    unique:true
  },
  content:String
});

const Template = mongoose.model("Template", templateSchema);

export default Template;

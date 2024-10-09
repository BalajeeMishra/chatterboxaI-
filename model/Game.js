import mongoose from "mongoose";
import mongooseSequence from 'mongoose-sequence';
const AutoIncrement = mongooseSequence(mongoose);

const gameSchema = new mongoose.Schema({
  gameName:{
    type:String, 
    required:true,
    unique:true
  },
  gameIcon:{
    type:String
  },
  description:String,
  order:{
    type:Number
  },
  status:{
    type:String, 
    enum:["active","inactive"],
    default:"inactive"
  },
})

gameSchema.plugin(AutoIncrement, { inc_field: 'order' });

const Game = mongoose.model("Game",gameSchema);

export default Game;

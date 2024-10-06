import mongoose from "mongoose";
import mongooseSequence from 'mongoose-sequence';
const AutoIncrement = mongooseSequence(mongoose);

const gameSchema = new mongoose.Schema({
  gameName:{
    type:String, 
    required:true
  },
  gameIcon:{
    type:String
  },
  contentOfGame:[{
    mainContent:String,
      level:{
        type:String,
        enum:["easy","medium","hard"]
      },
      detailOfContent:[String],
}],

  order:{
    type:Number
  },
  status:{
    type:String, 
    enum:["active","inactive"]
  },
})

gameSchema.plugin(AutoIncrement, { inc_field: 'order' });

const Game = mongoose.model("Game",gameSchema);

export default Game;

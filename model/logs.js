import mongoose from "mongoose";

const userDataLogSchema = new mongoose.Schema({
    userId: {
        // type: mongoose.Schema.ObjectId,
        // ref:"User"
        type:String
    },
    userResponse:[{
        text:String,
        modality:{
            type:String,
            enum:["speak","write"]
        },
        createdAt:{ type: Date, default: Date.now }
       }], 
    aiResponse:[
       {
        text:String,
        createdAt:{ type: Date, default: Date.now }
       }
        ],
    sessionId:String,
    engprolevel:String,
    gameId:String,
    count:{
     type:Number, 
     default:0
    },
    createdAt:{ type: Date, default: Date.now }
}
);

// Create the user model
const UserLog = mongoose.model('UserLog', userDataLogSchema);

export default UserLog;


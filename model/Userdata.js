import mongoose from "mongoose";

const userDataLogSchema = new mongoose.Schema({
    userId: {
        // type: mongoose.Schema.ObjectId,
        // ref:"User"
        type:String
    },
    userResponse:[String], 
    aiResponse:[String],
    session:Number
});

// Create the user model
const UserDataLog = mongoose.model('UserDataLog', userDataLogSchema);

export default UserDataLog;


import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    mobileNo:{
        type:String, 
        unique:true,
        required: true
    },
    name: {
        type: String,
        required: true
    },
    age: {
        type: Number,
        required: true
    },
    nativeLanguage: {
        type: String,
        required: true
    },
    OTP: {
        type: String,
        // required: true
    },
    verified: {
        type: Boolean,
        default: false
    },
    role: {
        type: String,
        enum: ['user', 'admin'],
        default: 'user'
    },
    country: {
        type: String,
        required: true
    },
});

// Create the user model
const User = mongoose.model('User', userSchema);

export default User;


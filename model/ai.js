import mongoose from "mongoose";
const aiSchema = new mongoose.Schema({
 aitouse:{
    type: String,
    enum: ["Open AI", "Grok AI"],
    default: "Open AI"
 },
});

const AI = mongoose.model("AI", aiSchema);

export default AI;

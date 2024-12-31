
import mongoose from "mongoose";

const PronounciationSchema = new mongoose.Schema({
  content:String
});

const Pronounciation = mongoose.model("Pronounciation", PronounciationSchema);

export default Pronounciation;

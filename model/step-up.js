import mongoose from "mongoose";

const stepupSchema = new mongoose.Schema({
    full_name:String,
    pickup_address:String,
    },
      {
        timestamps: true
      },
);

const Stepup = mongoose.model('Stepup', stepupSchema);

export default Stepup;


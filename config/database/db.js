import mongoose from "mongoose";
import dotenv from 'dotenv';
dotenv.config();



mongoose.set("strictQuery", true);
const connectDB = async () => {
  try {
    mongoose.connect(process.env.DBURL,{
      autoIndex: true
    });
  } catch (err) {
    await sendMail();
    process.exit(1);
  }
};

mongoose.connection.on("connected", () => {
  console.log("Mongoose connected to db");
});

mongoose.connection.on("error", (err) => {
  console.log(err.message);
});

mongoose.connection.on("disconnected", () => {
  console.log("Mongoose connection is disconnected.");
});
 
process.on("SIGINT", async () => {
  await mongoose.connection.close();
  process.exit(0);
});

export default connectDB;
import { Router } from "express";
import User from "../model/User.js";
import jwtHelper from "../helper/jwt_helper.js";
import UserLog from "../model/logs.js";

const router = Router();

router.post("/register", async (req, res, next) => {
  try {
    const { name, age, nativeLanguage, country, mobileNo, engprolevel } =
      req.body;
    const newUser = new User({
      name,
      age,
      nativeLanguage,
      country,
      mobileNo,
      engprolevel,
    });
    const accessToken = await jwtHelper.signAccessToken(newUser.id);
    await newUser.save();
    return res.status(200).json({ accessToken, newUser });
  } catch (err) {
    if (err.name == "MongoServerError") {
      throw Error("Mobileno already exist.");
    }
    throw err;
  }
});

router.put(
  "/changeproficiency",
  jwtHelper.verifyToken,
  async (req, res, next) => {
    try {
      const userId = req.userId;
      const { nativeLanguage, engprolevel } = req.body;
      const user = await User.findByIdAndUpdate(
        userId,
        { nativeLanguage, engprolevel },
        { new: true }
      );
      return res.status(200).json({ user });
    } catch (err) {
      throw err;
    }
  }
);

router.post("/checkphoneno", async (req, res, next) => {
  try {
    const { mobileNo } = req.body;
    const user = await User.findOne({ mobileNo });
    if (user) {
      const accessToken = await jwtHelper.signAccessToken(user?.id);
      return res.status(200).json({ user, accessToken });
    } else {
      return res.status(404).json({ message: "User doesn't exist" });
    }
  } catch (err) {
    throw err;
  }
});

router.get("/checkstatus/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ message: "Send to splash screen" });
    }
    const playingstatus = user.playingstatus;
    return res.status(200).json({ playingstatus });
  } catch (err) {
    throw err;
  }
});

router.patch("/changestatus/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const { playingstatus } = req.body;
    const updateduser = await User.findByIdAndUpdate(
      id,
      { playingstatus },
      { new: true }
    );
    if (!updateduser) {
      return res.status(500).json({ messagae: "Something went wrong." });
    }
    return res.status(200).json({ updateduser });
  } catch (err) {
    throw err;
  }
});

router.get("/allgameconversation", async (req, res) => {
  try {
    const { userId } = req.query;
    // const completeConversation = await UserLog.find({ userId });

    const completeConversation = await UserLog.aggregate([
      {
        $match: {
          userId: userId, // Match documents based on userId
        },
      },
      {
        $addFields: {
          gameIdObjectId: { $toObjectId: "$gameId" }, // Convert gameId (string) to ObjectId
        },
      },
      {
        $lookup: {
          from: "games", // The name of the collection for the Game model
          localField: "gameIdObjectId", // The converted ObjectId field
          foreignField: "_id", // Match with the _id field in the Game collection
          as: "gameDetails", // Output field for the joined documents
        },
      },
      {
        $unwind: {
          path: "$gameDetails", // Unwind the joined array to a single object
          preserveNullAndEmptyArrays: true, // Include documents without a matching Game
        },
      },
    ]);
    return res.status(200).json({ completeConversation });
  } catch (err) {
    throw err;
  }
});




router.get("/all", async (req, res) => {
  try {
    const {regDate,recentActive} = req.query;
    if(regDate){
      const allUser = await User.find({}).sort({createdAt:-1});
      return res.status(200).json({ allUser });
    }
    if(recentActive){
      const allUser = await User.find({}).sort({lastActive:-1});
      return res.status(200).json({ allUser });
    }
    const allUser = await User.find({});
    return res.status(200).json({ allUser });
  } catch (err) {
    throw err;
  }
});

router.delete("/delete",jwtHelper.verifyToken, async (req, res) => {
  try {
    const userId = req.userId;
    const deletedUser = await User.findByIdAndDelete(userId);
    if (!deletedUser) {
      return res.status(500).json({ messagae: "Something went wrong." });
    }
    return res.status(200).json({ deletedUser });
  } catch (err) {
    throw err;
  }
});

router.get("/currentuser",jwtHelper.verifyToken,async(req,res)=>{
  try{
    
    const userId = req.userId;
  
    const user = await User.findById(userId);
    if(!user){
      return res.status(404).json({message:"User not found"});
    }
    return res.status(200).json({user});
  }
    catch(err){
      throw err;
    }
})

export default router;

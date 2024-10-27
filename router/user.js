import {Router} from "express";
import User from "../model/User.js";
import jwtHelper  from "../helper/jwt_helper.js";
const router = Router();


router.post("/register",async(req,res,next)=>{
  try{
  const {name,age,nativeLanguage,country,mobileNo } = req.body; 
  const newUser = new User({
    name,age,nativeLanguage,country,mobileNo
  });
  const accessToken = await jwtHelper.signAccessToken(newUser.id);
  await newUser.save();
  return res.status(200).json({accessToken,newUser});
}
catch(err){
  if(err.name == "MongoServerError"){
    throw Error("Mobileno already exist."); 
  }
  throw err;
}
})

router.patch("/changestatus/:id",async(req,res,next)=>{
  try{
  const {id} = req.params; 
  const {playingstatus} = req.body;
  const updateduser = await User.findByIdAndUpdate(id, {playingstatus},{new:true}); 
  if(!updateduser){
    return res.status(500).json({messagae:"Something went wrong."})
  }
  return res.status(200).json({updateduser});
}
catch(err){
  throw err;
}
})

export default router;

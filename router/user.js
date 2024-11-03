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

router.post("/checkphoneno",async(req,res,next)=>{
  try{
  const {mobileNo} = req.body; 
  const user = await User.findOne({mobileNo});
  if(user){
    return res.status(200).json({message:"User already exist"}); 
  }
  else{
    return res.status(404).json({message:"User doesn't exist"}); 
  }
}
catch(err){
  throw err;
}
})

router.get("/checkstatus/:id",async(req,res,next)=>{
  try{
  const {id} = req.params; 
  const user = await User.findById(id);
  if(!user){
    return res.status(404).json({message:"Send to splash screen"});
  }
  const playingstatus = user.playingstatus;
  return res.status(200).json({playingstatus}); 
}
catch(err){
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

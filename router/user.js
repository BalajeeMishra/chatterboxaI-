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
  throw err;
}
})


export default router;

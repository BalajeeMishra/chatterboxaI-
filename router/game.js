import {Router} from "express";
import Game from "../model/Game.js";
const router = Router();

router.post("/new-game",async(req,res,next)=>{
  const {gameName,gameIcon,contentOfGame,order,status} = req.body;
  // console.log(gameName,gameIcon,contentOfGame,order,status);
  const game = new Game({
    gameName,
    gameIcon,
    contentOfGame
  });
  await game.save(); 
  return res.status(200).json({message:"Game Created Successfully"})
})

export default router;

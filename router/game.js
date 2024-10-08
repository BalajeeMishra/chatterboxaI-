import {Router} from "express";
import Game from "../model/Game.js";
import GameContent from "../model/GameContent.js";
const router = Router();

router.post("/new-game",async(req,res,next)=>{
  try{
  const {gameName,gameIcon,description,status} = req.body;
  const game = new Game({
    gameName,
    gameIcon,
    description,
    status
  });
  await game.save(); 
  return res.status(200).json({message:"Game Created Successfully"})
  } catch(err){
    return err;
    // return res.status(200).json({message:"Game Created Successfully"})
  }
});


router.get("/allgame",async(req,res,next)=>{
  const allGame = await Game.find({});
  return res.status(200).json({allGame});
})


router.delete("/deletegame/:id",async(req,res,next)=>{
  const id = req.params.id;
  const deletedGame = await Game.findByIdAndDelete(id);
  return res.status(200).json({deletedGame});
})


router.put("/editgame/:id",async(req,res,next)=>{
  const id = req.params.id;
  const {gameName,gameIcon,order,status,description} = req.body;
  const editedGame = await Game.findByIdAndUpdate(id, {gameName,gameIcon,order,status,description},{new:true});
  return res.status(200).json({editedGame});
})

router.patch("/changestatus/:id",async(req,res,next)=>{
  const id = req.params.id;
  const {status} = req.body;
  const editedGame = await Game.findByIdAndUpdate(id, {status},{new:true});
  return res.status(200).json({editedGame});
})

// adding game content in a page..
router.post("/new-game-content/:id",async(req,res,next)=>{
  const {id}= req.params;
  const {level,mainContent,detailOfContent} = req.body;
  const gameContent = new GameContent({
    gameId:id,
    level,
    mainContent,
    detailOfContent
  });
  await gameContent.save();
  return res.status(200).json({gameContent});
}); 

// all gamecontent
router.get("/allgamecontent/:id",async(req,res,next)=>{
  try{
  const {id} = req.params;
  const allGame = await GameContent.find({gameId:id});
  return res.status(200).json({allGame});
  }
  catch(err){
    return err; 
  }
});

// editing game content
router.put("/edit-game-content/:id",async(req,res,next)=>{
  const id = req.params.id;
  const {level,mainContent,detailOfContent} = req.body;
  const editedGameContent = await GameContent.findByIdAndUpdate(id, {level,mainContent,detailOfContent},{new:true});
  return res.status(200).json({editedGameContent});
}); 

// deleting game content
router.delete("/delete-game-content/:id",async(req,res,next)=>{
  const id = req.params.id;
  const {level,mainContent,detailOfContent} = req.body;
  const deletedGameContent = await GameContent.findByIdAndDelete(id);
  return res.status(200).json({deletedGameContent});
}); 


export default router;

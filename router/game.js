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
  console.log("hi gautabbds")
  await game.save(); 
  return res.status(200).json({message:"Game Created Successfully"})
  } catch(err){
    throw err;
  }
});


router.get("/allgame",async(req,res,next)=>{
  try{
  const allGame = await Game.find({status:"active"});
  if(allGame.length == 0){
    return res.status(200).json({message:"No Game Found"})
  }
  return res.status(200).json({allGame});
  }
  catch(err){
    throw err; 
  }
})


router.delete("/deletegame/:id",async(req,res,next)=>{
  const id = req.params.id;
  const deletedGame = await Game.findByIdAndDelete(id);
  if(!deletedGame){
    return res.status(500).json({messagae:"Something went wrong."})
  }
  return res.status(200).json({deletedGame});
})


router.put("/editgame/:id",async(req,res,next)=>{
  try{
  const id = req.params.id;
  const {gameName,gameIcon,order,status,description} = req.body;
  const editedGame = await Game.findByIdAndUpdate(id, {gameName,gameIcon,order,status,description},{new:true});
  if(!editedGame){
    return res.status(500).json({messagae:"Something went wrong."})
  }
  return res.status(200).json({editedGame});
}
catch(err){
  throw err;
}
})

router.patch("/changestatus/:id",async(req,res,next)=>{
  try{
  const id = req.params.id;
  const {status} = req.body;
  const editedGame = await Game.findByIdAndUpdate(id, {status},{new:true});
  if(!editedGame){
    return res.status(500).json({messagae:"Something went wrong."})
  }
  return res.status(200).json({editedGame});
}
catch(err){
  throw err;
}
})

// adding game content in a page..
router.post("/new-game-content/:id",async(req,res,next)=>{
  try{
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
}
catch(err){
  throw err; 
}
}); 

// all gamecontent
router.get("/allgamecontent/:id",async(req,res,next)=>{
  try{
  const {id} = req.params;
  const allGame = await GameContent.find({gameId:id});
  if(allGame.length == 0){
    return res.status(200).json({message:"No Game content Found"})
  }
  return res.status(200).json({allGame});
  }
  catch(err){
    throw err; 
  }
});

// editing game content
router.put("/edit-game-content/:id",async(req,res,next)=>{
  try{
  const id = req.params.id;
  const {level,mainContent,detailOfContent} = req.body;
  const editedGameContent = await GameContent.findByIdAndUpdate(id, {level,mainContent,detailOfContent},{new:true});
  if(!editedGameContent){
    return res.status(500).json({messagae:"Something went wrong."})
  }
  return res.status(200).json({editedGameContent});
  }
  catch(err){
    throw err;
  }
}); 

// deleting game content
router.delete("/delete-game-content/:id",async(req,res,next)=>{
  try{
  const id = req.params.id;
  const deletedGameContent = await GameContent.findByIdAndDelete(id);
  if(!deletedGameContent){
    return res.status(500).json({messagae:"Something went wrong."})
  }
  return res.status(200).json({deletedGameContent});
}
catch(err){
  throw err;
}
}); 


export default router;

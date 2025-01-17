import User from "../model/User.js";

const lastActivity = async (req, res, next) => { 
    try{
    await User.findByIdAndUpdate(req.userId, {lastActive: Date.now()});
    next();
    }
    catch(err){
        return next(err);
    }
}

export default lastActivity;
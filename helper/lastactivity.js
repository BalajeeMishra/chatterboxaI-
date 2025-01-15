import User from "../model/User.js";

const lastActivity = async (req, res, next) => {   
    await User.findByIdAndUpdate(req.userId, {lastactivity: Date.now()});
    next();
}

export default lastActivity;
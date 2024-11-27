import JWT from "jsonwebtoken";
import User from "../model/User.js";

export default {
  signAccessToken: async (userId) => {
    return new Promise((resolve, reject) => {
      const payload = {};
      const secret = process.env.ACCESS_TOKEN_SECRET;
      const options = {
        expiresIn: "24d",
        issuer: "ChatterboxAI",
        audience: userId,
      };
      JWT.sign(payload, secret, options, (err, token) => {
        if (err) {
          // logger.error(
          //   `${err.status} - ${err.message} - inside signAccessToken of jwt helper`,
          // );
          reject(new Error("Something went wrong!", 500));
          return;
        }
        resolve(token);
      });
    });
  },

  verifyToken: async (req, res, next) => {
    if (!req.headers["authorization"])
      return next(new Error("Unauthorized", 401));
    const authHeader = req.headers["authorization"];
    const bearerToken = authHeader.split(" ");
    const token = bearerToken[1];
    JWT.verify(token, process.env.ACCESS_TOKEN_SECRET, async (err, payload) => {
      if (err) {
        // logger.error(
        //   `${err.status} - ${err.message} - ${req.originalUrl} - ${req.method} inside verifyToken of jwt helper`,
        // );
        const message =
          err.name === "JsonWebTokenError" ? "Unauthorized" : err.message;
        return next(
          new Error(
            err.message == "jwt expired" ? "Unauthorized" : message,
            401,
          ),
        );
      }
      req.payload = payload;
      req.userId = payload.aud;
      const user = await User.findById(req.userId);
      next();
    });
  },
};

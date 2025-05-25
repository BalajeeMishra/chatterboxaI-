// config/passport.js
const passport = require("passport");
const GoogleStrategy = require("passport-google-oauth20").Strategy;
const User = require("../model/User"); 

// Google Strategy
passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID, // Set in your .env
      clientSecret: process.env.GOOGLE_CLIENT_SECRET, // Set in your .env
      callbackURL: process.env.GOOGLE_CALLBACK_URL, // Set in your .env
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        // Try to find an existing user by Google ID
        let user = await User.findOne({ email: profile.emails[0].value });
        // If no user exists, create one using the Google profile data
        if (!user) {
          user = new User({
            email: profile.emails[0].value,
            name: profile.displayName,
          });
          await user.save();
        }
        return done(null, user);
      } catch (error) {
        return done(error, null);
      }
    }
  )
);

// Serialize user into session
passport.serializeUser(function (user, done) {
  done(null, user);
});

// Deserialize user from session
passport.deserializeUser(function (user, done) {
  done(null, user);
});

module.exports = passport;

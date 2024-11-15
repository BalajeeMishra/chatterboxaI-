import { Router } from "express";
import Admin from "../model/admin.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const router = Router();

// Utility functions for token generation
const generateAccessToken = (userId) => {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, { expiresIn: process.env.ACCESS_TOKEN_EXPIRES_IN });
};

const generateRefreshToken = (userId) => {
  return jwt.sign({ id: userId }, process.env.JWT_REFRESH_SECRET, { expiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN });
};

// Register Route
router.post("/registeradmin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const existingAdmin = await Admin.findOne({ email });
    if (existingAdmin) return res.status(400).json({ message: 'Admin already exists' });

    const hashedPassword = await bcrypt.hash(password, 10);
    const admin = new Admin({ email, password: hashedPassword });
    await admin.save();

    res.status(201).json({ message: 'Admin registered successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Login Route
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const admin = await Admin.findOne({ email });
    if (!admin) return res.status(400).json({ message: 'Invalid credentials' });

    const isPasswordValid = await bcrypt.compare(password, admin.password);
    if (!isPasswordValid) return res.status(400).json({ message: 'Invalid credentials' });

    const accessToken = generateAccessToken(admin._id);
    const refreshToken = generateRefreshToken(admin._id);

    res.status(200).json({ message: "User logged in successfully", accessToken, refreshToken });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get All Admins Route
router.get("/alladmins", async (req, res) => {
  try {
    const admins = await Admin.find();
    res.status(200).json(admins);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete Admin Route
router.delete("/deleteadmin/:id", async (req, res) => {
  try {
    const { id } = req.params;

    // Check if the admin exists
    const admin = await Admin.findById(id);
    if (!admin) {
      return res.status(404).json({ message: 'Admin not found' });
    }

    // Delete the admin
    await Admin.findByIdAndDelete(id);

    res.status(200).json({ message: 'Admin deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
// Verify Token Route
router.post("/verifytoken", (req, res) => {
    const token = req.body.token;
  
    if (!token) {
      return res.status(401).json({ message: "Token is required" });
    }
  
    // Verify the token using JWT's verify method
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        return res.status(401).json({ message: "Invalid or expired token" });
      }
  
      // If token is valid, send the decoded information
      res.status(200).json({ message: "Token is valid", decoded });
    });
  });

  // Update Admin Email or Password Route
router.put("/updateadmin/:id", async (req, res) => {
    try {
      const { id } = req.params;
      const { email, password } = req.body;
  
      // Find the admin by ID
      const admin = await Admin.findById(id);
      if (!admin) {
        return res.status(404).json({ message: "Admin not found" });
      }
  
      // Update the email if provided and if it's different from the current one
      if (email && email !== admin.email) {
        const existingAdmin = await Admin.findOne({ email });
        if (existingAdmin) {
          return res.status(400).json({ message: "Email is already in use" });
        }
        admin.email = email;
      }
  
      // Update the password if provided
      if (password) {
        const hashedPassword = await bcrypt.hash(password, 10);
        admin.password = hashedPassword;
      }
  
      // Save the updated admin data to the database
      await admin.save();
  
      res.status(200).json({ message: "Admin updated successfully" });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });
  
export default router;

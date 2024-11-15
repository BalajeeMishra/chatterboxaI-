"use client";
import React, { useEffect, useState } from "react";

import toast from "react-hot-toast";
import { Formik, Field, Form, ErrorMessage } from "formik";
import * as Yup from "yup";
import { Icon } from "@iconify/react";

// Validation schema with Yup
const validationSchema = Yup.object({
  email: Yup.string()
    .email("Please enter a valid email.")
    .required("Email is required."),
  password: Yup.string()
    .required("Password is required.")
    .min(6, "Password must be at least 6 characters."),
});

interface LoginFormData {
  email: string;
  password: string;
}

const AdminLoginForm: React.FC = () => {
  // Function to verify token
  const verifyToken = async (token: string) => {
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/verifytoken`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ token }), // Pass accessToken for verification
        }
      );

      const result = await response.json();
      if (response.ok) {
        return result.decoded; // Token is valid
      } else {
        throw new Error(result.message || "Invalid token");
      }
    } catch (error) {
      throw new Error("Token verification failed");
    }
  };

  useEffect(() => {
    const checkTokenValidity = async () => {
      const accessToken = localStorage.getItem("accessToken");

      if (!accessToken) {
        return;
      }

      try {
        // Try verifying the accessToken
        await verifyToken(accessToken);
        window.location.href = "/admin/newgame"; // Redirect to the target page
      } catch (error: any) {
        toast.error("Session expired or invalid token. Please log in again."); // Show error toast
      }
    };

    checkTokenValidity();
  }, []);

  const handleSubmit = async (values: LoginFormData) => {
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/login`, // Ensure it's the login endpoint
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(values), // Send form data for login
        }
      );

      // If the response is not OK, throw an error
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || "Failed to login");
      }

      // Parse the response body for access and refresh tokens
      const result = await response.json();
      console.log("Login successful:", result);

      if (result.message === "User logged in successfully") {
        toast.success(result.message);
      }

      // Save the tokens to localStorage
      localStorage.setItem("accessToken", result.accessToken);
      localStorage.setItem("refreshToken", result.refreshToken);

      // Redirect to the desired page
      window.location.href = "/admin/newgame";
    } catch (error: any) {
      toast.error(error.message);
      console.error("Error:", error);
    }
  };

  return (
    <div className="h-screen bg-gradient-to-r from-violet-500 text-white to-indigo-500 pt-20">
      <div className="max-w-md mx-auto bg-white shadow-lg rounded-2xl p-6 border-2 border-purple-600">
        <div className="w-full flex justify-center">
          <Icon
            width="46"
            className="text-purple-600 "
            icon="eos-icons:admin-outlined"
          />
        </div>
        <h2 className="text-2xl text-purple-600 font-bold mb-6 text-center">
          Admin Login
        </h2>

        <Formik
          initialValues={{
            email: "",
            password: "",
          }}
          validationSchema={validationSchema}
          onSubmit={handleSubmit}
        >
          {({ isSubmitting }) => (
            <Form>
              <div className="mb-4">
                <label
                  htmlFor="email"
                  className="block text-gray-700 font-semibold mb-2"
                >
                  Email Id
                </label>
                <Field
                  type="email"
                  id="email"
                  name="email"
                  placeholder="Enter email"
                  className="w-full p-3 text-gray-800 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-300 transition-all duration-300"
                />
                <ErrorMessage
                  name="email"
                  component="p"
                  className="text-red-500 text-sm mt-1"
                />
              </div>

              <div className="mb-4">
                <label
                  htmlFor="password"
                  className="block text-gray-700 font-semibold mb-2"
                >
                  Password
                </label>
                <Field
                  type="password"
                  id="password"
                  name="password"
                  placeholder="Enter password"
                  className="w-full text-gray-800 p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-300 transition-all duration-300"
                />
                <ErrorMessage
                  name="password"
                  component="p"
                  className="text-red-500 text-sm mt-1"
                />
              </div>

              <button
                type="submit"
                className="w-full bg-gradient-to-r from-violet-600  to-indigo-600 text-white font-semibold p-3 rounded-md hover:bg-[#0a78c7] transition-all duration-300"
                disabled={isSubmitting}
              >
                {isSubmitting ? "Logging in..." : "Login"}
              </button>
            </Form>
          )}
        </Formik>
      </div>
    </div>
  );
};

export default AdminLoginForm;

"use client";
import Image from "next/image";
import React, { useState } from "react";
interface LoginFormData {
  identifier: string; // Can be email or mobile number
  password: string;
}

const AdminLoginForm: React.FC = () => {
  const [formData, setFormData] = useState<LoginFormData>({
    identifier: "",
    password: "",
  });

  const [error, setError] = useState<string>("");

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    // Validate inputs
    if (!formData.identifier || !formData.password) {
      setError("Both fields are required.");
      return;
    }

    if (
      !/^[\d]{10}$/.test(formData.identifier) &&
      !/^[\w-.]+@[\w-]+\.[\w]{2,4}$/.test(formData.identifier)
    ) {
      setError("Please enter a valid email or mobile number.");
      return;
    }

    setError("");

    // Here you can handle form submission logic like making an API call
    console.log("Form submitted", formData);
  };

  return (
    <div className="max-w-md mx-auto bg-white shadow-lg rounded-2xl p-6 mt-20 border-2 border-[#0068B4]">
      <div className="w-full flex justify-center">
        {/* <Image
          width={200}
          height={100}
          src={mainlogosankhala}
          alt="sankhala Logo"
          className="h-[70px] w-[74px]"
        /> */}
      </div>
      <h2 className="text-2xl text-[#0068B4] font-bold mb-6 text-center">
        Admin Login
      </h2>

      <form onSubmit={handleSubmit}>
        <div className="mb-4">
          <label
            htmlFor="identifier"
            className="block text-gray-700 font-semibold mb-2"
          >
            Email or Mobile Number
          </label>
          <input
            type="text"
            id="identifier"
            name="identifier"
            value={formData.identifier}
            onChange={handleInputChange}
            placeholder="Enter email or mobile number"
            className="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-300 transition-all duration-300"
          />
        </div>

        <div className="mb-4">
          <label
            htmlFor="password"
            className="block text-gray-700 font-semibold mb-2"
          >
            Password
          </label>
          <input
            type="password"
            id="password"
            name="password"
            value={formData.password}
            onChange={handleInputChange}
            placeholder="Enter password"
            className="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-300 transition-all duration-300"
          />
        </div>

        {error && <p className="text-red-500 mb-4">{error}</p>}

        <button
          type="submit"
          className="w-full bg-[#0068B4] text-white font-semibold p-3 rounded-md hover:bg-[#0a78c7] transition-all duration-300"
        >
          Login
        </button>
      </form>
    </div>
  );
};

export default AdminLoginForm;

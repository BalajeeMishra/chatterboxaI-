"use client";

import React, { useEffect, useState } from "react";
import { fetchAllGames, Game } from "./gamesApi";
import axios from "axios";
import toast from "react-hot-toast";
interface AddgameFormProps {
  editgameName: string;
  setEditGameName: React.Dispatch<React.SetStateAction<string>>;
  editgameIcon: string;
  setEditGameIcon: React.Dispatch<React.SetStateAction<string>>;
  editstatus: "active" | "inactive";
  setEditStatus: React.Dispatch<React.SetStateAction<"active" | "inactive">>;
  editdescription: string;
  setEditDescription: React.Dispatch<React.SetStateAction<string>>;
  setData: React.Dispatch<React.SetStateAction<Game[]>>;
  editorder: any;
  setEditorder: any;
  editId: string;
  setEditId: any;
}
const AddgameForm: React.FC<AddgameFormProps> = ({
  setData,
  editgameName,
  editgameIcon,
  editstatus,
  editId,
  setEditId,
  setEditGameName,
  setEditGameIcon,
  setEditStatus,
  editdescription,
  setEditDescription,
  editorder,
  setEditorder,
}) => {
  const [gameName, setGameName] = useState<string>(editgameName || "");
  const [gameIcon, setGameIcon] = useState<string>(editgameIcon || "");
  const [status, setStatus] = useState<"active" | "inactive">(
    editstatus || "active"
  );
  const [description, setDescription] = useState<string>(editdescription || "");
  const [errors, setErrors] = useState<{ [key: string]: string }>({});

  useEffect(() => {
    setGameName(editgameName);
    setGameIcon(editgameIcon);
    setStatus(editstatus);
    setDescription(editdescription);
  }, [editgameName, editgameName, editstatus]);
  useEffect(() => {
    const loadGames = async () => {
      try {
        const NewgamesContent = await fetchAllGames();
        console.log(NewgamesContent);
        setData(NewgamesContent);
      } catch (err) {
        console.log(err);
      }
    };

    loadGames();
  }, [editgameName, editgameIcon, editstatus]);
  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    // Reset errors
    setErrors({});

    // Validation
    const newErrors: { [key: string]: string } = {};
    if (!gameName) newErrors.gameName = "Game name is required.";
    if (!gameIcon) newErrors.gameIcon = "Game icon URL is required.";
    if (!/^https?:\/\//.test(gameIcon))
      newErrors.gameIcon = "Must be a valid URL.";
    if (!description) newErrors.description = "Description is required.";

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    const url =
      editgameName && editgameIcon && editdescription && editstatus && editId
        ? `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/editgame/${editId}`
        : `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/new-game`;

    try {
      // Use PUT for editing and POST for creating a new game
      const method = editId ? "PUT" : "POST";

      const response = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          gameName,
          gameIcon,
          status,
          description,
          ...(editId ? { order: editorder } : {}),
        }),
      });

      if (!response.ok) {
        throw new Error(`Error: ${response.status} ${response.statusText}`);
      }

      const data = await response.json();
      console.log("Game added successfully:", data);
      toast.success("Game added successfully");

      // Fetch updated game list
      const NewgamesContent = await fetchAllGames();
      console.log(NewgamesContent);
      setData(NewgamesContent);

      // Reset form fields
      setGameName("");
      setGameIcon("");
      setDescription("");
      setStatus("active");
      setEditId("");
    } catch (error) {
      console.error("Error adding game:", error);
      toast.error("Failed to add game. Please try again.");
    }
  };

  return (
    <div className="max-w-5xl  p-4 bg-white shadow-md rounded-lg">
      <h1 className="text-2xl font-bold mb-4">Add New Game</h1>
      <form onSubmit={handleSubmit}>
        {/* Game Name */}
        <div className="grid grid-cols-3 gap-3">
          <div className="mb-4">
            <label
              htmlFor="gameName"
              className="block text-sm font-medium text-gray-700"
            >
              Game Name
            </label>
            <input
              type="text"
              id="gameName"
              value={gameName}
              onChange={(e) => setGameName(e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            />
            {errors.gameName && (
              <div className="text-red-600 text-sm">{errors.gameName}</div>
            )}
          </div>

          {/* Game Icon URL */}
          <div className="mb-4">
            <label
              htmlFor="gameIcon"
              className="block text-sm font-medium text-gray-700"
            >
              Game Icon URL
            </label>
            <input
              type="text"
              id="gameIcon"
              value={gameIcon}
              onChange={(e) => setGameIcon(e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            />
            {errors.gameIcon && (
              <div className="text-red-600 text-sm">{errors.gameIcon}</div>
            )}
          </div>
          {/* Status */}
          <div className="mb-4">
            <label
              htmlFor="status"
              className="block text-sm font-medium text-gray-700"
            >
              Status
            </label>
            <select
              id="status"
              value={status}
              onChange={(e) =>
                setStatus(e.target.value as "active" | "inactive")
              }
              className="mt-1 block  w-full p-[10px] border border-gray-300 rounded-md"
            >
              <option value="active">Active</option>
              <option value="inactive">Inactive</option>
            </select>
          </div>
        </div>

        <div className="flex  gap-3">
          {editId && (
            <div className="mb-4 flex-1">
              <label
                htmlFor="editorder"
                className="block text-sm font-medium text-gray-700"
              >
                Order
              </label>
              <input
                type="text"
                id="editorder"
                value={editorder}
                onChange={(e) => setEditorder(e.target.value)}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
              />
            </div>
          )}
          {/* Description */}
          <div className="mb-4 flex-1">
            <label
              htmlFor="description"
              className="block text-sm font-medium text-gray-700"
            >
              Description
            </label>
            <textarea
              id="description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            />
            {errors.description && (
              <div className="text-red-600 text-sm">{errors.description}</div>
            )}
          </div>
        </div>
        {/* Submit Button */}
        <button
          type="submit"
          className="w-full py-2 px-4 bg-gradient-to-r from-violet-600 to-indigo-600 text-white font-semibold rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
        >
          Add Game
        </button>
      </form>
    </div>
  );
};

export default AddgameForm;

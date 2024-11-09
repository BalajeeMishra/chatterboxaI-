"use client";
// src/app/admin/newgame/NewGameContentForm.tsx
import React, { useEffect, useState } from "react";
import { Game } from "./gamecontent";
import { fetchGameContent } from "./gamecontentApi";
import { fetchAllGames } from "../newgame/gamesApi";
import axios from "axios";
import toast from "react-hot-toast";
interface NewGameContentFormProps {
  editgameId: string;
  setEditgameId: any;
  editmainContent: string;
  editlevel: "easy" | "medium" | "hard";
  editdetailOfContent: string[];
  seteditMainContent: React.Dispatch<React.SetStateAction<string>>;
  seteditLevel: React.Dispatch<
    React.SetStateAction<"easy" | "medium" | "hard">
  >;
  seteditDetailOfContent: React.Dispatch<React.SetStateAction<string[]>>;
  data: Game[]; // Receive data array from parent
  setData: React.Dispatch<React.SetStateAction<Game[]>>;
}
export interface Games {
  _id: string;
  gameName: string;
  gameIcon: string;
  description: string;
  status: string;
  order: number;
  __v: number;
}
const NewGameContentForm: React.FC<NewGameContentFormProps> = ({
  setData,
  editmainContent,
  editlevel,
  editdetailOfContent,
  editgameId,
  setEditgameId,
  seteditMainContent,
  seteditLevel,
  seteditDetailOfContent,
}) => {
  const [mainContent, setMainContent] = useState<string>(editmainContent || "");
  const [level, setLevel] = useState<"easy" | "medium" | "hard">(
    editlevel || "medium"
  );
  const [newgameId, setNewgameId] = useState<string>("");
  const [selectgameId, setSelectgameId] = useState<string>("");
  const [newDetail, setNewDetail] = useState<string>("");
  const [detailOfContent, setDetailOfContent] = useState<string[]>(
    editdetailOfContent || []
  );
  const [newgameData, setNewgameData] = useState<Games[]>([]);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  console.log(editgameId, selectgameId);
  useEffect(() => {
    setMainContent(editmainContent);
    setLevel(editlevel);
    setDetailOfContent(editdetailOfContent);
    setSelectgameId(editgameId);
  }, [editmainContent, editlevel, editdetailOfContent, editgameId]);
  useEffect(() => {
    const loadGames = async () => {
      try {
        const gamesData = await fetchAllGames();
        setNewgameData(gamesData);

        // If editgameId is empty, wait for user to select game
      } catch (err) {
        console.error(err);
      }
    };
    loadGames();
  }, []);

  useEffect(() => {
    const loadGameContent = async () => {
      try {
        const gamesContent = await fetchGameContent(selectgameId || "");
        setData(gamesContent);
      } catch (err) {
        console.error(err);
      }
    };

    if (selectgameId) loadGameContent();
  }, [selectgameId, setData]);
  const handleAddDetail = () => {
    if (newDetail && !detailOfContent.includes(newDetail)) {
      setDetailOfContent((prev) => [...prev, newDetail]);
      setNewDetail("");
    }
  };

  const handleRemoveDetail = (detail: string) => {
    setDetailOfContent((prev) => prev.filter((item) => item !== detail));
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    // Reset errors
    setErrors({});

    // Validation
    const newErrors: { [key: string]: string } = {};
    if (!mainContent) newErrors.mainContent = "Main content is required.";
    if (!level) newErrors.level = "Level is required.";
    if (detailOfContent.length === 0)
      newErrors.detailOfContent = "At least one detail is required.";

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    let url = "";
    let method = "POST"; // Default method for adding new content

    if (editgameId) {
      // If we are editing existing content, use PUT method
      url = `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/edit-game-content/${editgameId}`;
      method = "PUT"; // Change method to PUT for editing
    } else if (newgameId) {
      // If we are adding new game content, use POST method
      url = `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/new-game-content/${newgameId}`;
    } else {
      toast.error("Fill all details.");
      return;
    }

    try {
      const response = await axios({
        url,
        method, // Use PUT for edit and POST for new
        headers: {
          "Content-Type": "application/json",
        },
        data: {
          mainContent,
          level,
          detailOfContent,
        },
      });

      console.log(response);
      const data = response.data;
      console.log("Game content saved successfully:", data);
      toast.success("Game content saved successfully");

      // Reset form fields
      setMainContent("");
      setLevel("medium");
      setDetailOfContent([]);
      seteditMainContent("");
      seteditLevel("medium");
      seteditDetailOfContent([]);
      setEditgameId("");
    } catch (error) {
      console.error("Error saving game content:", error);
      toast.error("Failed to save game content. Please try again.");
    }
  };

  console.log(newgameData);
  return (
    <div className="max-w-5xl p-4 bg-white shadow-md rounded-lg">
      <h1 className="text-2xl font-bold mb-4">Add New Game Content</h1>
      <form onSubmit={handleSubmit}>
        {/* Main Content */}
        <div className="grid grid-cols-2 gap-4">
          <div className="mb-4">
            <label
              htmlFor="mainContent"
              className="block text-sm font-medium text-gray-700"
            >
              Main Content
            </label>
            <input
              type="text"
              id="mainContent"
              value={mainContent}
              onChange={(e) => setMainContent(e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            />
            {errors.mainContent && (
              <div className="text-red-600 text-sm">{errors.mainContent}</div>
            )}
          </div>

          {/* Level */}
          <div className="mb-4">
            <label
              htmlFor="level"
              className="block text-sm font-medium text-gray-700"
            >
              Level
            </label>
            <select
              id="level"
              value={level}
              onChange={(e) =>
                setLevel(e.target.value as "easy" | "medium" | "hard")
              }
              className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            >
              <option value="easy">Easy</option>
              <option value="medium">Medium</option>
              <option value="hard">Hard</option>
            </select>
          </div>
        </div>
        <div className="grid grid-cols-2 gap-4 ">
          {/* Detail of Content */}
          <div className="mb-4">
            <label
              htmlFor="detailOfContent"
              className="block text-sm font-medium text-gray-700"
            >
              Detail of Content
            </label>
            <div className="flex items-center">
              <input
                type="text"
                value={newDetail}
                onChange={(e) => setNewDetail(e.target.value)}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
                placeholder="Add a detail"
              />
              <button
                type="button"
                onClick={handleAddDetail}
                className="ml-2 py-2 px-4 bg-gradient-to-r from-violet-600 to-indigo-600 text-white rounded-md hover:bg-blue-700"
              >
                Add
              </button>
            </div>
            {errors.detailOfContent && (
              <div className="text-red-600 text-sm">
                {errors.detailOfContent}
              </div>
            )}

            {/* Displaying added details */}
            <div className="mt-2 max-h-40 px-4 overflow-scroll">
              {detailOfContent.map((detail) => (
                <div
                  key={detail}
                  className="flex items-center justify-between mb-1"
                >
                  <span className="text-gray-700">{detail}</span>
                  <button
                    type="button"
                    onClick={() => handleRemoveDetail(detail)}
                    className="text-red-600 hover:underline"
                  >
                    Remove
                  </button>
                </div>
              ))}
            </div>
          </div>
          {!editgameId ? (
            <div className="mb-4">
              <label
                htmlFor="level"
                className="block text-sm font-medium text-gray-700"
              >
                Game Name
              </label>
              {newgameData.length > 0 ? (
                <select
                  id="selectgameId"
                  value={newgameId}
                  onChange={(e) => setNewgameId(e.target.value)}
                  className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
                >
                  <option value="">select game</option>
                  {newgameData.map((game) => (
                    <option key={game._id} value={game._id}>
                      {game.gameName}
                    </option>
                  ))}
                </select>
              ) : (
                <p>No games available</p>
              )}
            </div>
          ) : (
            ""
          )}
        </div>
        {/* Submit Button */}
        <div className="flex justify-end items-end">
          <button
            type="submit"
            className=" w-60 py-2 px-4 h-10 bg-gradient-to-r from-violet-600 to-indigo-600 text-white font-semibold rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
          >
            Add Game Content
          </button>
        </div>
      </form>
    </div>
  );
};

export default NewGameContentForm;

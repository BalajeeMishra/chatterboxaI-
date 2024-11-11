"use client";

import React, { useEffect, useState } from "react";
import { fetchAllGames, Game } from "../newgame/gamesApi";
import Editor from "react-simple-wysiwyg";
import { Games } from "../game-content/addgamecontent";
import toast from "react-hot-toast";

interface AddTemplateFormProps {
  setData: React.Dispatch<React.SetStateAction<Game[]>>;
  editId?: any;
  edittemplate?: any;
  editEnglishProficiency?: any;
  setEditId?: any;
  setEditTemplate?: any;
}

const AddTemplate: React.FC<AddTemplateFormProps> = ({
  setData,
  editId,

  edittemplate,
  editEnglishProficiency,
 
}) => {
  const [template, setTemplate] = useState<string>(edittemplate || "");
  const [englishProficiency, setEnglishProficiency] = useState<string>(
    editEnglishProficiency || ""
  );
  const [game, setGame] = useState<string>("");
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [newgameData, setNewgameData] = useState<Games[]>([]);
  useEffect(() => {
    setTemplate(edittemplate || "");
    setEnglishProficiency(editEnglishProficiency || "");
  }, [editId, edittemplate, editEnglishProficiency]);
  useEffect(() => {
    const loadGames = async () => {
      try {
        const newGamesContent = await fetchAllGames();
        setNewgameData(newGamesContent);
      } catch (err) {
        console.error("Error loading games:", err);
      }
    };
    loadGames();
  }, [setData]);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    // Reset errors
    setErrors({});

    // Validation
    const newErrors: { [key: string]: string } = {};
    if (!template) newErrors.template = "Template is required.";

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }
    console.log(englishProficiency, template, editId);
    const url = editId
      ? `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/game-template/${editId}`
      : `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/game-template/${game}`;
    try {
      const response = await fetch(url, {
        method: editId ? "PUT" : "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          engprolevel: englishProficiency,
          content: template,
        }),
      });

      if (!response.ok) {
        throw new Error(`Error: ${response.status} ${response.statusText}`);
      }

      const data = await response.json();
      toast.success("Template added successfully");

      // Fetch updated game list
      const updatedGamesContent = await fetchAllGames();
      setNewgameData(updatedGamesContent);

      // Reset form fields
      setTemplate("");
      setEnglishProficiency("");
      setGame("");
    } catch (error) {
      console.error("Error adding template:", error);
      toast.error("Failed to add template. Please try again.");
    }
  };

  return (
    <div className="max-w-5xl p-4 bg-white shadow-md rounded-lg">
      <h1 className="text-2xl font-bold mb-4">Add Template</h1>
      <form onSubmit={handleSubmit}>
        {/* Template with WYSIWYG Editor */}
        <div className="mb-4">
          <label
            htmlFor="template"
            className="block text-sm font-medium text-gray-700"
          >
            Prompt Template
          </label>
          <Editor
            value={template}
            onChange={(e) => setTemplate(e.target.value)}
            className="border border-gray-300 rounded-md"
            containerProps={{ style: { height: '200px' } }}
          />
          {errors.template && (
            <div className="text-red-600 text-sm">{errors.template}</div>
          )}
        </div>

        {/* English Proficiency */}
        <div className="mb-4">
          <label
            htmlFor="englishProficiency"
            className="block text-sm font-medium text-gray-700"
          >
            English Proficiency
          </label>
          <select
            id="englishProficiency"
            value={englishProficiency}
            onChange={(e) => setEnglishProficiency(e.target.value)}
            className="mt-1 block w-full p-[10px] border border-gray-300 rounded-md"
          >
            {" "}
            <option value="">Select Proficiency</option>
            <option value="Beginner">Beginner</option>
            <option value="Intermediate">Intermediate</option>
            <option value="Advanced">Advanced</option>
          </select>
        </div>

        {/* Game */}
        {!editId ? (
          <div className="mb-4">
            <label
              htmlFor="game"
              className="block text-sm font-medium text-gray-700"
            >
              Game
            </label>
            {newgameData.length > 0 ? (
              <select
                id="game"
                value={game}
                onChange={(e) => setGame(e.target.value)}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
              >
                <option value="">Select game</option>
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
        {/* Submit Button */}
        <button
          type="submit"
          className="w-full py-2 px-4 bg-gradient-to-r from-violet-600 to-indigo-600 text-white font-semibold rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
        >
          Add Prompt Template
        </button>
      </form>
    </div>
  );
};

export default AddTemplate;

"use client";

import { useState, useEffect } from "react";
import PageHeadDesc from "@/components/ui/PageHeadDesc";
import Editor from "react-simple-wysiwyg";

export default function Newgame() {
  const [content, setContent] = useState(""); // Content for editing
  const [contentId, setContentId] = useState<string | null>(null); // ID of the existing content
  const [errors, setErrors] = useState<{ content?: string }>({});
  const [loading, setLoading] = useState(false); // Loading state for API calls

  // Fetch the existing content on component mount
  useEffect(() => {
    fetchContent();
  }, []);

  // Fetch content data from API
  const fetchContent = async () => {
    try {
      setLoading(true);
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/pronounciationtemplate`
      );

      if (!response.ok) {
        // No content exists
        setContent("");
        setContentId(null);
        return;
      }

      const data = await response.json();
      console.log(data.pronounciation);
      setContent(data.pronounciation[0].content || "");
      setContentId(data.pronounciation[0]._id || null);
    } catch (error) {
      console.error("Failed to fetch content:", error);
    } finally {
      setLoading(false);
    }
  };

  // Handle form submission
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrors({}); // Clear existing errors

    if (!content.trim()) {
      setErrors({ content: "Content cannot be empty." });
      return;
    }

    try {
      setLoading(true);

      const url = contentId
        ? `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/pronounciationtemplate/${contentId}`
        : `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/pronounciationtemplate`;

      const method = contentId ? "PUT" : "POST";

      const response = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ content }),
      });

      if (!response.ok) {
        throw new Error("Failed to save content.");
      }

      alert(
        contentId
          ? "Content updated successfully!"
          : "Content added successfully!"
      );
      fetchContent(); // Refresh content
    } catch (error) {
      console.error("Failed to save content:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <PageHeadDesc
        title={contentId ? "Edit Content" : "Add Content"}
        desc={
          contentId
            ? "Update the details of the content."
            : "Add new content to the database."
        }
      />
      <div className="mx-6">
        <div className="max-w-5xl p-4 bg-white shadow-md rounded-lg">
          <h1 className="text-2xl font-bold mb-4">
            {contentId ? "Edit Content" : "Add Content"}
          </h1>
          <form onSubmit={handleSubmit}>
            {/* Content with WYSIWYG Editor */}
            <div className="mb-4">
              <Editor
                value={content}
                onChange={(e: any) => setContent(e.target.value)}
                style={{ height: "200px", overflowY: "auto" }}
                className="border border-gray-300 rounded-md"
              />
              {errors.content && (
                <div className="text-red-600 text-sm">{errors.content}</div>
              )}
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              className={`w-full py-2 px-4 ${
                loading
                  ? "bg-gray-400"
                  : "bg-gradient-to-r from-violet-600 to-indigo-600"
              } text-white font-semibold rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50`}
              disabled={loading}
            >
              {loading
                ? "Saving..."
                : contentId
                ? "Update Content"
                : "Add Content"}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}

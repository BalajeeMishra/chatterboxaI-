"use client";

import { useState, useEffect } from "react";
import PageHeadDesc from "@/components/ui/PageHeadDesc";
import Editor from "react-simple-wysiwyg";

export default function Newgame() {
  const [template, setTemplate] = useState(""); // Template content
  const [errors, setErrors] = useState<{ template?: string }>({});
  const [loading, setLoading] = useState(false); // Loading state for API calls

  // Fetch the existing template on component mount
  useEffect(() => {
    fetchTemplate();
  }, []);

  // Fetch template data from API
  const fetchTemplate = async () => {
    try {
      setLoading(true);
      const response = await fetch("http://localhost:8000/templates/single"); // Adjust endpoint as needed
      const data = await response.json();
      setTemplate(data.template || ""); // Default to an empty template if not provided
    } catch (error) {
      console.error("Failed to fetch template:", error);
    } finally {
      setLoading(false);
    }
  };

  // Handle form submission
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrors({}); // Clear existing errors

    if (!template.trim()) {
      setErrors({ template: "Template cannot be empty." });
      return;
    }

    try {
      setLoading(true);

      const response = await fetch("http://localhost:8000/templates/single", {
        method: "PUT", // Always updating the single template
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ template }),
      });

      if (!response.ok) {
        throw new Error("Failed to save template.");
      }

      alert("Template saved successfully!");
    } catch (error) {
      console.error("Failed to save template:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <PageHeadDesc
        title="Edit Pronunciation Template"
        desc="Update the details of the pronunciation template."
      />
      <div className="mx-6">
        <div className="max-w-5xl p-4 bg-white shadow-md rounded-lg">
          <h1 className="text-2xl font-bold mb-4">Edit Template</h1>
          <form onSubmit={handleSubmit}>
            {/* Template with WYSIWYG Editor */}
            <div className="mb-4">
              <Editor
                value={template}
                onChange={(e: any) => setTemplate(e.target.value)}
                style={{ height: "200px", overflowY: "auto" }}
                className="border border-gray-300 rounded-md"
              />
              {errors.template && (
                <div className="text-red-600 text-sm">{errors.template}</div>
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
              {loading ? "Saving..." : "Save Template"}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}

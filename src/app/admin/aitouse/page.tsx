"use client";
import { useState, useEffect } from "react";
import PageHeadDesc from "@/components/ui/PageHeadDesc";

export default function Newgame() {
  const [selectedAi, setSelectedAi] = useState("");
  const [currentAi, setCurrentAi] = useState("");
  const [loading, setLoading] = useState(false);
  const [fetchingCurrent, setFetchingCurrent] = useState(true);
  const [message, setMessage] = useState("");
  const [messageType, setMessageType] = useState(""); // 'success' or 'error'
  const url = process.env.NEXT_PUBLIC_API_BASE_URL;
  const aiOptions = [
    {
      value: "Open AI",
      label: "Open AI",
      description: "GPT-4 powered responses",
    },
    { value:"Grok AI", label: "Grok AI", description: "X's AI assistant" },
  ];

  // GET API - Fetch current AI selection
  const fetchCurrentAi = async () => {
    try {
      setFetchingCurrent(true);
      const response = await fetch(`${url}/api/ai`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (!response.ok) {
        throw new Error("Failed to fetch current AI selection");
      }

      const data = await response.json();
      console.log(data);
      setCurrentAi(data?.ai?.aitouse || "");
      setSelectedAi(data?.ai?.aitouse || "");
    } catch (error) {
      console.error("Error fetching current AI:", error);
      setMessage("Failed to load current AI selection");
      setMessageType("error");
    } finally {
      setFetchingCurrent(false);
    }
  };

  // POST API - Submit AI selection
  const handleSubmit = async (e: any) => {
    e.preventDefault();

    if (!selectedAi) {
      setMessage("Please select an AI option");
      setMessageType("error");
      return;
    }

    try {
      setLoading(true);
      setMessage("");

      const response = fetch(`${url}/api/ai`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          selectedAi: selectedAi,
        }),
      });

   
      setCurrentAi(selectedAi);
      setMessage("AI selection updated successfully!");
      setMessageType("success");

      // Clear message after 3 seconds
      setTimeout(() => {
        setMessage("");
        setMessageType("");
      }, 3000);
    } catch (error) {
      console.error("Error updating AI selection:", error);
      setMessage("Failed to update AI selection. Please try again.");
      setMessageType("error");
    } finally {
      setLoading(false);
    }
  };

  // Load current AI selection on component mount
  useEffect(() => {
    fetchCurrentAi();
  }, []);

  const getCurrentAiLabel = () => {
    console.log(aiOptions, currentAi);
    const currentOption = aiOptions.find(
      (option: any) => option.label === currentAi
    );
    return currentOption ? currentOption.label : "Not set";
  };

  return (
    <div>
      <PageHeadDesc title="AI To Use" desc="Update the details of AI To Use" />

      <div className="mx-6 max-w-2xl">
        {/* Current AI Status */}
        <div className="bg-gray-50 border border-gray-200 rounded-lg p-6 mb-8">
          <h3 className="text-lg font-semibold text-gray-800 mb-2">
            Current AI Selection
          </h3>
          {fetchingCurrent ? (
            <div className="flex items-center space-x-2">
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-blue-600"></div>
              <span className="text-gray-600">Loading...</span>
            </div>
          ) : (
            <div className="flex items-center space-x-3">
              <div
                className={`w-3 h-3 rounded-full ${
                  currentAi ? "bg-green-500" : "bg-gray-400"
                }`}
              ></div>
              <span className="text-gray-700 font-medium">
                {getCurrentAiLabel()}
              </span>
            </div>
          )}
        </div>

        {/* AI Selection Form */}
        <div className="bg-white border border-gray-200 rounded-lg p-6 shadow-sm">
          <h2 className="text-xl font-semibold text-gray-800 mb-6">
            Select AI Provider
          </h2>

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* AI Selection */}
            <div>
              <label
                htmlFor="ai-select"
                className="block text-sm font-medium text-gray-700 mb-3"
              >
                Choose AI Provider
              </label>
              <div className="space-y-3">
                {aiOptions.map((option) => (
                  <div
                    key={option.value}
                    className={`relative border rounded-lg p-4 cursor-pointer transition-all duration-200 ${
                      selectedAi === option.value
                        ? "border-blue-500 bg-blue-50 ring-1 ring-blue-500"
                        : "border-gray-200 hover:border-gray-300 hover:bg-gray-50"
                    }`}
                    onClick={() => setSelectedAi(option.value)}
                  >
                    <div className="flex items-start space-x-3">
                      <input
                        type="radio"
                        id={option.value}
                        name="ai-selection"
                        value={option.value}
                        checked={selectedAi === option.value}
                        onChange={(e) => setSelectedAi(e.target.value)}
                        className="mt-1 text-blue-600 focus:ring-blue-500"
                      />
                      <div className="flex-1">
                        <label
                          htmlFor={option.value}
                          className="block text-sm font-medium text-gray-900 cursor-pointer"
                        >
                          {option.label}
                        </label>
                        <p className="text-sm text-gray-500 mt-1">
                          {option.description}
                        </p>
                      </div>
                      {currentAi === option.value && (
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                          Current
                        </span>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Message Display */}
            {message && (
              <div
                className={`p-4 rounded-md ${
                  messageType === "success"
                    ? "bg-green-50 border border-green-200 text-green-800"
                    : "bg-red-50 border border-red-200 text-red-800"
                }`}
              >
                <div className="flex items-center space-x-2">
                  {messageType === "success" ? (
                    <svg
                      className="w-5 h-5"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                        clipRule="evenodd"
                      />
                    </svg>
                  ) : (
                    <svg
                      className="w-5 h-5"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
                        clipRule="evenodd"
                      />
                    </svg>
                  )}
                  <span className="text-sm font-medium">{message}</span>
                </div>
              </div>
            )}

            {/* Submit Button */}
            <div className="flex items-center justify-between pt-4">
              <button
                type="button"
                onClick={fetchCurrentAi}
                disabled={fetchingCurrent}
                className="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {fetchingCurrent ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-gray-600 mr-2"></div>
                    Refreshing...
                  </>
                ) : (
                  <>
                    <svg
                      className="w-4 h-4 mr-2"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                      />
                    </svg>
                    Refresh
                  </>
                )}
              </button>

              <button
                type="submit"
                disabled={loading || !selectedAi || selectedAi === currentAi}
                className="inline-flex items-center px-6 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                    Updating...
                  </>
                ) : (
                  <>
                    <svg
                      className="w-4 h-4 mr-2"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M5 13l4 4L19 7"
                      />
                    </svg>
                    Update AI Selection
                  </>
                )}
              </button>
            </div>
          </form>
        </div>     
      </div>
    </div>
  );
}

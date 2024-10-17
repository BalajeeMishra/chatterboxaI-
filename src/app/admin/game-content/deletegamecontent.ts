import { fetchGameContent } from "./gamecontentApi";

export interface GameContent {
  contentid: string;
}

// Function to delete the content of a specific game by contentId
export const deleteGameContent = async (contentid: string) => {
  try {
    // Making the DELETE request
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/delete-game-content/${contentid}`,
      {
        method: "DELETE", // Correct HTTP method for deletion
        headers: {
          "Content-Type": "application/json",
        },
      }
    );

    // Log the response for debugging
    console.log("Delete Response:", response);

    // Check if the response is successful before proceeding
    if (!response.ok) {
      throw new Error(`An error occurred: ${response.statusText}`);
    }

    // If delete was successful, fetch updated game content
    const updatedContent = await fetchGameContent("670592d31ced4336d6bba9a1");
    console.log(updatedContent);
    // Return the updated content or handle it as needed
    // return updatedContent;
  } catch (error) {
    console.error(
      `Failed to delete game content with contentId ${contentid}:`,
      error
    );
    throw error; // Rethrow the error to be handled by the calling function
  }
};

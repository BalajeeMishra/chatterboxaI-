export interface GameContent {
  _id: string;
  gameId: string;
  mainContent: string;
  level: string;
  detailOfContent: string[];
  __v: number;
}

// Define the structure of the response that contains all game content
export interface AllGameContentResponse {
  allGame: GameContent[];
}

// Function to fetch the content of a specific game by gameId

export const fetchGameContent = async (
  gameId: string
): Promise<GameContent[]> => {
  try {
  
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/allgamecontent/${gameId}`
    );

    // Log the response to debug
    console.log(response);

    // Check if the response is successful
    if (!response.ok) {
      throw new Error(`An error occurred: ${response.statusText}`);
    }

    // Parse the response as JSON
    const data: AllGameContentResponse = await response.json();

    // Return the game content
    return data.allGame;
  } catch (error) {
    console.error(`Failed to fetch game content for gameId ${gameId}:`, error);
    throw error;
  }
};

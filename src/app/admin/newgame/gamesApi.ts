export interface Game {
  _id: string;
  gameName: string;
  gameIcon: string;
  description: string;
  status: string;
  order: number;
  __v: number;
}

interface AllGameResponse {
  allGame: Game[];
}

// Function to fetch all games from the API
export const fetchAllGames = async (): Promise<Game[]> => {
  try {
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/allgame`
    );

    if (!response.ok) {
      throw new Error(`An error occurred: ${response.statusText}`);
    }

    const data: AllGameResponse = await response.json();
    return data.allGame;
  } catch (error) {
    console.error("Failed to fetch games:", error);
    throw error;
  }
};

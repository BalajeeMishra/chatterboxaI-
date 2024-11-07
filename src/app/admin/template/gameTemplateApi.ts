// Define the structure of a single template content
export interface GameTemplateContent {
    _id: string;
    gameId: string;
    engprolevel: string;
    content: string;
    __v: number;
  }
  
  // Define the structure of the response containing all templates
  export interface AllGameTemplateResponse {
    alltemplate: GameTemplateContent[];
  }

  
// Function to fetch the game templates by gameId
export const fetchGameTemplateContent = async (
    gameId: string
  ): Promise<GameTemplateContent[]> => {
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/game-template/${gameId}`
      );
  
      // Parse the response as JSON
      const data: AllGameTemplateResponse = await response.json();
      console.log(data);
  
      // Return the game template content
      return data?.alltemplate || [];
    } catch (error) {
      console.error(`Failed to fetch game template content for gameId ${gameId}:`, error);
      throw error;
    }
  };
  
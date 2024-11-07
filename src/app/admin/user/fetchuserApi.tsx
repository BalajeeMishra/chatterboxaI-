export interface User {
    _id: string;
    playingstatus: boolean;
    mobileNo: string;
    name: string;
    age: number;
    nativeLanguage: string;
    verified: boolean;
    role: string;
    country: string;
    __v: number;
  }
  
  interface AllUserResponse {
    allUser: User[];
  }
  

export const fetchAllUsers = async (): Promise<User[]> => {
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/user/all`
      );
  
      if (!response.ok) {
        throw new Error(`An error occurred: ${response.statusText}`);
      }
  
      const data: AllUserResponse = await response.json();
      return data.allUser;
    } catch (error) {
      console.error("Failed to fetch users:", error);
      throw error;
    }
  };
  
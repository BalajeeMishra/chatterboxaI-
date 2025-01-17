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

export const fetchAllUsers = async (filter: string = ""): Promise<User[]> => {
  try {
    let url = `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/user/all`;

    // Add query parameters based on the filter
    if (filter === "regDate") {
      url += "?regDate=1";
    } else if (filter === "recentActive") {
      url += "?recentActive=1";
    } else if (filter === "both") {
      url += "?recentActive=1&regDate=1";
    }

    const response = await fetch(url);

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

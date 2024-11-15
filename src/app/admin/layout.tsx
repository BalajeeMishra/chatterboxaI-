"use client";
import { useEffect, useState } from "react";
import toast from "react-hot-toast"; // Import react-hot-toast
import { ProfileDropdownMenu } from "@/components/ui/profiledropdown";
import { Icon } from "@iconify/react/dist/iconify.js";
import { Toaster } from "react-hot-toast";
import Link from "next/link";
const Layout = ({ children }: { children: React.ReactNode }) => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Function to verify token
  const verifyToken = async (token: string) => {
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/verifytoken`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ token }), // Pass accessToken for verification
        }
      );

      const result = await response.json();
      if (response.ok) {
        return result.decoded; // Token is valid
      } else {
        throw new Error(result.message || "Invalid token");
      }
    } catch (error) {
      throw new Error("Token verification failed");
    }
  };

  useEffect(() => {
    const checkTokenValidity = async () => {
      const accessToken = localStorage.getItem("accessToken");

      if (!accessToken) {
        setError("You are not logged in.");
        toast.error("You are not logged in. Please log in again."); // Show toast if no token
        window.location.href = "/adminlogin"; // Redirect to login if no token is found
        return;
      }

      try {
        // Try verifying the accessToken
        await verifyToken(accessToken);
        // Token is valid, continue rendering layout
      } catch (error: any) {
        setError(error.message);
        toast.error("Session expired or invalid token. Please log in again."); // Show error toast
        window.location.href = "/adminlogin"; // Redirect to login page if the token is invalid or expired
      } finally {
        setLoading(false);
      }
    };

    checkTokenValidity();
  }, []);

  if (loading) {
    return <div>Loading...</div>; // Show loading indicator while checking token
  }

  if (error) {
    return <div>{error}</div>; // Display error message
  }
  return (
    <div className="min-h-screen h-full flex flex-col">
      {/* Header */}
      <header className="bg-gradient-to-r from-violet-600 to-indigo-600 text-white shadow h-16 flex items-center justify-between px-4 fixed top-0 left-0 right-0 z-10">
        <h1 className="text-xl font-semibold">Chatterbox Admin Dashboard</h1>
        <ProfileDropdownMenu />
      </header>
      <div className="flex flex-1 pt-16">
        {/* Sidebar */}
        <aside className="bg-gradient-to-r from-violet-600 text-white to-indigo-600 w-64 h-screen overflow-y-auto p-4">
          <nav className="space-y-2">
            <ul>
              <li>
                <Link
                  href="/admin/newgame"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="streamline:gameboy" width="20" />
                  <span> New Game</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/admin/game-content"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="icon-park-outline:game-ps" width="20" />
                  <span> Game Content</span>
                </Link>
              </li>

              <li>
                <Link
                  href="/admin/user"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="tabler:users" width="20" />
                  <span> User</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/admin/template"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="cil:description" width="20" />
                  <span>Prompt Template</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/admin/admindetails"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="mdi:user-add-outline" width="20" />
                  <span> Add Admin</span>
                </Link>
              </li>
            </ul>
          </nav>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-6 h-screen overflow-y-auto bg-white">
          {children}
        </main>
      </div>
      <Toaster position="top-center" reverseOrder={false} />
    </div>
  );
};

export default Layout;

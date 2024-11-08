import { ProfileDropdownMenu } from "@/components/ui/profiledropdown";
import { Icon } from "@iconify/react/dist/iconify.js";

const Layout = ({ children }: { children: React.ReactNode }) => {
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
                <a
                  href="/admin/newgame"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="streamline:gameboy" width="20" />
                  <span> New Game</span>
                </a>
              </li>
              <li>
                <a
                  href="/admin/game-content"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="icon-park-outline:game-ps" width="20" />
                  <span> Game Content</span>
                </a>
              </li>

              <li>
                <a
                  href="/admin/user"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="tabler:users" width="20" />
                  <span> User</span>
                </a>
              </li>
              <li>
                <a
                  href="/admin/template"
                  className="flex gap-2 py-2 px-4 rounded hover:bg-gray-100 hover:text-black"
                >
                  <Icon icon="cil:description" width="20" />
                  <span>Prompt Template</span>
                </a>
              </li>
            </ul>
          </nav>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-6 h-screen overflow-y-auto bg-white">
          {children}
        </main>
      </div>
    </div>
  );
};

export default Layout;

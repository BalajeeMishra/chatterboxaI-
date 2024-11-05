// "use client";

// import * as React from "react";
// import {
//   ColumnDef,
//   SortingState,
//   VisibilityState,
//   flexRender,
//   getCoreRowModel,
//   getFilteredRowModel,
//   getPaginationRowModel,
//   getSortedRowModel,
//   useReactTable,
// } from "@tanstack/react-table";
// import { ChevronDown, MoreHorizontal } from "lucide-react";

// import { Button } from "@/components/ui/button";

// import {
//   DropdownMenu,
//   DropdownMenuCheckboxItem,
//   DropdownMenuContent,
//   DropdownMenuItem,
//   DropdownMenuLabel,
//   DropdownMenuSeparator,
//   DropdownMenuTrigger,
// } from "@/components/ui/dropdown-menu";
// import { Input } from "@/components/ui/input";
// import {
//   Table,
//   TableBody,
//   TableCell,
//   TableHead,
//   TableHeader,
//   TableRow,
// } from "@/components/ui/table";
// import { fetchAllGames } from "../newgame/gamesApi";
// import axios from "axios";
// import { GameDialog } from "../newgame/icondialouge";

// // Define the game data structure without id
// interface Game {
//   _id: string;
//   gameName: string;
//   gameIcon: string;
//   description: string;
//   status: "active" | "inactive"; // Restrict status to "active" or "inactive"
//   order: number;
// }

// // Define the columns for the new table structure without id
// export const columns: ColumnDef<Game>[] = [
//   {
//     accessorKey: "_id",
//     header: "ID",
//     cell: ({ row }) => <div>{String(row.getValue("_id"))}</div>,
//   },
//   {
//     accessorKey: "gameName",
//     header: "Game Name",
//     cell: ({ row }) => <div>{row.getValue("gameName")}</div>,
//   },
//   {
//     accessorKey: "gameIcon",
//     header: "Game Icon",
//     cell: ({ row }) => <GameDialog imageSrc={row.getValue("gameIcon")} />,
//   },
//   {
//     accessorKey: "description",
//     header: "Description",
//     cell: ({ row }) => <div>{row.getValue("description")}</div>,
//   },
//   {
//     accessorKey: "status",
//     header: "Status",
//     cell: ({ row }) => <div>{row.getValue("status")}</div>,
//   },
//   {
//     accessorKey: "order",
//     header: "Order",
//     cell: ({ row }) => <div>{row.getValue("order")}</div>,
//   },
// ];
// interface NewGameTableProps {
//   setEditGameName: React.Dispatch<React.SetStateAction<string>>;
//   setEditGameIcon: React.Dispatch<React.SetStateAction<string>>;
//   setEditStatus: React.Dispatch<React.SetStateAction<"active" | "inactive">>;
//   setEditDescription: React.Dispatch<React.SetStateAction<string>>;
//   data: any; // The array of Game objects
//   setData: any; // Function to update the state
//   setEditId: any;
//   editorder: any;
//   setEditorder: any;
// }

// export const NewGameTable: React.FC<NewGameTableProps> = ({
//   data,
//   setEditId,
//   setData,
//   setEditGameName,
//   setEditGameIcon,
//   setEditStatus,
//   setEditDescription,

//   setEditorder,
// }) => {
//   const [sorting, setSorting] = React.useState<SortingState>([]);
//   const [columnVisibility, setColumnVisibility] =
//     React.useState<VisibilityState>({});
//   const [rowSelection, setRowSelection] = React.useState({});
//   // const [data, setData] = React.useState<Game[]>([]);
//   const [loading, setLoading] = React.useState(true);
//   const [error, setError] = React.useState<string | null>(null);
//   React.useEffect(() => {
//     const loadGames = async () => {
//       try {
//         const gamesData = await fetchAllGames();
//         console.log(gamesData);
//         setData(gamesData);
//       } catch (err) {
//         console.log(err);
//         setError("Failed to load games");
//       } finally {
//         setLoading(false);
//       }
//     };

//     loadGames();
//   }, []);

//   const table = useReactTable({
//     data,
//     columns,
//     onSortingChange: setSorting,
//     getCoreRowModel: getCoreRowModel(),
//     getPaginationRowModel: getPaginationRowModel(),
//     getSortedRowModel: getSortedRowModel(),
//     getFilteredRowModel: getFilteredRowModel(),
//     onColumnVisibilityChange: setColumnVisibility,
//     onRowSelectionChange: setRowSelection,
//     state: {
//       sorting,
//       columnVisibility,
//       rowSelection,
//     },
//   });
//   const handleEdit = (game: Game) => {
//     setEditGameIcon(game.gameIcon);
//     setEditGameName(game.gameName);
//     setEditStatus(game.status);
//     setEditDescription(game.description);
//     setEditId(game._id);
//     setEditorder(game.order);
//   };
//   const deleteGame = async (gameid: string): Promise<void> => {
//     try {
//       // Log the game ID for debugging
//       console.log("Deleting game with ID:", gameid);

//       // Construct the DELETE request URL
//       const apiUrl = `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/deletegame/${gameid}`;

//       // Make the DELETE request using Axios
//       await axios.delete(apiUrl, {
//         headers: {
//           "Content-Type": "application/json", // Ensure proper content type
//         },
//       });

//       // Fetch updated list of games after deletion
//       const gamesData = await fetchAllGames();

//       // Update the UI or state with the new games data
//       setData(gamesData);

//       // Notify the user that the game was deleted successfully
//       alert(`Game with ID ${gameid} deleted successfully.`);
//     } catch (error) {
//       // Handle and log any errors
//       if (axios.isAxiosError(error)) {
//         console.error(
//           `Failed to delete game with ID ${gameid}: ${
//             error.response?.data || error.message
//           }`
//         );
//       } else {
//         console.error("Unexpected error occurred");
//       }
//       throw error;
//     }
//   };
//   const changeStatus = async (gameid: string) => {
//     try {
//       // Log the game ID for debugging
//       console.log("Changing status of game with ID:", gameid);

//       // Construct the PATCH request URL
//       const apiUrl = `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/changestatus/${gameid}`;
//       console.log("API URL:", apiUrl);

//       // Make the PATCH request using axios
//       const response = await axios.patch(
//         apiUrl,
//         {
//           status: "inactive", // The body data being sent
//         },
//         {
//           headers: {
//             "Content-Type": "application/json", // Ensure proper content type
//             // "Authorization": `Bearer ${yourToken}`, // Uncomment if you need authentication
//           },
//         }
//       );

//       // Log the response data
//       console.log("Response from server:", response.data);

//       // Fetch updated list of games after status change (Assuming fetchAllGames is another function)
//       const gamesData = await fetchAllGames();

//       // Update the UI or state with the new games data
//       setData(gamesData);

//       // Notify the user that the game's status was changed successfully
//       alert(`Game with ID ${gameid} status changed to inactive successfully.`);
//     } catch (error) {
//       // Handle and log any errors
//       if (axios.isAxiosError(error)) {
//         // Axios error, handle it accordingly
//         console.error("Axios error:", error);
//         alert(
//           `Failed to change game status: ${
//             error.response?.data?.message || error.message
//           }`
//         );
//       } else {
//         // Non-Axios error
//         console.error("Unexpected error:", error);
//         alert("Failed to change game status. Please try again.");
//       }
//     }
//   };

//   if (loading) return <div>Loading...</div>;
//   if (error) return <div>{error}</div>;

//   return (
//     <div className="w-full">
//       <div className="flex items-center py-4">
//         <Input
//           placeholder="Filter by Game Name..."
//           value={
//             (table.getColumn("gameName")?.getFilterValue() as string) ?? ""
//           }
//           onChange={(event) =>
//             table.getColumn("gameName")?.setFilterValue(event.target.value)
//           }
//           className="max-w-sm"
//         />

//         <DropdownMenu>
//           <DropdownMenuTrigger asChild>
//             <Button variant="outline" className="ml-auto">
//               Columns <ChevronDown className="ml-2 h-4 w-4" />
//             </Button>
//           </DropdownMenuTrigger>
//           <DropdownMenuContent align="end" className="bg-white">
//             {table
//               .getAllColumns()
//               .filter((column) => column.getCanHide())
//               .map((column) => {
//                 return (
//                   <DropdownMenuCheckboxItem
//                     key={column.id}
//                     className="capitalize"
//                     checked={column.getIsVisible()}
//                     onCheckedChange={(value) =>
//                       column.toggleVisibility(!!value)
//                     }
//                   >
//                     {column.id}
//                   </DropdownMenuCheckboxItem>
//                 );
//               })}
//           </DropdownMenuContent>
//         </DropdownMenu>
//       </div>
//       <div className="rounded-md border">
//         <Table>
//           <TableHeader>
//             {table.getHeaderGroups().map((headerGroup) => (
//               <TableRow key={headerGroup.id}>
//                 {headerGroup.headers.map((header) => {
//                   return (
//                     <TableHead key={header.id}>
//                       {header.isPlaceholder
//                         ? null
//                         : flexRender(
//                             header.column.columnDef.header,
//                             header.getContext()
//                           )}
//                     </TableHead>
//                   );
//                 })}
//               </TableRow>
//             ))}
//           </TableHeader>
//           <TableBody>
//             {table.getRowModel().rows?.length ? (
//               table.getRowModel().rows.map((row) => (
//                 <TableRow
//                   key={row.id}
//                   data-state={row.getIsSelected() && "selected"}
//                 >
//                   {row.getVisibleCells().map((cell) => (
//                     <TableCell key={cell.id}>
//                       {flexRender(
//                         cell.column.columnDef.cell,
//                         cell.getContext()
//                       )}
//                     </TableCell>
//                   ))}
//                   <TableCell>
//                     <DropdownMenu>
//                       <DropdownMenuTrigger asChild>
//                         <Button variant="ghost" className="h-8 w-8 p-0">
//                           <span className="sr-only">Open menu</span>
//                           <MoreHorizontal className="h-4 w-4" />
//                         </Button>
//                       </DropdownMenuTrigger>
//                       <DropdownMenuContent align="end" className="bg-white">
//                         <DropdownMenuLabel>Actions</DropdownMenuLabel>
//                         <DropdownMenuItem
//                           onClick={() => deleteGame(row.original._id)}
//                         >
//                           Delete
//                         </DropdownMenuItem>
//                         <DropdownMenuSeparator />
//                         <DropdownMenuItem
//                           onClick={() => handleEdit(row.original)}
//                         >
//                           Edit data
//                         </DropdownMenuItem>
//                         <DropdownMenuSeparator />
//                         <DropdownMenuItem
//                           onClick={() => changeStatus(row.original._id)}
//                         >
//                           Change Status
//                         </DropdownMenuItem>
//                       </DropdownMenuContent>
//                     </DropdownMenu>
//                   </TableCell>
//                 </TableRow>
//               ))
//             ) : (
//               <TableRow>
//                 <TableCell
//                   colSpan={columns.length}
//                   className="h-24 text-center"
//                 >
//                   No results.
//                 </TableCell>
//               </TableRow>
//             )}
//           </TableBody>
//         </Table>
//       </div>
//       <div className="flex items-center justify-end space-x-2 py-4">
//         <div className="flex-1 text-sm text-muted-foreground">
//           {table.getFilteredRowModel().rows.length} of{" "}
//           {table.getRowModel().rows.length} rows
//         </div>
//         <Button
//           variant="outline"
//           onClick={() => table.previousPage()}
//           disabled={!table.getCanPreviousPage()}
//         >
//           Previous
//         </Button>
//         <Button
//           variant="outline"
//           onClick={() => table.nextPage()}
//           disabled={!table.getCanNextPage()}
//         >
//           Next
//         </Button>
//       </div>
//     </div>
//   );
// };







"use client";

import * as React from "react";
import {
  ColumnDef,
  SortingState,
  VisibilityState,
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  useReactTable,
} from "@tanstack/react-table";
import { ChevronDown, MoreHorizontal } from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { fetchAllGames } from "../newgame/gamesApi";
import axios from "axios";

// Define the game data structure without id
interface Game {
  _id: string;
  template: string;
  englishProficiency: string;
  game: string;
}

// Define the columns for the new table structure without status
export const columns: ColumnDef<Game>[] = [
  {
    accessorKey: "_id",
    header: "ID",
    cell: ({ row }) => <div>{String(row.getValue("_id"))}</div>,
  },
  {
    accessorKey: "template",
    header: "Template",
    cell: ({ row }) => <div>{row.getValue("template")}</div>,
  },
  {
    accessorKey: "englishProficiency",
    header: "English Proficiency",
    cell: ({ row }) => <div>{row.getValue("englishProficiency")}</div>,
  },
  {
    accessorKey: "game",
    header: "Game",
    cell: ({ row }) => <div>{row.getValue("game")}</div>,
  },
];

interface NewGameTableProps {
  setEditTemplate: React.Dispatch<React.SetStateAction<string>>;
  setEditEnglishProficiency: React.Dispatch<React.SetStateAction<string>>;
  setEditGame: React.Dispatch<React.SetStateAction<string>>;
  data: any; // The array of Game objects
  setData: any; // Function to update the state
  setEditId: any;
}

export const NewGameTable: React.FC<NewGameTableProps> = ({
  data,
  setEditId,
  setData,
  setEditTemplate,
  setEditEnglishProficiency,
  setEditGame,
}) => {
  const [sorting, setSorting] = React.useState<SortingState>([]);
  const [columnVisibility, setColumnVisibility] =
    React.useState<VisibilityState>({});
  const [rowSelection, setRowSelection] = React.useState({});
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState<string | null>(null);

  React.useEffect(() => {
    const loadGames = async () => {
      try {
        const gamesData = await fetchAllGames();
        setData(gamesData);
      } catch (err) {
        console.error(err);
        setError("Failed to load games");
      } finally {
        setLoading(false);
      }
    };

    loadGames();
  }, []);

  const table = useReactTable({
    data,
    columns,
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    onColumnVisibilityChange: setColumnVisibility,
    onRowSelectionChange: setRowSelection,
    state: {
      sorting,
      columnVisibility,
      rowSelection,
    },
  });

  const handleEdit = (game: Game) => {
    setEditTemplate(game.template);
    setEditEnglishProficiency(game.englishProficiency);
    setEditGame(game.game);
    setEditId(game._id);
  };

  const deleteGame = async (gameid: string): Promise<void> => {
    try {
      const apiUrl = `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/deletegame/${gameid}`;
      await axios.delete(apiUrl, {
        headers: {
          "Content-Type": "application/json",
        },
      });

      const gamesData = await fetchAllGames();
      setData(gamesData);

      alert(`Game with ID ${gameid} deleted successfully.`);
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.error(`Failed to delete game: ${error.response?.data || error.message}`);
      } else {
        console.error("Unexpected error occurred");
      }
    }
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>{error}</div>;

  return (
    <div className="w-full">
      <div className="flex items-center py-4">
        <Input
          placeholder="Filter by Template..."
          value={
            (table.getColumn("template")?.getFilterValue() as string) ?? ""
          }
          onChange={(event) =>
            table.getColumn("template")?.setFilterValue(event.target.value)
          }
          className="max-w-sm"
        />

        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" className="ml-auto">
              Columns <ChevronDown className="ml-2 h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="bg-white">
            {table
              .getAllColumns()
              .filter((column) => column.getCanHide())
              .map((column) => {
                return (
                  <DropdownMenuCheckboxItem
                    key={column.id}
                    className="capitalize"
                    checked={column.getIsVisible()}
                    onCheckedChange={(value) =>
                      column.toggleVisibility(!!value)
                    }
                  >
                    {column.id}
                  </DropdownMenuCheckboxItem>
                );
              })}
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            {table.getHeaderGroups().map((headerGroup) => (
              <TableRow key={headerGroup.id}>
                {headerGroup.headers.map((header) => {
                  return (
                    <TableHead key={header.id}>
                      {header.isPlaceholder
                        ? null
                        : flexRender(
                            header.column.columnDef.header,
                            header.getContext()
                          )}
                    </TableHead>
                  );
                })}
              </TableRow>
            ))}
          </TableHeader>
          <TableBody>
            {table.getRowModel().rows?.length ? (
              table.getRowModel().rows.map((row) => (
                <TableRow
                  key={row.id}
                  data-state={row.getIsSelected() && "selected"}
                >
                  {row.getVisibleCells().map((cell) => (
                    <TableCell key={cell.id}>
                      {flexRender(
                        cell.column.columnDef.cell,
                        cell.getContext()
                      )}
                    </TableCell>
                  ))}
                  <TableCell>
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" className="h-8 w-8 p-0">
                          <span className="sr-only">Open menu</span>
                          <MoreHorizontal className="h-4 w-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end" className="bg-white">
                        <DropdownMenuLabel>Actions</DropdownMenuLabel>
                        <DropdownMenuItem
                          onClick={() => deleteGame(row.original._id)}
                        >
                          Delete
                        </DropdownMenuItem>
                        <DropdownMenuSeparator />
                        <DropdownMenuItem
                          onClick={() => handleEdit(row.original)}
                        >
                          Edit data
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell
                  colSpan={columns.length}
                  className="h-24 text-center"
                >
                  No results.
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
      <div className="flex items-center justify-end space-x-2 py-4">
        <div className="flex-1 text-sm text-muted-foreground">
          {table.getFilteredRowModel().rows.length} of{" "}
          {table.getRowModel().rows.length} rows
        </div>
        <Button
          variant="outline"
          onClick={() => table.previousPage()}
          disabled={!table.getCanPreviousPage()}
        >
          Previous
        </Button>
        <Button
          variant="outline"
          onClick={() => table.nextPage()}
          disabled={!table.getCanNextPage()}
        >
          Next
        </Button>
      </div>
    </div>
  );
};

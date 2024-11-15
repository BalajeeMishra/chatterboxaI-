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
import { fetchGameContent } from "./gamecontentApi";
import { Games } from "./addgamecontent";
import { fetchAllGames } from "../newgame/gamesApi";
import toast from "react-hot-toast";

// Define the game data structure
export interface Game {
  _id: string;
  gameId: string;
  mainContent: string;
  level: string;
  detailOfContent: string[];
}

// // Define the columns for the new table structure
export const columns: ColumnDef<Game>[] = [
  {
    accessorKey: "_id",
    header: "ID",
    cell: ({ row }) => <div>{String(row.getValue("_id"))}</div>,
  },
  {
    accessorKey: "gameId",
    header: "Game ID",
    cell: ({ row }) => <div>{row.getValue("gameId")}</div>,
  },
  {
    accessorKey: "mainContent",
    header: "Main Content",
    cell: ({ row }) => <div>{row.getValue("mainContent")}</div>,
  },
  {
    accessorKey: "level",
    header: "Level",
    cell: ({ row }) => <div>{row.getValue("level")}</div>,
  },
  {
    accessorKey: "detailOfContent",
    header: "Detail of Content",
    cell: ({ row }) => {
      const details = row.getValue("detailOfContent") as string[] | undefined; // Allow it to be undefined
      return <div>{details ? details.join(", ") : "No details available"}</div>;
    },
  },
];
interface NewGameContentFormProps {
  seteditMainContent: React.Dispatch<React.SetStateAction<string>>;
  seteditLevel: React.Dispatch<
    React.SetStateAction<"easy" | "medium" | "hard">
  >;
  seteditDetailOfContent: React.Dispatch<React.SetStateAction<string[]>>;
  data: Game[]; // The array of Game objects
  setData: React.Dispatch<React.SetStateAction<Game[]>>; // Function to update the state
  setEditgameId: any;
}

export const GameContentTable: React.FC<NewGameContentFormProps> = ({
  data,
  setData,
  seteditMainContent,
  seteditLevel,
  seteditDetailOfContent,
  setEditgameId,
}) => {
  const [sorting, setSorting] = React.useState<SortingState>([]);
  const [columnVisibility, setColumnVisibility] =
    React.useState<VisibilityState>({});
  const [rowSelection, setRowSelection] = React.useState({});
  const [newgameData, setNewgameData] = React.useState<Games[]>([]);
  const [selectgameId, setSelectgameId] = React.useState<string>("");
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState<string | null>(null);
  React.useEffect(() => {
    const loadGames = async () => {
      try {
        const gamesData = await fetchAllGames();
        console.log(gamesData);
        setNewgameData(gamesData);
        setSelectgameId(gamesData[0]._id);
      } catch (err) {
        console.log(err);
      }
    };
    loadGames();
  }, []);

  React.useEffect(() => {
    const loadGames = async () => {
      if (!selectgameId) {
        return;
      }
      console.log(selectgameId);
      try {
        const gamesContent = await fetchGameContent(selectgameId);
        console.log(gamesContent);
        setData(gamesContent);
      } catch (err) {
        console.log(err);
        setError("Failed to load games");
        
      } finally {
        setLoading(false);
      }
    };

    loadGames();
  }, [selectgameId]);

  // Function to delete the content of a specific game by contentId
  const deleteGameContent = async (contentid: string) => {
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
      console.log("Delete Response:", response.json());
      toast.success("Game Deleted successfully");
      // Check if the response is successful before proceeding

      // If delete was successful, fetch updated game content
      const updatedContent = await fetchGameContent(selectgameId);
      setData(updatedContent);
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

  // Function to handle the Edit action
  const handleEdit = (game: Game) => {
    seteditMainContent(game.mainContent);
    seteditLevel(game.level as "easy" | "medium" | "hard");
    seteditDetailOfContent(game.detailOfContent);
    setEditgameId(game._id);
  };

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

  if (loading) return <div>Loading...</div>;
  if (!data || data?.length === 0) return <div> No results.</div>;
  if (error) return <div>{error}</div>;

  return (
    <div className="w-full">
      <div className="flex items-center justify-between py-4">
        <Input
          placeholder="Filter by content..."
          value={
            (table.getColumn("mainContent")?.getFilterValue() as string) ?? ""
          }
          onChange={(event) =>
            table.getColumn("mainContent")?.setFilterValue(event.target.value)
          }
          className="max-w-sm"
        />
        <div className="flex items-center gap-2">
          <select
            id="selectgameId"
            value={selectgameId}
            onChange={(e) => setSelectgameId(e.target.value)}
            className=" block w-full p-2 border border-gray-300 rounded-md"
          >
            <option key="2" value="">
              Select a game
            </option>
            {newgameData &&
              newgameData?.length !== 0 &&
              newgameData?.map((game) => (
                <option key={game._id} value={game._id}>
                  {game.gameName}
                </option>
              ))}
          </select>
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
                          onClick={() => deleteGameContent(row.original._id)}
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

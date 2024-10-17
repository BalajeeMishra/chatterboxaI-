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
import { Checkbox } from "@/components/ui/checkbox";
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
import { fetchAllGames } from "./gamesApi";
import { GameDialog } from "./icondialouge";

// Define the game data structure without id
interface Game {
  _id: string;
  gameName: string;
  gameIcon: string;
  description: string;
  status: "active" | "inactive"; // Restrict status to "active" or "inactive"
  order: number;
}

// Define the columns for the new table structure without id
export const columns: ColumnDef<Game>[] = [
  {
    accessorKey: "_id",
    header: "ID",
    cell: ({ row }) => <div>{String(row.getValue("_id"))?.slice(-6)}</div>,
  },
  {
    accessorKey: "gameName",
    header: "Game Name",
    cell: ({ row }) => <div>{row.getValue("gameName")}</div>,
  },
  {
    accessorKey: "gameIcon",
    header: "Game Icon",
    cell: ({ row }) => (
   
      <GameDialog imageSrc={row.getValue("gameIcon")}/>
    ),
  },
  {
    accessorKey: "description",
    header: "Description",
    cell: ({ row }) => <div>{row.getValue("description")}</div>,
  },
  {
    accessorKey: "status",
    header: "Status",
    cell: ({ row }) => <div>{row.getValue("status")}</div>,
  },
  {
    accessorKey: "order",
    header: "Order",
    cell: ({ row }) => <div>{row.getValue("order")}</div>,
  },
];
interface NewGameTableProps {
  setEditGameName: React.Dispatch<React.SetStateAction<string>>;
  setEditGameIcon: React.Dispatch<React.SetStateAction<string>>;
  setEditStatus: React.Dispatch<React.SetStateAction<"active" | "inactive">>;
  setEditDescription: React.Dispatch<React.SetStateAction<string>>;
  data: any; // The array of Game objects
  setData: any; // Function to update the state
}

export const NewGameTable: React.FC<NewGameTableProps> = ({
  data,
  setData,
  setEditGameName,
  setEditGameIcon,
  setEditStatus,
  setEditDescription,
}) => {
  const [sorting, setSorting] = React.useState<SortingState>([]);
  const [columnVisibility, setColumnVisibility] =
    React.useState<VisibilityState>({});
  const [rowSelection, setRowSelection] = React.useState({});
  // const [data, setData] = React.useState<Game[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState<string | null>(null);
  React.useEffect(() => {
    const loadGames = async () => {
      try {
        const gamesData = await fetchAllGames();
        console.log(gamesData);
        setData(gamesData);
      } catch (err) {
        console.log(err);
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
    setEditGameIcon(game.gameIcon);
    setEditGameName(game.gameName);
    setEditStatus(game.status);
    setEditDescription(game.description);
  };
  const deleteGame = async (gameid: string): Promise<void> => {
    try {
      // Make the DELETE request
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/deletegame${gameid}`,
        {
          method: "DELETE", // Specify the HTTP method
          headers: {
            "Content-Type": "application/json", // Set content type headers if needed
          },
        }
      );
      // Log the response for debugging purposes
      console.log("Delete Response:", response);
      const gamesData = await fetchAllGames();
      console.log(gamesData);
      setData(gamesData);
      // Check if the response is not successful (status code >= 400)
      if (!response.ok) {
        throw new Error(`Failed to delete the game: ${response.statusText}`);
      }
      // If delete was successful, you can log or return success feedback
      alert(`Game with id ${gameid} deleted successfully.`);
    } catch (error) {
      // Log and handle the error
      console.error(`Error deleting game with id ${gameid}:`, error);
      throw error; // Rethrow the error to be handled by the calling function if necessary
    }
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>{error}</div>;

  return (
    <div className="w-full">
      <div className="flex items-center py-4">
        <Input
          placeholder="Filter by Game Name..."
          value={
            (table.getColumn("gameName")?.getFilterValue() as string) ?? ""
          }
          onChange={(event) =>
            table.getColumn("gameName")?.setFilterValue(event.target.value)
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

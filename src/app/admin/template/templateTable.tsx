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
import { fetchGameTemplateContent } from "./gameTemplateApi";
import RenderContent from "./htmltext";

// Define the game data structure without id
interface Game {
  _id: string;
  template?: string;
  englishProficiency?: string;
  game?: string;
  engprolevel?: any;
  content?: any;
}

// Define the columns for the new table structure without status
export const columns: ColumnDef<Game>[] = [
  {
    accessorKey: "_id",
    header: "ID",
    cell: ({ row }) => <div>{String(row.getValue("_id"))}</div>,
  },
  {
    accessorKey: "content",
    header: "Template",
    cell: ({ row }) => <RenderContent content={row.getValue("content")} />,
  },

  {
    accessorKey: "engprolevel",
    header: "English Proficiency",
    cell: ({ row }) => <div>{row.getValue("engprolevel")}</div>,
  },
  {
    accessorKey: "gameId",
    header: "Game",
    cell: ({ row }) => <div>{row.getValue("gameId")}</div>,
  },
];

interface NewGameTableProps {
  setEditTemplate: React.Dispatch<React.SetStateAction<string>>;
  setEditEnglishProficiency?: any;

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
}) => {
  const [sorting, setSorting] = React.useState<SortingState>([]);
  const [columnVisibility, setColumnVisibility] =
    React.useState<VisibilityState>({});
  const [rowSelection, setRowSelection] = React.useState({});
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState<string | null>(null);
  const [selectgameId, setSelectgameId] = React.useState<string>("");
  const [newtemplateData, setNewtemplateData] = React.useState<Game[]>([]);
  React.useEffect(() => {
    const loadGames = async () => {
      try {
        const gamesData = await fetchAllGames();
        setNewtemplateData(gamesData);
      } catch (err) {
        console.error(err);
        setError("Failed to load games");
      } finally {
        setLoading(false);
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
        const templateContent = await fetchGameTemplateContent(selectgameId);
        console.log(templateContent);
        setData(templateContent);
      } catch (err) {
        console.log(err);
        setError("Failed to load games");
      } finally {
        setLoading(false);
      }
    };

    loadGames();
  }, [selectgameId]);
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
    console.log(game);
    setEditTemplate(game.content);
    setEditEnglishProficiency(game.engprolevel);

    setEditId(game._id);
  };

  const deleteTemplate = async (templateid: string): Promise<void> => {
    try {
      const apiUrl = `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/game/game-template/${templateid}`;
      await axios.delete(apiUrl, {
        headers: {
          "Content-Type": "application/json",
        },
      });

      const gamesData = await fetchAllGames();
      setNewtemplateData(gamesData);
      const templateContent = await fetchGameTemplateContent(selectgameId);
      console.log(templateContent);
      setData(templateContent);
      alert(`Template with ID ${templateid} deleted successfully.`);
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.error(
          `Failed to delete game: ${error.response?.data || error.message}`
        );
      } else {
        console.error("Unexpected error occurred");
      }
    }
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>{error}</div>;
  console.log(data);
  return (
    <div className="w-full">
      <div className="flex items-center justify-between py-4">
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
        <div className="flex items-center gap-2">
          <select
            id="selectgameId"
            value={selectgameId}
            onChange={(e) => setSelectgameId(e.target.value)}
            className=" block w-full p-2 border border-gray-300 rounded-md"
          >
            {" "}
            <option value="">Select a game</option>
            {newtemplateData?.map((game: any) => (
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
                          onClick={() => deleteTemplate(row.original._id)}
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

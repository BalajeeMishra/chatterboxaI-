"use client";
import { NewGameTable } from "@/app/admin/newgame/newgameTable";
import PageHeadDesc from "@/components/ui/PageHeadDesc";
import AddgameForm from "./addnewgameform";
import { useEffect, useState } from "react";
import { Game } from "./gamesApi";

export default function Newgame() {
  const [data, setData] = useState<Game[]>([]);
  const [editorder, setEditorder] = useState<string>("");
  const [editgameName, setEditGameName] = useState<string>("");
  const [editgameIcon, setEditGameIcon] = useState<string>("");
  const [editstatus, setEditStatus] = useState<"active" | "inactive">("active");
  const [editdescription, setEditDescription] = useState<string>("");
  const [editId, setEditId] = useState<string>("");
  useEffect(() => {
    console.log(editgameName, editgameIcon, editdescription, editstatus);
  }, [editgameName, editgameIcon, editdescription, editstatus]);
  return (
    <div>
      <PageHeadDesc title="New Game" desc="New game details" />
      <div className="mx-6">
        {/* <AddNewGameForm/> */}

        <AddgameForm
          editorder={editorder}
          setEditorder={setEditorder}
          editId={editId}
          setEditId={setEditId}
          setData={setData}
          editgameName={editgameName}
          editgameIcon={editgameIcon}
          editstatus={editstatus}
          editdescription={editdescription}
          setEditGameName={setEditGameName}
          setEditGameIcon={setEditGameIcon}
          setEditStatus={setEditStatus}
          setEditDescription={setEditDescription}
        />
        <NewGameTable
         editorder={editorder}
         setEditorder={setEditorder}
          setEditId={setEditId}
          setEditGameName={setEditGameName}
          setEditGameIcon={setEditGameIcon}
          setEditStatus={setEditStatus}
          setEditDescription={setEditDescription}
          data={data}
          setData={setData}
        />
      </div>
    </div>
  );
}

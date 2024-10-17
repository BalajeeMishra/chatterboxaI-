"use client";
import { NewGameTable } from "@/app/admin/newgame/newgameTable";
import PageHeadDesc from "@/components/ui/PageHeadDesc";
import AddgameForm from "./addnewgameform";
import { useEffect, useState } from "react";
import { Game } from "./gamesApi";

export default function Newgame() {
  const [data, setData] = useState<Game[]>([]);
  const [editgameName, setEditGameName] = useState<string>("");
  const [editgameIcon, setEditGameIcon] = useState<string>("");
  const [editstatus, setEditStatus] = useState<"active" | "inactive">("active");
  const [editdescription, setEditDescription] = useState<string>("");
  useEffect(() => {
    console.log(editgameName, editgameIcon, editdescription, editstatus);
  }, [editgameName, editgameIcon, editdescription, editstatus]);
  return (
    <div>
      <PageHeadDesc title="New Game" desc="New game details" />
      <div className="mx-6">
        {/* <AddNewGameForm/> */}

        <AddgameForm
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

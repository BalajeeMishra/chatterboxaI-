"use client";
import PageHeadDesc from "@/components/ui/PageHeadDesc";
import { useEffect, useState } from "react";
import { Game } from "../newgame/gamesApi";
import { NewGameTable } from "./templateTable";
import Addtemplate from "./addtemplateform";

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
      <PageHeadDesc title="Game Template" desc="Game Template details" />
      <div className="mx-6">
        {/* <AddNewGameForm/> */}

        <Addtemplate
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

"use client";
import PageHeadDesc from "@/components/ui/PageHeadDesc";
import { useEffect, useState } from "react";
import { Game } from "../newgame/gamesApi";
import { NewGameTable } from "./templateTable";
import Addtemplate from "./addtemplateform";

export default function Newgame() {
  const [data, setData] = useState<Game[]>([]);
  const [edittemplate, setEditTemplate] = useState<string>("");
  const [editEnglishProficiency, setEditEnglishProficiency] = useState<
    "active" | "inactive"
  >("active");
  const [editId, setEditId] = useState<string>("");

  return (
    <div>
      <PageHeadDesc title="Game Prompt Template" desc="Game Prompt Template details" />
      <div className="mx-6">
        {/* <AddNewGameForm/> */}

        <Addtemplate
          editId={editId}
          setEditId={setEditId}
          setData={setData}
         
          setEditTemplate={setEditTemplate}
          edittemplate={edittemplate}
         
          editEnglishProficiency={editEnglishProficiency}
        />
        <NewGameTable
          setEditId={setEditId}
          setEditTemplate={setEditTemplate}
          setEditEnglishProficiency={setEditEnglishProficiency}
          data={data}
          setData={setData}
        />
      </div>
    </div>
  );
}

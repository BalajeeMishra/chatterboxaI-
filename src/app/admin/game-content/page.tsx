"use client";
import PageHeadDesc from "@/components/ui/PageHeadDesc";
import { Game, GameContentTable } from "./gamecontent";
import NewGameContentForm from "./addgamecontent";
import React, { useEffect, useState } from "react";

export default function GameContent() {
  const [data, setData] = React.useState<Game[]>([]);
  const [editgameId, setEditgameId] = useState<string>("");
  const [editmainContent, seteditMainContent] = useState<string>("");
  const [editlevel, seteditLevel] = useState<"easy" | "medium" | "hard">(
    "medium"
  );
  const [editdetailOfContent, seteditDetailOfContent] = useState<string[]>([]);
  useEffect(() => {
    console.log(editmainContent, editlevel, editdetailOfContent);
  }, [editmainContent, editlevel, editdetailOfContent]);
  return (
    <div>
      <PageHeadDesc title="Game Content" desc="Game Content details" />
      <div className="mx-6">
        <NewGameContentForm
          editmainContent={editmainContent}
          editlevel={editlevel}
          editdetailOfContent={editdetailOfContent}
          editgameId={editgameId}
          setEditgameId={setEditgameId}
          seteditMainContent={seteditMainContent}
          seteditLevel={seteditLevel}
          seteditDetailOfContent={seteditDetailOfContent}
          data={data}
          setData={setData}
        />
        <GameContentTable
          seteditMainContent={seteditMainContent}
          seteditLevel={seteditLevel}
          setEditgameId={setEditgameId}
          seteditDetailOfContent={seteditDetailOfContent}
          data={data}
          setData={setData}
        />
      </div>
    </div>
  );
}

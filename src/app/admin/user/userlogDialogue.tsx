import { Copy } from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import React from "react";
interface DialogCloseButtonProps {
  selectUserId: string; // Assuming `selectUserId` is a string representing the user ID
}
interface gameDetails {
  gameName: string;
}
interface Response {
  text: string;
  createdAt: string | Date;
}
interface GameConversation {
  _id: string;
  userId: string;
  userResponse: Response[]; // Fixed from string[] to Response[]
  aiResponse: Response[]; // Fixed from string[] to Response[]
  sessionId: string;
  createdAt: string;
  gameDetails?: gameDetails;
}
export function DialogCloseButton({ selectUserId }: DialogCloseButtonProps) {
  const [userId, setUserId] = React.useState<string>(selectUserId || "");
  const [error, setError] = React.useState<string | null>(null);
  const [loading, setLoading] = React.useState<boolean>(true);
  const [gameConversations, setGameConversations] = React.useState<
    GameConversation[]
  >([]);
  React.useEffect(() => {
    setUserId(selectUserId);
  }, []);
  React.useEffect(() => {
    fetchGameConversations();
  }, [userId]); // Re-run the effect when userId changes
  const fetchGameConversations = async () => {
    setLoading(true);
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/user/allgameconversation?userId=${userId}`
      );
      if (!response.ok) {
        throw new Error("Failed to fetch game conversations");
      }
      const data = await response.json();
      console.log(data);
      setGameConversations(data.completeConversation);
    } catch (error: any) {
      setError(error.message);
    } finally {
      setLoading(false);
    }
  };
  const formattedDate = (dateString: any) => {
    const date = new Date(dateString);
    return date.toLocaleString("en-US", {
      hour: "numeric",
      minute: "numeric",
      second: "numeric",
      hour12: true,
      day: "2-digit",
      month: "short",
      year: "numeric",
    });
  };

  return (
    <Dialog>
      <DialogTrigger asChild>
        <p className="text-sm p-2 cursor-pointer">View Userlog</p>
      </DialogTrigger>
      <DialogContent className="sm:max-w-4xl max-h-[600px] overflow-scroll">
        <DialogHeader>
          <DialogTitle>Userlog</DialogTitle>
          <DialogDescription>Userlog full details</DialogDescription>
        </DialogHeader>
        <div className="flex flex-col gap-2">
          {gameConversations
            .slice()
            .reverse()
            .map((game, index) => (
              <Accordion
                type="single"
                collapsible
                key={game._id}
                className="w-full"
              >
                <AccordionItem
                  value={`session-${gameConversations.length - index}`}
                >
                  <AccordionTrigger className="font-semibold">
                    <div className="flex min-w-24">
                      Session {gameConversations.length - index}{" "}
                      {/* Reverse numbering */}
                    </div>
                    <span className="text-end my-2 w-full flex justify-end text-xs pr-4 text-gray-600">
                      {game?.gameDetails?.gameName}
                    </span>
                  </AccordionTrigger>
                  <AccordionContent>
                    <div className="flex flex-col gap-2">
                      <span className="text-end my-2 w-full flex justify-end text-xs text-gray-600">
                        {formattedDate(game.createdAt)}
                      </span>

                      {/* Reverse and map responses */}
                      {game.userResponse.map((userResp, idx) => (
                        <React.Fragment key={`response-pair-${idx}`}>
                          {/* User Response */}
                          <Accordion type="single" collapsible>
                            <AccordionItem
                              value={`user-response-${
                                game.userResponse.length - idx
                              }`}
                            >
                              <AccordionTrigger className="bg-blue-100 p-2 rounded-md">
                                User Response {idx + 1}{" "}
                                {/* Reverse numbering */}
                              </AccordionTrigger>
                              <AccordionContent className="bg-gray-100 p-4 rounded-md mt-2">
                                <p>{userResp?.text}</p>
                                <span className="text-end w-full flex justify-end text-xs text-gray-600 mt-4">
                                  {formattedDate(userResp?.createdAt)}
                                </span>
                              </AccordionContent>
                            </AccordionItem>
                          </Accordion>

                          {/* AI Response */}
                          {game.aiResponse[idx] && (
                            <Accordion type="single" collapsible>
                              <AccordionItem
                                value={`ai-response-${
                                  game.aiResponse.length - idx
                                }`}
                              >
                                <AccordionTrigger className="bg-green-100 p-2 rounded-md">
                                  AI Response {idx + 1}{" "}
                                  {/* Reverse numbering */}
                                </AccordionTrigger>
                                <AccordionContent className="bg-gray-100 p-4 rounded-md mt-2">
                                  <p>{game.aiResponse[idx]?.text}</p>
                                  <span className="text-end w-full flex justify-end text-xs text-gray-600 mt-4">
                                    {formattedDate(
                                      game.aiResponse[idx]?.createdAt
                                    )}
                                  </span>
                                </AccordionContent>
                              </AccordionItem>
                            </Accordion>
                          )}
                        </React.Fragment>
                      ))}
                    </div>
                  </AccordionContent>
                </AccordionItem>
              </Accordion>
            ))}
        </div>

        <DialogFooter className="sm:justify-start">
          <DialogClose asChild>
            <Button type="button" variant="secondary">
              Close
            </Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

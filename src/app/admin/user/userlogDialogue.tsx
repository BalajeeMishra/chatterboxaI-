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
interface GameConversation {
  _id: string;
  userId: string;
  userResponse: string[];
  aiResponse: string[];
  sessionId: string;
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

  console.log(gameConversations);
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

        {/* <div className="flex flex-col gap-2">
          {gameConversations.map((game, index) => (
            <Accordion
              type="single"
              collapsible
              key={game._id}
              className="w-full"
            >
              <AccordionItem value={`session-${index + 1}`}>
                <AccordionTrigger className="font-semibold">
                  Session {index + 1}
                </AccordionTrigger>
                <AccordionContent>
                  <div className="flex flex-col gap-2">
                    {game.userResponse.map((userResp, idx) => (
                      <Accordion
                        key={`user-response-${idx}`}
                        type="single"
                        collapsible
                      >
                        <AccordionItem value={`user-response-${idx + 1}`}>
                          <AccordionTrigger className="bg-blue-100 p-2 rounded-md">
                            User Response {idx + 1}
                          </AccordionTrigger>
                          <AccordionContent className="bg-gray-100 p-4 rounded-md mt-2">
                            {userResp}
                          </AccordionContent>
                        </AccordionItem>
                      </Accordion>
                    ))}

                    {game.aiResponse.map((aiResp, idx) => (
                      <Accordion
                        key={`ai-response-${idx}`}
                        type="single"
                        collapsible
                      >
                        <AccordionItem value={`ai-response-${idx + 1}`}>
                          <AccordionTrigger className="bg-green-100 p-2 rounded-md">
                            AI Response {idx + 1}
                          </AccordionTrigger>
                          <AccordionContent className="bg-gray-100 p-4 rounded-md mt-2">
                            {aiResp}
                          </AccordionContent>
                        </AccordionItem>
                      </Accordion>
                    ))}
                  </div>
                </AccordionContent>
              </AccordionItem>
            </Accordion>
          ))}
        </div> */}
        <div className="flex flex-col gap-2">
          {gameConversations.map((game, index) => (
            <Accordion
              type="single"
              collapsible
              key={game._id}
              className="w-full"
            >
              <AccordionItem value={`session-${index + 1}`}>
                <AccordionTrigger className="font-semibold">
                  Session {index + 1}
                </AccordionTrigger>
                <AccordionContent>
                  <div className="flex flex-col gap-2">
                    {game.userResponse.map((userResp, idx) => (
                      <React.Fragment key={`response-pair-${idx}`}>
                        {/* User Response */}
                        <Accordion type="single" collapsible>
                          <AccordionItem value={`user-response-${idx + 1}`}>
                            <AccordionTrigger className="bg-blue-100 p-2 rounded-md">
                              User Response {idx + 1}
                            </AccordionTrigger>
                            <AccordionContent className="bg-gray-100 p-4 rounded-md mt-2">
                              {userResp}
                            </AccordionContent>
                          </AccordionItem>
                        </Accordion>

                        {/* AI Response */}
                        {game.aiResponse[idx] && (
                          <Accordion type="single" collapsible>
                            <AccordionItem value={`ai-response-${idx + 1}`}>
                              <AccordionTrigger className="bg-green-100 p-2 rounded-md">
                                AI Response {idx + 1}
                              </AccordionTrigger>
                              <AccordionContent className="bg-gray-100 p-4 rounded-md mt-2">
                                {game.aiResponse[idx]}
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

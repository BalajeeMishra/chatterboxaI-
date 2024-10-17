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

interface KtseDialogCloseProps {
  imageSrc: string; // Updated to accept StaticImageData
}
export const GameDialog: React.FC<KtseDialogCloseProps> = ({ imageSrc }) => {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button className="p-0"  variant="link">View</Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-md bg-white ">
        <DialogHeader>
          <DialogTitle>Icon Image</DialogTitle>
          <DialogDescription>Icon preview</DialogDescription>
        </DialogHeader>
        <div className="flex justify-center w-full">
          <img src={imageSrc} alt="icon" width="200" height="200" />
        </div>
        <DialogFooter className="sm:justify-start">
          <DialogClose asChild>
            <Button type="button" variant="outline">
              Close
            </Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

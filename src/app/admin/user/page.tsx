import PageHeadDesc from "@/components/ui/PageHeadDesc";
import { UserTable } from "./userTable";

export default function User() {
  return (
    <div>
      <PageHeadDesc title="Game Content" desc="Game Content details" />
      <div className="mx-6">
        <UserTable />
      </div>
    </div>
  );
}

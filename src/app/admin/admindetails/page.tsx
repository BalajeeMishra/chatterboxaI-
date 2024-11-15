// import PageHeadDesc from "@/components/admindashboard/pageheaddesc";
import PageHeadDesc from "@/components/ui/PageHeadDesc";
import { AdminTable } from "./adminstable";

const KTSEPage = () => {
  return (
    <div>
      <PageHeadDesc
        title="Admins Details"
        desc="All Admin Information details"
      />
      <div className="mx-6">
        <AdminTable />
      </div>
    </div>
  );
};

export default KTSEPage;

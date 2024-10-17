import Link from 'next/link';
import React from 'react';

interface PageHeadDescProps {
  title: string;
  desc: string;
}

const PageHeadDesc: React.FC<PageHeadDescProps> = ({ title, desc }) => {
  return (
    <div className="p-6">
      {/* Breadcrumb */}
      <nav className="text-sm mb-4">
        <ol className="list-none p-0 inline-flex">
          <li className="flex items-center">
            <Link href="/admin/newgame">
              <div className="text-gray-500 hover:text-gray-700">
                Dashboard
              </div>
            </Link>
            <span className="mx-2 text-gray-400">/</span>
          </li>
          <li className="flex items-center">
            <span className="text-gray-700">{title}</span>
          </li>
        </ol>
      </nav>

      {/* Title */}
      <h1 className="text-4xl font-bold mb-2">{title}</h1>

      {/* Subtitle */}
      <p className="text-gray-600 text-lg">{desc}</p>
    </div>
  );
};

export default PageHeadDesc;

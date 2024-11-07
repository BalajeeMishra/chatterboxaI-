import React from 'react';

interface ContentProps {
  content: string;
}

const RenderContent: React.FC<ContentProps> = ({ content }) => {
  return (
    <div
      dangerouslySetInnerHTML={{ __html: content }}
    />
  );
};

export default RenderContent;

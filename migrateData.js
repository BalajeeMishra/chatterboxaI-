// import UserDataLog from "./model/Userdata.js";
// import connectDB from "./config/database/db.js";
// import Logs from "./model/logs.js";
// async function migrateData() {

//     await connectDB();

//     try {
//         const allLogs = await UserDataLog.find(); // Fetch all documents

//         for (const log of allLogs) { 

//             // console.log("1st time",log?.aiResponse[0]);
//             // Transform userResponse and aiResponse
//             const transformedUserResponse = (log.userResponse || []).map((text) => ({
//                 text:text,
//                 createdAt: log.createdAt || new Date(), // Use document's createdAt if available
//             }));

//             const transformedAiResponse = (log.aiResponse || []).map((text) => ({
//                 text:text,
//                 createdAt: log.createdAt || new Date(),
//             }));
//             // console.log(transformedUserResponse,transformedAiResponse,"done");
//             await new Logs({
//                 _id: log._id,
//                 userResponse: transformedUserResponse,
//                 aiResponse: transformedAiResponse,
//                 createdAt: log.createdAt,
//                 userId: log.userId,
//                 sessionId: log.sessionId,
//                 engprolevel: log.engprolevel,
//                 gameId: log.gameId,
//             }).save();
//             // Update the document
//             // await UserDataLog.updateOne(
//             //     { _id: log._id },
//             //     {
//             //         $set: {
//             //             userResponse: transformedUserResponse,
//             //             // aiResponse: transformedAiResponse,
//             //             createdAt: log.createdAt || new Date(),
//             //         },
//             //     }
//             // );
           
//         }

//         console.log('Migration completed successfully!');
//         process.exit(0); // Exit the script
//     } catch (error) {
//         console.error('Error during migration:', error);
//         process.exit(1); // Exit with error
//     }
// }

// migrateData();

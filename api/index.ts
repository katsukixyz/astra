import express from "express";
// import cors from "cors";
// import { Pool } from "pg";
// import { connectionString } from "./pool";

const app = express();

// const pool = new Pool({
//   connectionString: connectionString,
// });

// app.use(cors());

app.get("/test", (req: express.Request, res: express.Response) => {
});


app.listen(process.env.PORT || 5000, () => console.log(`Listening.`));
import express from "express";
import bodyParser from 'body-parser';
import cors from "cors";
// import { Pool } from "pg";
// import { connectionString } from "./pool";

const app = express();

const Pool = require('pg').Pool
const pool = new Pool({
  connectionString: `postgresql://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_DATABASE}`
});

const getData = (req: express.Request, res: express.Response) => {
  
    pool.query('SELECT * FROM data', (error: Error, results:any) => {
      if (error) {
        throw error
      }
      console.log(results.rows)
      res.status(200).json(results.rows)
    })
  };

const getDataId = (req: express.Request, res: express.Response) => {
  const id = parseInt(req.params.id)
  console.log(req.params)
  pool.query('SELECT * FROM data WHERE id = $1', [id], (err: Error, results:any) => {
    console.log(results.rows)
    if (err) {
      throw err
    }
    
    res.status(200).json(results.rows)
  }) 
}

const getDataByCoord = (req: express.Request, res: express.Response) => {
  console.log("called")
  console.log(req.params)
  const latlon = req.params.latlon.split('_')
  
  const lon = latlon[0]
  const lat = latlon[1]
  console.log(lon)
  console.log(lat)

  pool.query(`SELECT * FROM data WHERE lon = ${lon} and lat = ${lat}`, (err: Error, results: any) => {
    console.log(results.rows)
    if(err){
      throw err
    }
    res.status(200).json(results.rows)
  })
}

app.use(cors());

app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

app.get("/", (req, res) => {
    res.json({info: 'Node.js, Express, and Postgres API' })
});

app.get('/data', getData)
app.get('/data/:id', getDataId)
app.get('/latlon/:latlon', getDataByCoord)
app.listen(process.env.PORT || 5000, () => console.log(`Listening.`));
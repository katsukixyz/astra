import React, { useEffect, useState } from "react";
import "./App.css";
import DeckGL from "@deck.gl/react";
import { ScatterplotLayer } from "@deck.gl/layers";
import { StaticMap } from "react-map-gl";
import { DataSchema } from "./types/types";
import Overlay from "./components/Overlay";
import data from "./data.js";

const MAPBOX_ACCESS_TOKEN = process.env.REACT_APP_MAPBOX_TOKEN;

const INITIAL_VIEW_STATE = {
  longitude: 120.441,
  latitude: 11.8546,
  zoom: 5,
  pitch: 0,
  bearing: 0,
};

const App: React.FC = () => {
  // const [data, setData] = useState([]);
  const [selectedCoordData, setSelectedCoordData] = useState<DataSchema>();
  const [overlayVisible, setOverlayVisible] = useState(false);

  // useEffect(() => {
  //   async function fetchData() {
  //     const response = await fetch("http://localhost:5000/data");
  //     setData(await response.json());
  //   }
  //   fetchData();
  // }, []);

  const layers = [
    new ScatterplotLayer({
      id: "scatterplot-layer",
      data,
      pickable: true,
      opacity: 0.4,
      filled: true,
      radiusScale: 1000,
      getPosition: (d: any) => [parseFloat(d.lat), parseFloat(d.lon)],
      // getWeight: (d) => parseFloat(d.slope), //! change later
      onClick: (info, event) => {
        console.log(info);
        setSelectedCoordData(info.object as DataSchema);
        setOverlayVisible(true);
      },
    }),
  ];

  return (
    <div>
      <DeckGL
        initialViewState={INITIAL_VIEW_STATE}
        controller={true}
        layers={layers}
      >
        <StaticMap mapboxApiAccessToken={MAPBOX_ACCESS_TOKEN} />
      </DeckGL>
      <Overlay
        overlayVisible={overlayVisible}
        selectedCoordData={selectedCoordData!}
      />
    </div>
  );
};

export default App;

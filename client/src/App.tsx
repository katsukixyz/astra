import React, { useEffect, useState } from "react";
import logo from "./logo.svg";
import "./App.css";
import DeckGL from "@deck.gl/react";
import { ScreenGridLayer } from "@deck.gl/aggregation-layers";
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
  const [data, setData] = useState([]);
  const [selectedCoords, setSelectedCoords] = useState([0, 0] as [
    number,
    number
  ]);
  const [overlayVisible, setOverlayVisible] = useState(false);

  useEffect(() => {
    async function fetchData() {
      const response = await fetch("http://localhost:5000");
      setData(await response.json());
    }
    fetchData();
  }, []);

  const layers = [
    new ScreenGridLayer({
      id: "screengrid-layer",
      data,
      pickable: true,
      opacity: 0.4,
      cellSizePixels: 10,
      getPosition: (d: DataSchema) => [d.lat, d.lon],
      getWeight: (d) => d.slope, //! change later
      onClick: (info, event) => {
        console.log(info.coordinate);
        setSelectedCoords(info.coordinate as [number, number]);
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
        selectedCoords={selectedCoords}
      />
    </div>
  );
};

export default App;

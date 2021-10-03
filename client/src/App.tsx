import React, { useEffect, useState } from "react";
import "./App.css";
import DeckGL from "@deck.gl/react";
// import { ScatterplotLayer } from "@deck.gl/layers";
import { HeatmapLayer } from "@deck.gl/aggregation-layers";
import { StaticMap } from "react-map-gl";
import { DataSchema } from "./types/types";
import Overlay from "./components/Overlay";

const MAPBOX_ACCESS_TOKEN =
  "pk.eyJ1Ijoia2F0c3VraXh5eiIsImEiOiJja3ViYW9uc2Qwb3A3MnFxNmh0Y2VhbjE3In0.jOK1ZvAR-8eEMVhKP9mMkg";

const INITIAL_VIEW_STATE = {
  longitude: 120.441,
  latitude: 11.8546,
  zoom: 5,
  pitch: 0,
  bearing: 0,
};

const App: React.FC = () => {
  const [data, setData] = useState([]);
  const [selectedCoordData, setSelectedCoordData] = useState<DataSchema>();
  const [overlayVisible, setOverlayVisible] = useState(false);

  useEffect(() => {
    async function fetchData() {
      const response = await fetch("http://localhost:5000/data");
      setData(await response.json());
    }
    fetchData();
  }, []);

  console.log(data);

  const layers = [
    new HeatmapLayer({
      id: "heatmap-layer",
      data,
      pickable: true,
      opacity: 0.4,
      radiusPixels: 10,
      // filled: true,
      // radiusScale: 1000,
      getPosition: (d: DataSchema) => [d.lon, d.lat],
      getWeight: (d: DataSchema) => d.prob_landslide,
      // getWeight: (d: DataSchema) => d.dist_geo,
      aggregation: "SUM",
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

import React from "react";
import logo from "./logo.svg";
import "./App.css";
import DeckGL from "@deck.gl/react";
import { LineLayer } from "@deck.gl/layers";
import { StaticMap } from "react-map-gl";
import model from "./data.json";

const MAPBOX_ACCESS_TOKEN = process.env.REACT_APP_MAPBOX_TOKEN;

const INITIAL_VIEW_STATE = {
  longitude: 120.441,
  latitude: 11.8546,
  zoom: 5,
  pitch: 0,
  bearing: 0,
};

const data = [
  {
    sourcePosition: [-122.41669, 37.7853],
    targetPosition: [-122.41669, 37.781],
  },
];

const App: React.FC = () => {
  const layers = [
    new LineLayer({
      id: "line-layer",
      data,
      pickable: true,
      onClick: (info, event) => console.log(info),
    }),
  ];

  return (
    <div>
      <DeckGL
        initialViewState={INITIAL_VIEW_STATE}
        controller={true}
        // onClick={(r) => console.log(r)}
        layers={layers}
      >
        <StaticMap mapboxApiAccessToken={MAPBOX_ACCESS_TOKEN} />
      </DeckGL>
    </div>
  );
};

export default App;
